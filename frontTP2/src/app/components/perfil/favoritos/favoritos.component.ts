import { Component, OnInit, ChangeDetectorRef } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule } from '@angular/router';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { MatIconModule } from '@angular/material/icon';
import { MatButtonModule } from '@angular/material/button';
import { WishlistService } from '../../../services/wishlist.service';
import { CarrinhoService } from '../../../services/carrinho.service';
import { DialogService } from '../../../services/dialog.service';
import { catchError, finalize } from 'rxjs/operators';
import { EMPTY } from 'rxjs';

@Component({
  selector: 'app-favoritos',
  standalone: true,
  imports: [
    CommonModule,
    RouterModule,
    MatProgressSpinnerModule,
    MatIconModule,
    MatButtonModule
  ],
  templateUrl: './favoritos.component.html',
  styleUrls: ['./favoritos.component.css']
})
export class FavoritosComponent implements OnInit {
  favoritos: any[] = [];
  isLoading = true;

  constructor(
    private wishlistService: WishlistService,
    private carrinhoService: CarrinhoService,
    private dialogService: DialogService,
    private cdr: ChangeDetectorRef
  ) {}

  ngOnInit(): void {
    this.carregarFavoritos();
  }

  carregarFavoritos(): void {
    this.isLoading = true;
    this.wishlistService.getWishlist().pipe(
      catchError((err) => {
        console.error('[Favoritos] Erro ao carregar favoritos:', err);
        this.dialogService.showWarning('Erro ao carregar lista de desejos.', 'Erro');
        return EMPTY;
      }),
      finalize(() => {
        this.isLoading = false;
        this.cdr.detectChanges();
      })
    ).subscribe((data) => {
      console.log('Favoritos carregados:', data);
      this.favoritos = data || [];
    });
  }

  adicionarAoCarrinho(item: any): void {
    if (!item.fonte) return;
    try {
      this.carrinhoService.adicionar(item.fonte);
      this.dialogService.showSuccess(
        `${item.fonte.nome} adicionado ao carrinho!`,
        'Sucesso'
      );
    } catch (e) {
      console.error('[Favoritos] Erro ao adicionar ao carrinho:', e);
      this.dialogService.showWarning('Erro ao adicionar ao carrinho.', 'Erro');
    }
  }

  remover(item: any): void {
    if (!item.id) return;
    this.wishlistService.remover(item.id).pipe(
      catchError((err) => {
        console.error('[Favoritos] Erro ao remover favorito:', err);
        this.dialogService.showWarning('Erro ao remover dos favoritos.', 'Erro');
        return EMPTY;
      })
    ).subscribe(() => {
      this.favoritos = this.favoritos.filter(fav => fav.id !== item.id);
      this.dialogService.showSuccess('Removido dos favoritos!', 'Sucesso');
      this.cdr.detectChanges();
    });
  }
}
