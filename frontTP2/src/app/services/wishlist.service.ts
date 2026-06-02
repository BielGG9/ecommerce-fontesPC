import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

export interface Desejo {
  id: number;
  fonte: any;
}

@Injectable({
  providedIn: 'root'
})
export class WishlistService {
  private apiUrl = 'http://localhost:8081/desejos';

  constructor(private http: HttpClient) {}

  getWishlist(): Observable<Desejo[]> {
    return this.http.get<Desejo[]>(this.apiUrl);
  }

  adicionar(idFonte: number): Observable<Desejo> {
    return this.http.post<Desejo>(this.apiUrl, { idFonte });
  }

  remover(idDesejo: number): Observable<void> {
    return this.http.delete<void>(`${this.apiUrl}/${idDesejo}`);
  }
}
