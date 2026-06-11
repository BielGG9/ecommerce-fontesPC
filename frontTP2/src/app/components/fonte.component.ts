import { Component, OnInit, OnDestroy, signal, inject, HostListener } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';
import { FonteService } from '../services/fonte.service';
import { Fonte } from '../models/fonte.model';
import { DialogService } from '../services/dialog.service';

import { MarcaService } from '../services/marca.service';
import { Marca } from '../models/marca.model';
import { MatDialog } from '@angular/material/dialog';
import { ModeloService } from '../services/modelo.service';
import { Modelo } from '../models/modelo.models';
import { FornecedorService } from '../services/fornecedor.service';
import { Fornecedor } from '../models/fornecedor.model';
import { CertificacaoDialog } from './certificacao-dialog/certificacao-dialog';
import { RouterModule, Router } from '@angular/router';
import { AuthService } from '../services/auth.service';
import { ThemeService } from '../services/theme.service';
import { Subscription, concat } from 'rxjs';

@Component({
  selector: 'app-fonte',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule, RouterModule],
  templateUrl: './fonte.component.html',
  styleUrl: './fonte.component.css'
})
export class FonteComponent implements OnInit, OnDestroy {
  private modeloService = inject(ModeloService);
  private dialog = inject(MatDialog);
  private fonteService = inject(FonteService);
  private marcaService = inject(MarcaService);
  private fornecedorService = inject(FornecedorService);
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

  coluna: string[] = ['id', 'nome', 'potencia', 'preco', 'marca', 'imagens', 'acoes'];
  
  // Controle de Tela (Lista x Formulário)
  isFormVisible = false;

  // --- Configuração da Paginação ---
  totalFontes = signal(0); // Quantidade total de itens no servidor
  pageSize = 2; // Quantos itens por página
  page = 0; // Começamos na página 0 (a primeira)
  nomeBusca = ''; // O texto que o usuário digita

  fontes = signal<Fonte[]>([]);
  marcas = signal<Marca[]>([]);
  modelos = signal<Modelo[]>([]);
  fornecedores = signal<Fornecedor[]>([]);

  fonteForm = this.fb.group({
    id: [null as number | null],
    nome: ['', [Validators.required, Validators.maxLength(100)]],
    potencia: ['', [Validators.required, Validators.maxLength(5)]],
    preco: ['', [Validators.required, Validators.maxLength(10)]],
    idMarca: ['', Validators.required], 
    idModelo: ['', Validators.required],
    idFornecedores: [[] as number[]],
    certificacaoNome: [{value: '', disabled: true}, Validators.required],
    certificacao: ['', Validators.required]
  });

  async ngOnInit() {
    console.log("Tela fontes abriu! ");
    this.authSub = this.authService.usuarioLogado$.subscribe(nome => {
      this.nomeUsuario = nome;
    });
    try {
      !!localStorage.getItem('token');
    } catch (e) {
      console.log("Erro ao carregar fontes", e);
    } finally {
      this.carregarFontes();
      this.carregarMarcasParaOSelect();
      this.carregarModelosParaOSelect();
      this.carregarFornecedoresParaOSelect();
    }
  }

  ngOnDestroy() {
    if (this.authSub) {
      this.authSub.unsubscribe();
    }
  }

  carregarFontes() {
    this.fonteService.findAll(this.page, this.pageSize, this.nomeBusca).subscribe({
      next: (dados) => {
        this.fontes.set(dados.items);
        
        this.fonteService.count(this.nomeBusca).subscribe({
          next: (total) => {
            this.totalFontes.set(total);
          },
          error: (err) => console.error('Erro ao contar fontes', err)
        });
      },
      error: (err) => console.error('Erro ao carregar fontes', err)
    });
  }

  buscar(texto: string) {
    this.nomeBusca = texto;
    this.page = 0; // Sempre volta para a primeira página ao buscar
    this.carregarFontes();
  }

  carregarMarcasParaOSelect() {
    console.log("Carregando marcas...");
    this.marcaService.findAll().subscribe({
      next: (dados) => {
        console.log("Marcas carregadas com sucesso!", dados);
        this.marcas.set(dados);
      },
      error: (err) => {
        console.error('Erro ao carregar marcas', err);
      }
    });
  }

