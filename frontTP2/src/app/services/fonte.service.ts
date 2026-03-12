import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Fonte } from '../models/fonte.model';

@Injectable({
  providedIn: 'root'
})
export class FonteService {
  private apiUrl = 'http://localhost:8081/fontes';

  constructor(private http: HttpClient) { }

  findAll(): Observable<Fonte[]> {
    return this.http.get<Fonte[]>(this.apiUrl);
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
