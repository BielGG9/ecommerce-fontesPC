import { Component, OnInit, inject, ChangeDetectorRef, NgZone } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ClienteService } from '../../services/cliente.service';
import { PedidoService } from '../../services/pedido.service';
import { Cliente } from '../../models/cliente.model';
import { Pedido } from '../../models/pedido.model';
import { MatButtonModule } from '@angular/material/button';
import { RouterModule } from '@angular/router';

@Component({
  selector: 'app-perfil',
  standalone: true,
  imports: [CommonModule, MatButtonModule, RouterModule],
  templateUrl: './perfil.component.html',
  styleUrls: ['./perfil.component.css']
})
export class PerfilComponent implements OnInit {

  clienteService = inject(ClienteService);
  pedidoService = inject(PedidoService);
  private cdr = inject(ChangeDetectorRef);
  private ngZone = inject(NgZone);
  
  cliente: Cliente | null = null;
  ultimoPedido: Pedido | null = null;
  carregandoPedido = true;

  ngOnInit() {
    this.carregarPerfil();
    this.carregarUltimoPedido();
  }

  carregarPerfil() {
    this.clienteService.getMeuPerfil().subscribe({
      next: (dados) => {
        this.ngZone.run(() => {
          this.cliente = dados;
          this.cdr.detectChanges();
        });
        console.log('Perfil carregado:', this.cliente);
      },
      error: (err) => {
        this.ngZone.run(() => {
          console.error('Erro ao carregar perfil', err);
          alert('Erro ao carregar seu perfil. Tente fazer login novamente.');
          this.cdr.detectChanges();
        });
      }
    });
  }

  carregarUltimoPedido() {
    this.pedidoService.getMeusPedidos().subscribe({
      next: (pedidos) => {
        this.ngZone.run(() => {
          if (pedidos && pedidos.length > 0) {
            // Pega o pedido mais recente baseado no ID (assumindo que ID maior = mais novo)
            // Ou pega o último elemento do array
            this.ultimoPedido = pedidos[pedidos.length - 1]; 
          }
          this.carregandoPedido = false;
          this.cdr.detectChanges();
        });
      },
      error: (err) => {
        this.ngZone.run(() => {
          console.error('Erro ao carregar os pedidos', err);
          this.carregandoPedido = false;
          this.cdr.detectChanges();
        });
      }
    });
  }
}
