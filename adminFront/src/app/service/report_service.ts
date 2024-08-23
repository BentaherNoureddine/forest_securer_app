import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Report } from '../models/report'; // Make sure the path is correct

@Injectable({
  providedIn: 'root'
})
export class ReportService {
  private baseUrl = 'http://localhost:8082/reports';

  constructor(private http: HttpClient) {}

  getReportById(id: number): Observable<Report> {
    return this.http.get<Report>(`${this.baseUrl}/${id}`);
  }

  getAllReports(): Observable<Report[]> {
    return this.http.get<Report[]>(`${this.baseUrl}/getAll`);
  }

  getImage(imagePath:string): Observable<Blob> {
    return this.http.get<Blob>(`${this.baseUrl}/getImage/${imagePath}`,{responseType : 'blob' as 'json'});
  }
}
