# 📘 Bộ Quy Tắc Clean Code & Clean Architecture

> Tài liệu chuẩn hóa các nguyên tắc thiết kế phần mềm theo hướng Clean Architecture, DDD và OOP hiện đại.

---

## 1. Kiến trúc & Tổ chức Mã Nguồn

### 1.1 Tổ chức thư mục theo Tính năng (Vertical Slice Architecture)

**✅ Do — Cấu trúc theo module/feature:**

```
shoppingcart/
  place/
  update/
order/
  place/
  cancel/
```

**❌ Don't — Cấu trúc theo loại class kỹ thuật:**

```
controllers/
services/
repositories/
entities/
```

---

### 1.2 Sử dụng Use Case cụ thể thay vì Service khổng lồ

**✅ Do — Tách thành các class chuyên biệt (tuân thủ SRP):**

```java
PlaceOrderUseCase
UpdateOrderUseCase
DeleteOrderUseCase
```

**❌ Don't — Nhồi nhét mọi logic vào một class duy nhất:**

```java
OrderService  // vi phạm Single Responsibility Principle
```

---

### 1.3 Luôn dùng DTO để giao tiếp, KHÔNG dùng Entity

**✅ Do — Nhận/trả qua DTO:**

```java
// Controller nhận InputUser, trả về OutputUser
// Entity chỉ dùng nội bộ ở tầng Domain
```

**❌ Don't — Truyền Entity ra ngoài:**

```java
// Trả thẳng Entity User ra Response → lộ mật khẩu, dữ liệu nhạy cảm
```

---

### 1.4 Đảo ngược Phụ thuộc (Dependency Inversion) với Repository

**✅ Do:**

- Interface `UserRepository` đặt ở tầng **Domain**
- Triển khai `JpaUserRepository` đặt ở tầng **Infrastructure**

**❌ Don't:**

- Đặt interface Repository ở tầng Use Case
- Dùng thẳng Spring Data JPA vào logic Domain

---

### 1.5 Tách biệt Framework khỏi Use Case / Domain

**✅ Do — Xử lý Transaction qua Decorator:**

```java
// Bọc Use Case bằng TransactionalUseCase
```

**❌ Don't — Annotation framework trực tiếp vào Domain:**

```java
@Transactional  // KHÔNG đặt ở tầng Domain hoặc Use Case
public void placeOrder(...) { ... }
```

---

## 2. Thiết kế Lớp (Class) & OOP

### 2.1 Gộp Dữ liệu và Hành vi — Tránh Anemic Domain Model

**✅ Do — Class chứa cả thuộc tính lẫn hành vi:**

```java
class User {
    private String password;

    public void changePassword(String newPassword) {
        // validate & set
    }
}
```

**❌ Don't — Class chỉ có getter/setter, logic nằm nơi khác:**

```java
class User {
    private String password;
    public String getPassword() { return password; }
    public void setPassword(String p) { password = p; }
}
// Logic đổi mật khẩu bị rải rác ở nơi khác
```

---

### 2.2 Tell, Don't Ask (Bảo làm, đừng hỏi)

**✅ Do:**

```java
double volume = cube.calculateVolume();
```

**❌ Don't:**

```java
double volume = cube.getWidth() * cube.getHeight() * cube.getDepth();
```

---

### 2.3 Đảm bảo tính Bất biến (Immutability)

**✅ Do:**

```java
return Collections.unmodifiableList(items);
```

**❌ Don't:**

```java
return this.items;  // Mã bên ngoài có thể tùy ý sửa danh sách nội bộ
```

---

### 2.4 Ưu tiên Composition hơn Inheritance

**✅ Do:**

```java
class NotificationService {
    private final MessageSender sender;  // Inject qua constructor

    public NotificationService(MessageSender sender) {
        this.sender = sender;
    }
}
```

**❌ Don't:**

```java
class MyList extends ArrayList { ... }  // Fragile Base Class Problem
class MySet extends HashSet { ... }
```

---

### 2.5 Thay thế If/Else phức tạp bằng Đa hình (Polymorphism)

**✅ Do:**

