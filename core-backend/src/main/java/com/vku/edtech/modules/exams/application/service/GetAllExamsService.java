package com.vku.edtech.modules.exams.application.service;

import com.vku.edtech.modules.exams.application.port.in.GetAllExamsUseCase;
import com.vku.edtech.modules.exams.application.port.out.ExamQueryPort;
import com.vku.edtech.modules.exams.domain.model.Exam;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class GetAllExamsService implements GetAllExamsUseCase {

    private final ExamQueryPort examQueryPort;

    @Override
    public List<Exam> getAllExams(String status) {
        if ("ARCHIVED".equalsIgnoreCase(status)) {
            return examQueryPort.findAllByStatus("ARCHIVED");
        }
        if ("DRAFT".equalsIgnoreCase(status) || "PUBLISHED".equalsIgnoreCase(status)) {
            return examQueryPort.findAllByStatus(status.toUpperCase());
        }
        return examQueryPort.findAllActive();
    }
}
