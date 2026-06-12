import { Component, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule, Router } from '@angular/router';

@Component({
  selector: 'app-pedido-confirmado',
  standalone: true,
  imports: [CommonModule, RouterModule],
  templateUrl: './pedido-confirmado.component.html',
  styleUrl: './pedido-confirmado.component.css'
})
export class PedidoConfirmadoComponent {
  router = inject(Router);

  irParaHome() {
    this.router.navigate(['/']);
  }

  irParaMeusPedidos() {
    this.router.navigate(['/minha-conta/pedidos']);
  }
}
