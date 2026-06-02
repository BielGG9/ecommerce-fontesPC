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
import { DialogService } from '../../services/dialog.service';
import { CupomService, CupomResponse } from '../../services/cupom.service';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatButtonModule } from '@angular/material/button';

@Component({
  selector: 'app-checkout',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule, RouterModule, MatFormFieldModule, MatInputModule, MatButtonModule],
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
  dialogService = inject(DialogService);

  checkoutForm!: FormGroup;
  processando = signal(false);
  idPessoa: number | null = null;
  nomePessoa: string = '';
  meusEnderecos: Endereco[] = [];
  selectedEnderecoId: number | null = null;
  adicionandoNovoEndereco: boolean = false;
  cupomService = inject(CupomService);

  cupomAplicado: CupomResponse | null = null;
  erroCupom: string | null = null;
  totalComDesconto: number = 0;

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
        
        // Carrega os endereços do cliente logado
        this.enderecoService.getMeusEnderecos().subscribe({
          next: (enderecos) => {
            this.meusEnderecos = enderecos;
            this.adicionandoNovoEndereco = enderecos.length === 0;
            if (enderecos.length > 0) {
              this.selectedEnderecoId = enderecos[0].id || null;
            }
            this.updateEnderecoValidators();
          },
          error: (err) => {
            console.error('Erro ao buscar endereços:', err);
            this.adicionandoNovoEndereco = true;
            this.updateEnderecoValidators();
          }
        });
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
      cvv: [''],
      cupom: ['']
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

    if (this.selectedEnderecoId !== null) {
      // usa endereço existente — NÃO chama enderecoService.create()
      this.criarPedido(this.selectedEnderecoId, formValue);
    } else {
      // cria novo endereço e usa o id retornado
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
  }

  selecionarEndereco(id: number): void {
    this.selectedEnderecoId = id;
    this.adicionandoNovoEndereco = false;
    this.updateEnderecoValidators();
  }

  selecionarNovoEndereco(): void {
    this.selectedEnderecoId = null;
    this.adicionandoNovoEndereco = true;
    this.updateEnderecoValidators();
  }

  updateEnderecoValidators(): void {
    const fields = ['rua', 'numero', 'bairro', 'cidade', 'estado', 'cep'];
    fields.forEach(field => {
      const control = this.checkoutForm.get(field);
      if (this.adicionandoNovoEndereco) {
        control?.setValidators(Validators.required);
      } else {
        control?.clearValidators();
      }
      control?.updateValueAndValidity();
    });
  }

  calcularTotal(): number {
    return this.carrinhoService.valorTotal();
  }

  aplicarCupom(): void {
    const codigo = this.checkoutForm.get('cupom')?.value;
    if (!codigo) return;
    this.cupomService.validarCupom(codigo).subscribe({
      next: (cupom) => {
        if (cupom.valido) {
          this.cupomAplicado = cupom;
          this.erroCupom = null;
          this.totalComDesconto = this.calcularTotal() * (1 - cupom.porcentagem! / 100);
        } else {
          this.erroCupom = 'Cupom inválido ou expirado.';
          this.cupomAplicado = null;
          this.totalComDesconto = this.calcularTotal();
        }
      },
      error: () => {
        this.erroCupom = 'Erro ao validar cupom.';
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
      pagamento: formValue.pagamento,
      cupom: this.cupomAplicado?.codigo ?? null
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
        this.dialogService.showSuccess('Pedido realizado com sucesso!');
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
