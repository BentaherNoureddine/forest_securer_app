import { Injectable } from '@angular/core';
import {HttpClient} from "@angular/common/http";
import {Observable} from "rxjs";

@Injectable({
  providedIn: 'root'
})

export class ReportService {


  private baseUrl = 'http://localhost:8080/reports';

  constructor(private http: HttpClient) {}

  getReport(id : number): Observable<any> {
    return this.http.get(`${this.baseUrl}/${id}`, {})
  }

  getAllReports():Observable<any> {
    return this.http.get(`${this.baseUrl}/getAll`);
  }
}
