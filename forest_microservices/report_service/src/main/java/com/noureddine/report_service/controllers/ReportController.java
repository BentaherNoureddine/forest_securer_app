package com.noureddine.report_service.controllers;


import com.noureddine.report_service.models.Category;
import com.noureddine.report_service.models.Report;
import com.noureddine.report_service.repositories.ReportRepository;
import com.noureddine.report_service.requests.ReportRequest;
import com.noureddine.report_service.services.ReportService;
import jakarta.ws.rs.NotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;

@RestController
@RequestMapping("/reports")
@RequiredArgsConstructor
@CrossOrigin(origins = "http://localhost:4200")
public class ReportController {

    private final ReportService reportService;

    private final ReportRepository reportRepository;



    //CREATE A REPORT
    @PostMapping("/create")
    public ResponseEntity<?> createReport(
            @RequestParam("category") Category category,
            @RequestParam("reporterId") String reporterId,
            @RequestParam("description") String description,
            @RequestParam("location") String location,
            @RequestParam("title") String title,
            @RequestParam("address") String address,
            @RequestParam(value = "image", required = false) MultipartFile image) {
        try {
            String imagePath = null;
            if (image != null && !image.isEmpty()) {
                // Save the image and get the path
                imagePath = reportService.saveImageToStorage("src/main/resources/static/images", image);
            }

            ReportRequest request = new ReportRequest(category,reporterId,description,image,location,address,title);


            reportService.create(request, imagePath);

            return ResponseEntity.status(HttpStatus.CREATED).body("Report created");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(e.getMessage());
        }
    }


    //FETCH ALL REPORTS
    @GetMapping("/getAll")
    public ResponseEntity<?> getAllReports() {
        try{

           List<Report> reports = reportService.getAllReports();
            return ResponseEntity.status(HttpStatus.OK).body(reports);

        } catch (NotFoundException e){
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());

        }
        catch (Exception e){
           return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("error while getting reports");
        }
    }



    //FETCH REPORTS BY ID
    @GetMapping("/{id}")
    public Report getReport(Long id) {

        System.out.println(reportRepository.findById(id));
        return  reportRepository.findById(id).orElseThrow(() -> new NotFoundException("Report not found"));

    }

    //FETCH AN IMAGE BY THE GIVEN PATH
    @GetMapping("/getImage/{imagePath}")
    public ResponseEntity<byte[]> getImage(@PathVariable String imagePath) {
        try {
            byte[] imageBytes = reportService.getImage("src/main/resources/static/images", imagePath);
            for(int i=0;i<10;i++){
                System.out.println(imagePath);
                System.out.println(imageBytes);

            }

            if (imageBytes != null) {
                MediaType mediaType = MediaType.IMAGE_JPEG; // or determine the type dynamically
                return ResponseEntity.ok()
                        .contentType(mediaType)
                        .body(imageBytes);
            } else {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
            }
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }

}






