package com.noureddine.report_service.models;


import jakarta.persistence.*;
import lombok.*;
import org.springframework.data.annotation.CreatedDate;
import java.util.Date;


@Entity
@AllArgsConstructor
@NoArgsConstructor
@Builder
@Getter
@Setter
@ToString
public class Report {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Enumerated(EnumType.STRING)
    private Category category;

    private String description;

    private String reporterId;

    private String title;

    private String address;

    private String imagePath;

    private String lat;

    private String lng;

    @CreatedDate
    private Date createdAt;

}
