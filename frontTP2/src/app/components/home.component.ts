import { Component, OnInit, signal, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router } from '@angular/router';
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
  private marcaService = inject(MarcaService);
  private carrinhoService = inject(CarrinhoService);
  private dialogService = inject(DialogService);
  public router = inject(Router);
  
  // Guardamos as fontes que vão aparecer na vitrine
  fontes = signal<Fonte[]>([]);

  marcas: any[] = [];
  certificacoes: string[] = [];
  filtroNome: string = '';
  filtroMarca: number | null = null;
  filtroCategoria: string = '';

  page: number = 0;
  pageSize: number = 12;
  total: number = 0;

  ngOnInit(): void {
    this.marcaService.findAll().subscribe(m => this.marcas = m);
    this.fonteService.getCertificacoes().subscribe(c => this.certificacoes = c);
    this.loadFontes();
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

  buscar(): void {
    this.page = 0;
    this.loadFontes();
  }

  limparFiltros(): void {
    this.filtroNome = '';
    this.filtroMarca = null;
    this.filtroCategoria = '';
    this.page = 0;
    this.loadFontes();
  }

  // Novo método de comprar!
  comprar(fonte: Fonte) {
    if ((fonte.estoque ?? 0) > 0) {
      this.carrinhoService.adicionar(fonte);
      
      // Atualiza o estoque recriando o objeto da fonte no Signal
      // O Angular prefere essa abordagem para acionar a atualização de tela corretamente!
      this.fontes.update(lista => 
        lista.map(f => {
          if (f.id === fonte.id) {
            return { ...f, estoque: (f.estoque ?? 1) - 1 };
          }
          return f;
        })
      );

      // Mostra quantos itens já temos guardados
      this.dialogService.showSuccess(`${fonte.nome} adicionado! O seu carrinho tem agora ${this.carrinhoService.quantidadeTotal()} itens.`, 'Adicionado!');
    } else {
      this.dialogService.showWarning(`Desculpe, ${fonte.nome} está esgotada!`, 'Esgotado');
    }
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
