import { Component, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormBuilder, FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';
import { CartaoService } from '../../../services/cartao.service';
import { ClienteService } from '../../../services/cliente.service';
import { Cliente } from '../../../models/cliente.model';
import { RouterModule } from '@angular/router';

@Component({
  selector: 'app-perfil-cartoes',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule, RouterModule],
  templateUrl: './cartoes.component.html',
  styleUrls: ['./cartoes.component.css']
})
export class CartoesComponent implements OnInit {
  cartaoService = inject(CartaoService);
  clienteService = inject(ClienteService);
  fb = inject(FormBuilder);

  cliente: Cliente | null = null;
  cartoes: any[] = []; 
  
  formGroup!: FormGroup;
  isFormVisible = false;
  editingId: number | null = null;

  ngOnInit() {
    this.initForm();
    this.carregarDados();
  }

  initForm() {
    this.formGroup = this.fb.group({
      numero: ['', Validators.required],
      nomeImpresso: ['', Validators.required],
      bandeira: ['', Validators.required],
      cpfCnpj: ['', Validators.required]
    });
  }

  carregarDados() {
    this.clienteService.getMeuPerfil().subscribe({
      next: (dados) => {
        this.cliente = dados;
        this.cartoes = dados.cartoes || []; // Depende de como o back mapeia
      },
      error: (err) => console.error(err)
    });
  }

  novoCartao() {
    this.isFormVisible = true;
    this.editingId = null;
    this.formGroup.reset();
  }

  editarCartao(cartao: any) {
    this.isFormVisible = true;
    this.editingId = cartao.id;
    this.formGroup.patchValue({
      numero: cartao.numero,
      nomeImpresso: cartao.nomeImpresso,
      bandeira: cartao.bandeira,
      cpfCnpj: cartao.cpfCnpj
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
      this.cartaoService.update(this.editingId, request).subscribe({
        next: () => {
          alert('Cartão atualizado com sucesso!');
          this.cancelar();
          this.carregarDados();
        },
        error: (err) => alert('Erro: ' + (err.error || err.message))
      });
    } else {
      this.cartaoService.create(request).subscribe({
        next: () => {
          alert('Cartão adicionado com sucesso!');
          this.cancelar();
          this.carregarDados();
        },
        error: (err) => alert('Erro: ' + (err.error || err.message))
      });
    }
  }

  excluirCartao(id: number) {
    if (confirm('Tem certeza que deseja excluir este cartão?')) {
      this.cartaoService.delete(id).subscribe({
        next: () => {
          alert('Cartão excluído!');
          this.carregarDados();
        },
        error: (err) => alert('Erro: ' + (err.error || err.message))
      });
    }
  }
}
