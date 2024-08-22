import { Component } from '@angular/core';
import {CommonModule} from "@angular/common";
import  {ReportsComponent} from "../reports/reports.component";

@Component({
  selector: 'app-home',
  standalone: true,
  imports: [CommonModule,ReportsComponent],
  templateUrl: './home.component.html',
  styleUrl: './home.component.css'
})
export class HomeComponent {

}
