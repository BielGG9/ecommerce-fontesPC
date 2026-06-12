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
  selector: 'app-cadastro-completo',
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
  templateUrl: './cadastro-completo.component.html',
  styleUrls: ['./cadastro-cliente.component.css']
})
export class CadastroCompletoComponent {
  form: FormGroup;
  isLoading = false;
  erroForm: string | null = null;
  mostrarSenha = false;

  private fb = inject(FormBuilder);
  private http = inject(HttpClient);
  private router = inject(Router);
  private authService = inject(AuthService);

  private apiUrl = 'http://localhost:8081/clientes';
  private keycloakUrl = 'http://localhost:8080/realms/TP2/protocol/openid-connect/token';

  constructor() {
    this.form = this.fb.group({
      nome:     ['', [Validators.required, Validators.minLength(3)]],
      username: ['', [Validators.required, Validators.minLength(3)]],
      email:    ['', [Validators.required, Validators.email]],
      cpf:      ['', [Validators.required, Validators.pattern('^[0-9]{11}$')]],
      rg:       ['', [Validators.required, Validators.pattern('^[0-9]{7,15}$')]],
      senha:    ['', [Validators.required, Validators.minLength(6)]],
    });
  }

  obterErro(campo: string): string {
    const c = this.form.get(campo);
    if (!c || !c.touched || !c.errors) return '';
    if (c.errors['required'])   return 'Campo obrigatório.';
    if (c.errors['email'])      return 'E-mail inválido.';
    if (c.errors['minlength'])  return `Mínimo ${c.errors['minlength'].requiredLength} caracteres.`;
    if (c.errors['pattern']) {
      if (campo === 'cpf') return 'CPF deve ter exatamente 11 dígitos numéricos.';
      if (campo === 'rg')  return 'RG deve ter de 7 a 15 dígitos numéricos.';
    }
    return '';
  }

  apenasNumeros(event: KeyboardEvent): boolean {
    const charCode = event.which || event.keyCode;
    return charCode >= 48 && charCode <= 57;
  }

  criarContaCompleta(): void {
    if (this.form.invalid) {
      this.form.markAllAsTouched();
      return;
    }
    this.isLoading = true;
    this.erroForm = null;

    const payload = {
      nome:     this.form.value.nome,
      username: this.form.value.username,
      email:    this.form.value.email,
      cpf:      this.form.value.cpf,
      rg:       this.form.value.rg,
      senha:    this.form.value.senha
    };

    this.http.post<any>(this.apiUrl, payload).subscribe({
      next: () => {
        // Login automático após o cadastro
        const body = new HttpParams()
          .set('client_id', 'quarkuss')
          .set('grant_type', 'password')
          .set('username', payload.email)
          .set('password', payload.senha);

        const headers = new HttpHeaders({ 'Content-Type': 'application/x-www-form-urlencoded' });

        this.http.post<any>(this.keycloakUrl, body.toString(), { headers }).subscribe({
          next: (res) => {
            if (res?.access_token) {
              localStorage.setItem('token', res.access_token);
              this.authService.atualizarUsuarioLogado(res.access_token);
            }
            this.isLoading = false;
            this.router.navigate(['/']);
          },
          error: () => {
            // Cadastro foi com sucesso; só o login automático falhou
            this.isLoading = false;
            this.router.navigate(['/login']);
          }
        });
      },
      error: (err) => {
        this.isLoading = false;
        const msg = err?.error?.message ?? err?.error ?? 'Erro ao criar conta. Verifique os dados.';
        this.erroForm = typeof msg === 'string' ? msg : JSON.stringify(msg);
      }
    });
  }
}
