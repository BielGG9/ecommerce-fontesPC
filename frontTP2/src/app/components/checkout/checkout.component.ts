import { Component, inject, signal, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormBuilder, FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';
import { Router, RouterModule } from '@angular/router';
import { CarrinhoService } from '../../services/carrinho.service';
import { PedidoService } from '../../services/pedido.service';
import { EnderecoService } from '../../services/endereco.service';
import { ClienteService } from '../../services/cliente.service';
import { PedidoRequest } from '../../models/pedido-request.model';
import { Endereco } from '../../models/endereco.model';

@Component({
  selector: 'app-checkout',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule, RouterModule],
  templateUrl: './checkout.component.html',
  styleUrl: './checkout.component.css'
})
export class CheckoutComponent implements OnInit {
  carrinhoService = inject(CarrinhoService);
  pedidoService = inject(PedidoService);
  enderecoService = inject(EnderecoService);
  clienteService = inject(ClienteService);
  fb = inject(FormBuilder);
  router = inject(Router);

  checkoutForm!: FormGroup;
  processando = signal(false);
  idPessoa: number | null = null;
  nomePessoa: string = '';

  ngOnInit() {
    if (this.carrinhoService.itens().length === 0) {
      this.router.navigate(['/']);
      return;
    }

    this.clienteService.getMeuPerfil().subscribe({
      next: (perfil) => {
        this.idPessoa = perfil.id || null;
        this.nomePessoa = perfil.nome;
        this.checkoutForm.patchValue({ nomeCliente: perfil.nome });
      },
      error: (err) => {
        console.error('Erro ao buscar perfil:', err);
        if (err.status === 404) {
          alert('O seu cadastro de cliente não foi encontrado no banco de dados local! Isso acontece porque ao reiniciar o backend (em modo dev), o banco é apagado, mas o Keycloak mantém o login. Por favor, crie uma nova conta com outro e-mail para prosseguir.');
          localStorage.removeItem('token');
          window.location.href = '/login';
        }
      }
    });

    this.checkoutForm = this.fb.group({
      nomeCliente: ['', Validators.required],
      rua: ['', Validators.required],
      numero: ['', Validators.required],
      complemento: [''],
      bairro: ['', Validators.required],
      cidade: ['', Validators.required],
      estado: ['', Validators.required],
      cep: ['', Validators.required],
      pagamento: ['pix', Validators.required],
      nomeImpresso: [''],
      numeroCartao: [''],
      validadeCartao: [''],
      cvv: ['']
    });

    this.checkoutForm.get('pagamento')?.valueChanges.subscribe(value => {
      const isCartao = value === 'cartao';
      const cartaoControls = ['nomeImpresso', 'numeroCartao', 'validadeCartao', 'cvv'];
      
      cartaoControls.forEach(ctrl => {
        const control = this.checkoutForm.get(ctrl);
        if (isCartao) {
          control?.setValidators(Validators.required);
        } else {
          control?.clearValidators();
        }
        control?.updateValueAndValidity();
      });
    });
  }

  finalizarPedido() {
    if (this.checkoutForm.invalid) {
      this.checkoutForm.markAllAsTouched();
      return;
    }

    if (!this.idPessoa) {
      alert('Não foi possível identificar o usuário logado. Por favor, faça login novamente.');
      return;
    }

    this.processando.set(true);
    const formValue = this.checkoutForm.value;

    const endereco: Endereco = {
      rua: formValue.rua,
      numero: formValue.numero,
      complemento: formValue.complemento,
      bairro: formValue.bairro,
      cidade: formValue.cidade,
      estado: formValue.estado,
      cep: formValue.cep,
      idPessoa: this.idPessoa
    };

    this.enderecoService.create(endereco).subscribe({
      next: (endCriado) => {
        this.criarPedido(endCriado.id!, formValue);
      },
      error: (err) => {
        console.error('Erro ao criar endereço', err);
        const backendMsg = err.error ? (typeof err.error === 'string' ? err.error : JSON.stringify(err.error)) : '';
        alert('Erro ao processar o endereço: ' + backendMsg);
        this.processando.set(false);
      }
    });
  }

  private criarPedido(idEndereco: number, formValue: any) {
    const itensPedido = this.carrinhoService.itens().map(i => ({
      quantidade: i.quantidade,
      fonteId: i.fonte!.id!
    }));

    const pedidoRequest: PedidoRequest = {
      nomeCliente: formValue.nomeCliente,
      idEnderecoEntrega: idEndereco,
      itensPedido: itensPedido,
      pagamento: formValue.pagamento
    };

    if (formValue.pagamento === 'cartao') {
      pedidoRequest.novoCartao = {
        nomeImpresso: formValue.nomeImpresso,
        numeroCartao: formValue.numeroCartao,
        validadeCartao: formValue.validadeCartao,
        cvv: formValue.cvv
      };
    }

    this.pedidoService.create(pedidoRequest).subscribe({
      next: (pedido) => {
        alert('Pedido realizado com sucesso!');
        this.carrinhoService.limparCarrinho();
        this.router.navigate(['/']);
      },
      error: (err) => {
        console.error('Erro ao criar pedido', err);
        const backendMsg = err.error ? (typeof err.error === 'string' ? err.error : JSON.stringify(err.error)) : '';
        alert('Erro ao finalizar o pedido: ' + backendMsg);
        this.processando.set(false);
      }
    });
  }
}
