import { Component, OnInit, OnDestroy, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterOutlet, RouterModule, Router } from '@angular/router';
import { Subscription } from 'rxjs';
import { MatBadgeModule } from '@angular/material/badge';
import { MatIconModule } from '@angular/material/icon';
import { MatButtonModule } from '@angular/material/button';
import { AuthService } from '../services/auth.service';
import { CarrinhoService } from '../services/carrinho.service';


@Component({
  selector: 'app-root',
  standalone: true,
  imports: [CommonModule, RouterOutlet, RouterModule, MatBadgeModule, MatButtonModule, MatIconModule],
  templateUrl: './app.component.html',
  styleUrl: './app.component.css'
})
export class AppComponent implements OnInit, OnDestroy {
  private router = inject(Router);
  private authService = inject(AuthService);
  private authSub!: Subscription;
  public carrinhoService = inject(CarrinhoService)

  usuarioLogado = false;
  nomeUsuario: string | null = '';

  ngOnInit() {
    this.authSub = this.authService.usuarioLogado$.subscribe(nome => {
      this.usuarioLogado = !!nome;
      this.nomeUsuario = nome;
    });
  }

  ngOnDestroy() {
    if (this.authSub) {
      this.authSub.unsubscribe();
    }
  }

  sair() {
    this.authService.limparSessao();
    this.router.navigate(['/login']);
  }
}