  carregarModelosParaOSelect() {
    console.log("Carregando modelos...");
    this.modeloService.findAll().subscribe({
      next: (dados) => {
        console.log("Modelos carregados com sucesso!", dados);
        this.modelos.set(dados);
      },
      error: (err) => {
        console.error('Erro ao carregar modelos', err);
      }
    });
  }

  carregarFornecedoresParaOSelect() {
    this.fornecedorService.findAll().subscribe({
      next: (dados) => {
        this.fornecedores.set(dados);
      },
      error: (err) => {
        console.error('Erro ao carregar fornecedores', err);
      }
    });
  }

  salvar() {
    if (this.fonteForm.invalid) return;
    
    const idAtual = this.fonteForm.value.id;
    
    const fontePronta = {
        id: idAtual,
        nome: this.fonteForm.value.nome,
        potencia: Number(this.fonteForm.value.potencia),
        preco: Number(this.fonteForm.value.preco),
        idMarca: Number(this.fonteForm.value.idMarca),
        idModelo: Number(this.fonteForm.value.idModelo),
        idFornecedores: this.fonteForm.value.idFornecedores || [],
        certificacao: this.fonteForm.value.certificacao
    } as Fonte;

    if (idAtual) {
      this.fonteService.update(fontePronta).subscribe({
        next: () => {
          this.dialogService.showSuccess('Fonte atualizada com sucesso!');
          this.resetForm();
          this.isFormVisible = false;
          this.carregarFontes();
        },
        error: (err) => {
          console.error('Erro ao atualizar fonte', err);
          this.dialogService.showWarning('Erro ao atualizar a fonte.', 'Erro');
        }
      });
    } else {
      this.fonteService.save(fontePronta).subscribe({
        next: () => {
          this.dialogService.showSuccess('Fonte guardada com sucesso!');
          this.resetForm(); 
          this.isFormVisible = false;
          this.carregarFontes();
        },
        error: (err) => {
          console.error('Erro ao salvar fonte', err);
          this.dialogService.showWarning('Erro ao guardar a fonte.', 'Erro');
        }
      });
    }
  }

  editar(fonte: any) {
    const nomeCert = fonte.certificacao?.fontcert || fonte.certificacao;

    this.fonteForm.patchValue({
      ...fonte,    
      idModelo: fonte.idModelo, 
      idFornecedores: fonte.idFornecedores || [],
      certificacaoNome: nomeCert,
      certificacao: nomeCert ? nomeCert.replace('80 Plus ', '').toUpperCase() : ''
    });
    
    this.isFormVisible = true;
  }

  novaFonte() {
    this.resetForm();
    this.isFormVisible = true;
  }

  voltarParaLista() {
    this.isFormVisible = false;
  }

  excluir(id: number | undefined) {
    if (!id) return;
    
    this.dialogService.showConfirm('Tem a certeza que deseja eliminar esta fonte?', 'Eliminar Fonte').subscribe(confirmado => {
      if (confirmado) {
        this.fonteService.delete(id).subscribe({
          next: () => {
            this.dialogService.showSuccess('Fonte eliminada com sucesso!');
            this.resetForm();
            this.carregarFontes();
          },
          error: (err) => {
            console.error('Erro ao excluir', err);
            this.dialogService.showWarning('Erro ao excluir a fonte.', 'Erro');
          }
        });
      }
    });
  }

  obterMensagemErro(campo: string, nomeCampo: string = 'Campo'): string {
    const controle = this.fonteForm.get(campo);
    if (!controle || !controle.errors) return '';

    if (controle.hasError('required')) return `${nomeCampo} obrigatório.`;
    if (controle.hasError('minlength')) return `Deve ter pelo menos ${controle.getError('minlength').requiredLength} caracteres.`;
    if (controle.hasError('maxlength')) return `Pode ter no máximo ${controle.getError('maxlength').requiredLength} caracteres.`;
    if (controle.hasError('min')) return `O valor mínimo é ${controle.getError('min').min}.`;

    return '';
  }

  resetForm() {
    this.fonteForm.reset();
  }

  abrirDialogCertificacao() {
    const dialogRef = this.dialog.open(CertificacaoDialog, {
      width: '400px'
    });

    dialogRef.afterClosed().subscribe(resultado => {
      if (resultado) {
        const valorParaOjava = resultado.fontcert.replace('80 Plus ', '').toUpperCase();
        this.fonteForm.patchValue({
          certificacaoNome: resultado.fontcert,
          certificacao: valorParaOjava
        });
      }
    });
  }

