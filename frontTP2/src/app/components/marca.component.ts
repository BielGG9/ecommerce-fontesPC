import { Component, signal, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';
import { MarcaService } from '../services/marca.service';
import { Marca } from '../models/marca.model';

import { MatCardModule } from '@angular/material/card';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatTableModule } from '@angular/material/table';
import { Router } from '@angular/router';
import { MatPaginatorIntl, MatPaginatorModule, PageEvent } from '@angular/material/paginator';
import { PaginatorIntlPtBr } from '../paginator-ptbr';

@Component({
  selector: 'app-marca',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule, MatCardModule, MatFormFieldModule, MatInputModule, MatButtonModule, MatIconModule, MatTableModule, MatPaginatorModule],
  templateUrl: './marca.component.html',
  styleUrl: './marca.component.css',
  providers: [{ provide: MatPaginatorIntl, useClass: PaginatorIntlPtBr }]
})
export class MarcaComponent implements OnInit {
  private marcaService = inject(MarcaService);
  private fb = inject(FormBuilder);

  private router = inject(Router);
  colunas: string[] = ['id', 'nome', 'acoes'];

  marcas = signal<Marca[]>([]);

  totalMarcas = signal(0);
  pageSize = 2;
  page = 0;
  nomeBusca = '';
  
  // O formulário reativo. Tem o ID (escondido) para sabermos se estamos a editar ou a criar.
  marcaForm = this.fb.group({
    id: [null as number | null],
    nome: ['', [Validators.required, Validators.maxLength(100)]]
  });

  async ngOnInit() {
    try{
      const logado = !!localStorage.getItem('token');
    } catch(e) {
      console.warn('Não está logado, modo visitante ativo');
    } finally {
      this.carregarMarcas();
    }
  }

  carregarMarcas() {
    this.marcaService.findAll(this.page, this.pageSize, this.nomeBusca).subscribe({
      next: (dados) => {
        this.marcas.set(dados);
        this.marcaService.count(this.nomeBusca).subscribe({
          next: (total) => this.totalMarcas.set(total),
          error: (err) => console.error('Erro ao contar marcas', err)
        });
      },
      error: (err) => console.error('Erro ao carregar marcas', err)
    });
  }

  paginar(event: PageEvent): void {
    this.page = event.pageIndex;
    this.pageSize = event.pageSize;
    this.carregarMarcas();
  }

  buscar(texto: string) {
    this.nomeBusca = texto;
    this.page = 0;
    this.carregarMarcas();
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
          this.resetForm();
          this.carregarMarcas();
        },
        error: (err) => {
          if (err.status === 400) {
            alert('Não é possível excluir esta Marca, pois ela possui modelos vinculados. Remova os modelos primeiro.');
          } else {
            alert('Falha ao tentar remover a marca. Verifique a conexão.');
            console.error(err);
          }
        }
      });
    }
  }

  obterMensagemErro(campo: string, nomeCampo: string = 'Campo'): string {
    const controle = this.marcaForm.get(campo);
    if (!controle || !controle.errors) return '';

    if (controle.hasError('required')) return `${nomeCampo} obrigatório.`;
    if (controle.hasError('minlength')) return `Deve ter pelo menos ${controle.getError('minlength').requiredLength} caracteres.`;
    if (controle.hasError('maxlength')) return `Pode ter no máximo ${controle.getError('maxlength').requiredLength} caracteres.`;
    if (controle.hasError('min')) return `O valor mínimo é ${controle.getError('min').min}.`;

    return '';
  }

  resetForm() {
    this.marcaForm.reset();
  }

  navegarParaHome() {
    this.router.navigate(['/home']);
  }
}