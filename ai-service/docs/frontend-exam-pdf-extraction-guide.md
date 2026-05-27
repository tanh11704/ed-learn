# Frontend Guide: Exam PDF Extraction

Tai lieu nay huong dan frontend dev tich hop tinh nang upload PDF de thi len `ai-service`, nhan ve JSON cau hoi, cho admin review va sau do luu vao Spring Boot/Postgres.

## Scope MVP

Tinh nang hien tai chi lam:

```text
PDF file
  -> ai-service extract text bang pypdf
  -> Gemini parse thanh JSON cau hoi
  -> frontend hien preview/review
  -> frontend goi Spring Boot de luu tung cau hoi
```

`ai-service` **khong luu Postgres** va **khong tao exam**.

## Gioi Han MVP

Ho tro tot:

- PDF export tu Word/Google Docs/LaTeX co text layer.
- De thi text ro, it hinh anh.
- Cong thuc don gian co the extract tu PDF text.

Chua ho tro tot:

- PDF scan/chup anh.
- Cau hoi phu thuoc vao hinh anh/do thi/bang bien thien.
- Cong thuc phuc tap bi PDF text extraction lam hong.
- Tu dong luu vao Postgres ma khong qua review.

Neu PDF scan, service co the tra loi:

```json
{
  "detail": "Could not extract enough text from PDF. The file may be scanned; OCR/vision extraction is not implemented yet."
}
```

## UI Flow

```text
Admin chon exam da tao trong Spring Boot
        |
Upload PDF de thi
        |
POST /api/v1/exams/extract-pdf
        |
Nhan questions[]
        |
Preview + edit
        |
Admin confirm
        |
Loop POST /api/v1/admin/exams/questions
```

## Man Hinh De Xuat

### 1. Upload Step

UI nen co:

- Select/input `exam_id` hoac chon exam co san.
- Select subject.
- Input grade level.
- Select profile, mac dinh `THPT_2026`.
- File picker PDF.
- Nut `Trich xuat cau hoi`.

Wireframe:

```text
┌────────────────────────────────────────────┐
│ Import De Thi Tu PDF                       │
├────────────────────────────────────────────┤
│ Exam:        [De thi Toan lan 1 ▼]         │
│ Subject:     [Toan ▼]                      │
│ Grade:       [12]                          │
│ Profile:     [THPT_2026 ▼]                 │
│ PDF file:    [chon-file.pdf]               │
│                                            │
│                      [Trich xuat cau hoi]  │
└────────────────────────────────────────────┘
```

### 2. Review Step

Sau khi co response, frontend phai cho admin review/sua truoc khi luu.

Moi cau hoi nen co:

- `questionType`
- `paperPart`
- `score`
- `content`
- `options`
- `correctAnswer`
- warning neu co

Wireframe:

```text
┌────────────────────────────────────────────┐
│ Ket qua trich xuat: 24 cau                 │
│ Warning: Admin should review...            │
├────────────────────────────────────────────┤
│ Cau 1 · PART_I · MULTIPLE_CHOICE · 0.25    │
│ [Noi dung cau hoi...]                      │
│ A. ...                    [correct]        │
│ B. ...                                     │
│ C. ...                                     │
│ D. ...                                     │
│ [Sua] [Xoa]                                │
├────────────────────────────────────────────┤
│                         [Luu vao de thi]   │
└────────────────────────────────────────────┘
```

### 3. Save Step

Khi admin bam `Luu vao de thi`, frontend loop tung question va goi Spring Boot:

```http
POST /api/v1/admin/exams/questions
```

Nen hien progress:

```text
Dang luu 12/24 cau...
```

Neu mot cau loi validation, dung lai va highlight cau do.

## AI Service API

Base URL dev:

```text
http://localhost:8001
```

Required header:

```text
X-AI-Service-Key: dev-ai-service-key
```

Endpoint:

```http
POST /api/v1/exams/extract-pdf
```

Body type:

```text
multipart/form-data
```

Fields:

| Field | Type | Required | Description |
| --- | --- | --- | --- |
| `file` | File | Yes | PDF de thi |
| `exam_id` | Text | No | UUID exam trong Spring Boot neu da co |
| `subject` | Text | No | Mon thi, vi du `Toan` |
| `grade_level` | Text/Number | No | Khoi lop, vi du `12` |
| `profile` | Text | No | Cau truc de, default `THPT_2026` |

Postman example:

```text
Method: POST
URL: http://localhost:8001/api/v1/exams/extract-pdf
Headers:
  X-AI-Service-Key: dev-ai-service-key
Body:
  form-data
    file         File   de-thi.pdf
    exam_id      Text   100ab6bd-ed08-4bfa-af40-d00977051d70
    subject      Text   Toan
    grade_level  Text   12
    profile      Text   THPT_2026
```

