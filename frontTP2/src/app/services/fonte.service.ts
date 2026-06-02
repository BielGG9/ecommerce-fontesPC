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

  findAll(page: number, pageSize: number, nome?: string, idMarca?: number, categoria?: string): Observable<any> {
    let params = new HttpParams()
      .set('page', page.toString())
      .set('pageSize', pageSize.toString());
    if (nome) params = params.set('nome', nome);
    if (idMarca) params = params.set('marca', idMarca.toString());
    if (categoria) params = params.set('categoria', categoria);
    return this.http.get<any>(this.apiUrl, { params });
  }

  count(nome: string = '', idMarca?: number, categoria?: string): Observable<number> {
    let params = new HttpParams();
    if (nome) params = params.set('nome', nome);
    if (idMarca) params = params.set('marca', idMarca.toString());
    if (categoria) params = params.set('categoria', categoria);
    return this.http.get<number>(`${this.apiUrl}/count`, { params });
  }

  getCertificacoes(): Observable<string[]> {
    return this.http.get<string[]>(`${this.apiUrl}/certificacoes`);
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

  uploadImagem(idFonte: number, file: File): Observable<any> {
    const formData = new FormData();
    formData.append('idFonte', idFonte.toString());
    formData.append('file', file);
    return this.http.patch(`${this.apiUrl}/image/upload`, formData);
  }

  deleteImagem(fid: string): Observable<any> {
    return this.http.delete(`${this.apiUrl}/image/${fid}`);
  }
}
