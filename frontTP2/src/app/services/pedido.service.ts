import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';
import { Pedido } from '../models/pedido.model';
import { PedidoRequest } from '../models/pedido-request.model';

@Injectable({
  providedIn: 'root'
})
export class PedidoService {
  private apiUrl = 'http://localhost:8081/pedidos'; // URL do seu Quarkus

  constructor(private http: HttpClient) { }

  private mapToPedido(p: any): Pedido {
    return {
      id: p.id,
      dataHora: p.data ? new Date(p.data) : new Date(),
      valorTotal: p.total || 0,
      cliente: p.nomeCliente ? { nome: p.nomeCliente } as any : undefined,
      itens: (p.itensPedido || []).map((item: any) => ({
        id: item.id,
        quantidade: item.quantidade,
        precoUnitario: item.preco || 0,
        fonte: item.fonte
      }))
    };
  }

  findAll(): Observable<Pedido[]> {
    return this.http.get<any[]>(this.apiUrl).pipe(
      map(pedidos => pedidos.map(p => this.mapToPedido(p)))
    );
  }

  findById(id: number): Observable<Pedido> {
    return this.http.get<any>(`${this.apiUrl}/${id}`).pipe(
      map(p => this.mapToPedido(p))
    );
  }

  getMeusPedidos(): Observable<Pedido[]> {
    return this.http.get<any[]>(`${this.apiUrl}/meus-pedidos`).pipe(
      map(pedidos => pedidos.map(p => this.mapToPedido(p)))
    );
  }

  create(pedidoReq: PedidoRequest): Observable<Pedido> {
    return this.http.post<any>(this.apiUrl, pedidoReq).pipe(
      map(p => this.mapToPedido(p))
    );
  }

  update(id: number, pedido: Pedido): Observable<Pedido> {
    return this.http.put<any>(`${this.apiUrl}/${id}`, pedido).pipe(
      map(p => this.mapToPedido(p))
    );
  }

  delete(id: number): Observable<void> {
    return this.http.delete<void>(`${this.apiUrl}/${id}`);
  }
}