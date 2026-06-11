import { Component, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormBuilder, FormGroup, ReactiveFormsModule, Validators, FormGroupDirective } from '@angular/forms';
import { RouterModule, Router } from '@angular/router';
import { AuthService } from '../services/auth.service';
import { DialogService } from '../services/dialog.service';
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
  private dialogService = inject(DialogService);
  private router = inject(Router);

  constructor() {
    this.form = this.fb.group({
      email: ['', [Validators.required, Validators.email]]
    });
  }

  enviarEmail(formDirective: FormGroupDirective) {
    if (this.form.valid) {
      this.enviando = true;
      this.sucesso = false;
      this.mensagemSucesso = null;
      this.mensagemErro = null;

      this.authService.solicitarRecuperacaoSenha(this.form.value.email).subscribe({
        next: () => {
          this.enviando = false;
          this.sucesso = true;
          this.mensagemSucesso = 'E-mail de recuperação enviado com sucesso! Verifique a sua caixa de entrada.';
          
          this.dialogService.showSuccess('Verifique o seu e-mail para receber o link de recuperação.', 'E-mail Enviado!');
          
          // Reseta a diretiva do formulário para evitar a linha vermelha ao redor do input
          if (formDirective) {
            formDirective.resetForm();
          }
          this.form.reset();

          // Redireciona de volta para o login após 10 segundos
          setTimeout(() => {
            this.router.navigate(['/login']);
          }, 10000);
        },
        error: (err) => {
          this.enviando = false;
          this.sucesso = false;
          
          let errorMsg = 'Erro ao tentar recuperar a senha. Tente novamente mais tarde.';
          if (err) {
            if (err.status === 404) {
              errorMsg = 'E-mail não encontrado no sistema.';
            } else if (err.error && typeof err.error === 'string') {
              errorMsg = err.error;
            } else if (err.error && err.error.message) {
              errorMsg = err.error.message;
            }
          }
          
          this.dialogService.showError(errorMsg, 'E-mail Não Enviado');
        }
      });
    }
  }
}
