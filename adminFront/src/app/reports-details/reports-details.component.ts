import {Component, inject} from '@angular/core';
import {ActivatedRoute} from "@angular/router";
import {ReportService} from "../service/report_service";

@Component({
  selector: 'app-reports-details',
  standalone: true,
  imports: [],
  templateUrl: './reports-details.component.html',
  styleUrl: './reports-details.component.css'
})
export class ReportsDetailsComponent {

  route:ActivatedRoute = inject(ActivatedRoute);
  reportService=inject(ReportService);
  report:Report | undefined;

  constructor() {
    const reportId =Number(this.route.snapshot.params['id']);


  }

}
