import { Component, inject, Input, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { ReportService } from '../service/report_service';
import { Report } from '../models/report';
import {GoogleMap, MapMarker} from '@angular/google-maps';



@Component({
  selector: 'app-reports-details',
  standalone: true,
  imports: [GoogleMap, MapMarker],
  templateUrl: './reports-details.component.html',
  styleUrls: ['./reports-details.component.css']
})
export class ReportsDetailsComponent implements OnInit {
  @Input() report!: Report;




  route: ActivatedRoute = inject(ActivatedRoute);
  reportId: number | null = null;
  imageUrl: string | undefined;

  lat?: number ;
  lng?: number ;




  constructor(protected reportService: ReportService) {}

  ngOnInit(): void {
    this.reportId = Number(this.route.snapshot.params['id']);
    if (this.reportId !== null) {
      this.reportService.getReportById(this.reportId).subscribe(report => {
        this.report = report;
        this.lat = Number(report.lat);
        this.lng = Number(report.lng);
        this.loadImage();
      });
    }
  }

  loadImage(): void {
    if (this.report?.imagePath) {
      this.reportService.getImage(this.report.imagePath).subscribe(blob => {
        this.imageUrl = URL.createObjectURL(blob);
      });
    }
  }

  //INITIALISE THE MAP
  ready(map: google.maps.Map) {
    if (this.lat !== undefined && this.lng !== undefined) {
      map.setCenter(new google.maps.LatLng(this.lat, this.lng));
      map.setMapTypeId(google.maps.MapTypeId.SATELLITE);
    }
  }


  initMarker(marker: google.maps.Marker) {
    if (this.lat !== undefined && this.lng !== undefined) {
      const position: google.maps.LatLngLiteral = { lat: this.lat, lng: this.lng };
      marker.setPosition(position);
      marker.setTitle(this.report.title)
      marker.setIcon()
    }
  }
}
