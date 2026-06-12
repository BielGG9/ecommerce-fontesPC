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
  avatarUrl = 'https://i.pinimg.com/736x/21/e4/f0/21e4f0c4bb7c4e57cdccbc412ca671c6.jpg';

  menuAvatarAberto = false;

  onAvatarSelected(event: any) {
    const file: File = event.target.files[0];
    if (file) {
      this.clienteService.uploadAvatar(file).subscribe({
        next: (res) => {
          console.log('Upload sucesso:', res);
          // Reload the profile to get the new nomeImagem
          this.carregarPerfil();
          this.menuAvatarAberto = false;
        },
        error: (err) => {
          console.error('Erro no upload', err);
          alert('Erro ao enviar a imagem.');
        }
      });
    }
  }

  toggleMenuAvatar() {
    this.menuAvatarAberto = !this.menuAvatarAberto;
  }

  editarFotoAtual() {
    // Pode disparar o fileInput também
    const fileInput = document.querySelector('input[type="file"]') as HTMLElement;
    if (fileInput) fileInput.click();
    this.menuAvatarAberto = false;
  }

  ngOnInit() {
    this.carregarPerfil();
    this.carregarUltimoPedido();
  }

  carregarPerfil() {
    this.clienteService.getMeuPerfil().subscribe({
      next: (dados) => {
        this.ngZone.run(() => {
          this.cliente = dados;
          if (this.cliente?.nomeImagem) {
            this.avatarUrl = this.clienteService.getAvatarUrl(this.cliente.nomeImagem);
          }
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
