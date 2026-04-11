import { Component, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormBuilder, FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';
import { RouterModule } from '@angular/router';
import { AuthService } from '../services/auth.service';
import { MatCardModule } from '@angular/material/card';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatButtonModule } from '@angular/material/button';

@Component({
  selector: 'app-recuperar-senha',
  standalone: true,
  imports: [
    CommonModule,
    ReactiveFormsModule,
    RouterModule,
    MatCardModule,
    MatFormFieldModule,
    MatInputModule,
    MatButtonModule
  ],
  templateUrl: './recuperar-senha.component.html',
  styleUrls: ['./login.component.css']
})
export class RecuperarSenhaComponent {
  form: FormGroup;
  mensagemSucesso: string | null = null;
  mensagemErro: string | null = null;
  enviando = false;
  sucesso = false;

  private fb = inject(FormBuilder);
  private authService = inject(AuthService);

  constructor() {
    this.form = this.fb.group({
      email: ['', [Validators.required, Validators.email]]
    });
  }

  enviarEmail() {
    if (this.form.valid) {
      this.enviando = true;
      this.sucesso = false;
      this.mensagemSucesso = null;
      this.mensagemErro = null;

      this.authService.solicitarRecuperacaoSenha(this.form.value.email).subscribe({
        next: () => {
          this.mensagemSucesso = 'Verifique o seu e-mail para receber o link de recuperação.';
          this.enviando = false;
          this.sucesso = true;
          this.form.reset();
        },
        error: (err) => {
          if (err.status === 404) {
            this.mensagemErro = 'E-mail não encontrado no sistema.';
          } else {
            this.mensagemErro = 'Erro ao tentar recuperar a senha. Tente novamente mais tarde.';
          }
          this.enviando = false;
        }
      });
    }
  }
}
