import { Component, OnInit, OnDestroy, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterOutlet, RouterLink, Router, RouterLinkActive, ActivatedRoute } from '@angular/router';
import { FormsModule } from '@angular/forms';
import { Subscription } from 'rxjs';
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
  templateUrl: './components/app.component.html'
})
export class App implements OnInit, OnDestroy {
  private router = inject(Router);
  private route = inject(ActivatedRoute);
  private authService = inject(AuthService);
  private marcaService = inject(MarcaService);
  private fonteService = inject(FonteService);
  private authSub!: Subscription;
  public carrinhoService = inject(CarrinhoService);

  usuarioLogado = false;
  nomeUsuario: string | null = '';

  marcas: any[] = [];
  certificacoes: string[] = [];
  
  filtroNome: string = '';
  filtroMarca: number | null = null;
  filtroCategoria: string = '';

  ngOnInit() {
    this.authSub = this.authService.usuarioLogado$.subscribe(nome => {
      this.usuarioLogado = !!nome;
      this.nomeUsuario = nome;
    });

    this.marcaService.findAll().subscribe(m => this.marcas = m);
    this.fonteService.getCertificacoes().subscribe(c => this.certificacoes = c);
    
    // Sync filter fields with URL
    this.route.queryParams.subscribe(params => {
      this.filtroNome = params['nome'] || '';
      this.filtroMarca = params['marca'] ? Number(params['marca']) : null;
      this.filtroCategoria = params['categoria'] || '';
    });
  }

  ngOnDestroy() {
    if (this.authSub) {
      this.authSub.unsubscribe();
    }
  }

  get isAdminRoute(): boolean {
    return this.router.url.startsWith('/admin');
  }

  buscar() {
    this.router.navigate(['/'], { 
      queryParams: { 
        nome: this.filtroNome || null, 
        marca: this.filtroMarca || null, 
        categoria: this.filtroCategoria || null 
      },
      queryParamsHandling: 'merge'
    });
  }

  limparFiltros() {
    this.filtroNome = '';
    this.filtroMarca = null;
    this.filtroCategoria = '';
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