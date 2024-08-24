package com.noureddine.report_service.requests;


import com.noureddine.report_service.models.Category;
import jakarta.validation.constraints.NotNull;
import org.springframework.web.multipart.MultipartFile;
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
    String location,

    @NotNull(message = "the title mandatory")
    String title,

    @NotNull(message = "the latitude is mandatory")
    String lat,

    @NotNull(message = "the longitude is mandatory")
    String lng,

    @NotNull(message = "the address mandatory")
    String address
    ) {

}

