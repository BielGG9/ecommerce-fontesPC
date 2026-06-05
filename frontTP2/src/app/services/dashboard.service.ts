import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

export interface DashboardResponse {
  totalFontes: number;
  totalMarcas: number;
  vendasDiarias: number;
  quantidadeVendasDiarias: number;
}

@Injectable({
  providedIn: 'root'
})
export class DashboardService {
  private apiUrl = 'http://localhost:8081/admin/dashboard';

  constructor(private http: HttpClient) {}

  getEstatisticas(): Observable<DashboardResponse> {
    return this.http.get<DashboardResponse>(this.apiUrl);
  }
}
