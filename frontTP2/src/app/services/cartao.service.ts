import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

export interface Cartao {
  id?: number;
  numeroCartao: string;
  nomeImpresso: string;
  validadeCartao?: string;
  cvv?: string;
}

export interface CartaoRequest {
  numeroCartao: string;
  nomeImpresso: string;
  validadeCartao?: string;
  cvv?: string;
}

@Injectable({
  providedIn: 'root'
})
export class CartaoService {
  private apiUrl = 'http://localhost:8081/cartoes';

  constructor(private http: HttpClient) { }

  findAll(): Observable<Cartao[]> {
    return this.http.get<Cartao[]>(this.apiUrl);
  }

  findById(id: number): Observable<Cartao> {
    return this.http.get<Cartao>(`${this.apiUrl}/${id}`);
  }

  create(cartaoReq: CartaoRequest): Observable<Cartao> {
    return this.http.post<Cartao>(this.apiUrl, cartaoReq);
  }

  update(id: number, cartaoReq: CartaoRequest): Observable<Cartao> {
    return this.http.put<Cartao>(`${this.apiUrl}/${id}`, cartaoReq);
  }

  delete(id: number): Observable<void> {
    return this.http.delete<void>(`${this.apiUrl}/${id}`);
  }
}
