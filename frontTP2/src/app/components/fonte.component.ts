import { Component, OnInit, signal, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';
import { FonteService } from '../services/fonte.service';
import { Fonte } from '../models/fonte.model';

import { MarcaService } from '../services/marca.service';
import { Marca } from '../models/marca.model';
import { MatDialog } from '@angular/material/dialog';
import { ModeloService } from '../services/modelo.service';
import { Modelo } from '../models/modelo.models';
import { FornecedorService } from '../services/fornecedor.service';
import { Fornecedor } from '../models/fornecedor.model';
import { CertificacaoDialog } from './certificacao-dialog/certificacao-dialog';

import { MatCardModule } from '@angular/material/card';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatSelectModule } from '@angular/material/select'; 
import { MatButtonModule } from '@angular/material/button';
import { MatTableModule } from '@angular/material/table';
import { MatIconModule } from '@angular/material/icon'; 
import { MatPaginatorIntl, MatPaginatorModule, PageEvent } from '@angular/material/paginator';
import { PaginatorIntlPtBr } from '../paginator-ptbr';
import { Router } from '@angular/router';
@Component({
  selector: 'app-fonte',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule, MatCardModule, MatFormFieldModule, MatInputModule, MatSelectModule, MatButtonModule, MatTableModule, MatIconModule, MatPaginatorModule],
  templateUrl: './fonte.component.html',
  styleUrl: './fonte.component.css',
  providers: [{ provide: MatPaginatorIntl, useClass: PaginatorIntlPtBr }]
})
export class FonteComponent implements OnInit {
  private modeloService = inject(ModeloService);
  private dialog = inject(MatDialog);
  private fonteService = inject(FonteService);
  private marcaService = inject(MarcaService);
  private fornecedorService = inject(FornecedorService);
  private fb = inject(FormBuilder);

  private router = inject(Router);

  coluna: string[] = ['id', 'nome', 'potencia', 'preco', 'marca', 'acoes'];
  
  // Controle de Tela (Lista x Formulário)
  isFormVisible = false;

  // --- Configuração da Paginação ---
  totalFontes = signal(0); // Quantidade total de itens no servidor
  pageSize = 2; // Quantos itens por página (pode mudar conforme o backend)
  page = 0; // Começamos na página 0 (a primeira)
  nomeBusca = ''; // O texto que o usuário digita

  fontes = signal<Fonte[]>([]);
  marcas = signal<Marca[]>([]);
  modelos = signal<Modelo[]>([]);
  fornecedores = signal<Fornecedor[]>([]);

  fonteForm = this.fb.group({
    id: [null as number | null],
    nome: ['', [Validators.required, Validators.maxLength(100)]],
    potencia: ['', [Validators.required, Validators.maxLength(5)]],
    preco: ['', [Validators.required, Validators.maxLength(10)]],
    idMarca: [''], 
    idModelo: [''],
    idFornecedores: [[] as number[]],
    certificacaoNome: [{value: '', disabled: true}, Validators.required],
    certificacao: ['', Validators.required]
  });

  async ngOnInit() {
    console.log("Tela fontes abriu! ");
    try {
      !!localStorage.getItem('token');
    } catch (e) {
      console.log("Erro ao carregar fontes", e);
    } finally {
      this.carregarFontes();
      this.carregarMarcasParaOSelect();
      this.carregarModelosParaOSelect();
      this.carregarFornecedoresParaOSelect();
    }
  }

  carregarFontes() {
    // 1. Chamamos o serviço passando os parâmetros de paginação
    this.fonteService.findAll(this.page, this.pageSize, this.nomeBusca).subscribe({
      next: (dados) => {
        this.fontes.set(dados);
        
        // 2. Chamamos o serviço de contagem para saber o total
        this.fonteService.count(this.nomeBusca).subscribe({
          next: (total) => {
            this.totalFontes.set(total);
          },
          error: (err) => console.error('Erro ao contar fontes', err)
        });
      },
      error: (err) => console.error('Erro ao carregar fontes', err)
    });
  }

  // --- Método para lidar com a mudança de página ---
  paginar(event: PageEvent): void{
    // event.pageIndex é o número da página (0, 1, 2...)
    this.page = event.pageIndex;
    // event.pageSize é o tamanho da página (2, 5, 10...)
    this.pageSize = event.pageSize;
    // Recarrega os dados com a nova página
    this.carregarFontes();
  }

  // --- Método para buscar ---
  buscar(texto: string) {
    this.nomeBusca = texto;
    this.page = 0; // Sempre volta para a primeira página ao buscar
    this.carregarFontes();
  }
  carregarMarcasParaOSelect() {
    console.log("Carregando marcas...");

      this.marcaService.findAll().subscribe({
        next: (dados) => {
        console.log("Marcas carregadas com sucesso!", dados),
        this.marcas.set(dados);
      },
        error: (err) => {
          console.error('Erro ao carregar marcas', err)
    }
      });
    }

  carregarModelosParaOSelect() {
    console.log("Carregando modelos...");

      this.modeloService.findAll().subscribe({
        next: (dados) => {
        console.log("Modelos carregados com sucesso!", dados),
        this.modelos.set(dados);
      },
        error: (err) => {
          console.error('Erro ao carregar modelos', err)
    }
      });
    }

