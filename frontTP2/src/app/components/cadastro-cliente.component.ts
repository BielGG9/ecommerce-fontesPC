import { Component, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';
import { ClienteService } from '../services/cliente.service';
import { Cliente } from '../models/cliente.model';
import { Router, RouterModule } from '@angular/router';
import { MatCardModule } from '@angular/material/card';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';

@Component({
  selector: 'app-cadastro-cliente',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule, RouterModule, MatCardModule, MatFormFieldModule, MatInputModule, MatButtonModule, MatIconModule],
  templateUrl: './cadastro-cliente.component.html',
  styleUrl: './cadastro-cliente.component.css'
})
export class CadastroClienteComponent {

  private fb = inject(FormBuilder);
  private clienteService = inject(ClienteService);
  private router = inject(Router);

  cadastroForm = this.fb.group({
    nome: ['', [Validators.required, Validators.maxLength(100)]],
    email: ['', [Validators.required, Validators.email, Validators.maxLength(100)]],
    cpf: ['', [Validators.required, Validators.maxLength(11), Validators.minLength(11)]],
    rg: ['', [Validators.required, Validators.maxLength(20)]],
    senha: ['', [Validators.required, Validators.minLength(6)]]
  });

  obterMensagemErro(campo: string, nomeCampo: string): string {
    const controle = this.cadastroForm.get(campo);
    if (!controle || !controle.errors) return '';

    if (controle.hasError('required')) return `${nomeCampo} é obrigatório.`;
    if (controle.hasError('email')) return `Formato de e-mail inválido.`;
    if (controle.hasError('minlength')) return `O tamanho mínimo é ${controle.getError('minlength').requiredLength} caracteres.`;
    if (controle.hasError('maxlength')) return `O tamanho máximo é ${controle.getError('maxlength').requiredLength} caracteres.`;

    return '';
  }

  erroCadastro: string | null = null;

  salvar() {
    if (this.cadastroForm.invalid) {
      this.cadastroForm.markAllAsTouched();
      return;
    }

    this.erroCadastro = null;
    const cliente: Cliente = this.cadastroForm.value as Cliente;

    this.clienteService.registrar(cliente).subscribe({
      next: () => {
        alert('Conta criada com sucesso!');
        this.router.navigate(['/home']);
      },
      error: (err) => {
        console.error('Erro ao registar cliente', err);
        this.erroCadastro = err.error?.message || 'Erro ao realizar cadastro. Verifique se o email ou CPF já estão em uso.';
      }
    });
  }

  voltar() {
    this.router.navigate(['/home']); 
  }
}
