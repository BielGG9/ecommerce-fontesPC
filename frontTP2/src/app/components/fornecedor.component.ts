import { Component, signal, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';
import { FornecedorService } from '../services/fornecedor.service';
import { Fornecedor } from '../models/fornecedor.model';

import { MatCardModule } from '@angular/material/card';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatTableModule } from '@angular/material/table';
import { Router } from '@angular/router';
import { MatPaginatorIntl, MatPaginatorModule, PageEvent } from '@angular/material/paginator';
import { PaginatorIntlPtBr } from '../paginator-ptbr';

@Component({
  selector: 'app-fornecedor',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule, MatCardModule, MatFormFieldModule, MatInputModule, MatButtonModule, MatIconModule, MatTableModule, MatPaginatorModule],
  templateUrl: './fornecedor.component.html',
  styleUrl: './fornecedor.component.css',
  providers: [{ provide: MatPaginatorIntl, useClass: PaginatorIntlPtBr }]
})
export class FornecedorComponent implements OnInit {
  private fornecedorService = inject(FornecedorService);
  private fb = inject(FormBuilder);

  private router = inject(Router);
  
  colunas: string[] = ['id', 'nome', 'cnpj', 'razaoSocial', 'acoes'];

  fornecedores = signal<Fornecedor[]>([]);
  
  totalFornecedores = signal(0);
  pageSize = 2;
  page = 0;
  nomeBusca = '';
  
  fornecedorForm = this.fb.group({
    id: [null as number | null],
    nome: ['', Validators.required],
    email: ['', [Validators.required, Validators.email]],
    razaoSocial: ['', Validators.required],
    cnpj: ['', Validators.required],
    inscricaoEstadual: ['', Validators.required]
  });

  async ngOnInit() {
    try {
      const logado = !!localStorage.getItem('token');
    } catch(e) {
      console.warn('Não está logado, modo visitante ativo');
    } finally {
      this.carregarFornecedores();
    }
  }

  carregarFornecedores() {
    this.fornecedorService.findAll(this.page, this.pageSize, this.nomeBusca).subscribe({
      next: (dados) => {
        this.fornecedores.set(dados);
        this.fornecedorService.count(this.nomeBusca).subscribe({
          next: (total) => this.totalFornecedores.set(total),
          error: (err) => console.error('Erro ao contar fornecedores', err)
        });
      },
      error: (err) => console.error('Erro ao carregar fornecedores', err)
    });
  }

  paginar(event: PageEvent): void {
    this.page = event.pageIndex;
    this.pageSize = event.pageSize;
    this.carregarFornecedores();
  }

  buscar(texto: string) {
    this.nomeBusca = texto;
    this.page = 0;
    this.carregarFornecedores();
  }

  salvar() {
    if (this.fornecedorForm.invalid) return;

    const fornecedor = this.fornecedorForm.value as Fornecedor;

    if (fornecedor.id) {
      this.fornecedorService.update(fornecedor).subscribe({
        next: () => {
          alert('Fornecedor atualizado com sucesso!');
          this.resetForm();
          this.carregarFornecedores();
        }
      });
    } else {
      this.fornecedorService.save(fornecedor).subscribe({
        next: () => {
          alert('Fornecedor criado com sucesso!');
          this.resetForm();
          this.carregarFornecedores();
        }
      });
    }
  }

  editar(fornecedor: Fornecedor) {
    this.fornecedorForm.patchValue({
      id: fornecedor.id,
      nome: fornecedor.nome,
      email: fornecedor.email,
      razaoSocial: fornecedor.razaoSocial,
      cnpj: fornecedor.cnpj,
      inscricaoEstadual: fornecedor.inscricaoEstadual
    });
  }

  excluir(id: number) {
    if (confirm('Tem a certeza que deseja eliminar este fornecedor?')) {
      this.fornecedorService.delete(id).subscribe({
        next: () => {
          alert('Fornecedor eliminado!');
          this.resetForm();
          this.carregarFornecedores();
        },
        error: (err) => {
          if (err.status === 400) {
            const msg = (typeof err.error === 'string') ? err.error : 'Não é possível excluir este Fornecedor...';
            alert(msg);
          } else {
            console.error('Erro ao excluir Fornecedor', err);
            alert('Erro inesperado ao excluir o Fornecedor.');
          }
        }
      });
    }
  }

  obterMensagemErro(campo: string, nomeCampo: string = 'Campo'): string {
    const controle = this.fornecedorForm.get(campo);
    if (!controle || !controle.errors) return '';

    if (controle.hasError('required')) return `${nomeCampo} obrigatório.`;
    if (controle.hasError('email')) return `Formato de e-mail inválido.`;

    return '';
  }

  resetForm() {
    this.fornecedorForm.reset();
  }

  navegarParaHome() {
    this.router.navigate(['/home']);
  }
}