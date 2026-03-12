import { Component, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterOutlet, RouterLink } from '@angular/router';
import { KeycloakService } from 'keycloak-angular';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [CommonModule, RouterOutlet, RouterLink],
  templateUrl: './components/app.component.html'
})
export class App implements OnInit {
  private keycloakService = inject(KeycloakService);

  logado = false;
  nomeUsuario = '';

  async ngOnInit() {
    try {
      // O provideKeycloak já ligou o motor, então só precisamos verificar o status!
      this.logado = this.keycloakService.isLoggedIn();
      
      if (this.logado) {
        const perfil = await this.keycloakService.loadUserProfile();
        this.nomeUsuario = perfil.firstName || perfil.username || 'Usuário';
      }
    } catch (erro) {
      console.error('Erro ao ler perfil do Keycloak:', erro);
    }
  }

  fazerLogin() {
    // Redireciona para o login e manda voltar para a página inicial depois
    this.keycloakService.login({ redirectUri: window.location.origin + '/' });
  }

  fazerLogout() {
    this.keycloakService.logout(window.location.origin + '/');
  }
}