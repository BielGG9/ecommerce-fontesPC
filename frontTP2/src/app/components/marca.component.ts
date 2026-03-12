import { Component, signal, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';
import { MarcaService } from '../services/marca.service';
import { Marca } from '../models/marca.model';
import { KeycloakService } from 'keycloak-angular';
import { MatCardModule } from '@angular/material/card';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatTableModule } from '@angular/material/table';

@Component({
  selector: 'app-marca',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule, MatCardModule, MatFormFieldModule, MatInputModule, MatButtonModule, MatIconModule, MatTableModule],
  templateUrl: './marca.component.html',
  styleUrl: './marca.component.css'
})
export class MarcaComponent implements OnInit {
  private marcaService = inject(MarcaService);
  private fb = inject(FormBuilder);
  private keycloak = inject(KeycloakService);

  colunas: string[] = ['id', 'nome', 'acoes'];

  marcas = signal<Marca[]>([]);
  
  // O formulário reativo. Tem o ID (escondido) para sabermos se estamos a editar ou a criar.
  marcaForm = this.fb.group({
    id: [null as number | null],
    nome: ['', Validators.required]
  });

  async ngOnInit() {
    try{
      const logado = this.keycloak.isLoggedIn();
    } catch(e) {
      console.warn('Não está logado, modo visitante ativo');
    } finally {
      this.carregarMarcas();
    }
  }

  carregarMarcas() {
    this.marcaService.findAll().subscribe({
      next: (dados) => this.marcas.set(dados),
      error: (err) => console.error('Erro ao carregar marcas', err)
    });
  }

  salvar() {
    if (this.marcaForm.invalid) return;

    const marca = this.marcaForm.value as Marca;

    if (marca.id) {
      // Se tem ID, é porque estamos a atualizar um registo existente (PUT)
      this.marcaService.update(marca).subscribe({
        next: () => {
          alert('Marca atualizada com sucesso!');
          this.resetForm();
          this.carregarMarcas();
        }
      });
    } else {
      // Se não tem ID, é uma marca nova (POST)
      this.marcaService.save(marca).subscribe({
        next: () => {
          alert('Marca criada com sucesso!');
          this.resetForm();
          this.carregarMarcas();
        }
      });
    }
  }

  editar(marca: Marca) {
    // Preenche os campos do formulário com os dados da marca selecionada na tabela
    this.marcaForm.patchValue({
      id: marca.id,
      nome: marca.nome
    });
  }

  excluir(id: number) {
    if (confirm('Tem a certeza que deseja eliminar esta marca?')) {
      this.marcaService.delete(id).subscribe({
        next: () => {
          alert('Marca eliminada!');
          this.carregarMarcas();
        }
      });
    }
  }

  resetForm() {
    this.marcaForm.reset();
  }
}