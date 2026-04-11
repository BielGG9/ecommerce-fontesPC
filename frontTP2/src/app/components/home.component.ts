import { Component, OnInit, signal, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FonteService } from '../services/fonte.service';
import { Fonte } from '../models/fonte.model';
import { CarrinhoService } from '../services/carrinho.service';


// --- FERRAMENTAS VISUAIS QUE VAMOS USAR NA VITRINE ---
import { MatCardModule } from '@angular/material/card';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatChipsModule } from '@angular/material/chips'; // Ótimo para destacar a Potência e Certificação
import { MatGridListModule } from '@angular/material/grid-list'; // Para organizar os cards em grade

@Component({
  selector: 'app-home',
  standalone: true,
  imports: [
    CommonModule, 
    MatCardModule, 
    MatButtonModule, 
    MatIconModule, 
    MatChipsModule, 
    MatGridListModule
  ],
  templateUrl: './home.component.html',
  styleUrl: './home.component.css'
})
export class HomeComponent implements OnInit {
  private fonteService = inject(FonteService);
  private carrinhoService = inject(CarrinhoService);
  
  // Guardamos as fontes que vão aparecer na vitrine
  fontes = signal<Fonte[]>([]);

  ngOnInit(): void {
    // Ao abrir a tela, carregamos as primeiras fontes (ex: 12 fontes)
    this.fonteService.findAll(0, 12, '').subscribe({
      next: (dados) => this.fontes.set(dados),
      error: (err) => console.error('Erro ao carregar a vitrine', err)
    });
  }

  // Novo método de comprar!
  comprar(fonte: Fonte) {
    if ((fonte.estoque ?? 0) > 0) {
      this.carrinhoService.adicionar(fonte);
      
      // Atualiza o estoque recriando o objeto da fonte no Signal
      // O Angular prefere essa abordagem para acionar a atualização de tela corretamente!
      this.fontes.update(lista => 
        lista.map(f => {
          if (f.id === fonte.id) {
            return { ...f, estoque: (f.estoque ?? 1) - 1 };
          }
          return f;
        })
      );

      // Mostra quantos itens já temos guardados
      alert(`${fonte.nome} adicionado! O seu carrinho tem agora ${this.carrinhoService.quantidadeTotal()} itens.`);
    } else {
      alert(`Desculpe, ${fonte.nome} está esgotada!`);
    }
  }

}
