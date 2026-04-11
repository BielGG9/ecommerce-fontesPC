import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Fonte } from '../models/fonte.model';
import { HttpParams } from '@angular/common/http';


@Injectable({
  providedIn: 'root'
})
export class FonteService {
  private apiUrl = 'http://localhost:8081/fontes';

  constructor(private http: HttpClient) { }

  findAll(page: number = 0, pageSize: number = 10, nome: string = ''): Observable<Fonte[]> {

    // Cria os parâmetros da requisição
    let params = new HttpParams()
      .set('page', page.toString())
      .set('pageSize', pageSize.toString());

    // Adiciona o parâmetro de busca se ele não estiver vazio
    if (nome) {
      params = params.set('nome', nome);
    }
    return this.http.get<Fonte[]>(this.apiUrl, { params });
  }

  // Conta o número total de fontes
  count(nome: string = ''): Observable<number> {
    let params = new HttpParams();
    if (nome) {
      params = params.set('nome', nome);
    }
    return this.http.get<number>(`${this.apiUrl}/count`, { params });
  }

  findById(id: number): Observable<Fonte> {
    return this.http.get<Fonte>(`${this.apiUrl}/${id}`);
  }

  save(fonte: Fonte): Observable<Fonte> {
    return this.http.post<Fonte>(this.apiUrl, fonte);
  }

  update(fonte: Fonte): Observable<Fonte> {
    return this.http.put<Fonte>(`${this.apiUrl}/${fonte.id}`, fonte);
  }

  delete(id: number): Observable<void> {
    return this.http.delete<void>(`${this.apiUrl}/${id}`);
  }
}
