import { Component, signal, OnInit, OnDestroy, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';
import { MarcaService } from '../services/marca.service';
import { Marca } from '../models/marca.model';
import { DialogService } from '../services/dialog.service';
import { RouterModule, Router } from '@angular/router';
import { AuthService } from '../services/auth.service';
import { ThemeService } from '../services/theme.service';
import { Subscription } from 'rxjs';

@Component({
  selector: 'app-marca',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule, RouterModule],
  templateUrl: './marca.component.html',
  styleUrl: './marca.component.css'
})
export class MarcaComponent implements OnInit, OnDestroy {
  private marcaService = inject(MarcaService);
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

  colunas: string[] = ['id', 'nome', 'imagens', 'acoes'];
  
  // Controle de Tela (Lista x Formulário)
  isFormVisible = false;

  marcas = signal<Marca[]>([]);

  totalMarcas = signal(0);
  pageSize = 2;
  page = 0;
  nomeBusca = '';
  
  // O formulário reativo. Tem o ID (escondido) para sabermos se estamos a editar ou a criar.
  marcaForm = this.fb.group({
    id: [null as number | null],
    nome: ['', [Validators.required, Validators.maxLength(100)]]
  });

  async ngOnInit() {
    this.authSub = this.authService.usuarioLogado$.subscribe(nome => {
      this.nomeUsuario = nome;
    });
    try{
      const logado = !!localStorage.getItem('token');
    } catch(e) {
      console.warn('Não está logado, modo visitante ativo');
    } finally {
      this.carregarMarcas();
    }
  }

  ngOnDestroy() {
    if (this.authSub) {
      this.authSub.unsubscribe();
    }
  }

  carregarMarcas() {
    this.marcaService.findAll(this.page, this.pageSize, this.nomeBusca).subscribe({
      next: (dados) => {
        this.marcas.set(dados);
        this.marcaService.count(this.nomeBusca).subscribe({
          next: (total) => this.totalMarcas.set(total),
          error: (err) => console.error('Erro ao contar marcas', err)
        });
      },
      error: (err) => console.error('Erro ao carregar marcas', err)
    });
  }

  // --- Métodos de Paginação Customizada ---
  getPageStart(): number {
    if (this.totalMarcas() === 0) return 0;
    return this.page * this.pageSize + 1;
  }

  getPageEnd(): number {
    return Math.min((this.page + 1) * this.pageSize, this.totalMarcas());
  }

  onPageSizeChange(newSize: string) {
    this.pageSize = Number(newSize);
    this.page = 0;
    this.carregarMarcas();
  }

  anteriorPagina() {
    if (this.page > 0) {
      this.page--;
      this.carregarMarcas();
    }
  }

  proximaPagina() {
    if ((this.page + 1) * this.pageSize < this.totalMarcas()) {
      this.page++;
      this.carregarMarcas();
    }
  }

  buscar(texto: string) {
    this.nomeBusca = texto;
    this.page = 0;
    this.carregarMarcas();
  }

  salvar() {
    if (this.marcaForm.invalid) return;

    const marca = this.marcaForm.value as Marca;

    if (marca.id) {
      // Se tem ID, é porque estamos a atualizar um registo existente (PUT)
      this.marcaService.update(marca).subscribe({
        next: () => {
          this.dialogService.showSuccess('Marca atualizada com sucesso!');
          this.resetForm();
          this.isFormVisible = false;
          this.carregarMarcas();
        }
      });
    } else {
      // Se não tem ID, é uma marca nova (POST)
      this.marcaService.save(marca).subscribe({
        next: () => {
          this.dialogService.showSuccess('Marca criada com sucesso!');
          this.resetForm();
          this.isFormVisible = false;
          this.carregarMarcas();
        }
      });
    }
  }

  editar(marca: Marca) {
    // Preenche os campos do formulário com os dados da marca selecionada na tabela
    this.marcaForm.patchValue({
      id: marca.id,
      nome: marca.nome
    });
    this.isFormVisible = true;
  }

  novaMarca() {
    this.resetForm();
    this.isFormVisible = true;
  }

  voltarParaLista() {
    this.isFormVisible = false;
  }

  excluir(id: number) {
    if (confirm('Tem a certeza que deseja eliminar esta marca?')) {
      this.marcaService.delete(id).subscribe({
        next: () => {
          this.dialogService.showSuccess('Marca eliminada!');
          this.resetForm();
          this.carregarMarcas();
        },
        error: (err) => {
          if (err.status === 400) {
            alert('Não é possível excluir esta Marca, pois ela possui modelos vinculados. Remova os modelos primeiro.');
          } else {
            alert('Falha ao tentar remover a marca. Verifique a conexão.');
            console.error(err);
          }
        }
      });
    }
  }

  obterMensagemErro(campo: string, nomeCampo: string = 'Campo'): string {
    const controle = this.marcaForm.get(campo);
    if (!controle || !controle.errors) return '';

    if (controle.hasError('required')) return `${nomeCampo} obrigatório.`;
    if (controle.hasError('minlength')) return `Deve ter pelo menos ${controle.getError('minlength').requiredLength} caracteres.`;
    if (controle.hasError('maxlength')) return `Pode ter no máximo ${controle.getError('maxlength').requiredLength} caracteres.`;
    if (controle.hasError('min')) return `O valor mínimo é ${controle.getError('min').min}.`;

    return '';
  }

  resetForm() {
    this.marcaForm.reset();
  }

  navegarParaHome() {
    this.router.navigate(['/home']);
  }

  // --- Gerenciamento de Imagens ---
  onFileSelected(event: any, marcaId: number) {
    const file: File = event.target.files[0];
    if (file) {
      this.marcaService.uploadImagem(marcaId, file).subscribe({
        next: () => {
          this.dialogService.showSuccess('Imagem enviada com sucesso!');
          this.carregarMarcas();
        },
        error: (err) => {
          console.error('Erro no upload da imagem', err);
          alert('Erro ao enviar imagem.');
        }
      });
    }
    event.target.value = '';
  }

  excluirImagem(fidUrl: string) {
    const partes = fidUrl.split('/');
    const fid = partes[partes.length - 1];
    
    if (confirm('Deseja realmente remover esta imagem?')) {
      this.marcaService.deleteImagem(fid).subscribe({
        next: () => {
          this.carregarMarcas();
        },
        error: (err) => {
          console.error('Erro ao remover imagem', err);
          alert('Erro ao remover imagem.');
        }
      });
    }
  }

  getImagemUrl(url: string): string {
    return `http://localhost:8081${url}`;
  }
}