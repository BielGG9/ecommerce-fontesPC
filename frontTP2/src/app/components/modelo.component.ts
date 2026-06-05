import { Component, OnInit, signal, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';

// Nossos Serviços e Models
import { ModeloService } from '../services/modelo.service';
import { MarcaService } from '../services/marca.service';
import { Modelo } from '../models/modelo.models';
import { Marca } from '../models/marca.model';
import { DialogService } from '../services/dialog.service';


import { Router } from '@angular/router';

@Component({
  selector: 'app-modelo',
  standalone: true,
  imports: [
    CommonModule, 
    ReactiveFormsModule
  ],
  templateUrl: './modelo.component.html',
  styleUrl: './modelo.component.css'
})
export class ModeloComponent implements OnInit {
  private modeloService = inject(ModeloService);
  private marcaService = inject(MarcaService);
  private fb = inject(FormBuilder);
  private router = inject(Router);
  private dialogService = inject(DialogService);

  modelos = signal<Modelo[]>([]);
  marcas = signal<Marca[]>([]); 

  totalModelos = signal(0);
  pageSize = 2;
  page = 0;
  nomeBusca = '';
  
  // Controle de Tela (Lista x Formulário)
  isFormVisible = false;

  // Colunas da nossa tabela de Modelos
  colunasExibidas: string[] = ['id', 'numeracao', 'marca', 'acoes'];

  modeloForm = this.fb.group({
    id: [null as number | null],
    numeracao: ['', [Validators.required, Validators.min(1), Validators.maxLength(50)]],
    idMarca: ['', Validators.required]
  });

  async ngOnInit() {
    try {
      !!localStorage.getItem('token');
    } catch (e) {
      // Ignora erro offline
    } finally {
      this.carregarModelos();
      this.carregarMarcas(); 
    }
  }

  carregarModelos() {
    this.modeloService.findAll(this.page, this.pageSize, this.nomeBusca).subscribe({
      next: (dados) => {
        this.modelos.set(dados);
        this.modeloService.count(this.nomeBusca).subscribe({
          next: (total) => this.totalModelos.set(total),
          error: (err) => console.error('Erro ao contar modelos', err)
        });
      },
      error: (err) => console.error('Erro ao carregar modelos', err)
    });
  }

  // --- Métodos de Paginação Customizada ---
  getPageStart(): number {
    if (this.totalModelos() === 0) return 0;
    return this.page * this.pageSize + 1;
  }

  getPageEnd(): number {
    return Math.min((this.page + 1) * this.pageSize, this.totalModelos());
  }

  onPageSizeChange(newSize: string) {
    this.pageSize = Number(newSize);
    this.page = 0;
    this.carregarModelos();
  }

  anteriorPagina() {
    if (this.page > 0) {
      this.page--;
      this.carregarModelos();
    }
  }

  proximaPagina() {
    if ((this.page + 1) * this.pageSize < this.totalModelos()) {
      this.page++;
      this.carregarModelos();
    }
  }

  buscar(texto: string) {
    this.nomeBusca = texto;
    this.page = 0;
    this.carregarModelos();
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
       novoModelo.id = this.modeloForm.value.id;
       this.modeloService.update(novoModelo).subscribe({
         next: () => {
           this.dialogService.showSuccess('Modelo atualizado com sucesso!');
           this.modeloForm.reset();
           this.isFormVisible = false;
           this.carregarModelos();
         },
         error: (err) => {
           console.error('Erro ao atualizar modelo', err);
           alert('Erro ao atualizar. Verifique a conexão.');
         }
       });
    } else {
      this.modeloService.save(novoModelo).subscribe({
        next: () => {
          this.dialogService.showSuccess('Modelo guardado com sucesso!');
          this.modeloForm.reset();
          this.isFormVisible = false;
          this.carregarModelos();
        },
        error: (err) => {
          console.error('Erro ao salvar modelo', err);
          alert('Erro ao guardar. Verifique a conexão.');
        }
      });
    }
  }

  obterMensagemErro(campo: string, nomeCampo: string = 'Campo'): string {
    const controle = this.modeloForm.get(campo);
    if (!controle || !controle.errors) return '';

    if (controle.hasError('required')) return `${nomeCampo} obrigatório.`;
    if (controle.hasError('minlength')) return `Deve ter pelo menos ${controle.getError('minlength').requiredLength} caracteres.`;
    if (controle.hasError('maxlength')) return `Pode ter no máximo ${controle.getError('maxlength').requiredLength} caracteres.`;
    if (controle.hasError('min')) return `O valor mínimo é ${controle.getError('min').min}.`;

    return '';
  }

  voltarParaLista() {
    this.modeloForm.reset();
    this.isFormVisible = false;
  }
  
  novoModelo() {
    this.modeloForm.reset();
    this.isFormVisible = true;
  }

  editar(modelo: Modelo) {
    this.modeloForm.patchValue({
      id: modelo.id ?? null,
      numeracao: modelo.numeracao.toString(),
      idMarca: modelo.idMarca as any
    });
    this.isFormVisible = true;
  }

  excluir(id: number) {
    if (confirm('Tem a certeza que deseja eliminar este modelo?')) {
      this.modeloService.delete(id).subscribe({
        next: () => {
          this.dialogService.showSuccess('Modelo eliminado!');
          this.modeloForm.reset();
          this.carregarModelos();
        },
        error: (err) => {
          if (err.status === 400) {
            // Se o backend enviar um texto no corpo do erro, usamos ele, senão usamos um padrão.
            const msg = (typeof err.error === 'string') ? err.error : 'Não é possível excluir este Modelo, pois existem Fontes vinculadas a ele no catálogo.';
            alert(msg);
          } else {
            alert('Falha interna ao tentar remover o modelo.');
            console.error(err);
          }
        }
      });
    }
  }

  navegarParaHome() {
    this.router.navigate(['/home']);
  }
}