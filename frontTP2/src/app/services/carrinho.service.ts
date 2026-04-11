import { Injectable, signal, computed } from '@angular/core';
import { Fonte } from '../models/fonte.model';
import { ItemPedido } from '../models/item-pedido.model';

@Injectable({
  providedIn: 'root'
})
export class CarrinhoService {
  
  // O nosso carrinho começa vazio
  itens = signal<ItemPedido[]>([]);

  // O Angular 'computed' calcula os totais automaticamente sempre que um item for adicionado!
  quantidadeTotal = computed(() => this.itens().reduce((acc, item) => acc + item.quantidade, 0));
  valorTotal = computed(() => this.itens().reduce((acc, item) => acc + (item.precoUnitario * item.quantidade), 0));

  adicionar(fonte: Fonte) {
    this.itens.update(itensAtuais => {
      // Verifica se a fonte já está no carrinho
      const itemExistente = itensAtuais.find(i => i.fonte?.id === fonte.id);
      
      if (itemExistente) {
        // Se já existe, só aumenta a quantidade
        itemExistente.quantidade += 1;
        return [...itensAtuais];
      } else {
        // Se é nova, cria o ItemPedido
        const novoItem: ItemPedido = {
          quantidade: 1,
          precoUnitario: fonte.preco,
          fonte: fonte
        };
        return [...itensAtuais, novoItem];
      }
    });
  }

  limparCarrinho() {
    this.itens.set([]);
  }
}