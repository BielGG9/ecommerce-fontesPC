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

  alterarSenha(senhaAtual: string, novaSenha: string): Observable<void> {
    return this.http.post<void>(`${this.apiUrl}/alterar-senha`, { senhaAtual, novaSenha });
  }

  completarCadastro(dados: {
    cpf: string;
    cep: string;
    logradouro: string;
    numero: string;
    telefone: string;
  }): Observable<any> {
    return this.http.put<any>(`${this.apiUrl}/completar-cadastro`, dados);
  }

  uploadAvatar(idCliente: number, file: File): Observable<any> {
    const formData = new FormData();
    formData.append('idCliente', idCliente.toString());
    formData.append('file', file);
    return this.http.patch(`${this.apiUrl}/image/upload`, formData);
  }
}
