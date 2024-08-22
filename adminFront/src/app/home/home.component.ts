import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ReportsComponent } from '../reports/reports.component';
import { Report } from '../models/report';
import { ReportService } from '../service/report_service';

@Component({
  selector: 'app-home',
  standalone: true,
  imports: [CommonModule, ReportsComponent],
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.css']
})
export class HomeComponent implements OnInit {
  reportsList: Report[] = [];

  constructor(private reportService: ReportService) {}

  ngOnInit() {
    console.log('Fetching reports...'); // Log before fetching

    this.reportService.getAllReports().subscribe(
      (reportsList: Report[]) => {
        console.log('Reports received:', reportsList); // Log the received reports
        this.reportsList = reportsList;
      },
      (error) => {
        console.error('Error fetching reports:', error);
      }
    );
  }
}
