package com.vku.edtech.modules.exams.presentation.dto.request;

import com.vku.edtech.modules.exams.domain.model.ExamQuestionPaperPart;
import com.vku.edtech.modules.exams.domain.model.ExamQuestionType;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.util.List;
import java.util.UUID;

@Schema(description = "Dữ liệu yêu cầu tạo câu hỏi")
public record CreateQuestionRequest(
        @Schema(description = "ID đề thi", example = "100ab6bd-ed08-4bfa-af40-d00977051d70")
                @NotNull(message = "examId không được để trống")
                UUID examId,
        @Schema(description = "Loại câu hỏi") @NotNull(message = "questionType không được để trống")
                ExamQuestionType questionType,
        @Schema(description = "Phần đề thi") @NotNull(message = "paperPart không được để trống")
                ExamQuestionPaperPart paperPart,
        @Schema(description = "Nội dung câu hỏi")
                @NotBlank(message = "content không được để trống")
                @Size(max = 5000, message = "content tối đa 5000 ký tự")
                String content,
        @Schema(description = "Thứ tự câu hỏi", example = "1") Integer orderIndex,
        @Schema(description = "Điểm của câu hỏi", example = "0.25")
                @NotNull(message = "score không được để trống")
                @DecimalMin(value = "0.01", message = "score phải lớn hơn 0")
                Double score,
        @Schema(description = "Đáp án chuẩn cho trả lời ngắn") String correctAnswer,
        @Schema(description = "Danh sách đáp án lựa chọn") List<CreateOptionRequest> options) {}
