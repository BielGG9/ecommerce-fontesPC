import { Component, signal, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';
import { DepartamentoService } from '../services/departamento.service';
import { Departamento } from '../models/departamento.model';

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
  selector: 'app-departamento',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule, MatCardModule, MatFormFieldModule, MatInputModule, MatButtonModule, MatIconModule, MatTableModule, MatPaginatorModule],
  templateUrl: './departamento.component.html',
  styleUrl: './departamento.component.css',
  providers: [{ provide: MatPaginatorIntl, useClass: PaginatorIntlPtBr }]
})
export class DepartamentoComponent implements OnInit {
  private departamentoService = inject(DepartamentoService);
  private fb = inject(FormBuilder);

  private router = inject(Router);
  
  colunas: string[] = ['id', 'sigla', 'descricao', 'acoes'];

  totalDepartamentos = signal(0);
  pageSize = 2;
  page = 0;
  nomeBusca = '';

  departamentos = signal<Departamento[]>([]);
  
  departamentoForm = this.fb.group({
    id: [null as number | null],
    sigla: ['', [Validators.required, Validators.maxLength(10)]],
    descricao: ['', [Validators.required, Validators.maxLength(100)]]
  });

  async ngOnInit() {
    try {
      const logado = !!localStorage.getItem('token');
    } catch(e) {
      console.warn('Não está logado, modo visitante ativo');
    } finally {
      this.carregarDepartamentos();
    }
  }

  carregarDepartamentos() {
    this.departamentoService.findAll(this.page, this.pageSize, this.nomeBusca).subscribe({
      next: (dados) => {
        this.departamentos.set(dados);
        this.departamentoService.count(this.nomeBusca).subscribe({
          next: (total) => this.totalDepartamentos.set(total),
          error: (err) => console.error('Erro ao contar departamentos', err)
        });
      },
      error: (err) => console.error('Erro ao carregar departamentos', err)
    });
  }

  paginar(event: PageEvent): void {
    this.page = event.pageIndex;
    this.pageSize = event.pageSize;
    this.carregarDepartamentos();
  }

  buscar(texto: string) {
    this.nomeBusca = texto;
    this.page = 0;
    this.carregarDepartamentos();
  }

  salvar() {
    if (this.departamentoForm.invalid) return;

    const departamento = this.departamentoForm.value as Departamento;

    if (departamento.id) {
      this.departamentoService.update(departamento).subscribe({
        next: () => {
          alert('Departamento atualizado com sucesso!');
          this.resetForm();
          this.carregarDepartamentos();
        }
      });
    } else {
      this.departamentoService.save(departamento).subscribe({
        next: () => {
          alert('Departamento criado com sucesso!');
          this.resetForm();
          this.carregarDepartamentos();
        }
      });
    }
  }

  editar(departamento: Departamento) {
    this.departamentoForm.patchValue({
      id: departamento.id,
      sigla: departamento.sigla,
      descricao: departamento.descricao
    });
  }

  excluir(id: number) {
    if (confirm('Tem a certeza que deseja eliminar este departamento?')) {
      this.departamentoService.delete(id).subscribe({
        next: () => {
          alert('Departamento eliminado!');
          this.resetForm();
          this.carregarDepartamentos();
        },
        error: (err) => {
          if (err.status === 400) {
            const msg = (typeof err.error === 'string') ? err.error : 'Não é possível excluir este Departamento, pois há funcionários alocados a ele.';
            alert(msg);
          } else {
            alert('Falha interna ao tentar remover o departamento.');
            console.error(err);
          }
        }
      });
    }
  }

  obterMensagemErro(campo: string, nomeCampo: string = 'Campo'): string {
    const controle = this.departamentoForm.get(campo);
    if (!controle || !controle.errors) return '';

    if (controle.hasError('required')) return `${nomeCampo} obrigatório.`;
    if (controle.hasError('maxlength')) return `Pode ter no máximo ${controle.getError('maxlength').requiredLength} caracteres.`;

    return '';
  }

  resetForm() {
    this.departamentoForm.reset();
  }

  navegarParaHome() {
    this.router.navigate(['/home']);
  }
}