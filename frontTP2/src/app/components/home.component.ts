import { Component, OnInit, signal, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router, ActivatedRoute, RouterModule } from '@angular/router';
import { FonteService } from '../services/fonte.service';
import { MarcaService } from '../services/marca.service';
import { Fonte } from '../models/fonte.model';
import { CarrinhoService } from '../services/carrinho.service';
import { DialogService } from '../services/dialog.service';

// --- FERRAMENTAS VISUAIS QUE VAMOS USAR NA VITRINE ---
import { MatCardModule } from '@angular/material/card';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatChipsModule } from '@angular/material/chips'; // Ótimo para destacar a Potência e Certificação
import { MatGridListModule } from '@angular/material/grid-list'; // Para organizar os cards em grade
import { MatSelectModule } from '@angular/material/select';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';

@Component({
  selector: 'app-home',
  standalone: true,
  imports: [
    CommonModule, 
    FormsModule,
    RouterModule,
    MatCardModule, 
    MatButtonModule, 
    MatIconModule, 
    MatChipsModule, 
    MatGridListModule,
    MatSelectModule,
    MatFormFieldModule,
    MatInputModule
  ],
  templateUrl: './home.component.html',
  styleUrl: './home.component.css'
})
export class HomeComponent implements OnInit {
  private fonteService = inject(FonteService);
  private carrinhoService = inject(CarrinhoService);
  private dialogService = inject(DialogService);
  public router = inject(Router);
  private route = inject(ActivatedRoute); // Injected ActivatedRoute
  
  // Guardamos as fontes que vão aparecer na vitrine
  fontes = signal<Fonte[]>([]);

  filtroNome: string = '';
  filtroMarca: number | null = null;
  filtroCategoria: string = '';

  page: number = 0;
  pageSize: number = 12;
  total: number = 0;

  ngOnInit(): void {
    // Listen to query parameters from the URL
    this.route.queryParams.subscribe(params => {
      this.filtroNome = params['nome'] || '';
      this.filtroMarca = params['marca'] ? Number(params['marca']) : null;
      this.filtroCategoria = params['categoria'] || '';
      
      this.page = 0; // Reset page when filters change
      this.loadFontes();
    });
  }

  loadFontes(): void {
    this.fonteService.findAll(
      this.page, this.pageSize,
      this.filtroNome || undefined,
      this.filtroMarca || undefined,
      this.filtroCategoria || undefined
    ).subscribe({
      next: (res) => {
        this.fontes.set(res.items);
        this.total = res.total;
      },
      error: (err) => console.error('Erro ao carregar fontes filtradas', err)
    });
  }

  // Novo método de comprar!
  comprar(fonte: Fonte) {
    if ((fonte.estoque ?? 0) > 0) {
      this.carrinhoService.adicionar(fonte);

      // Mostra quantos itens já temos guardados
      this.dialogService.showSuccess(`${fonte.nome} adicionado! O seu carrinho tem agora ${this.carrinhoService.quantidadeTotal()} itens.`, 'Adicionado!');
    } else {
      this.dialogService.showWarning(`Desculpe, ${fonte.nome} está esgotada!`, 'Esgotado');
    }
  }

  limparFiltros(): void {
    this.router.navigate(['/'], { 
      queryParams: { nome: null, marca: null, categoria: null },
      queryParamsHandling: 'merge'
    });
  }


  getImagemUrl(url: string): string {
    return `http://localhost:8081${url}`;
  }

  /** Retorna a URL absoluta da primeira imagem do produto, ou null se não houver. */
  getFirstImageUrl(fonte: Fonte): string | null {
    if (!fonte?.imagens || fonte.imagens.length === 0) return null;
    const first = fonte.imagens[0];
    if (!first?.url) return null;
    return this.getImagemUrl(first.url);
  }
}
