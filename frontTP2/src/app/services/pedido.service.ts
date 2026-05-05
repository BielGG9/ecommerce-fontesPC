import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Pedido } from '../models/pedido.model';
import { PedidoRequest } from '../models/pedido-request.model';

@Injectable({
  providedIn: 'root'
})
export class PedidoService {
  private apiUrl = 'http://localhost:8081/pedidos'; // URL do seu Quarkus

  constructor(private http: HttpClient) { }

  findAll(): Observable<Pedido[]> {
    return this.http.get<Pedido[]>(this.apiUrl);
  }

  findById(id: number): Observable<Pedido> {
    return this.http.get<Pedido>(`${this.apiUrl}/${id}`);
  }

  create(pedidoReq: PedidoRequest): Observable<Pedido> {
    return this.http.post<Pedido>(this.apiUrl, pedidoReq);
  }

  update(id: number, pedido: Pedido): Observable<Pedido> {
    return this.http.put<Pedido>(`${this.apiUrl}/${id}`, pedido);
  }

  delete(id: number): Observable<void> {
    return this.http.delete<void>(`${this.apiUrl}/${id}`);
  }
}