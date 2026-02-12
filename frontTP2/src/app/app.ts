import { Component, signal, OnInit, inject } from '@angular/core';
import { RouterOutlet } from '@angular/router';
import { CommonModule } from '@angular/common'; // Import CommonModule for ngFor/AsyncPipe if needed, or just imports
import { FonteService } from './services/fonte.service';
import { Fonte } from './models/fonte.model';

@Component({
  selector: 'app-root',
  imports: [RouterOutlet, CommonModule],
  templateUrl: './app.html',
  styleUrl: './app.css'
})
export class App implements OnInit {
  protected readonly title = signal('frontTP2');
  private fonteService = inject(FonteService);
  
  fontes = signal<Fonte[]>([]);
  loading = signal(true);
  errorMsg = signal('');

  ngOnInit() {
    this.fonteService.findAll().subscribe({
      next: (data) => {
        console.log('Dados recebidos:', data);
        this.fontes.set(data);
        this.loading.set(false);
      },
      error: (err) => {
        console.error('Erro ao buscar fontes:', err);
        this.errorMsg.set('Erro ao carregar dados: ' + (err.message || 'Erro desconhecido'));
        this.loading.set(false);
      }
    });
  }
}
