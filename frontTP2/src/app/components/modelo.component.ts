import { Component, OnInit, signal, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';

// Nossos Serviços e Models
import { ModeloService } from '../services/modelo.service';
import { MarcaService } from '../services/marca.service';
import { Modelo } from '../models/modelo.models';
import { Marca } from '../models/marca.model';
import { KeycloakService } from 'keycloak-angular';

// Peças do Angular Material
import { MatCardModule } from '@angular/material/card';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatSelectModule } from '@angular/material/select';
import { MatButtonModule } from '@angular/material/button';
import { MatTableModule } from '@angular/material/table';
import { MatIconModule } from '@angular/material/icon';

@Component({
  selector: 'app-modelo',
  standalone: true,
  imports: [
    CommonModule, 
    ReactiveFormsModule,
    MatCardModule,
    MatFormFieldModule,
    MatInputModule,
    MatSelectModule,
    MatButtonModule,
    MatTableModule,
    MatIconModule
  ],
  templateUrl: './modelo.component.html',
  styleUrl: './modelo.component.css'
})
export class ModeloComponent implements OnInit {
  private modeloService = inject(ModeloService);
  private marcaService = inject(MarcaService);
  private fb = inject(FormBuilder);
  private keycloak = inject(KeycloakService);

  modelos = signal<Modelo[]>([]);
  marcas = signal<Marca[]>([]); 

  // Colunas da nossa tabela de Modelos
  colunasExibidas: string[] = ['id', 'numeracao', 'marca', 'acoes'];

  modeloForm = this.fb.group({
    id: [null as number | null],
    numeracao: ['', [Validators.required, Validators.min(1)]],
    idMarca: ['', Validators.required]
  });

  async ngOnInit() {
    try {
      this.keycloak.isLoggedIn();
    } catch (e) {
      // Ignora erro offline
    } finally {
      this.carregarModelos();
      this.carregarMarcas(); 
    }
  }

  carregarModelos() {
    this.modeloService.findAll().subscribe({
      next: (dados) => this.modelos.set(dados),
      error: (err) => console.error('Erro ao carregar modelos', err)
    });
  }

  carregarMarcas() {
    this.marcaService.findAll().subscribe({
      next: (dados) => this.marcas.set(dados),
      error: (err) => console.error('Erro ao carregar marcas', err)
    });
  }

  salvar() {
    if (this.modeloForm.invalid) return;
    
    // Montando o objeto exatamente como o seu ModeloRequest em Java pede!
    const novoModelo = {
        numeracao: Number(this.modeloForm.value.numeracao),
        idMarca: Number(this.modeloForm.value.idMarca)
    } as Modelo;

    if (this.modeloForm.value.id) {
       // logica de update futuramente...
    } else {
      this.modeloService.save(novoModelo).subscribe({
        next: () => {
          alert('Modelo guardado com sucesso!');
          this.modeloForm.reset();
          this.carregarModelos();
        },
        error: (err) => {
          console.error('Erro ao salvar modelo', err);
          alert('Erro ao guardar. Verifique o F12.');
        }
      });
    }
  }

  cancelar() {
    this.modeloForm.reset();
  }

  editar(modelo: Modelo) {}
  excluir(id: number) {}
}