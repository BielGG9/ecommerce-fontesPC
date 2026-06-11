import { Component, OnInit, OnDestroy, ChangeDetectorRef } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ActivatedRoute, Router, RouterModule } from '@angular/router';
import { catchError, finalize } from 'rxjs/operators';
import { EMPTY, Subscription, of } from 'rxjs';
import { FonteService } from '../../services/fonte.service';
import { CarrinhoService } from '../../services/carrinho.service';
import { DialogService } from '../../services/dialog.service';
import { WishlistService } from '../../services/wishlist.service';
import { AuthService } from '../../services/auth.service';

import { MatButtonModule } from '@angular/material/button';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { MatIconModule } from '@angular/material/icon';
import { MatChipsModule } from '@angular/material/chips';
import { MatDividerModule } from '@angular/material/divider';

@Component({
  selector: 'app-produto-detalhe',
  standalone: true,
  imports: [
    CommonModule,
    RouterModule,
    MatButtonModule,
    MatProgressSpinnerModule,
    MatIconModule,
    MatChipsModule,
    MatDividerModule,
  ],
  templateUrl: './produto-detalhe.component.html',
  styleUrls: ['./produto-detalhe.component.css'],
})
export class ProdutoDetalheComponent implements OnInit, OnDestroy {
  // ─── Estado público consumido pelo template ────────────────────────────────
  fonte: any = null;
  isLoading = true;
  erro: string | null = null;
  adicionandoWishlist = false;
  isFavorito = false;

  private sub = new Subscription();

  constructor(
    private route: ActivatedRoute,
    private fonteService: FonteService,
    private carrinhoService: CarrinhoService,
    private dialogService: DialogService,
    private wishlistService: WishlistService,
    private authService: AuthService,
    public router: Router,
    private cdr: ChangeDetectorRef
  ) {}

  // ─── Ciclo de vida ─────────────────────────────────────────────────────────
  ngOnInit(): void {
    this.carregarProduto();
  }

  ngOnDestroy(): void {
    this.sub.unsubscribe();
  }

  // ─── Carregamento principal ─────────────────────────────────────────────────
  /**
   * Usa finalize() para GARANTIR que isLoading = false seja executado
   * independentemente de sucesso, erro HTTP ou erro de template.
   * O try/catch no subscribe captura qualquer exceção síncrona restante.
   */
  carregarProduto(): void {
    const idParam = this.route.snapshot.paramMap.get('id');
    const id = Number(idParam);

    // Guarda antecipada: se o ID não for um número válido, falha rápido
    if (!idParam || isNaN(id) || id <= 0) {
      this.erro = 'ID de produto inválido na URL.';
      this.isLoading = false;
      return;
    }

    this.isLoading = true;
    this.erro = null;
    this.fonte = null;

    console.log('PASSO 1: Iniciou a busca, ID:', id);
    const req$ = this.fonteService.findById(id).pipe(
      // 1️⃣  Captura qualquer erro HTTP (4xx, 5xx, network failure, etc.)
      catchError((err) => {
        console.error('[ProdutoDetalhe] Erro ao buscar produto:', err);
        if (err?.status === 404) {
          this.erro = `Produto #${id} não encontrado no catálogo.`;
        } else if (err?.status === 0) {
          this.erro = 'Não foi possível conectar ao servidor. Verifique sua conexão.';
        } else {
          this.erro = `Erro ao carregar produto (código ${err?.status ?? 'desconhecido'}).`;
        }
        // Retorna EMPTY para que o finalize ainda seja acionado
        return EMPTY;
      }),

      // 2️⃣  finalize roda SEMPRE: após next+complete OU após o EMPTY do catchError
      finalize(() => {
        console.log('PASSO 3: Finalize rodou, desligando loading!');
        this.isLoading = false;
        this.cdr.detectChanges();
      })
    );

    this.sub.add(
      req$.subscribe({
        next: (f) => {
          console.log('PASSO 2: Dados chegaram no componente:', f);
          // 3️⃣  Guarda contra resposta nula/undefined vinda do servidor
          if (f == null) {
            this.erro = `Produto #${id} retornou resposta vazia.`;
            return;
          }
          this.fonte = f;
          const idFonte = f.id;

          try {
            const token = localStorage.getItem('token');
            if (token && token !== 'null' && !this.authService.isTokenExpired(token) && idFonte) {
              this.verificarWishlist(idFonte);
            } else {
              this.isFavorito = false;
            }
          } catch (e) {
            console.warn('Ignorando wishlist: visitante.', e);
            this.isFavorito = false;
          }
        },
        // 4️⃣  Camada de segurança extra: catchError já tratou, mas se algo
        //     escapar (ex.: erro síncrono no next), isLoading já é false via finalize
        error: (err) => {
          console.error('[ProdutoDetalhe] Erro inesperado no subscribe:', err);
          this.erro = 'Ocorreu um erro inesperado. Por favor, tente novamente.';
          // isLoading já é false aqui pois o finalize rodou antes
        },
      })
    );
  }

  verificarWishlist(idFonte: number | undefined): void {
    if (!idFonte) return;
    this.sub.add(
      this.wishlistService.getWishlist().pipe(
        catchError((err) => {
          console.warn('[ProdutoDetalhe] Erro ao buscar wishlist:', err);
          return of([]);
        })
      ).subscribe((wishlist) => {
        if (wishlist) {
          this.isFavorito = wishlist.some(item => item.fonte && item.fonte.id === idFonte);
          this.cdr.detectChanges();
        }
      })
    );
  }

