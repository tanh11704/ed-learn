# EdLearn AI Service

FastAPI service cho chatbot RAG theo lesson/course.

## Chuc nang

- `POST /api/v1/ingest/lesson`: nhan noi dung lesson, chia chunk, tao embedding va luu vao ChromaDB.
- Ingest ho tro `sections[]` cho production va van ho tro `text` legacy cho MVP.
- `POST /api/v1/chat`: nhan cau hoi hoc sinh, tim chunk lien quan theo `course_id`/`lesson_id`, dua ngu canh cho LLM va tra loi kem sources.
- `POST /api/v1/exams/extract-pdf`: upload PDF de thi, trich xuat thanh JSON cau hoi gan voi `CreateQuestionRequest` cua Spring Boot.
- LLM/embedding di qua provider abstraction. Mac dinh cau hinh `AI_PROVIDER=gemini`, van giu provider `ollama` de co the chuyen doi sau nay.

## Luong hoat dong RAG

1. Backend lay noi dung lesson/course da duoc phep truy cap.
2. Backend goi `/ingest/lesson` de dua noi dung vao vector store.
3. Khi hoc sinh hoi, backend goi `/chat` voi `course_id`, `lesson_id`, cau hoi va lich su chat gan day.
4. AI service embed cau hoi, query ChromaDB lay cac chunk lien quan.
5. Service tao prompt co ngu canh bai hoc, goi provider chat model da cau hinh.
6. Response tra ve cau tra loi, danh sach source chunks va confidence.

## Cai dat local

```powershell
cd ai-service
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
Copy-Item .env.example .env
uvicorn app.main:app --reload --port 8001
```

Can chay them ChromaDB:

```powershell
docker compose up -d chromadb
```

Project pin ChromaDB Docker image va Python client cung version `0.5.23`. Khong nen dung `chromadb/chroma:latest` voi client cu vi co the loi schema API.

Neu dung Gemini, tao `.env` tu `.env.example` va dat:

```powershell
AI_PROVIDER=gemini
GEMINI_API_KEY=your-gemini-api-key
GEMINI_CHAT_MODEL=gemini-2.5-flash
GEMINI_EMBEDDING_MODEL=gemini-embedding-001
```

Neu muon chuyen lai Ollama:

```powershell
AI_PROVIDER=ollama
OLLAMA_CHAT_MODEL=qwen3:8b
OLLAMA_EMBEDDING_MODEL=nomic-embed-text
```

Khi doi embedding provider/model, nen xoa collection cu hoac re-ingest toan bo lesson vi vector dimension co the khac nhau.

## Vi du ingest lesson

```json
{
  "course_id": "course-toan-12",
  "lesson_id": "ham-so-01",
  "course_title": "Toan 12",
  "lesson_title": "Khao sat ham so",
  "subject": "Toan",
  "grade_level": 12,
  "sections": [
    {
      "section_id": "definition",
      "section_title": "Dinh nghia",
      "section_type": "theory",
      "text": "Noi dung phan dinh nghia..."
    },
    {
      "section_id": "method",
      "section_title": "Quy trinh lam bai",
      "section_type": "method",
      "text": "Noi dung phan phuong phap..."
    }
  ]
}
```

## Vi du chat

```json
{
  "user_id": "student-1",
  "course_id": "course-toan-12",
  "lesson_id": "ham-so-01",
  "question": "Em chua hieu cach tim cuc tri cua ham so",
  "chat_history": []
}
```

Header noi bo:

```text
X-AI-Service-Key: dev-ai-service-key
```

## Swagger cho dong nghiep

Sau khi chay service:

```powershell
uvicorn app.main:app --reload --port 8001
```

Mo Swagger UI:

```text
http://localhost:8001/docs
```

Mo OpenAPI JSON:

```text
http://localhost:8001/openapi.json
```

Trong Swagger, bam nut `Authorize` va nhap:

```text
dev-ai-service-key
```

Neu `.env` dat `AI_SERVICE_API_KEY=dev-ai-service-key`, moi request toi `/api/v1/ingest/lesson` va `/api/v1/chat` can header:

```text
X-AI-Service-Key: dev-ai-service-key
```

