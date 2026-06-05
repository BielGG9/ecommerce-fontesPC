import { Component, OnInit, OnDestroy, inject, HostListener } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterOutlet, RouterLink, Router, RouterLinkActive, ActivatedRoute, NavigationEnd } from '@angular/router';
import { FormsModule } from '@angular/forms';
import { Subscription } from 'rxjs';
import { toSignal } from '@angular/core/rxjs-interop';
import { MatBadgeModule } from '@angular/material/badge';
import { CarrinhoService } from './services/carrinho.service';
import { MatIconModule } from '@angular/material/icon';
import { AuthService } from './services/auth.service';
import { MarcaService } from './services/marca.service';
import { FonteService } from './services/fonte.service';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterOutlet, RouterLink, RouterLinkActive, MatBadgeModule, MatIconModule],
  templateUrl: './components/app.component.html',
  styleUrl: './components/app.component.css'
})
export class App implements OnInit, OnDestroy {
  private router = inject(Router);
  private route = inject(ActivatedRoute);
  private authService = inject(AuthService);
  private marcaService = inject(MarcaService);
  private fonteService = inject(FonteService);
  private authSub!: Subscription;
  public carrinhoService = inject(CarrinhoService);

  // Signals reativos — sem NG0100
  readonly marcas = toSignal(this.marcaService.findAll(), { initialValue: [] as any[] });
  readonly certificacoes = toSignal(this.fonteService.getCertificacoes(), { initialValue: [] as string[] });

  usuarioLogado = false;
  nomeUsuario: string | null = '';

  isAdminRoute = false;
  isVitrine = false;

  termoBusca: string = '';
  marcaSelecionada: number | null = null;
  certificacaoSelecionada: string = '';

  lastScrollPosition = 0;
  isScrollingDown = false;

  @HostListener('window:scroll', [])
  onWindowScroll() {
    const currentScroll = window.scrollY || document.documentElement.scrollTop || 0;

    if (currentScroll <= 0) {
      this.isScrollingDown = false;
      this.lastScrollPosition = 0;
      return;
    }

    this.isScrollingDown = currentScroll > this.lastScrollPosition;
    this.lastScrollPosition = currentScroll;
  }

  ngOnInit() {
    this.authSub = this.authService.usuarioLogado$.subscribe(nome => {
      this.usuarioLogado = !!nome;
      this.nomeUsuario = nome;
    });

    // Sync filter fields with URL (deferred to next tick to avoid NG0100)
    this.route.queryParams.subscribe(params => {
      setTimeout(() => {
        this.termoBusca = params['nome'] || '';
        this.marcaSelecionada = params['marca'] ? Number(params['marca']) : null;
        this.certificacaoSelecionada = params['categoria'] || '';
      });
    });

    // Initialize route state synchronously, then track navigation
    this.updateRouteState(this.router.url);
    this.router.events.subscribe(event => {
      if (event instanceof NavigationEnd) {
        this.updateRouteState(event.urlAfterRedirects || event.url);
      }
    });
  }

  ngOnDestroy() {
    if (this.authSub) {
      this.authSub.unsubscribe();
    }
  }

  private updateRouteState(url: string) {
    if (!url) return;
    this.isAdminRoute = url.startsWith('/admin');
    this.isVitrine = url === '/' || url.startsWith('/?') || url === '/home' || url.startsWith('/home?');
  }

  filtrar() {
    this.router.navigate(['/'], {
      queryParams: {
        nome: this.termoBusca || null,
        marca: this.marcaSelecionada || null,
        categoria: this.certificacaoSelecionada || null
      },
      queryParamsHandling: 'merge'
    });
  }

  limpar() {
    this.termoBusca = '';
    this.marcaSelecionada = null;
    this.certificacaoSelecionada = '';
    this.router.navigate(['/'], {
      queryParams: { nome: null, marca: null, categoria: null },
      queryParamsHandling: 'merge'
    });
  }

  sair() {
    this.authService.limparSessao();
    this.router.navigate(['/login']);
  }
}