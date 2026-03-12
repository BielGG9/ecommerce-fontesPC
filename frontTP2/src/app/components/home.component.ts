import { Component, OnInit, signal, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FonteService } from '../services/fonte.service';
import { Fonte } from '../models/fonte.model';

import { KeycloakService } from 'keycloak-angular';

@Component({
  selector: 'app-home',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './home.component.html'
})
export class HomeComponent implements OnInit {
  private fonteService = inject(FonteService);
  private keycloak = inject(KeycloakService);
  
  fontes = signal<Fonte[]>([]);

  async ngOnInit() {
    const logado = await this.keycloak.isLoggedIn();
    if (logado) {
      this.carregarFontes();
    }
  }

  carregarFontes() {
    this.fonteService.findAll().subscribe({
      next: (dados) => this.fontes.set(dados),
      error: (err) => console.error('Erro ao carregar fontes', err)
    });
  }
}
