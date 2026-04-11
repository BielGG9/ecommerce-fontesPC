import { Component, signal, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';
import { FuncionarioService } from '../services/funcionario.service';
import { Funcionario } from '../models/funcionario.model';
import { DepartamentoService } from '../services/departamento.service';
import { Departamento } from '../models/departamento.model';

import { MatCardModule } from '@angular/material/card';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatTableModule } from '@angular/material/table';
import { MatSelectModule } from '@angular/material/select';
import { Router } from '@angular/router';
import { MatPaginatorIntl, MatPaginatorModule, PageEvent } from '@angular/material/paginator';
import { PaginatorIntlPtBr } from '../paginator-ptbr';

@Component({
  selector: 'app-funcionario',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule, MatCardModule, MatFormFieldModule, MatInputModule, MatSelectModule, MatButtonModule, MatIconModule, MatTableModule, MatPaginatorModule],
  templateUrl: './funcionario.component.html',
  styleUrl: './funcionario.component.css',
  providers: [{ provide: MatPaginatorIntl, useClass: PaginatorIntlPtBr }]
})
export class FuncionarioComponent implements OnInit {
  private funcionarioService = inject(FuncionarioService);
  private departamentoService = inject(DepartamentoService);
  private fb = inject(FormBuilder);

  private router = inject(Router);
  
  colunas: string[] = ['id', 'nome', 'cpf', 'cargo', 'departamento', 'acoes'];

  funcionarios = signal<Funcionario[]>([]);
  departamentos = signal<Departamento[]>([]);

  totalFuncionarios = signal(0);
  pageSize = 2;
  page = 0;
  nomeBusca = '';
  
  funcionarioForm = this.fb.group({
    id: [null as number | null],
    nome: ['', [Validators.required, Validators.maxLength(100)]],
    email: ['', [Validators.required, Validators.email, Validators.maxLength(100)]],
    cpf: ['', [Validators.required, Validators.maxLength(11)]],
    rg: ['', [Validators.required, Validators.maxLength(20)]],
    cargo: ['', [Validators.required, Validators.maxLength(100)]],
    dataAdmissao: ['', Validators.required],
    idDepartamento: [null as number | null, Validators.required]
  });

  async ngOnInit() {
    try {
      const logado = !!localStorage.getItem('token');
    } catch(e) {
      console.warn('Não está logado, modo visitante ativo');
    } finally {
      this.carregarDepartamentos();
      this.carregarFuncionarios();
    }
  }

  carregarFuncionarios() {
    this.funcionarioService.findAll(this.page, this.pageSize, this.nomeBusca).subscribe({
      next: (dados) => {
        this.funcionarios.set(dados);
        this.funcionarioService.count(this.nomeBusca).subscribe({
          next: (total) => this.totalFuncionarios.set(total),
          error: (err) => console.error('Erro ao contar funcionarios', err)
        });
      },
      error: (err) => console.error('Erro ao carregar funcionarios', err)
    });
  }

  paginar(event: PageEvent): void {
    this.page = event.pageIndex;
    this.pageSize = event.pageSize;
    this.carregarFuncionarios();
  }

  buscar(texto: string) {
    this.nomeBusca = texto;
    this.page = 0;
    this.carregarFuncionarios();
  }

  carregarDepartamentos() {
    this.departamentoService.findAll().subscribe({
      next: (dados) => this.departamentos.set(dados),
      error: (err) => console.error('Erro ao carregar departamentos', err)
    });
  }

  salvar() {
    if (this.funcionarioForm.invalid) {
        this.funcionarioForm.markAllAsTouched();
        return;
    }
    
    const funcionario = this.funcionarioForm.value as Funcionario;
    if (funcionario.id) {
      this.funcionarioService.update(funcionario).subscribe({
        next: () => {
          alert('Funcionário atualizado com sucesso!');
          this.resetForm();
          this.carregarFuncionarios();
        }
      });
    } else {
      this.funcionarioService.save(funcionario).subscribe({
        next: () => {
          alert('Funcionário criado com sucesso!');
          this.resetForm();
          this.carregarFuncionarios();
        }
      });
    }
  }

  editar(funcionario: any) {
    const idDepto = funcionario.departamento?.id || funcionario.idDepartamento;
    
    // Tratamento para garantir que a data seja lida corretamente no input type="date" caso venha do back-end
    let dataFormatada = funcionario.dataAdmissao;
    if(dataFormatada && dataFormatada.includes('T')) {
      dataFormatada = dataFormatada.split('T')[0];
    }
    
    this.funcionarioForm.patchValue({
      id: funcionario.id,
      nome: funcionario.nome,
      email: funcionario.email,
      cpf: funcionario.cpf,
      rg: funcionario.rg,
      cargo: funcionario.cargo,
      dataAdmissao: dataFormatada,
      idDepartamento: idDepto
    });
  }

  excluir(id: number) {
    if (confirm('Tem a certeza que deseja eliminar este funcionário?')) {
      this.funcionarioService.delete(id).subscribe({
        next: () => {
          alert('Funcionário eliminado!');
          this.resetForm();
          this.carregarFuncionarios();
        }
      });
    }
  }

  obterMensagemErro(campo: string, nomeCampo: string = 'Campo'): string {
    const controle = this.funcionarioForm.get(campo);
    if (!controle || !controle.errors) return '';

    if (controle.hasError('required')) return `${nomeCampo} obrigatório.`;
    if (controle.hasError('email')) return `Formato de e-mail inválido.`;
    if (controle.hasError('maxlength')) return `Pode ter no máximo ${controle.getError('maxlength').requiredLength} caracteres.`;

    return '';
  }

  obterNomeDepartamento(idDepto: number | any): string {
    if (idDepto && typeof idDepto === 'object') return idDepto.descricao || idDepto.sigla || '';
    const depto = this.departamentos().find(d => d.id === (typeof idDepto === 'number' ? idDepto : Number(idDepto)));
    return depto ? `${depto.sigla} - ${depto.descricao}` : 'N/A';
  }

  resetForm() {
    this.funcionarioForm.reset();
  }

  navegarParaHome() {
    this.router.navigate(['/home']);
  }
}