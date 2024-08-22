package com.noureddine.report_service.services;


import com.noureddine.report_service.models.Report;
import com.noureddine.report_service.repositories.ReportRepository;
import com.noureddine.report_service.requests.ReportRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.util.Date;
import java.util.List;
import java.util.UUID;


@Service
@RequiredArgsConstructor
public class ReportService {
    private final ReportRepository reportRepository;



    //CREATE REPORT
    public  void create(ReportRequest request, String imagePath) throws Exception {

        Report report = Report.builder()
                .category(request.category())
                .title(request.title())
                .address(request.address())
                .location(request.location())
                .description(request.description())
                .imagePath(imagePath)
                .reporterId(request.reporterId())
                .createdAt(new Date())
                .build();
        reportRepository.save(report);


    }

    public List<Report> getAllReports() throws Exception {

            return reportRepository.findAll();

    }

    public  Report getReport(Long reportId) throws Exception {

        return reportRepository.findById(reportId).orElseThrow();
    }


    ///////////////IMAGE SECTION /////////



    // Save image in a local directory
    public String saveImageToStorage(String uploadDirectory, MultipartFile imageFile) throws IOException {
        String uniqueFileName = UUID.randomUUID().toString() + "_" + imageFile.getOriginalFilename();
        Path uploadPath = Path.of(uploadDirectory);
        Path filePath = uploadPath.resolve(uniqueFileName);

        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }

        Files.copy(imageFile.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);

        return uniqueFileName;
    }


    // To view an image
    public byte[] getImage(String imageDirectory, String imageName) throws IOException {
        Path imagePath = Path.of(imageDirectory, imageName);

        if (Files.exists(imagePath)) {
            byte[] imageBytes = Files.readAllBytes(imagePath);
            return imageBytes;
        } else {
            return null; // Handle missing images
        }
    }

    // Delete an image
    public String deleteImage(String imageDirectory, String imageName) throws IOException {
        Path imagePath = Path.of(imageDirectory, imageName);

        if (Files.exists(imagePath)) {
            Files.delete(imagePath);
            return "Success";
        } else {
            return "Failed"; // Handle missing images
        }
    }

    public  void createAd(MultipartFile[] adsImages ) throws IOException {
        String uploadDirectory = "src/main/resources/static/images/ads";
        String adsImagesString = "";
        for (MultipartFile imageFile : adsImages) {
            adsImagesString += saveImageToStorage(uploadDirectory, imageFile) + ",";
        }



    }
}
