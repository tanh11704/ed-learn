# Mobile Mock Exam API Integration

Base URL: `https://<backend-domain>/api/v1`

All learner exam endpoints require bearer auth.

```http
Authorization: Bearer <access_token>
Content-Type: application/json
Accept: application/json
```

## 1. Load Published Exams

Use this endpoint for the mock exam library.

```http
GET /exams
```

Response:

```json
[
  {
    "id": "9d94f472-6ba8-4df2-81d7-3c1dcf772da7",
    "title": "De thi thu Toan 12",
    "subject": "Toan",
    "schoolYear": 2026,
    "durationMinutes": 90,
    "totalQuestions": 50,
    "description": "On tap hoc ky",
    "status": "PUBLISHED"
  }
]
```

Do not call legacy routes such as `/exams/available` or `/admin/exams` from mobile.

## 2. Load Exam Metadata

Use this when the app needs a detail screen before starting.

```http
GET /exams/{examId}
```

`examId` must be a real UUID returned by `GET /exams`.

## 3. Start Attempt

Call this once when the learner confirms starting the exam.

```http
POST /exams/{examId}/attempts
```

Request:

```json
{
  "gradeLevel": 12,
  "className": "12A1"
}
```

`className` is optional. `gradeLevel` is required and must be from 1 to 12.

Response:

```json
{
  "attempt": {
    "id": "d4d400d5-f449-4a2d-970d-b4e918fbd1e8",
    "examId": "9d94f472-6ba8-4df2-81d7-3c1dcf772da7",
    "userId": "6ab7d89f-913d-44de-b2dc-b9021a2a8a40",
    "gradeLevel": 12,
    "className": "12A1",
    "status": "IN_PROGRESS",
    "startedAt": "2026-05-27T12:23:51.000Z",
    "submittedAt": null,
    "durationSeconds": null,
    "score": null,
    "maxScore": null
  },
  "exam": {
    "id": "9d94f472-6ba8-4df2-81d7-3c1dcf772da7",
    "title": "De thi thu Toan 12",
    "subject": "Toan",
    "durationMinutes": 90,
    "totalQuestions": 50,
    "status": "PUBLISHED"
  },
  "questions": [
    {
      "id": "0c09098f-3cbe-4b0c-a62f-4a738059ae50",
      "examId": "9d94f472-6ba8-4df2-81d7-3c1dcf772da7",
      "questionType": "MULTIPLE_CHOICE",
      "paperPart": "PART_I",
      "content": "Cau hoi...",
      "imageUrl": null,
      "orderIndex": 1,
      "score": 0.25,
      "options": [
        {
          "id": "a810ddfc-d231-42aa-9eab-20d465ddcdf7",
          "questionId": "0c09098f-3cbe-4b0c-a62f-4a738059ae50",
          "content": "A. ...",
          "orderIndex": 1
        }
      ]
    }
  ]
}
```

The learner question response does not include `correctAnswer` or option correctness.

Mobile should disable the start button while this request is pending to avoid creating multiple attempts from repeated taps.

## 4. Restore Attempt

Use this if the app already has an `attempt.id` and needs to reopen the in-progress exam.

```http
GET /exams/attempts/{attemptId}
```

Response shape is the same as start attempt.

## 5. Submit Attempt

Submit only the final answers.

```http
POST /exams/attempts/{attemptId}/submit
```

Request:

```json
{
  "answers": [
    {
      "questionId": "0c09098f-3cbe-4b0c-a62f-4a738059ae50",
      "selectedOptionId": "a810ddfc-d231-42aa-9eab-20d465ddcdf7",
      "answerText": null
    }
  ]
}
```

For multiple-choice and true-false questions, send `selectedOptionId`.

For short-answer questions, send `answerText`. If `selectedOptionId` is not applicable, leave it null or omit it.

Response:

```json
{
  "id": "d4d400d5-f449-4a2d-970d-b4e918fbd1e8",
  "examId": "9d94f472-6ba8-4df2-81d7-3c1dcf772da7",
  "status": "SUBMITTED",
  "durationSeconds": 430,
  "score": 7.5,
  "maxScore": 10.0
}
```

## 6. Review Submitted Attempt

Only call this after the attempt status is `SUBMITTED` or `GRADED`.

```http
GET /exams/attempts/{attemptId}/review
```

This response includes correct answers and correct option flags for review.

## 7. My Attempt History

```http
GET /exams/attempts/me
```

Use this for a learner history screen.

## Mobile Notes

- Never send demo ids such as `demo-1`, `demo-2`, or `available` to backend UUID routes.
- Use only ids returned by backend APIs.
- Keep selected answers locally while the learner is doing the exam. There is no draft-answer API yet.
- Disable repeated submit and start actions while a request is in flight.
- On `401`, refresh token or redirect to login.
- On `400`, show backend validation message.
- On `403`, show access denied.
- On `404`, reload the exam list because the exam/attempt may no longer exist.
