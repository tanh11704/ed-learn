package com.vku.edtech.modules.identity.infrastructure.persistence.entity;

import com.vku.edtech.modules.identity.domain.model.Role;
import com.vku.edtech.shared.infrastructure.persistence.entity.BaseEntity;
import jakarta.persistence.*;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.*;
import lombok.experimental.SuperBuilder;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

@Entity
@Table(name = "users")
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@SuperBuilder
public class UserJpaEntity extends BaseEntity {

    @NotBlank(message = "Email không được để trống")
    @Email(message = "Email không đúng định dạng")
    @Column(nullable = false, unique = true)
    private String email;

    @Column(name = "password_hash", nullable = false)
    private String passwordHash;

    @NotBlank(message = "Họ tên không thể để trống")
    @Size(max = 100, message = "Họ tên không được vượt quá 100 ký tự")
    @Column(name = "full_name", nullable = false, length = 100)
    private String fullName;

    @Enumerated(EnumType.STRING)
    @JdbcTypeCode(SqlTypes.NAMED_ENUM)
    @Column(name = "role")
    @Builder.Default
    private Role role = Role.USER;
}
