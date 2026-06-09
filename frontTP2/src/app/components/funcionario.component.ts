import { Component, signal, OnInit, OnDestroy, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';
import { FuncionarioService } from '../services/funcionario.service';
import { Funcionario } from '../models/funcionario.model';
import { DialogService } from '../services/dialog.service';
import { DepartamentoService } from '../services/departamento.service';
import { Departamento } from '../models/departamento.model';
import { RouterModule, Router } from '@angular/router';
import { AuthService } from '../services/auth.service';
import { ThemeService } from '../services/theme.service';
import { Subscription } from 'rxjs';

@Component({
  selector: 'app-funcionario',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule, RouterModule],
  templateUrl: './funcionario.component.html',
  styleUrl: './funcionario.component.css'
})
export class FuncionarioComponent implements OnInit, OnDestroy {
  private funcionarioService = inject(FuncionarioService);
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
      description: 'Gerencie os fornecedores de produtos and estoque.'
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

  colunas: string[] = ['id', 'nome', 'cpf', 'cargo', 'departamento', 'acoes'];

  // Controle de Tela (Lista x Formulário)
  isFormVisible = false;

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
    cpf: ['', [Validators.required, Validators.pattern('^[0-9]{11}$')]],
    rg: ['', [Validators.required, Validators.pattern('^[0-9]{7,15}$')]],
    cargo: ['', [Validators.required, Validators.maxLength(100)]],
    dataAdmissao: ['', Validators.required],
    idDepartamento: [null as number | null, Validators.required]
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
      this.carregarFuncionarios();
    }
  }

  ngOnDestroy() {
    if (this.authSub) {
      this.authSub.unsubscribe();
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

  // --- Métodos de Paginação Customizada ---
  getPageStart(): number {
    if (this.totalFuncionarios() === 0) return 0;
    return this.page * this.pageSize + 1;
  }

  getPageEnd(): number {
    return Math.min((this.page + 1) * this.pageSize, this.totalFuncionarios());
  }

  onPageSizeChange(newSize: string) {
    this.pageSize = Number(newSize);
    this.page = 0;
    this.carregarFuncionarios();
  }

  anteriorPagina() {
    if (this.page > 0) {
      this.page--;
      this.carregarFuncionarios();
    }
  }

  proximaPagina() {
    if ((this.page + 1) * this.pageSize < this.totalFuncionarios()) {
      this.page++;
      this.carregarFuncionarios();
    }
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
          this.dialogService.showSuccess('Funcionário atualizado com sucesso!');
          this.resetForm();
          this.isFormVisible = false;
          this.carregarFuncionarios();
        },
        error: (err) => {
          console.error('Erro ao atualizar funcionário', err);
          const msg = typeof err.error === 'string' ? err.error : JSON.stringify(err.error);
          if (err.status === 403) alert('Acesso negado. Apenas administradores podem atualizar funcionários.');
          else alert('Erro ao atualizar funcionário: ' + msg);
        }
      });
    } else {
      this.funcionarioService.save(funcionario).subscribe({
        next: () => {
          this.dialogService.showSuccess('Funcionário criado com sucesso!');
          this.resetForm();
          this.isFormVisible = false;
          this.carregarFuncionarios();
        },
        error: (err) => {
          console.error('Erro ao criar funcionário', err);
          const msg = typeof err.error === 'string' ? err.error : JSON.stringify(err.error);
          if (err.status === 403) alert('Acesso negado. Apenas administradores podem cadastrar funcionários.');
          else alert('Erro ao criar funcionário: ' + msg);
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
    this.isFormVisible = true;
  }

  novoFuncionario() {
    this.resetForm();
    this.isFormVisible = true;
  }

  voltarParaLista() {
    this.isFormVisible = false;
  }

  excluir(id: number) {
    if (confirm('Tem a certeza que deseja eliminar este funcionário?')) {
      this.funcionarioService.delete(id).subscribe({
        next: () => {
          this.dialogService.showSuccess('Funcionário eliminado!');
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
    if (controle.hasError('pattern')) {
      if (campo === 'cpf') return 'CPF deve ter exatamente 11 dígitos numéricos.';
      if (campo === 'rg') return 'RG deve ter de 7 a 15 dígitos numéricos.';
    }

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