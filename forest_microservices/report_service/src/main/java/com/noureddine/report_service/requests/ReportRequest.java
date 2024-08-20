package com.noureddine.report_service.requests;


import com.noureddine.report_service.models.Category;
import jakarta.validation.constraints.NotNull;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;

public record ReportRequest (



    @NotNull(message = "the category mandatory")
    Category category,

    @NotNull(message = "the reporterId mandatory")
    String reporterId,

    @NotNull(message = "the description mandatory")
    String description,

    @NotNull(message = "the photo mandatory")
    MultipartFile  img,


    @NotNull(message = "the location mandatory")
    String location
    ) {

}

