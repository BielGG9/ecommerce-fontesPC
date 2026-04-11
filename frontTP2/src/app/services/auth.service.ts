import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { BehaviorSubject, Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class AuthService {
  
  public usuarioLogado$ = new BehaviorSubject<string | null>(null);
  private http = inject(HttpClient);

  constructor() {
    const token = localStorage.getItem('token');
    if (token) {
      this.atualizarUsuarioLogado(token);
    } else {
      this.atualizarUsuarioLogado(null);
    }
  }

  atualizarUsuarioLogado(token: string | null): void {
    if (token) {
      this.usuarioLogado$.next(this.extrairNomeDoToken(token));
    } else {
      this.usuarioLogado$.next(null);
    }
  }

  definirSessao(token: string): void {
    localStorage.setItem('token', token);
    this.atualizarUsuarioLogado(token);
  }

  limparSessao(): void {
    localStorage.removeItem('token');
    this.atualizarUsuarioLogado(null);
  }

  solicitarRecuperacaoSenha(email: string): Observable<any> {
    const url = 'http://localhost:8081/clientes/esqueci-senha';
    return this.http.post(url, { email });
  }

  private extrairNomeDoToken(token: string): string | null {
    try {
      const base64Url = token.split('.')[1];
      const base64 = base64Url.replace(/-/g, '+').replace(/_/g, '/');
      const jsonPayload = decodeURIComponent(window.atob(base64).split('').map(function(c) {
          return '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2);
      }).join(''));
      
      const payload = JSON.parse(jsonPayload);
      return payload.given_name || payload.name || payload.preferred_username || 'Utilizador';
    } catch (e) {
      return null;
    }
  }

  hasRole(role: string): boolean {
    const token = localStorage.getItem('token');
    if (!token) return false;
    
    try {
      const base64Url = token.split('.')[1];
      const base64 = base64Url.replace(/-/g, '+').replace(/_/g, '/');
      const jsonPayload = decodeURIComponent(window.atob(base64).split('').map(function(c) {
          return '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2);
      }).join(''));
      
      const payload = JSON.parse(jsonPayload);
      
      if (payload.realm_access && payload.realm_access.roles && payload.realm_access.roles.includes(role)) {
        return true;
      }
      if (payload.groups && payload.groups.includes(role)) {
        return true;
      }
      if (payload.roles && payload.roles.includes(role)) {
         return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
