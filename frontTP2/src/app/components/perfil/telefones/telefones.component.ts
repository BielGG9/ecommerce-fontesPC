import { Component, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormBuilder, FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';
import { TelefoneService } from '../../../services/telefone.service';
import { ClienteService } from '../../../services/cliente.service';
import { Cliente } from '../../../models/cliente.model';
import { RouterModule } from '@angular/router';

@Component({
  selector: 'app-perfil-telefones',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule, RouterModule],
  templateUrl: './telefones.component.html',
  styleUrls: ['./telefones.component.css']
})
export class TelefonesComponent implements OnInit {
  telefoneService = inject(TelefoneService);
  clienteService = inject(ClienteService);
  fb = inject(FormBuilder);

  cliente: Cliente | null = null;
  telefones: any[] = []; 
  
  formGroup!: FormGroup;
  isFormVisible = false;
  editingId: number | null = null;

  ngOnInit() {
    this.initForm();
    this.carregarDados();
  }

  initForm() {
    this.formGroup = this.fb.group({
      ddd: ['', [Validators.required, Validators.maxLength(2)]],
      numero: ['', Validators.required]
    });
  }

  carregarDados() {
    this.clienteService.getMeuPerfil().subscribe({
      next: (dados) => {
        this.cliente = dados;
        // Asuming the backend returns telefones nested
        this.telefones = dados.telefones || [];
      },
      error: (err) => console.error(err)
    });
  }

  novoTelefone() {
    this.isFormVisible = true;
    this.editingId = null;
    this.formGroup.reset();
  }

  editarTelefone(tel: any) {
    this.isFormVisible = true;
    this.editingId = tel.id;
    this.formGroup.patchValue({
      ddd: tel.ddd,
      numero: tel.numero
    });
  }

  cancelar() {
    this.isFormVisible = false;
    this.editingId = null;
    this.formGroup.reset();
  }

  salvar() {
    if (this.formGroup.invalid || !this.cliente) return;

    const request = {
      ...this.formGroup.value,
      idPessoa: this.cliente.id
    };

    if (this.editingId) {
      this.telefoneService.update(this.editingId, request).subscribe({
        next: () => {
          alert('Telefone atualizado!');
          this.cancelar();
          this.carregarDados();
        },
        error: (err) => alert('Erro: ' + (err.error || err.message))
      });
    } else {
      this.telefoneService.create(request).subscribe({
        next: () => {
          alert('Telefone adicionado!');
          this.cancelar();
          this.carregarDados();
        },
        error: (err) => alert('Erro: ' + (err.error || err.message))
      });
    }
  }

  excluirTelefone(id: number) {
    if (confirm('Deseja excluir este telefone?')) {
      this.telefoneService.delete(id).subscribe({
        next: () => {
          alert('Telefone excluído!');
          this.carregarDados();
        },
        error: (err) => alert('Erro: ' + (err.error || err.message))
      });
    }
  }
}
