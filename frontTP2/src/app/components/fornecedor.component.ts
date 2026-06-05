import { Component, signal, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';
import { FornecedorService } from '../services/fornecedor.service';
import { Fornecedor } from '../models/fornecedor.model';
import { DialogService } from '../services/dialog.service';

import { Router } from '@angular/router';

@Component({
  selector: 'app-fornecedor',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule],
  templateUrl: './fornecedor.component.html',
  styleUrl: './fornecedor.component.css'
})
export class FornecedorComponent implements OnInit {
  private fornecedorService = inject(FornecedorService);
  private fb = inject(FormBuilder);

  private router = inject(Router);
  private dialogService = inject(DialogService);
  
  colunas: string[] = ['id', 'nome', 'cnpj', 'razaoSocial', 'acoes'];

  // Controle de Tela (Lista x Formulário)
  isFormVisible = false;

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

  // --- Métodos de Paginação Customizada ---
  getPageStart(): number {
    if (this.totalFornecedores() === 0) return 0;
    return this.page * this.pageSize + 1;
  }

  getPageEnd(): number {
    return Math.min((this.page + 1) * this.pageSize, this.totalFornecedores());
  }

  onPageSizeChange(newSize: string) {
    this.pageSize = Number(newSize);
    this.page = 0;
    this.carregarFornecedores();
  }

  anteriorPagina() {
    if (this.page > 0) {
      this.page--;
      this.carregarFornecedores();
    }
  }

  proximaPagina() {
    if ((this.page + 1) * this.pageSize < this.totalFornecedores()) {
      this.page++;
      this.carregarFornecedores();
    }
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
          this.dialogService.showSuccess('Fornecedor atualizado com sucesso!');
          this.resetForm();
          this.isFormVisible = false;
          this.carregarFornecedores();
        },
        error: (err) => {
          console.error('Erro ao atualizar fornecedor', err);
          const msg = typeof err.error === 'string' ? err.error : JSON.stringify(err.error);
          if (err.status === 403) alert('Acesso negado. Apenas administradores podem atualizar fornecedores.');
          else alert('Erro ao atualizar fornecedor: ' + msg);
        }
      });
    } else {
      this.fornecedorService.save(fornecedor).subscribe({
        next: () => {
          this.dialogService.showSuccess('Fornecedor criado com sucesso!');
          this.resetForm();
          this.isFormVisible = false;
          this.carregarFornecedores();
        },
        error: (err) => {
          console.error('Erro ao criar fornecedor', err);
          const msg = typeof err.error === 'string' ? err.error : JSON.stringify(err.error);
          if (err.status === 403) alert('Acesso negado. Apenas administradores podem cadastrar fornecedores.');
          else alert('Erro ao criar fornecedor: ' + msg);
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
    this.isFormVisible = true;
  }

  novoFornecedor() {
    this.resetForm();
    this.isFormVisible = true;
  }

  voltarParaLista() {
    this.isFormVisible = false;
  }

  excluir(id: number) {
    if (confirm('Tem a certeza que deseja eliminar este fornecedor?')) {
      this.fornecedorService.delete(id).subscribe({
        next: () => {
          this.dialogService.showSuccess('Fornecedor eliminado!');
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