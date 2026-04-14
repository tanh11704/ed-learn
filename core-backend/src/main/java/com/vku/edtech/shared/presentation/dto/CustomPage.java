package com.vku.edtech.shared.presentation.dto;

import com.fasterxml.jackson.annotation.JsonTypeInfo;
import java.util.ArrayList;
import java.util.List;
import java.util.function.Function;
import java.util.stream.Collectors;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.domain.Page;

@Data
@NoArgsConstructor
@AllArgsConstructor
@JsonTypeInfo(use = JsonTypeInfo.Id.CLASS, include = JsonTypeInfo.As.PROPERTY, property = "@class")
public class CustomPage<T> {
    private List<T> content;
    private int pageNumber;
    private int pageSize;
    private long totalElements;
    private int totalPages;
    private boolean last;

    public static <T> CustomPage<T> from(Page<T> page) {
        return new CustomPage<>(
                new ArrayList<>(page.getContent()),
                page.getNumber(),
                page.getSize(),
                page.getTotalElements(),
                page.getTotalPages(),
                page.isLast());
    }

    public <U> CustomPage<U> map(Function<? super T, ? extends U> converter) {
        // Lấy danh sách content hiện tại, map từng phần tử, rồi gom lại thành List mới
        List<U> convertedContent =
                this.content.stream().map(converter).collect(Collectors.toList());

        // Trả về một CustomPage mới chứa data đã được map, giữ nguyên thông số phân trang
        return new CustomPage<>(
                convertedContent,
                this.pageNumber,
                this.pageSize,
                this.totalElements,
                this.totalPages,
                this.last);
    }
}
