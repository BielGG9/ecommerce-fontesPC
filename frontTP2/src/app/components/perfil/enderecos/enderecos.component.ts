import { Component, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormBuilder, FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';
import { EnderecoService } from '../../../services/endereco.service';
import { ClienteService } from '../../../services/cliente.service';
import { Cliente } from '../../../models/cliente.model';
import { RouterModule } from '@angular/router';

@Component({
  selector: 'app-perfil-enderecos',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule, RouterModule],
  templateUrl: './enderecos.component.html',
  styleUrls: ['./enderecos.component.css']
})
export class EnderecosComponent implements OnInit {
  enderecoService = inject(EnderecoService);
  clienteService = inject(ClienteService);
  fb = inject(FormBuilder);

  cliente: Cliente | null = null;
  enderecos: any[] = []; // Assuming we get a list from cliente.enderecos or similar
  
  formGroup!: FormGroup;
  isFormVisible = false;
  editingId: number | null = null;

  ngOnInit() {
    this.initForm();
    this.carregarDados();
  }

  initForm() {
    this.formGroup = this.fb.group({
      cep: ['', Validators.required],
      logradouro: ['', Validators.required],
      numero: ['', Validators.required],
      bairro: ['', Validators.required],
      cidade: ['', Validators.required],
      estado: ['', Validators.required],
      complemento: ['']
    });
  }

  carregarDados() {
    this.clienteService.getMeuPerfil().subscribe({
      next: (dados) => {
        this.cliente = dados;
        // Se a API retornar os endereços aninhados no cliente:
        this.enderecos = dados.enderecos || [];
        
        // Caso a API não retorne aninhado, teríamos que buscar e filtrar. Mas vamos assumir que o Quarkus mapeou @OneToMany
      },
      error: (err) => console.error(err)
    });
  }

  novoEndereco() {
    this.isFormVisible = true;
    this.editingId = null;
    this.formGroup.reset();
  }

  editarEndereco(end: any) {
    this.isFormVisible = true;
    this.editingId = end.id;
    this.formGroup.patchValue({
      cep: end.cep,
      logradouro: end.logradouro,
      numero: end.numero,
      bairro: end.bairro,
      cidade: end.cidade,
      estado: end.estado,
      complemento: end.complemento
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
      this.enderecoService.update(this.editingId, request).subscribe({
        next: () => {
          alert('Endereço atualizado com sucesso!');
          this.cancelar();
          this.carregarDados();
        },
        error: (err) => {
          alert('Erro ao atualizar: ' + (err.error || err.message));
        }
      });
    } else {
      this.enderecoService.create(request).subscribe({
        next: () => {
          alert('Endereço adicionado com sucesso!');
          this.cancelar();
          this.carregarDados();
        },
        error: (err) => {
          alert('Erro ao criar: ' + (err.error || err.message));
        }
      });
    }
  }

  excluirEndereco(id: number) {
    if (confirm('Tem certeza que deseja excluir este endereço?')) {
      this.enderecoService.delete(id).subscribe({
        next: () => {
          alert('Endereço excluído!');
          this.carregarDados();
        },
        error: (err) => alert('Erro ao excluir: ' + (err.error || err.message))
      });
    }
  }
}
