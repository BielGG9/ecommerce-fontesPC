import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

export interface Telefone {
  id?: number;
  ddd: string;
  numero: string;
  // pessoa/cliente ID is required on creation
}

export interface TelefoneRequest {
  ddd: string;
  numero: string;
  idPessoa: number;
}

@Injectable({
  providedIn: 'root'
})
export class TelefoneService {
  private apiUrl = 'http://localhost:8081/telefones';

  constructor(private http: HttpClient) { }

  findAll(): Observable<Telefone[]> {
    return this.http.get<Telefone[]>(this.apiUrl);
  }

  findById(id: number): Observable<Telefone> {
    return this.http.get<Telefone>(`${this.apiUrl}/${id}`);
  }

  create(telefoneReq: TelefoneRequest): Observable<Telefone> {
    return this.http.post<Telefone>(this.apiUrl, telefoneReq);
  }

  update(id: number, telefoneReq: TelefoneRequest): Observable<Telefone> {
    return this.http.put<Telefone>(`${this.apiUrl}/${id}`, telefoneReq);
  }

  delete(id: number): Observable<void> {
    return this.http.delete<void>(`${this.apiUrl}/${id}`);
  }
}
