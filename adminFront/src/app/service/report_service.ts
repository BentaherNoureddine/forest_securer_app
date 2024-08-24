import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import {map, Observable, pipe} from 'rxjs';
import { Report } from '../models/report';

@Injectable({
  providedIn: 'root'
})
export class ReportService {
  private baseUrl = 'http://localhost:8080';

  constructor(private http: HttpClient) {}

  getReportById(id: number): Observable<Report> {
    return this.http.get<Report>(`${this.baseUrl}/reports/getReport/${id}`);
  }

  getAllReports(): Observable<Report[]> {
    return this.http.get<Report[]>(`${this.baseUrl}/reports/getAll`);
  }

  getImage(imagePath:string | undefined): Observable<Blob> {
    return this.http.get<Blob>(`${this.baseUrl}/reports/getImage/${imagePath}`,{responseType : 'blob' as 'json'});
  }


  authenticate(email: string, password: string): Observable<any> {
    return this.http.post<any>(`${this.baseUrl}/auth/authenticate`,
      { email: email, password: password },
      { observe: 'response',headers: { 'Content-Type': 'application/json' } }
    );
  }

}
