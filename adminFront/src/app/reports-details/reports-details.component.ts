import {Component, inject, Input, OnInit} from '@angular/core';
import {ActivatedRoute} from "@angular/router";
import {ReportService} from "../service/report_service";
import {Report} from "../models/report";

@Component({
  selector: 'app-reports-details',
  standalone: true,
  imports: [],
  templateUrl: './reports-details.component.html',
  styleUrl: './reports-details.component.css'
})
export class ReportsDetailsComponent implements OnInit {
  @Input() report!: Report;

  route: ActivatedRoute = inject(ActivatedRoute);

  reportId: number | null = null;
  imageUrl: string | undefined;

  constructor(protected reportService: ReportService) {}

  ngOnInit(): void {
    this.reportId = Number(this.route.snapshot.params['id']);
    if (this.reportId !== null) {
      this.reportService.getReportById(this.reportId).subscribe(report => {
        this.report = report;
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
}


