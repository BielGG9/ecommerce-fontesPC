import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule } from '@angular/router';
import { WishlistService, Desejo } from '../../services/wishlist.service';
import { CarrinhoService } from '../../services/carrinho.service';
import { DialogService } from '../../services/dialog.service';

import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';

@Component({
  selector: 'app-wishlist',
  standalone: true,
  imports: [
    CommonModule,
    RouterModule,
    MatButtonModule,
    MatIconModule,
    MatProgressSpinnerModule
  ],
  templateUrl: './wishlist.component.html',
  styleUrls: ['./wishlist.component.css']
})
export class WishlistComponent implements OnInit {
  desejos: Desejo[] = [];
  loading: boolean = true;
  erro: string | null = null;

  constructor(
    private wishlistService: WishlistService,
    private carrinhoService: CarrinhoService,
    private dialogService: DialogService
  ) {}

  ngOnInit(): void {
    this.carregarWishlist();
  }

  carregarWishlist(): void {
    this.loading = true;
    this.wishlistService.getWishlist().subscribe({
      next: (data) => {
        this.desejos = data;
        this.loading = false;
      },
      error: (err) => {
        console.error('Erro ao carregar wishlist:', err);
        this.erro = 'Erro ao carregar a lista de desejos.';
        this.loading = false;
      }
    });
  }

  remover(idDesejo: number): void {
    this.wishlistService.remover(idDesejo).subscribe({
      next: () => {
        this.desejos = this.desejos.filter(d => d.id !== idDesejo);
        this.dialogService.showSuccess('Item removido da lista de desejos.', 'Removido');
      },
      error: (err) => {
        console.error('Erro ao remover item:', err);
        this.dialogService.showWarning('Erro ao remover o item.', 'Erro');
      }
    });
  }

  adicionarAoCarrinho(fonte: any): void {
    this.carrinhoService.adicionar(fonte);
    this.dialogService.showSuccess(`${fonte.nome} adicionado ao carrinho!`, 'Adicionado');
  }

  getImagemUrl(fonte: any): string {
    if (fonte && fonte.imagens && fonte.imagens.length > 0) {
      return `http://localhost:8081${fonte.imagens[0].url}`;
    }
    return '';
  }
}
