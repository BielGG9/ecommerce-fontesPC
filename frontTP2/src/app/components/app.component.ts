import { Component, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterOutlet } from '@angular/router';
import { KeycloakService } from 'keycloak-angular';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [CommonModule, RouterOutlet],
  templateUrl: './app.component.html'
})
export class AppComponent implements OnInit {
  private keycloak = inject(KeycloakService);

  logado = false;
  nomeUsuario = '';


  async ngOnInit() {
    // Pergunta ao Keycloak se há uma sessão ativa
    this.logado = await this.keycloak.isLoggedIn();

    if (this.logado) {
      // Se estiver logado, vai buscar o perfil para mostrar o nome
      const perfil = await this.keycloak.loadUserProfile();
      this.nomeUsuario = perfil.firstName || perfil.username || 'Utilizador';
    }
  }

  fazerLogin() {
    this.keycloak.login({
      redirectUri: window.location.origin + '/'
    });
  }

  fazerLogout() {
    // Faz o logout e manda o utilizador de volta para a raiz do site
    this.keycloak.logout(window.location.origin);
  }
}