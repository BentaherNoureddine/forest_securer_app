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
    return this.http.get<Report>(`${this.baseUrl}/getReport/${id}`);
  }

  getAllReports(): Observable<Report[]> {
    return this.http.get<Report[]>(`${this.baseUrl}/getAll`);
  }

  getImage(imagePath:string | undefined): Observable<Blob> {
    return this.http.get<Blob>(`${this.baseUrl}/getImage/${imagePath}`,{responseType : 'blob' as 'json'});
  }

  getReportLat(location :string) : number {
    return Number(location.indexOf(location,7));
  }
}
