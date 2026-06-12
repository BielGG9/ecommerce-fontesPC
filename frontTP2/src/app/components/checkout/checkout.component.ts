import { Component, inject, signal, OnInit, ChangeDetectorRef } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormBuilder, FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';
import { Router, RouterModule } from '@angular/router';
import { CarrinhoService } from '../../services/carrinho.service';
import { PedidoService } from '../../services/pedido.service';
import { EnderecoService } from '../../services/endereco.service';
import { ClienteService } from '../../services/cliente.service';
import { CartaoService, Cartao } from '../../services/cartao.service';
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
  cartaoService = inject(CartaoService);
  fb = inject(FormBuilder);
  router = inject(Router);
  dialogService = inject(DialogService);
  cdr = inject(ChangeDetectorRef);

  checkoutForm!: FormGroup;
  processando = signal(false);
  idPessoa: number | null = null;
  nomePessoa: string = '';
  meusEnderecos: Endereco[] = [];
  selectedEnderecoId: number | null = null;
  adicionandoNovoEndereco: boolean = false;
  enderecoSendoEditadoId: number | null = null;

  meusCartoes: Cartao[] = [];
  selectedCartaoId: number | null = null;
  adicionandoNovoCartao: boolean = false;
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
            this.cdr.detectChanges();
          },
          error: (err) => {
            console.error('Erro ao buscar endereços:', err);
            this.adicionandoNovoEndereco = true;
            this.updateEnderecoValidators();
            this.cdr.detectChanges();
          }
        });

        // Carrega os cartões salvos do cliente
        this.cartaoService.findAll().subscribe({
          next: (cartoes) => {
            this.meusCartoes = cartoes;
            if (cartoes.length > 0) {
              this.selectedCartaoId = cartoes[0].id || null;
              this.adicionandoNovoCartao = false;
            } else {
              this.adicionandoNovoCartao = true;
            }
            this.atualizarValidadoresCartao();
            this.cdr.detectChanges();
          },
          error: () => {
            this.adicionandoNovoCartao = true;
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
      cupom: [''],
      salvarEndereco: [true],
      salvarCartao: [true]
    });

    this.checkoutForm.get('pagamento')?.valueChanges.subscribe(value => {
      this.atualizarValidadoresCartao(value);
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
      // cria novo endereço ou atualiza o endereço existente e usa o id retornado
      const salvarEndereco: boolean = this.checkoutForm.get('salvarEndereco')?.value ?? true;
      const endereco: Endereco = {
        rua: formValue.rua,
        numero: formValue.numero,
        complemento: formValue.complemento,
        bairro: formValue.bairro,
        cidade: formValue.cidade,
        estado: formValue.estado,
        cep: formValue.cep,
        idPessoa: this.idPessoa,
        salvo: salvarEndereco
      };

      if (this.enderecoSendoEditadoId) {
        endereco.id = this.enderecoSendoEditadoId;
        this.enderecoService.update(this.enderecoSendoEditadoId, endereco).subscribe({
          next: (endAtualizado) => {
            this.criarPedido(endAtualizado.id!, formValue);
          },
          error: (err) => {
            console.error('Erro ao atualizar endereço', err);
            const backendMsg = err.error ? (typeof err.error === 'string' ? err.error : JSON.stringify(err.error)) : '';
            alert('Erro ao atualizar o endereço: ' + backendMsg);
            this.processando.set(false);
          }
        });
      } else {
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
  }

  selecionarEndereco(id: number): void {
    this.selectedEnderecoId = id;
    this.adicionandoNovoEndereco = false;
    this.enderecoSendoEditadoId = null;
    this.updateEnderecoValidators();
  }

  selecionarNovoEndereco(): void {
    this.selectedEnderecoId = null;
    this.adicionandoNovoEndereco = true;
    this.enderecoSendoEditadoId = null;
    
    this.checkoutForm.patchValue({
      rua: '',
      numero: '',
      complemento: '',
      bairro: '',
      cidade: '',
      estado: '',
      cep: ''
    });
    this.updateEnderecoValidators();
  }

  editarEndereco(event: Event, endereco: Endereco): void {
    event.stopPropagation();
    this.selectedEnderecoId = null;
    this.adicionandoNovoEndereco = true;
    this.enderecoSendoEditadoId = endereco.id!;
    
    this.checkoutForm.patchValue({
      rua: endereco.rua,
      numero: endereco.numero,
      complemento: endereco.complemento,
      bairro: endereco.bairro,
      cidade: endereco.cidade,
      estado: endereco.estado,
      cep: endereco.cep
    });
    this.updateEnderecoValidators();
  }

  selecionarCartao(id: number): void {
    this.selectedCartaoId = id;
    this.adicionandoNovoCartao = false;
    this.atualizarValidadoresCartao();
  }

  selecionarNovoCartao(): void {
    this.selectedCartaoId = null;
    this.adicionandoNovoCartao = true;
    this.checkoutForm.patchValue({ nomeImpresso: '', numeroCartao: '', validadeCartao: '', cvv: '' });
    this.atualizarValidadoresCartao();
  }

  atualizarValidadoresCartao(pagamento?: string): void {
    const tipoPagamento = pagamento ?? this.checkoutForm.get('pagamento')?.value;
    const precisaDigitarCartao = tipoPagamento === 'cartao' && this.adicionandoNovoCartao;

    const controlNome = this.checkoutForm.get('nomeImpresso');
    const controlNumero = this.checkoutForm.get('numeroCartao');
    const controlValidade = this.checkoutForm.get('validadeCartao');
    const controlCvv = this.checkoutForm.get('cvv');

    if (precisaDigitarCartao) {
      controlNome?.setValidators(Validators.required);
      controlNumero?.setValidators([Validators.required, Validators.pattern('^[0-9]{16}$')]);
      controlValidade?.setValidators(Validators.required);
      controlCvv?.setValidators([Validators.required, Validators.pattern('^[0-9]{3,4}$')]);
    } else {
      controlNome?.clearValidators();
      controlNumero?.clearValidators();
      controlValidade?.clearValidators();
      controlCvv?.clearValidators();
    }

    controlNome?.updateValueAndValidity();
    controlNumero?.updateValueAndValidity();
    controlValidade?.updateValueAndValidity();
    controlCvv?.updateValueAndValidity();
  }

  updateEnderecoValidators(): void {
    const fields = ['rua', 'numero', 'bairro', 'cidade', 'estado', 'cep'];
    fields.forEach(field => {
      const control = this.checkoutForm.get(field);
      if (this.adicionandoNovoEndereco) {
        if (field === 'cep') {
          control?.setValidators([Validators.required, Validators.pattern('^[0-9]{8}$')]);
        } else {
          control?.setValidators(Validators.required);
        }
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
      if (this.selectedCartaoId !== null) {
        // usa cartão existente
        pedidoRequest.idCartao = this.selectedCartaoId;
      } else {
        // novo cartão digitado
        pedidoRequest.novoCartao = {
          nomeImpresso: formValue.nomeImpresso,
          numeroCartao: formValue.numeroCartao,
          validadeCartao: formValue.validadeCartao,
          cvv: formValue.cvv
        };
        pedidoRequest.salvarCartao = formValue.salvarCartao ?? false;
      }
    }

    this.pedidoService.create(pedidoRequest).subscribe({
      next: (pedido) => {
        this.dialogService.showSuccess('Pedido realizado com sucesso!');
        this.carrinhoService.limparCarrinho();
        this.router.navigate(['/']);
      },
      error: (err) => {
        console.error('Erro ao criar pedido', err);
        
        if (err.status === 401) {
          alert('Sua sessão expirou por inatividade. Por favor, faça login novamente para finalizar seu pedido.');
        } else {
          const backendMsg = err.error ? (typeof err.error === 'string' ? err.error : JSON.stringify(err.error)) : '';
          alert('Erro ao finalizar o pedido: ' + backendMsg);
        }
        
        this.processando.set(false);
      }
    });
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
    // Remove everything that is not a digit
    let value = input.value.replace(/\D/g, '');

    // Insert '/' after the 2nd digit
    if (value.length >= 3) {
      value = value.substring(0, 2) + '/' + value.substring(2, 4);
    }

    // Update the DOM input and the form control
    input.value = value;
    this.checkoutForm.get('validadeCartao')?.setValue(value, { emitEvent: false });
  }

  getImagemUrl(url: string): string {
    return `http://localhost:8081${url}`;
  }

  getFirstImageUrl(fonte: any): string | null {
    if (!fonte?.imagens || fonte.imagens.length === 0) return null;
    const first = fonte.imagens[0];
    if (!first?.url) return null;
    return this.getImagemUrl(first.url);
  }
}
