import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Modelo } from '../models/modelo.models';
import { HttpParams } from '@angular/common/http';
@Injectable({
  providedIn: 'root'
})
export class ModeloService {
  private apiUrl = 'http://localhost:8081/modelos'; 

  constructor(private http: HttpClient) { }

  findAll(page: number = 0, pageSize: number = 10, nome: string = ''): Observable<Modelo[]> {
    let params = new HttpParams()
        .set('page', page.toString())
        .set('pageSize', pageSize.toString());

    if (nome) {
        params = params.set('nome', nome);
    }
    return this.http.get<Modelo[]>(this.apiUrl, { params });
  }

  count(nome: string = ''): Observable<number> {
    let params = new HttpParams();
    if (nome) {
        params = params.set('nome', nome);
    }
    return this.http.get<number>(`${this.apiUrl}/count`, { params });
  }

  findById(id: number): Observable<Modelo> {
    return this.http.get<Modelo>(`${this.apiUrl}/${id}`);
  }

  save(modelo: Modelo): Observable<Modelo> {
    return this.http.post<Modelo>(this.apiUrl, modelo);
  }

  update(modelo: Modelo): Observable<Modelo> {
    return this.http.put<Modelo>(`${this.apiUrl}/${modelo.id}`, modelo);
  }

  delete(id: number): Observable<void> {
    return this.http.delete<void>(`${this.apiUrl}/${id}`);
  }
}