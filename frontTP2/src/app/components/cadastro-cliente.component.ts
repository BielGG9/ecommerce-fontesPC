import { Component } from '@angular/core';
import { HttpClient, HttpParams, HttpHeaders } from '@angular/common/http';
import { Router } from '@angular/router';
import { FormsModule } from '@angular/forms';
import { CommonModule } from '@angular/common';
import { AuthService } from '../services/auth.service';

@Component({
  selector: 'app-cadastro-cliente',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './cadastro-cliente.component.html',
  styleUrl: './cadastro-cliente.component.css'
})
export class CadastroClienteComponent {
  nome = '';
  email = '';
  senha = '';
  isLoading = false;

  constructor(
    private http: HttpClient,
    private router: Router,
    private authService: AuthService
  ) {}

  criarContaRapida() {
    this.isLoading = true;
    const payload = { 
      nome: this.nome, 
      email: this.email, 
      senha: this.senha 
    };

    // Aponta para o endpoint do Quarkus
    this.http.post('http://localhost:8081/clientes/cadastro-expresso', payload)
      .subscribe({
        next: (res: any) => {
          // Após cadastrar com sucesso, faz o login automático buscando o token no Keycloak
          const loginUrl = 'http://localhost:8080/realms/TP2/protocol/openid-connect/token';
          const body = new HttpParams()
            .set('client_id', 'quarkuss')
            .set('grant_type', 'password')
            .set('username', this.email)
            .set('password', this.senha);

          const headers = new HttpHeaders({
            'Content-Type': 'application/x-www-form-urlencoded'
          });

          this.http.post<any>(loginUrl, body.toString(), { headers }).subscribe({
            next: (response) => {
              if (response && response.access_token) {
                // Salva o token na sessão
                localStorage.setItem('token', response.access_token);
                // Atualiza o estado global no serviço
                this.authService.atualizarUsuarioLogado(response.access_token);
              }
              // Redireciona para a vitrine inicial
              this.router.navigate(['/']);
            },
            error: (loginErr) => {
              console.error('Erro no login automático após cadastro:', loginErr);
              // Redireciona para a tela de login tradicional se falhar por algum motivo
              this.router.navigate(['/login']);
            },
            complete: () => {
              this.isLoading = false;
            }
          });
        },
        error: (err) => {
          console.error('Erro no cadastro expresso:', err);
          alert('Erro ao criar conta. Verifique os dados.');
          this.isLoading = false;
        }
      });
  }
}