  carregarFornecedoresParaOSelect() {
      this.fornecedorService.findAll().subscribe({
        next: (dados) => {
        this.fornecedores.set(dados);
      },
        error: (err) => {
          console.error('Erro ao carregar fornecedores', err)
    }
      });
    }

 salvar() {
    if (this.fonteForm.invalid) return;
    
    // 1. Verificamos se há um ID preenchido no formulário 
    const idAtual = this.fonteForm.value.id;
    
    // 2. Montamos o pacote.
    const fontePronta = {
        id: idAtual, // <-- Se for novo vai nulo, se for edição vai com o número!
        nome: this.fonteForm.value.nome,
        potencia: Number(this.fonteForm.value.potencia),
        preco: Number(this.fonteForm.value.preco),
        idMarca: Number(this.fonteForm.value.idMarca),
        idModelo: Number(this.fonteForm.value.idModelo),
        idFornecedores: this.fonteForm.value.idFornecedores || [],
        certificacao: this.fonteForm.value.certificacao
    } as Fonte;

    // 3. A Bifurcação: Atualizar ou Criar?
    if (idAtual) {
      // TEM ID: Vamos chamar o método de atualizar
      this.fonteService.update(fontePronta).subscribe({
        next: () => {
          alert('Fonte atualizada com sucesso!');
          this.resetForm(); // Usamos o cancelar para limpar tudo direitinho
          this.isFormVisible = false;
          this.carregarFontes();
        },
        error: (err) => {
          console.error('Erro ao atualizar fonte', err);
          alert('Erro ao atualizar. Verifique o F12.');
        }
      });
    } else {
      // NÃO TEM ID: É uma fonte nova 
      this.fonteService.save(fontePronta).subscribe({
        next: () => {
          alert('Fonte guardada com sucesso!');
          this.resetForm(); 
          this.isFormVisible = false;
          this.carregarFontes();
        },
        error: (err) => {
          console.error('Erro ao salvar fonte', err);
          alert('Erro ao guardar fonte. Verifique o F12.');
        }
      });
    }
  }
  editar(fonte: any) {
    // Pegamos o nome da certificação quer venha como objeto ou como texto
    const nomeCert = fonte.certificacao?.fontcert || fonte.certificacao;

    // Colamos os dados no formulário! 
    this.fonteForm.patchValue({
      ...fonte,    
      idModelo: fonte.idModelo, 
      idFornecedores: fonte.idFornecedores || [],
      certificacaoNome: nomeCert,
      certificacao: nomeCert ? nomeCert.replace('80 Plus ', '').toUpperCase() : ''
    });
    
    // Mostra o formulário
    this.isFormVisible = true;
  }

  novaFonte() {
    this.resetForm();
    this.isFormVisible = true;
  }

  voltarParaLista() {
    this.isFormVisible = false;
  }

  excluir(id: number | undefined) {
    if (!id) return; // Segurança extra caso o ID venha vazio
    
    if (confirm('Tem a certeza que deseja eliminar esta fonte?')) {
      this.fonteService.delete(id).subscribe({
        next: () => {
          alert('Fonte eliminada com sucesso!');
          this.resetForm();
          this.carregarFontes();
        },
        error: (err) => {
          console.error('Erro ao excluir', err);
          alert('Erro ao excluir a fonte.');
        }
      });
    }
  }

  obterMensagemErro(campo: string, nomeCampo: string = 'Campo'): string {
    const controle = this.fonteForm.get(campo);
    if (!controle || !controle.errors) return '';

    if (controle.hasError('required')) return `${nomeCampo} obrigatório.`;
    if (controle.hasError('minlength')) return `Deve ter pelo menos ${controle.getError('minlength').requiredLength} caracteres.`;
    if (controle.hasError('maxlength')) return `Pode ter no máximo ${controle.getError('maxlength').requiredLength} caracteres.`;
    if (controle.hasError('min')) return `O valor mínimo é ${controle.getError('min').min}.`;

    return '';
  }

  resetForm() {
    this.fonteForm.reset();
  }
  abrirDialogCertificacao() {
    // 1. Mandamos o Angular abrir o nosso componente flutuante
    const dialogRef = this.dialog.open(CertificacaoDialog, {
      width: '400px' // Um tamanho bacana para não ficar gigante
    });

    // 2. Ficamos "à escuta" do momento em que o Dialog for fechado
    dialogRef.afterClosed().subscribe(resultado => {
      // Se o utilizador escolheu uma opção (não clicou em Cancelar)
      if (resultado) {
        const valorParaOjava = resultado.fontcert.replace('80 Plus ', '').toUpperCase();
        // Atualizamos o nosso formulário com a escolha dele!
        this.fonteForm.patchValue({
          certificacaoNome: resultado.fontcert, // Ex: "80 Plus Bronze"
          certificacao: valorParaOjava        // Ex: 1
        });
      }
    });
  }

  navegarParaHome() {
    this.router.navigate(['/home']);
  }
}