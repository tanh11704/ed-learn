package com.vku.edtech.modules.lms.infrastructure.persistence.mapper;

import com.vku.edtech.modules.lms.domain.model.ErrorBankCard;
import com.vku.edtech.modules.lms.infrastructure.persistence.entity.ErrorBankJpaEntity;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface ErrorBankMapper {
    ErrorBankCard toDomain(ErrorBankJpaEntity entity);

    ErrorBankJpaEntity toEntity(ErrorBankCard domain);
}
