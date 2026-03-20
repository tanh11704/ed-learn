# 🎓 EdLearn - Nền tảng EdTech Thông minh ứng dụng AI (RAG & Spaced Repetition)

[![Spring Boot](https://img.shields.io/badge/Spring_Boot-3.2-6DB33F?style=flat-square&logo=spring&logoColor=white)](https://spring.io/projects/spring-boot)
[![FastAPI](https://img.shields.io/badge/FastAPI-0.109-009688?style=flat-square&logo=fastapi&logoColor=white)](https://fastapi.tiangolo.com/)
[![Flutter](https://img.shields.io/badge/Flutter-3.19-02569B?style=flat-square&logo=flutter&logoColor=white)](https://flutter.dev/)
[![Ollama](https://img.shields.io/badge/Ollama-Local_LLM-white?style=flat-square&logo=meta&logoColor=black)](https://ollama.com/)

> **Đồ án Chuyên ngành 3 - Khoa Khoa học Máy tính - VKU**
>
> _Giải pháp học tập chủ động giúp sinh viên tối ưu hóa thời gian ôn thi thông qua việc tự động hóa tạo bài tập và gia sư ảo AI bám sát ngữ cảnh tài liệu._

---

## 🌟 Tổng quan dự án (Overview)

**EdLearn** là một hệ thống EdTech đa nền tảng được thiết kế theo kiến trúc Microservices (Modular Monolith cho Core Backend).

Thay vì học tập thụ động qua việc đọc tài liệu PDF dài dòng, EdLearn tự động trích xuất nội dung, sinh ra các bộ câu hỏi trắc nghiệm và Flashcard. Điểm nhấn của dự án là việc tích hợp thuật toán **Spaced Repetition (SM-2)** để tối ưu chu kỳ ghi nhớ và trợ lý ảo **AI Tutor (RAG)** túc trực 24/7 giải đáp thắc mắc dựa trên chính tài liệu của người dùng.

---

## ✨ Tính năng cốt lõi (Core Features)

- 📄 **Smart Material Processing:** Tải lên file PDF (Slide, Giáo trình), hệ thống tự động bóc tách và xử lý văn bản (Text Extraction & Chunking).
- 🧠 **AI Auto-Generator:** Tự động sinh JSON cấu trúc chứa bộ câu hỏi Multiple Choice và Flashcards từ nội dung tài liệu.
- 💬 **Contextual AI Tutor (RAG):** Chatbot giải đáp thắc mắc realtime. Đảm bảo AI chỉ trả lời dựa trên ngữ cảnh tài liệu được cung cấp, loại bỏ hoàn toàn tình trạng "ảo giác" (Hallucination) của LLM.
- 📈 **Active Recall & Spaced Repetition:** App học tập qua Flashcard tích hợp thuật toán SM-2, tự động tính toán và nhắc nhở ngày cần ôn tập lại kiến thức.
- 🔒 **Enterprise Security:** Hệ thống phân quyền chặt chẽ với Spring Security và JWT.

---

## 🏗️ Kiến trúc Hệ thống (System Architecture)

Hệ thống được chia làm 3 phân hệ chính giao tiếp với nhau:

1. **Mobile Client (Flutter):** Giao diện người dùng tương tác.
2. **Core Backend (Spring Boot 3):** Đóng vai trò API Gateway, quản lý nghiệp vụ lõi (Auth, CRUD, SM-2 Algorithm), sử dụng PostgreSQL & Redis. Được thiết kế theo chuẩn **Domain-Driven Design (DDD)**.
3. **AI Service (FastAPI):** Internal API xử lý tác vụ nặng (LangChain, PyPDF2, Vector DB ChromaDB) và giao tiếp với **Local LLM (Ollama)** để đảm bảo bảo mật dữ liệu tuyệt đối.

---

## 🗂️ Cấu trúc thư mục (Repository Structure)

Dự án được quản lý theo mô hình Monorepo:

```text
ed-learn/
├── core-backend/       # Spring Boot 3 (Java 17) - Quản lý nghiệp vụ & Data
├── ai-service/         # FastAPI (Python 3.10) - Xử lý RAG, LangChain, PDF
├── mobile_app/         # Flutter (Dart) - Ứng dụng di động
├── docker-compose.yml  # File cấu hình hạ tầng (Postgres, Redis, ChromaDB)
└── README.md
```

---

## 🚀 Hướng dẫn cài đặt (Getting Started)

### 1. Yêu cầu hệ thống (Prerequisites)

- Docker & Docker Compose
- Java 17 & Maven/Gradle
- Python 3.10+
- Flutter SDK 3.19+
- Ollama (Cài đặt model: `ollama run llama3`)

### 2. Khởi chạy Hạ tầng (Infrastructure)

Tại thư mục gốc của project, khởi chạy Database và Cache:

```bash
docker-compose up -d
```

> Sẽ khởi tạo PostgreSQL ở port `5432`, Redis ở port `6379` và ChromaDB ở port `8000`.

### 3. Khởi chạy Core Backend (Spring Boot)

```bash
cd core-backend
./mvnw spring-boot:run
```

API Docs (Swagger) có sẵn tại: <http://localhost:8080/swagger-ui.html>

### 4. Khởi chạy AI Service (FastAPI)

```bash
cd ai-service
python -m venv venv
source venv/bin/activate  # Trên Windows dùng: venv\Scripts\activate
pip install -r requirements.txt
uvicorn app.main:app --reload --port 8001
```

### 5. Khởi chạy Mobile App (Flutter)

```bash
cd mobile_app
flutter pub get
flutter run
```

---

## 👥 Đội ngũ thực hiện

Dự án được thực hiện bởi nhóm sinh viên năm 4 - Khoa KHMT, Trường ĐH CNTT & TT Việt - Hàn (VKU):

| Thành viên          | Vai trò                                  |
| ------------------- | ---------------------------------------- |
| `<Tên Sinh Viên 1>` | Backend Developer (Spring Boot) & DevOps |
| `<Tên Sinh Viên 2>` | AI Engineer (FastAPI) & Database Design  |
| `<Tên Sinh Viên 3>` | Mobile Developer (Flutter)               |

👨‍🏫 **Giảng viên hướng dẫn:** `<Học hàm, Học vị, Tên GVHD>`

---

## 📄 License

Phân phối dưới giấy phép [MIT License](LICENSE). Xem file `LICENSE` để biết thêm chi tiết.
