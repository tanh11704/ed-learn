package com.vku.edtech.modules.identity.repository;

import com.vku.edtech.modules.identity.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface UserRepository extends JpaRepository<User, UUID> {
}
