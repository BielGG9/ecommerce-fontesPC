import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

export interface CupomResponse {
  codigo: string;
  porcentagem: number | null;
  valido: boolean;
}

@Injectable({
  providedIn: 'root'
})
export class CupomService {
  private apiUrl = 'http://localhost:8081/cupons';

  constructor(private http: HttpClient) {}

  validarCupom(codigo: string): Observable<CupomResponse> {
    return this.http.post<CupomResponse>(`${this.apiUrl}/validar`, { codigo });
  }
}
