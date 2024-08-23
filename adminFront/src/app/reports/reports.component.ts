import { Component, Input, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Report } from '../models/report';
import { RouterModule } from '@angular/router';
import { ReportService } from "../service/report_service";

@Component({
  selector: 'app-reports',
  standalone: true,
  imports: [CommonModule, RouterModule],
  templateUrl: './reports.component.html',
  styleUrls: ['./reports.component.css']
})
export class ReportsComponent implements OnInit {
  @Input() report!: Report;

  imageBlob: Blob | null = null;
  imageUrl: string | null = null;

  constructor(private reportService: ReportService) {}

  ngOnInit() {
    this.reportService.getImage(this.report.imagePath).subscribe(blob => {
      this.imageBlob = blob;
      this.imageUrl = URL.createObjectURL(blob);
    });
  }

}
