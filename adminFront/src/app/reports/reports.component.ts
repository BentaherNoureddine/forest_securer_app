import { Component, Input, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Report } from '../models/report';
import { RouterModule } from '@angular/router';

@Component({
  selector: 'app-reports',
  standalone: true,
  imports: [CommonModule, RouterModule],
  templateUrl: './reports.component.html',
  styleUrls: ['./reports.component.css']
})
export class ReportsComponent {
  @Input() report!: Report;


}
