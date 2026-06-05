import { Component, OnInit, inject, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule } from '@angular/router';
import { PedidoService } from '../../../services/pedido.service';
import { Pedido } from '../../../models/pedido.model';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatCardModule } from '@angular/material/card';

@Component({
  selector: 'app-perfil-pedidos',
  standalone: true,
  imports: [CommonModule, RouterModule, MatButtonModule, MatIconModule, MatCardModule],
  templateUrl: './pedidos.component.html',
  styleUrls: ['./pedidos.component.css']
})
export class PedidosComponent implements OnInit {
  pedidoService = inject(PedidoService);
  
  pedidos = signal<Pedido[]>([]);
  carregando = signal(true);
  expandedPedidoId = signal<number | null>(null);

  ngOnInit() {
    this.carregarPedidos();
  }

  carregarPedidos() {
    this.pedidoService.getMeusPedidos().subscribe({
      next: (dados) => {
        // Ordena para que os mais recentes apareçam no topo
        this.pedidos.set(dados.sort((a, b) => (b.id ?? 0) - (a.id ?? 0)));
        this.carregando.set(false);
      },
      error: (err) => {
        console.error('Erro ao carregar seus pedidos:', err);
        this.carregando.set(false);
      }
    });
  }

  toggleExpandir(id: number | undefined) {
    if (!id) return;
    if (this.expandedPedidoId() === id) {
      this.expandedPedidoId.set(null);
    } else {
      this.expandedPedidoId.set(id);
    }
  }

  formatDate(date: Date | string): string {
    const d = new Date(date);
    return d.toLocaleDateString('pt-BR', {
      day: '2-digit',
      month: '2-digit',
      year: 'numeric',
      hour: '2-digit',
      minute: '2-digit'
    });
  }

  formatCpf(cpf: string | undefined): string {
    if (!cpf) return '';
    const digits = cpf.replace(/\D/g, '');
    if (digits.length === 11) {
      return `${digits.substring(0, 3)}.***.***-**`;
    }
    return digits.substring(0, 3) + '...';
  }
}
