import { Component, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule, Router } from '@angular/router';
import { CarrinhoService } from '../../services/carrinho.service';
import { ItemPedido } from '../../models/item-pedido.model';

@Component({
  selector: 'app-carrinho',
  standalone: true,
  imports: [CommonModule, RouterModule],
  templateUrl: './carrinho.component.html',
  styleUrl: './carrinho.component.css'
})
export class CarrinhoComponent {
  carrinhoService = inject(CarrinhoService);
  router = inject(Router);

  removerItem(item: ItemPedido) {
    this.carrinhoService.itens.update(itens => itens.filter(i => i.fonte?.id !== item.fonte?.id));
  }

  aumentarQuantidade(item: ItemPedido) {
    if (item.fonte && item.quantidade < (item.fonte.estoque ?? 0)) {
       this.carrinhoService.itens.update(itens => {
         const i = itens.find(it => it.fonte?.id === item.fonte?.id);
         if (i) i.quantidade++;
         return [...itens];
       });
    }
  }

  diminuirQuantidade(item: ItemPedido) {
    if (item.quantidade > 1) {
       this.carrinhoService.itens.update(itens => {
         const i = itens.find(it => it.fonte?.id === item.fonte?.id);
         if (i) i.quantidade--;
         return [...itens];
       });
    }
  }

  irParaCheckout() {
    this.router.navigate(['/checkout']);
  }
}
