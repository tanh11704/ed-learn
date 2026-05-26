# EdLearn AI Service

FastAPI service cho chatbot RAG theo lesson/course.

## Chuc nang

- `POST /api/v1/ingest/lesson`: nhan noi dung lesson, chia chunk, tao embedding va luu vao ChromaDB.
- `POST /api/v1/chat`: nhan cau hoi hoc sinh, tim chunk lien quan theo `course_id`/`lesson_id`, dua ngu canh cho LLM va tra loi kem sources.
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
  "text": "Noi dung bai hoc..."
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
- `text`: noi dung bai hoc da extract/nhap thu cong.

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
  text = "Ham so y = f(x) duoc goi la dong bien tren khoang K neu x1 < x2 thi f(x1) < f(x2). Ham so y = f(x) duoc goi la nghich bien tren khoang K neu x1 < x2 thi f(x1) > f(x2). Neu f'(x) > 0 tren K thi ham so dong bien tren K. Neu f'(x) < 0 tren K thi ham so nghich bien tren K. De xet tinh don dieu cua ham so, ta tim tap xac dinh, tinh dao ham f'(x), giai f'(x)=0, lap bang xet dau va ket luan khoang dong bien nghich bien. Vi du y = x^3 - 3x + 1 co f'(x)=3x^2-3=3(x-1)(x+1), dong bien tren (-vo cuc,-1) va (1,+vo cuc), nghich bien tren (-1,1)."
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