## Client goi truc tiep ai-service

Service hien tai co the goi truc tiep tu client theo flow:

```text
Client lay course/lesson tu Spring Boot nhu hien tai
        |
Client goi ai-service /api/v1/ingest/lesson de nap RAG
        |
Client goi ai-service /api/v1/chat de hoi dap
```

Luu y cho production: khong nen hard-code `X-AI-Service-Key` trong mobile app public. Cach nay phu hop MVP/demo/noi bo. Production nen dung Spring Boot proxy hoac token ngan han.

### Request nap RAG

Endpoint:

```http
POST /api/v1/ingest/lesson
```

Client can truyen:

- `course_id`: ID khoa hoc lay tu Spring Boot.
- `lesson_id`: ID bai hoc lay tu Spring Boot.
- `lesson_title`: ten bai hoc.
- `sections`: danh sach section cua bai hoc. Moi section can `section_id`, `section_title`, `section_type`, `text`.

Van co the truyen `text` legacy neu client chua chia section, nhung production nen dung `sections`.

Nen truyen them:

- `course_title`
- `subject`
- `grade_level`
- `source_url`

Client khong truyen:

- chunk
- embedding
- vector
- Gemini API key

### Request chat

Endpoint:

```http
POST /api/v1/chat
```

Client can truyen:

- `course_id`
- `question`

Neu hoc sinh dang hoi trong mot bai hoc cu the, truyen them:

- `lesson_id`

Neu khong truyen `lesson_id`, service se search trong toan course.

## Test end-to-end bang PowerShell

### 1. Chay ChromaDB

Tu root project:

```powershell
docker compose up -d chromadb
```

### 2. Cau hinh Gemini

Trong `ai-service/.env`:

```powershell
AI_PROVIDER=gemini
GEMINI_API_KEY=your-gemini-api-key
GEMINI_CHAT_MODEL=gemini-2.5-flash
GEMINI_EMBEDDING_MODEL=gemini-embedding-001
AI_SERVICE_API_KEY=dev-ai-service-key
```

### 3. Chay ai-service

```powershell
cd ai-service
.\.venv\Scripts\Activate.ps1
uvicorn app.main:app --reload --port 8001
```

Kiem tra:

```powershell
Invoke-RestMethod -Uri "http://localhost:8001/health"
```

### 4. Ingest lesson mau

```powershell
$headers = @{
  "Content-Type" = "application/json"
  "X-AI-Service-Key" = "dev-ai-service-key"
}

$ingestBody = @{
  course_id = "toan-12"
  lesson_id = "don-dieu-cua-ham-so"
  course_title = "Toan 12"
  lesson_title = "Tinh don dieu cua ham so"
  subject = "Toan"
  grade_level = 12
  source_url = "manual://toan-12/don-dieu-cua-ham-so"
  sections = @(
    @{
      section_id = "definition"
      section_title = "Dinh nghia"
      section_type = "theory"
      text = "Ham so y = f(x) duoc goi la dong bien tren khoang K neu x1 < x2 thi f(x1) < f(x2). Ham so y = f(x) duoc goi la nghich bien tren khoang K neu x1 < x2 thi f(x1) > f(x2)."
    },
    @{
      section_id = "derivative-theorem"
      section_title = "Dinh ly dao ham"
      section_type = "theory"
      text = "Neu f'(x) > 0 tren K thi ham so dong bien tren K. Neu f'(x) < 0 tren K thi ham so nghich bien tren K."
    },
    @{
      section_id = "method"
      section_title = "Quy trinh lam bai"
      section_type = "method"
      text = "De xet tinh don dieu cua ham so, ta tim tap xac dinh, tinh dao ham f'(x), giai f'(x)=0, lap bang xet dau va ket luan khoang dong bien nghich bien."
    },
    @{
      section_id = "example-basic"
      section_title = "Vi du mau"
      section_type = "example"
      text = "Vi du y = x^3 - 3x + 1 co f'(x)=3x^2-3=3(x-1)(x+1). Ham so dong bien tren (-vo cuc,-1) va (1,+vo cuc), nghich bien tren (-1,1)."
    }
  )
} | ConvertTo-Json -Depth 8

Invoke-RestMethod `
  -Uri "http://localhost:8001/api/v1/ingest/lesson" `
  -Method Post `
  -Headers $headers `
  -Body $ingestBody
```

