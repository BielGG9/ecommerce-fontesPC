import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Cliente } from '../models/cliente.model';

@Injectable({
  providedIn: 'root'
})
export class ClienteService {

  private apiUrl = 'http://localhost:8081/clientes';

  constructor(private http: HttpClient) { }

  registrar(cliente: Cliente): Observable<Cliente> {
    return this.http.post<Cliente>(this.apiUrl, cliente);
  }

  getMeuPerfil(): Observable<Cliente> {
    return this.http.get<Cliente>(`${this.apiUrl}/meu-perfil`);
  }

  update(id: number | undefined, cliente: Partial<Cliente>): Observable<Cliente> {
    return this.http.put<Cliente>(`${this.apiUrl}/${id}`, cliente);
  }

  validarSenhaESolicitarAlteracao(senha: string): Observable<any> {
    return this.http.post<any>(`${this.apiUrl}/solicitar-alteracao-segura`, { senha });
  }
}