  navegarParaHome() {
    this.router.navigate(['/home']);
  }

  // --- Métodos de Paginação Customizada ---
  getPageStart(): number {
    if (this.totalFontes() === 0) return 0;
    return this.page * this.pageSize + 1;
  }

  getPageEnd(): number {
    return Math.min((this.page + 1) * this.pageSize, this.totalFontes());
  }

  onPageSizeChange(newSize: string) {
    this.pageSize = Number(newSize);
    this.page = 0;
    this.carregarFontes();
  }

  anteriorPagina() {
    if (this.page > 0) {
      this.page--;
      this.carregarFontes();
    }
  }

  proximaPagina() {
    if ((this.page + 1) * this.pageSize < this.totalFontes()) {
      this.page++;
      this.carregarFontes();
    }
  }

  // --- Seleção de Fornecedores ---
  isFornecedorSelected(id: number | undefined): boolean {
    if (id === undefined) return false;
    const selected = this.fonteForm.value.idFornecedores || [];
    return selected.includes(id);
  }

  toggleFornecedor(id: number | undefined) {
    if (id === undefined) return;
    const selected = [...(this.fonteForm.value.idFornecedores || [])];
    const index = selected.indexOf(id);
    if (index > -1) {
      selected.splice(index, 1);
    } else {
      selected.push(id);
    }
    this.fonteForm.patchValue({ idFornecedores: selected });
    this.fonteForm.get('idFornecedores')?.markAsTouched();
  }

  // --- Seleção de Modelo ---
  selecionarModelo(id: number | undefined) {
    if (id === undefined) return;
    this.fonteForm.patchValue({ idModelo: id as any });
    this.fonteForm.get('idModelo')?.markAsTouched();
  }

  // --- Controle de Dropdown de Fornecedores ---
  fornecedoresDropdownAberto = false;

  toggleFornecedoresDropdown(event: Event) {
    event.stopPropagation();
    this.fornecedoresDropdownAberto = !this.fornecedoresDropdownAberto;
  }

  @HostListener('document:click')
  onDocumentClick() {
    this.fornecedoresDropdownAberto = false;
  }

  obterFornecedoresSelecionadosTexto(): string {
    const selectedIds = this.fonteForm.value.idFornecedores || [];
    const nomes = this.fornecedores()
      .filter(f => selectedIds.includes(f.id as number))
      .map(f => f.razaoSocial);
    return nomes.join(', ');
  }

  // --- Gerenciamento de Imagens ---
  onFileSelected(event: any, fonteId: number | undefined) {
    if (fonteId === undefined) return;
    const files: FileList = event.target.files;
    if (files && files.length > 0) {
      const uploads = [];
      for (let i = 0; i < files.length; i++) {
        uploads.push(this.fonteService.uploadImagem(fonteId, files[i]));
      }

      concat(...uploads).subscribe({
        next: () => {
          // Executado a cada upload concluído
        },
        error: (err) => {
          console.error('Erro no upload das imagens', err);
          const mensagemErro = (typeof err.error === 'string' && err.error) ? err.error : 'Erro ao enviar uma ou mais imagens.';
          this.dialogService.showWarning(mensagemErro, 'Erro');
          this.carregarFontes();
        },
        complete: () => {
          this.dialogService.showSuccess('Todas as imagens foram enviadas com sucesso!');
          this.carregarFontes();
        }
      });
    }
    event.target.value = '';
  }

  excluirImagem(fidUrl: string) {
    const partes = fidUrl.split('/');
    const fid = partes[partes.length - 1];
    
    this.dialogService.showConfirm('Deseja realmente remover esta imagem?', 'Excluir Imagem').subscribe(confirmado => {
      if (confirmado) {
        this.fonteService.deleteImagem(fid).subscribe({
          next: () => {
            this.carregarFontes();
            this.dialogService.showSuccess('Imagem removida com sucesso!');
          },
          error: (err) => {
            console.error('Erro ao remover imagem', err);
            this.dialogService.showWarning('Erro ao remover imagem.', 'Erro');
          }
        });
      }
    });
  }

  getImagemUrl(url: string): string {
    return `http://localhost:8081${url}`;
  }
}