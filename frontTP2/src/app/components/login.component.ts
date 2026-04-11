import { Component, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormBuilder, FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';
import { Router, RouterModule } from '@angular/router';
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { AuthService } from '../services/auth.service';
import { MatCardModule } from '@angular/material/card';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';

@Component({
  selector: 'app-login',
  standalone: true,
  imports: [
    CommonModule,
    ReactiveFormsModule,
    RouterModule,
    MatCardModule,
    MatFormFieldModule,
    MatInputModule,
    MatButtonModule,
    MatIconModule
  ],
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css']
})
export class LoginComponent {
  loginForm: FormGroup;
  erroLogin: string | null = null;

  private fb = inject(FormBuilder);
  private http = inject(HttpClient);
  private router = inject(Router);
  private authService = inject(AuthService);

  constructor() {
    this.loginForm = this.fb.group({
      email: ['', [Validators.required, Validators.email]],
      senha: ['', [Validators.required]]
    });
  }

  obterMensagemErro(campo: string, nomeCampo: string): string {
    const controle = this.loginForm.get(campo);
    if (controle?.hasError('required')) {
      return `${nomeCampo} obrigatório`;
    }
    if (controle?.hasError('email')) {
      return `E-mail inválido`;
    }
    return '';
  }

  efetuarLogin() {
    if (this.loginForm.valid) {
      this.erroLogin = null;
      const { email, senha } = this.loginForm.value;

      const url = 'http://localhost:8080/realms/meu-realm/protocol/openid-connect/token';
      const body = new HttpParams()
        .set('client_id', 'quarkuss')
        .set('grant_type', 'password')
        .set('username', email)
        .set('password', senha);

      const headers = new HttpHeaders({
        'Content-Type': 'application/x-www-form-urlencoded'
      });

      this.http.post<any>(url, body.toString(), { headers }).subscribe({
        next: (response) => {
          if (response && response.access_token) {
            localStorage.setItem('token', response.access_token);
            this.authService.atualizarUsuarioLogado(response.access_token);
            this.router.navigate(['/home']);
          }
        },
        error: (err) => {
          this.erroLogin = 'Email ou senha incorretos';
        }
      });
    }
  }
}
