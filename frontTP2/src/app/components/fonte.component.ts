import { Component, OnInit, signal, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';
import { FonteService } from '../services/fonte.service';
import { Fonte } from '../models/fonte.model';
import { KeycloakService } from 'keycloak-angular';
import { MarcaService } from '../services/marca.service';
import { Marca } from '../models/marca.model';
import { MatDialog } from '@angular/material/dialog';
import { ModeloService } from '../services/modelo.service';
import { Modelo } from '../models/modelo.models';
import { CertificacaoDialog } from './certificacao-dialog/certificacao-dialog';

import { MatCardModule } from '@angular/material/card';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatSelectModule } from '@angular/material/select'; 
import { MatButtonModule } from '@angular/material/button';
import { MatTableModule } from '@angular/material/table';
import { MatIconModule } from '@angular/material/icon';

@Component({
  selector: 'app-fonte',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule, MatCardModule, MatFormFieldModule, MatInputModule, MatSelectModule, MatButtonModule, MatTableModule, MatIconModule],
  templateUrl: './fonte.component.html',
  styleUrl: './fonte.component.css'
})
export class FonteComponent implements OnInit {
  private modeloService = inject(ModeloService);
  private dialog = inject(MatDialog);
  private fonteService = inject(FonteService);
  private marcaService = inject(MarcaService);
  private fb = inject(FormBuilder);
  private keycloak = inject(KeycloakService);

  coluna: string[] = ['id', 'nome', 'potencia', 'preco', 'marca', 'acoes'];

  fontes = signal<Fonte[]>([]);
  marcas = signal<Marca[]>([]);
  modelos = signal<Modelo[]>([]);

  fonteForm = this.fb.group({
    id: [null as number | null],
    nome: ['', Validators.required],
    potencia: ['', Validators.required],
    preco: ['', Validators.required],
    idMarca: [''], 
    idModelo: [''],
    certificacaoNome: [{value: '', disabled: true}, Validators.required],
    certificacao: ['', Validators.required]
  });

  async ngOnInit() {
    console.log("Tela fontes abriu! ");
    try {
      this.keycloak.isLoggedIn();
    } catch (e) {
      console.log("Erro ao carregar fontes", e);
    } finally {
      this.carregarFontes();
      this.carregarMarcasParaOSelect();
      this.carregarModelosParaOSelect();
    }
  }

  carregarFontes() {
    this.fonteService.findAll().subscribe({
      next: (dados) => this.fontes.set(dados),
      error: (err) => console.error('Erro ao carregar fontes', err)
    });
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
        certificacao: this.fonteForm.value.certificacao
    } as Fonte;

    // 3. A Bifurcação: Atualizar ou Criar?
    if (idAtual) {
      // TEM ID: Vamos chamar o método de atualizar
      this.fonteService.update(fontePronta).subscribe({
        next: () => {
          alert('Fonte atualizada com sucesso!');
          this.resetForm(); // Usamos o cancelar para limpar tudo direitinho
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
      certificacaoNome: nomeCert,
      certificacao: nomeCert ? nomeCert.replace('80 Plus ', '').toUpperCase() : ''
    });
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
}