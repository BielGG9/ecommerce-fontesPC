import { Component, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule, Router } from '@angular/router';
import { CarrinhoService } from '../../services/carrinho.service';
import { ClienteService } from '../../services/cliente.service';
import { AuthService } from '../../services/auth.service';
import { ItemPedido } from '../../models/item-pedido.model';

@Component({
  selector: 'app-carrinho',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterModule],
  templateUrl: './carrinho.component.html',
  styleUrl: './carrinho.component.css'
})
export class CarrinhoComponent implements OnInit {
  carrinhoService = inject(CarrinhoService);
  router         = inject(Router);
  clienteService = inject(ClienteService);
  authService    = inject(AuthService);

  // ─── Estado do Modal de Completar Cadastro ───────────────────────────────
  exibirModalCompletar = false;
  enviandoCompletar    = false;
  erroCompletar: string | null = null;

  // Campos do formulário
  form = {
    cpf:        '',
    cep:        '',
    logradouro: '',
    numero:     '',
    telefone:   ''
  };

  // Dados do usuário logado (carregados do backend ao iniciar)
  usuarioLogado: any = null;

  ngOnInit(): void {
    // Carrega o perfil para saber se já tem CPF real preenchido
    const token = localStorage.getItem('token');
    if (token) {
      this.clienteService.getMeuPerfil().subscribe({
        next:  (perfil) => { this.usuarioLogado = perfil; },
        error: ()       => { this.usuarioLogado = null; }
      });
    }
  }

  // ─── Lógica do botão "Finalizar Compra" ──────────────────────────────────
  tentarCheckout(): void {
    const token = localStorage.getItem('token');

    // Usuário não está logado → redireciona para login
    if (!token) {
      alert('Você precisa estar logado para finalizar a compra!');
      this.router.navigate(['/login']);
      return;
    }

    // Verifica se o CPF real já foi informado
    // (cadastro expresso salva "00000000000" como placeholder)
    const cpfValido = this.usuarioLogado?.cpf
      && this.usuarioLogado.cpf !== '00000000000'
      && this.usuarioLogado.cpf.trim() !== '';

    if (cpfValido) {
      // Cadastro já completo → segue para o checkout normalmente
      this.irParaCheckout();
    } else {
      // Cadastro incompleto → abre o modal de completar cadastro
      this.exibirModalCompletar = true;
      this.erroCompletar = null;
    }
  }

  fecharModal(): void {
    this.exibirModalCompletar = false;
    this.form = { cpf: '', cep: '', logradouro: '', numero: '', telefone: '' };
    this.erroCompletar = null;
  }

  // ─── Máscaras de Entrada ──────────────────────────────────────────────────
  onCpfChange(valor: string) {
    valor = valor.replace(/\D/g, '');
    if (valor.length > 11) valor = valor.slice(0, 11);
    
    if (valor.length > 9) {
      valor = valor.replace(/(\d{3})(\d{3})(\d{3})(\d{1,2})/, '$1.$2.$3-$4');
    } else if (valor.length > 6) {
      valor = valor.replace(/(\d{3})(\d{3})(\d{1,3})/, '$1.$2.$3');
    } else if (valor.length > 3) {
      valor = valor.replace(/(\d{3})(\d{1,3})/, '$1.$2');
    }
    
    this.form.cpf = valor;
  }

  onCepChange(valor: string) {
    valor = valor.replace(/\D/g, '');
    if (valor.length > 8) valor = valor.slice(0, 8);
    
    if (valor.length > 5) {
      valor = valor.replace(/(\d{5})(\d{1,3})/, '$1-$2');
    }
    
    this.form.cep = valor;
  }

  onTelefoneChange(valor: string) {
    valor = valor.replace(/\D/g, '');
    if (valor.length > 11) valor = valor.slice(0, 11);
    
    if (valor.length > 10) {
      valor = valor.replace(/(\d{2})(\d{5})(\d{4})/, '($1) $2-$3');
    } else if (valor.length > 6) {
      // Para telefones com 8 ou 9 dígitos + DDD
      valor = valor.replace(/(\d{2})(\d{4,5})(\d{1,4})/, '($1) $2-$3');
    } else if (valor.length > 2) {
      valor = valor.replace(/(\d{2})(\d{1,5})/, '($1) $2');
    } else if (valor.length > 0) {
      valor = valor.replace(/(\d{1,2})/, '($1');
    }
    
    this.form.telefone = valor;
  }

  // ─── Submissão do Modal ───────────────────────────────────────────────────
  submeterCompletar(): void {
    if (!this.form.cpf || !this.form.cep || !this.form.logradouro || !this.form.numero || !this.form.telefone) {
      this.erroCompletar = 'Por favor, preencha todos os campos obrigatórios.';
      return;
    }

    this.enviandoCompletar = true;
    this.erroCompletar = null;

    this.clienteService.completarCadastro({
      cpf:        this.form.cpf,
      cep:        this.form.cep,
      logradouro: this.form.logradouro,
      numero:     this.form.numero,
      telefone:   this.form.telefone
    }).subscribe({
      next: (clienteAtualizado) => {
        // Atualiza localmente e fecha o modal
        this.usuarioLogado = clienteAtualizado;
        this.enviandoCompletar = false;
        this.fecharModal();
        // Prossegue automaticamente para o checkout
        this.irParaCheckout();
      },
      error: (err) => {
        this.enviandoCompletar = false;
        this.erroCompletar = err?.error?.message ?? 'Ocorreu um erro. Tente novamente.';
      }
    });
  }

  // ─── Ações de itens do carrinho ───────────────────────────────────────────
  irParaCheckout() {
    this.router.navigate(['/checkout']);
  }

  removerItem(item: ItemPedido) {
    this.carrinhoService.itens.update(itens => itens.filter(i => i.fonte?.id !== item.fonte?.id));
  }

  removerTodos() {
    this.carrinhoService.itens.set([]);
  }

  aumentarQuantidade(item: ItemPedido) {
    if (item.fonte && item.quantidade < (item.fonte.estoque ?? 0)) {
       this.carrinhoService.itens.update(itens => {
         const i = itens.find(it => it.fonte?.id === item.fonte?.id);
         if (i) i.quantidade++;
         return [...itens];
       });
    }
  }

  diminuirQuantidade(item: ItemPedido) {
    if (item.quantidade > 1) {
       this.carrinhoService.itens.update(itens => {
         const i = itens.find(it => it.fonte?.id === item.fonte?.id);
         if (i) i.quantidade--;
         return [...itens];
       });
    }
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
