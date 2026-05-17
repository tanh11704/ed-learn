package com.vku.edtech.modules.exams.application.service;

import com.vku.edtech.modules.exams.application.exception.ExamNotFoundException;
import com.vku.edtech.modules.exams.application.port.in.DeleteOptionUseCase;
import com.vku.edtech.modules.exams.application.port.out.ExamOptionCommandPort;
import com.vku.edtech.modules.exams.application.port.out.ExamOptionQueryPort;
import com.vku.edtech.modules.exams.domain.model.ExamQuestionOption;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class DeleteOptionService implements DeleteOptionUseCase {

    private final ExamOptionQueryPort optionQueryPort;
    private final ExamOptionCommandPort optionCommandPort;

    @Override
    @Transactional
    public void delete(DeleteOptionCommand command) {
        ExamQuestionOption option =
                optionQueryPort
                        .findById(command.optionId())
                        .orElseThrow(() -> new ExamNotFoundException("Không tìm thấy option"));
        optionCommandPort.deleteById(option.getId());
    }
}
