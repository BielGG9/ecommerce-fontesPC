import { Component, signal, OnInit, OnDestroy, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';
import { DepartamentoService } from '../services/departamento.service';
import { Departamento } from '../models/departamento.model';
import { DialogService } from '../services/dialog.service';

import { MatCardModule } from '@angular/material/card';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatTableModule } from '@angular/material/table';
import { RouterModule, Router } from '@angular/router';
import { MatPaginatorIntl, MatPaginatorModule, PageEvent } from '@angular/material/paginator';
import { PaginatorIntlPtBr } from '../paginator-ptbr';
import { AuthService } from '../services/auth.service';
import { ThemeService } from '../services/theme.service';
import { Subscription } from 'rxjs';

@Component({
  selector: 'app-departamento',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule, MatCardModule, MatFormFieldModule, MatInputModule, MatButtonModule, MatIconModule, MatTableModule, MatPaginatorModule, RouterModule],
  templateUrl: './departamento.component.html',
  styleUrl: './departamento.component.css',
  providers: [{ provide: MatPaginatorIntl, useClass: PaginatorIntlPtBr }]
})
export class DepartamentoComponent implements OnInit, OnDestroy {
  private departamentoService = inject(DepartamentoService);
  private fb = inject(FormBuilder);
  private router = inject(Router);
  private dialogService = inject(DialogService);
  private authService = inject(AuthService);
  private themeService = inject(ThemeService);
  private authSub!: Subscription;

  nomeUsuario: string | null = '';
  isCollapsed = false;
  get isDarkMode() {
    return this.themeService.isDarkMode();
  }

  menuItems = [
    {
      name: 'Dashboard',
      route: '/admin',
      icon: 'bi bi-speedometer2',
      description: 'Visão geral do sistema e relatórios rápidos.'
    },
    {
      name: 'Fontes',
      route: '/admin/fontes',
      icon: 'bi bi-pc-display',
      description: 'Gerencie o estoque e especificações técnicas de fontes.'
    },
    {
      name: 'Marcas',
      route: '/admin/marca',
      icon: 'bi bi-patch-check',
      description: 'Administre as marcas fabricantes de fontes.'
    },
    {
      name: 'Modelos',
      route: '/admin/modelos',
      icon: 'bi bi-cpu',
      description: 'Configure os modelos e linhas de produtos.'
    },
    {
      name: 'Fornecedores',
      route: '/admin/fornecedores',
      icon: 'bi bi-truck',
      description: 'Gerencie os fornecedores de produtos e estoque.'
    },
    {
      name: 'Funcionários',
      route: '/admin/funcionarios',
      icon: 'bi bi-person-badge',
      description: 'Gerencie a equipe e acessos ao sistema.'
    },
    {
      name: 'Departamentos',
      route: '/admin/departamentos',
      icon: 'bi bi-building',
      description: 'Organize os departamentos da empresa.'
    },
    {
      name: 'Pedidos',
      route: '/admin/pedidos',
      icon: 'bi bi-cart-check',
      description: 'Acompanhe e gerencie os pedidos dos clientes.'
    }
  ];

  toggleSidebar() {
    this.isCollapsed = !this.isCollapsed;
  }

  toggleTheme() {
    this.themeService.toggleTheme();
  }

  sair() {
    this.authService.limparSessao();
    this.router.navigate(['/login']);
  }

  colunas: string[] = ['id', 'sigla', 'descricao', 'acoes'];

  totalDepartamentos = signal(0);
  pageSize = 2;
  page = 0;
  nomeBusca = '';

  // Controle de Tela (Lista x Formulário)
  isFormVisible = false;

  departamentos = signal<Departamento[]>([]);
  
  departamentoForm = this.fb.group({
    id: [null as number | null],
    sigla: ['', [Validators.required, Validators.maxLength(10)]],
    descricao: ['', [Validators.required, Validators.maxLength(100)]]
  });

  async ngOnInit() {
    this.authSub = this.authService.usuarioLogado$.subscribe(nome => {
      this.nomeUsuario = nome;
    });
    try {
      const logado = !!localStorage.getItem('token');
    } catch(e) {
      console.warn('Não está logado, modo visitante ativo');
    } finally {
      this.carregarDepartamentos();
    }
  }

  ngOnDestroy() {
    if (this.authSub) {
      this.authSub.unsubscribe();
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
          this.dialogService.showSuccess('Departamento atualizado com sucesso!');
          this.resetForm();
          this.isFormVisible = false;
          this.carregarDepartamentos();
        },
        error: (err) => {
          console.error('Erro ao atualizar departamento', err);
          const msg = typeof err.error === 'string' ? err.error : JSON.stringify(err.error);
          if (err.status === 403) alert('Acesso negado. Apenas administradores podem atualizar departamentos.');
          else alert('Erro ao atualizar departamento: ' + msg);
        }
      });
    } else {
      this.departamentoService.save(departamento).subscribe({
        next: () => {
          this.dialogService.showSuccess('Departamento criado com sucesso!');
          this.resetForm();
          this.isFormVisible = false;
          this.carregarDepartamentos();
        },
        error: (err) => {
          console.error('Erro ao criar departamento', err);
          const msg = typeof err.error === 'string' ? err.error : JSON.stringify(err.error);
          if (err.status === 403) alert('Acesso negado. Apenas administradores podem cadastrar departamentos.');
          else alert('Erro ao criar departamento: ' + msg);
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
    this.isFormVisible = true;
  }

  novoDepartamento() {
    this.resetForm();
    this.isFormVisible = true;
  }

  voltarParaLista() {
    this.isFormVisible = false;
  }

  excluir(id: number) {
    if (confirm('Tem a certeza que deseja eliminar este departamento?')) {
      this.departamentoService.delete(id).subscribe({
        next: () => {
          this.dialogService.showSuccess('Departamento eliminado!');
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