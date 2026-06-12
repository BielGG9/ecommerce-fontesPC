import { Component, OnInit, inject, ChangeDetectorRef } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormBuilder, FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';
import { CartaoService, Cartao } from '../../../services/cartao.service';
import { ClienteService } from '../../../services/cliente.service';
import { Cliente } from '../../../models/cliente.model';
import { RouterModule } from '@angular/router';
import { DialogService } from '../../../services/dialog.service';

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
  dialogService = inject(DialogService);
  cdr = inject(ChangeDetectorRef);

  cliente: Cliente | null = null;
  cartoes: Cartao[] = [];

  formGroup!: FormGroup;
  isFormVisible = false;
  editingId: number | null = null;

  ngOnInit() {
    this.initForm();
    this.carregarDados();
  }

  initForm() {
    this.formGroup = this.fb.group({
      numeroCartao: ['', [Validators.required, Validators.pattern('^[0-9]{16}$')]],
      nomeImpresso: ['', Validators.required],
      validadeCartao: ['', [Validators.required, Validators.pattern('^(0[1-9]|1[0-2])\\/[0-9]{2}$')]],
      cvv: ['', [Validators.required, Validators.pattern('^[0-9]{3,4}$')]]
    });
  }

  carregarDados() {
    this.clienteService.getMeuPerfil().subscribe({
      next: (dados) => {
        this.cliente = dados;
        this.cdr.detectChanges();
      },
      error: (err) => console.error(err)
    });

    this.cartaoService.findAll().subscribe({
      next: (cartoes) => {
        this.cartoes = cartoes || [];
        this.cdr.detectChanges();
      },
      error: (err) => console.error('Erro ao carregar cartões:', err)
    });
  }

  novoCartao() {
    this.isFormVisible = true;
    this.editingId = null;
    this.formGroup.reset();
    this.formGroup.get('numeroCartao')?.enable();
  }

  editarCartao(cartao: Cartao) {
    this.isFormVisible = true;
    this.editingId = cartao.id ?? null;
    this.formGroup.patchValue({
      numeroCartao: cartao.numeroCartao,
      nomeImpresso: cartao.nomeImpresso,
      validadeCartao: cartao.validadeCartao,
      cvv: cartao.cvv
    });
    this.formGroup.get('numeroCartao')?.disable();
  }

  cancelar() {
    this.isFormVisible = false;
    this.editingId = null;
    this.formGroup.reset();
    this.formGroup.get('numeroCartao')?.enable();
  }

  salvar() {
    if (this.formGroup.invalid) return;

    const request = this.formGroup.getRawValue();

    if (this.editingId) {
      this.cartaoService.update(this.editingId, request).subscribe({
        next: () => {
          this.dialogService.showSuccess('Cartão atualizado com sucesso!');
          this.cancelar();
          this.carregarDados();
        },
        error: (err) => alert('Erro: ' + (err.error || err.message))
      });
    } else {
      this.cartaoService.create(request).subscribe({
        next: () => {
          this.dialogService.showSuccess('Cartão adicionado com sucesso!');
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
          this.dialogService.showSuccess('Cartão excluído!');
          this.carregarDados();
        },
        error: (err) => alert('Erro: ' + (err.error || err.message))
      });
    }
  }

  apenasNumeros(event: KeyboardEvent): boolean {
    const charCode = event.which || event.keyCode;
    if (charCode < 48 || charCode > 57) {
      event.preventDefault();
      return false;
    }
    return true;
  }

  formatarValidade(event: Event): void {
    const input = event.target as HTMLInputElement;
    let value = input.value.replace(/\D/g, '');
    if (value.length >= 3) {
      value = value.substring(0, 2) + '/' + value.substring(2, 4);
    }
    input.value = value;
    this.formGroup.get('validadeCartao')?.setValue(value, { emitEvent: false });
  }
}