Ket qua mong muon:

```json
{
  "course_id": "toan-12",
  "lesson_id": "don-dieu-cua-ham-so",
  "chunk_count": 1
}
```

### 5. Chat trong lesson

```powershell
$chatBody = @{
  user_id = "student-1"
  course_id = "toan-12"
  lesson_id = "don-dieu-cua-ham-so"
  question = "Vi sao f'(x) > 0 thi ham so dong bien?"
  chat_history = @()
} | ConvertTo-Json -Depth 8

Invoke-RestMethod `
  -Uri "http://localhost:8001/api/v1/chat" `
  -Method Post `
  -Headers $headers `
  -Body $chatBody
```

Response can co:

- `answer`: cau tra loi cua AI.
- `sources`: chunk da duoc dung lam context.
- `confidence`: diem lien quan trung binh.
- `used_fallback`: `false` neu goi Gemini thanh cong.

### 6. Chat toan course

Khong truyen `lesson_id`:

```powershell
$chatBody = @{
  user_id = "student-1"
  course_id = "toan-12"
  question = "Cach xet tinh don dieu cua ham so gom nhung buoc nao?"
  chat_history = @()
} | ConvertTo-Json -Depth 8

Invoke-RestMethod `
  -Uri "http://localhost:8001/api/v1/chat" `
  -Method Post `
  -Headers $headers `
  -Body $chatBody
```

Service se search tat ca chunks co `course_id = toan-12`.

## Extract de thi PDF

Endpoint:

```http
POST /api/v1/exams/extract-pdf
```

Headers:

```text
X-AI-Service-Key: dev-ai-service-key
```

Body type: `form-data`

Fields:

- `file`: PDF de thi.
- `exam_id`: UUID de thi trong Spring Boot, optional.
- `subject`: mon thi, optional.
- `grade_level`: khoi lop, optional.
- `profile`: cau truc de, default `THPT_2026`.

Postman setup:

```text
Method: POST
URL: http://localhost:8001/api/v1/exams/extract-pdf
Headers:
  X-AI-Service-Key: dev-ai-service-key
Body:
  form-data
    file      File    de-thi.pdf
    exam_id   Text    100ab6bd-ed08-4bfa-af40-d00977051d70
    subject   Text    Toan
    grade_level Text  12
    profile   Text    THPT_2026
```

Response:

```json
{
  "exam_id": "100ab6bd-ed08-4bfa-af40-d00977051d70",
  "subject": "Toan",
  "profile": "THPT_2026",
  "question_count": 1,
  "warnings": [
    "Admin should review extracted questions and answers before saving to Postgres."
  ],
  "questions": [
    {
      "examId": "100ab6bd-ed08-4bfa-af40-d00977051d70",
      "questionType": "MULTIPLE_CHOICE",
      "paperPart": "PART_I",
      "content": "Cau 1. Ham so nao dong bien tren \\(\\mathbb{R}\\)?",
      "orderIndex": 1,
      "score": 0.25,
      "correctAnswer": null,
      "options": [
        {
          "content": "A. \\(y = x\\)",
          "correct": true,
          "orderIndex": 1
        }
      ]
    }
  ]
}
```

Client/admin nen review response truoc khi goi Spring Boot luu vao Postgres. De luu, lap qua tung item trong `questions` va goi:

```http
POST /api/v1/admin/exams/questions
```

Luu y:

- Endpoint hien tai doc text PDF bang `pypdf`, phu hop PDF co text layer.
- PDF scan anh/chup tu may anh co the khong extract duoc text; can OCR/vision flow rieng.
- Neu PDF dai, service cat text truoc khi gui LLM. Nen tach PDF lon thanh nhieu phan de tang do chinh xac.
- Cong thuc toan trong response duoc yeu cau tra ve LaTeX voi inline delimiter `\\(...\\)`. Frontend nen render bang KaTeX hoac MathJax.