## Response

```json
{
  "exam_id": "100ab6bd-ed08-4bfa-af40-d00977051d70",
  "subject": "Toan",
  "profile": "THPT_2026",
  "question_count": 2,
  "warnings": [
    "Admin should review extracted questions and answers before saving to Postgres."
  ],
  "questions": [
    {
      "examId": "100ab6bd-ed08-4bfa-af40-d00977051d70",
      "questionType": "MULTIPLE_CHOICE",
      "paperPart": "PART_I",
      "content": "Cau 1. Ham so \\(y=x^2\\) co dao ham la gi?",
      "orderIndex": 1,
      "score": 0.25,
      "correctAnswer": null,
      "options": [
        {
          "content": "A. \\(2x\\)",
          "correct": true,
          "orderIndex": 1
        },
        {
          "content": "B. \\(x\\)",
          "correct": false,
          "orderIndex": 2
        }
      ]
    },
    {
      "examId": "100ab6bd-ed08-4bfa-af40-d00977051d70",
      "questionType": "SHORT_ANSWER",
      "paperPart": "PART_III",
      "content": "Cau 2. Tinh gia tri lon nhat cua ham so \\(y=-x^2+4x+1\\).",
      "orderIndex": 2,
      "score": 0.5,
      "correctAnswer": "\\(5\\)",
      "options": []
    }
  ]
}
```

## Field Mapping Sang Spring Boot

Moi item trong `questions[]` gan voi DTO `CreateQuestionRequest`.

Frontend co the gui tung item sang Spring Boot:

```http
POST /api/v1/admin/exams/questions
Authorization: Bearer <admin-token>
Content-Type: application/json
```

Body:

```json
{
  "examId": "100ab6bd-ed08-4bfa-af40-d00977051d70",
  "questionType": "MULTIPLE_CHOICE",
  "paperPart": "PART_I",
  "content": "Cau 1. Ham so \\(y=x^2\\) co dao ham la gi?",
  "orderIndex": 1,
  "score": 0.25,
  "correctAnswer": null,
  "options": [
    {
      "content": "A. \\(2x\\)",
      "correct": true,
      "orderIndex": 1
    }
  ]
}
```

Enum values:

```text
questionType:
- MULTIPLE_CHOICE
- TRUE_FALSE
- SHORT_ANSWER

paperPart:
- PART_I
- PART_II
- PART_III
```

## LaTeX Rendering

`ai-service` yeu cau Gemini tra cong thuc bang LaTeX:

```text
\(...\) for inline math
\[...\] for display math
```

Frontend nen render bang:

- KaTeX
- MathJax
- Flutter: flutter_math_fork hoac package tuong duong

Neu khong render LaTeX, van hien text duoc nhung trai nghiem kem hon.

## Error Handling

Common errors:

### 401 Unauthorized

Thieu hoac sai header:

```text
X-AI-Service-Key
```

UI message:

```text
Khong co quyen goi AI service.
```

### 400 Only PDF files are supported

Nguoi dung upload file khong phai PDF.

UI message:

```text
Vui long chon file PDF.
```

### 422 Could not extract enough text

PDF co the la scan/anh, khong co text layer.

UI message:

```text
File PDF nay co the la anh scan. MVP hien chua ho tro OCR/vision, vui long dung PDF co text hoac nhap thu cong.
```

### 502 AI did not return valid JSON

Gemini tra output sai format.

UI message:

```text
AI chua trich xuat duoc dung dinh dang. Vui long thu lai hoac dung file ngan hon.
```

### 503 Gemini unavailable / timeout

Gemini loi mang, qua tai hoac timeout.

UI message:

```text
AI dang ban hoac qua thoi gian xu ly. Vui long thu lai sau.
```

## UX Recommendations

- Khong auto-save ket qua AI.
- Luon bat admin review.
- Highlight cau co `correct=false` toan bo options vi co the thieu dap an.
- Cho phep sua LaTeX bang text editor.
- Cho phep xoa cau AI trich sai.
- Cho phep them option neu AI thieu.
- Hien `warnings` o dau trang.
- De dai nen co progress/loading message: `Dang doc PDF va trich xuat cau hoi...`

## Production Notes

MVP hien chi dung `pypdf`, nen khong doc tot PDF scan/hinh anh.

Huong nang cap sau:

```text
PDF -> render page image -> Gemini Vision/OCR -> JSON + image assets
```

Neu backend can luu cau hoi co hinh, Spring Boot schema can mo rong them `assets` hoac `imageUrl`.

