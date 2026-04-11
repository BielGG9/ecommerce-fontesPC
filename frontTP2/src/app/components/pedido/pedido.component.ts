import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatTableModule } from '@angular/material/table';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatCardModule } from '@angular/material/card';
import { PedidoService } from '../../services/pedido.service';
import { Pedido } from '../../models/pedido.model';

@Component({
  selector: 'app-pedido',
  standalone: true,
  imports: [
    CommonModule,
    MatTableModule,
    MatButtonModule,
    MatIconModule,
    MatCardModule
  ],
  templateUrl: './pedido.component.html',
  styleUrls: ['./pedido.component.css']
})
export class PedidoComponent implements OnInit {
  pedidos: Pedido[] = [];
  colunasExibidas: string[] = ['id', 'dataHora', 'cliente', 'valorTotal', 'acoes'];

  constructor(private pedidoService: PedidoService) {}

  ngOnInit(): void {
    this.carregarPedidos();
  }

  carregarPedidos(): void {
    this.pedidoService.findAll().subscribe({
      next: (dados) => {
        this.pedidos = dados;
      },
      error: (err) => {
        console.error('Erro ao carregar os pedidos', err);
      }
    });
  }

  excluirPedido(id: number | undefined): void {
    if (id && confirm('Tem certeza que deseja apagar este pedido? Todos os itens dele serão apagados também (Composição)!')) {
      this.pedidoService.delete(id).subscribe({
        next: () => {
          this.carregarPedidos(); // Recarrega a tabela após apagar
        },
        error: (err) => {
          console.error('Erro ao excluir pedido', err);
        }
      });
    }
  }

  verItens(pedido: Pedido): void {
    // Para já, vamos apenas mostrar um alerta com a quantidade de itens.
    // Depois podemos criar um modal (Dialog) bonito para listar os itens!
    alert(`Este pedido possui ${pedido.itens?.length || 0} itens. O valor total é R$ ${pedido.valorTotal}`);
  }
}