```java
shape.draw();  // Circle, Square tự xử lý theo loại của chúng
```

**❌ Don't:**

```java
if (type == "circle") drawCircle();
else if (type == "square") drawSquare();
// Thêm loại mới → phải sửa điều kiện ở nhiều nơi
```

---

## 3. Nguyên tắc Hàm & Clean Code Chung

### 3.1 Quản lý Logging qua Dependency Injection

**✅ Do:**

```java
class PlaceOrderUseCase {
    private final Logger logger;

    public PlaceOrderUseCase(Logger logger) {
        this.logger = logger;
    }
}
```

**❌ Don't:**

```java
private static final Logger log = LoggerFactory.getLogger(PlaceOrderUseCase.class);
// Cả codebase bị dính chặt vào SLF4J, khó test và thay thế
```

---

### 3.2 Xử lý Exception theo Miền (Domain Exception)

**✅ Do:**

```java
throw new InsufficientBalanceException("Số dư không đủ để thực hiện giao dịch");

// Tên hàm có thể ném lỗi dùng tiền tố try:
tryLoadConfig();
```

**❌ Don't:**

```java
throw new Exception("HTTP 500: SQL error: column not found");
// Lộ chi tiết kỹ thuật ở tầng Domain
// Dùng mã lỗi số nguyên vô nghĩa: return -1;
```

---

### 3.3 Giới hạn độ dài Class, Hàm và số lượng Tham số

| Thành phần           | Giới hạn khuyến nghị                           |
| -------------------- | ---------------------------------------------- |
| Thuộc tính của Class | Tối đa **5–7** (dùng Value Object để gom nhóm) |
| Dòng code của Class  | Tối đa **~200 dòng** (vượt → nên tách lớp)     |
| Lệnh trong một hàm   | Khoảng **5–7 lệnh**                            |
| Tham số của hàm      | Tối đa **3–4 tham số**                         |

**✅ Do — Dùng Value Object để gom nhóm:**

```java
class User {
    private Name name;       // gom firstName, lastName
    private Address address; // gom street, city, zipCode
}
```

**❌ Don't:**

```java
class UserService {
    // 2000 dòng code...
    public void process(String a, int b, boolean flag1, boolean flag2) { ... }
    // Flag parameter ẩn nghĩa → khó đọc, khó test
}
```

---

### 3.4 Loại bỏ Magic Numbers/Strings và Mã Thừa

**✅ Do:**

```java
private static final double VAT_RATE = 0.07;

double tax = price * VAT_RATE;  // Rõ ràng, dễ bảo trì
```

**❌ Don't:**

```java
double tax = price * 0.07;  // 0.07 nghĩa là gì?

// Code cũ comment lại "phòng hờ" → biến source thành bãi rác:
// double tax = price * 0.05;
```

> **Quy tắc vàng:** Xóa hẳn code không dùng nữa. Version control (Git) sẽ giữ lịch sử cho bạn.

---

## 📌 Tổng kết nhanh

| #   | Nguyên tắc                                      | Từ khóa            |
| --- | ----------------------------------------------- | ------------------ |
| 1   | Tổ chức theo Feature, không theo Layer          | Vertical Slice     |
| 2   | Mỗi Use Case một class                          | SRP                |
| 3   | Giao tiếp qua DTO, không qua Entity             | DTO                |
| 4   | Interface Domain, Implementation Infrastructure | DIP                |
| 5   | Framework tách khỏi Domain                      | Clean Architecture |
| 6   | Domain Model có hành vi                         | Rich Domain Model  |
| 7   | Tell, Don't Ask                                 | Law of Demeter     |
| 8   | Trả về bản sao bất biến                         | Immutability       |
| 9   | Composition > Inheritance                       | Composition        |
| 10  | Polymorphism thay if/else                       | OCP                |
| 11  | Logger qua DI                                   | Testability        |
| 12  | Exception mang nghĩa nghiệp vụ                  | Domain Exception   |
| 13  | Hàm ngắn, ít tham số                            | Clean Functions    |
| 14  | Không có Magic Numbers                          | Readability        |