  // ─── Ações do utilizador ───────────────────────────────────────────────────
  adicionarAoCarrinho(): void {
    if (!this.fonte) return;
    try {
      this.carrinhoService.adicionar(this.fonte);
      this.dialogService.showSuccess(
        `${this.fonte.nome} adicionado! O seu carrinho tem agora ${this.carrinhoService.quantidadeTotal()} itens.`,
        'Adicionado!'
      );
    } catch (e) {
      console.error('[ProdutoDetalhe] Erro ao adicionar ao carrinho:', e);
      this.dialogService.showWarning('Erro ao adicionar ao carrinho.', 'Erro');
    }
  }

  comprarAgora(): void {
    if (!this.fonte) return;
    try {
      this.carrinhoService.adicionar(this.fonte);
      this.router.navigate(['/carrinho']);
    } catch (e) {
      console.error('[ProdutoDetalhe] Erro ao comprar agora:', e);
      this.dialogService.showWarning('Erro ao processar compra.', 'Erro');
    }
  }

  adicionarAWishlist(): void {
    if (!this.fonte || this.adicionandoWishlist) return;
    this.adicionandoWishlist = true;

    this.sub.add(
      this.wishlistService.adicionar(this.fonte.id).subscribe({
        next: () => {
          this.isFavorito = true;
          this.adicionandoWishlist = false;
          this.dialogService.showSuccess('Adicionado à lista de desejos!', 'Sucesso!');
          this.cdr.detectChanges();
        },
        error: (err) => {
          this.adicionandoWishlist = false;
          if (err?.status === 409) {
            this.isFavorito = true;
            this.dialogService.showWarning(
              'Este produto já está na sua lista de desejos.',
              'Já adicionado'
            );
          } else if (err?.status === 401 || err?.status === 403) {
            this.dialogService.showWarning(
              'Faça login para adicionar à lista de desejos.',
              'Login necessário'
            );
          } else {
            this.dialogService.showWarning(
              'Erro ao adicionar à lista de desejos. Tente novamente.',
              'Erro'
            );
          }
          this.cdr.detectChanges();
        }
      })
    );
  }

  // ─── Helpers de template ───────────────────────────────────────────────────
  /** Monta a URL absoluta de imagem a partir do path relativo retornado pela API */
  getImagemUrl(urlRelativa: string): string {
    if (!urlRelativa) return '';
    return `http://localhost:8081${urlRelativa}`;
  }

  // ─── Estado do Slider de Imagens ───────────────────────────────────────────
  imagemAtualIndex = 0;

  /** Monta a URL da imagem correspondente ao índice atual do slider */
  get imagemAtualUrl(): string | null {
    if (!this.fonte || !this.fonte.imagens || this.fonte.imagens.length === 0) {
      return null;
    }
    const idx = this.imagemAtualIndex;
    if (idx < 0 || idx >= this.fonte.imagens.length) {
      this.imagemAtualIndex = 0;
    }
    const imagem = this.fonte.imagens[this.imagemAtualIndex];
    if (!imagem || !imagem.url) return null;
    return this.getImagemUrl(imagem.url);
  }

  proximaImagem(): void {
    if (!this.fonte || !this.fonte.imagens || this.fonte.imagens.length <= 1) return;
    this.imagemAtualIndex = (this.imagemAtualIndex + 1) % this.fonte.imagens.length;
    this.cdr.detectChanges();
  }

  imagemAnterior(): void {
    if (!this.fonte || !this.fonte.imagens || this.fonte.imagens.length <= 1) return;
    this.imagemAtualIndex = (this.imagemAtualIndex - 1 + this.fonte.imagens.length) % this.fonte.imagens.length;
    this.cdr.detectChanges();
  }

  selecionarImagem(index: number): void {
    if (!this.fonte || !this.fonte.imagens || index < 0 || index >= this.fonte.imagens.length) return;
    this.imagemAtualIndex = index;
    this.cdr.detectChanges();
  }

  // Swipe Mobile
  private touchStartX = 0;

  onTouchStart(event: TouchEvent): void {
    this.touchStartX = event.changedTouches[0].screenX;
  }

  onTouchEnd(event: TouchEvent): void {
    const touchEndX = event.changedTouches[0].screenX;
    const diff = this.touchStartX - touchEndX;

    if (Math.abs(diff) > 50) {
      if (diff > 0) {
        this.proximaImagem();
      } else {
        this.imagemAnterior();
      }
    }
  }

  get primeiraImagemUrl(): string | null {
    return this.imagemAtualUrl;
  }

  /** Rótulo legível da certificação */
  get certificacaoLabel(): string {
    if (!this.fonte) return ''; // guard
    const cert = this.fonte.certificacao;
    if (!cert) return 'Não informada';
    // API retorna objeto {id, fontcert} quando @JsonFormat(OBJECT) — ou string quando string
    if (typeof cert === 'object' && cert.fontcert) return cert.fontcert;
    if (typeof cert === 'string') return cert;
    return String(cert);
  }

  /** Rótulo legível da marca */
  get marcaLabel(): string {
    if (!this.fonte) return ''; // guard
    const marca = this.fonte.marca;
    if (!marca) return 'Não informada';
    // API pode retornar string simples ou objeto {id, nome}
    if (typeof marca === 'object' && marca.nome) return marca.nome;
    return String(marca);
  }

  /** Indica se o produto tem estoque disponível */
  get temEstoque(): boolean {
    if (!this.fonte) return false; // guard
    return (this.fonte.estoque ?? 0) > 0;
  }

  voltar(): void {
    this.router.navigate(['/']);
  }
}
