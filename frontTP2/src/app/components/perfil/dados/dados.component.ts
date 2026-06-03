import { Component, OnInit, inject, ChangeDetectorRef, NgZone } from '@angular/core';
import { CommonModule } from '@angular/common';
import { AbstractControl, FormBuilder, FormGroup, FormsModule, ReactiveFormsModule, ValidationErrors, Validators } from '@angular/forms';
import { catchError } from 'rxjs/operators';
import { EMPTY } from 'rxjs';
import { ClienteService } from '../../../services/cliente.service';
import { AuthService } from '../../../services/auth.service';
import { Cliente } from '../../../models/cliente.model';
import { RouterModule } from '@angular/router';
import { DialogService } from '../../../services/dialog.service';

@Component({
  selector: 'app-perfil-dados',
  standalone: true,
  imports: [CommonModule, FormsModule, ReactiveFormsModule, RouterModule],
  templateUrl: './dados.component.html',
  styleUrls: ['./dados.component.css']
})
export class DadosComponent implements OnInit {

  clienteService = inject(ClienteService);
  authService = inject(AuthService);
  fb = inject(FormBuilder);
  private cdr = inject(ChangeDetectorRef);
  private ngZone = inject(NgZone);
  private dialogService = inject(DialogService);

  cliente: Cliente | null = null;
  formGroup!: FormGroup;
  senhaForm!: FormGroup;
  erroSenha: string | null = null;

  // ─── Estado do Modal de Segurança (modo duplo) ───────────────────────────────
  mostrarModalSeguranca = false;

  /** 'campo' = desbloquear CPF/RG | 'senha' = alterar senha */
  modalModo: 'campo' | 'senha' = 'campo';

  // Modo 'campo': desbloqueio de CPF / RG
  cpfBloqueado = true;
  rgBloqueado = true;
  campoParaAlterar: 'cpf' | 'rg' | null = null;
  senhaConfirmacao = '';

  // Modo 'senha': campos do formulário de troca de senha
  senhaAtualInput = '';
  novaSenhaInput = '';
  confirmarNovaSenhaInput = '';

  // Feedback visual do modal (compartilhado entre modos)
  erroModal = '';
  sucessoModal = '';
  processandoModal = false;

  // ─── Abertura / Fechamento ────────────────────────────────────────────────────

  abrirModalSeguranca(campo: 'cpf' | 'rg') {
    this.modalModo = 'campo';
    this.campoParaAlterar = campo;
    this._resetarEstadoModal();
    this.mostrarModalSeguranca = true;
    this.cdr.detectChanges();
  }

  abrirModalAlterarSenha() {
    this.modalModo = 'senha';
    this.campoParaAlterar = null;
    this._resetarEstadoModal();
    this.mostrarModalSeguranca = true;
    this.cdr.detectChanges();
  }

  fecharModalSeguranca() {
    this.mostrarModalSeguranca = false;
    this.campoParaAlterar = null;
    this._resetarEstadoModal();
    this.cdr.detectChanges();
  }

  private _resetarEstadoModal() {
    this.senhaConfirmacao = '';
    this.senhaAtualInput = '';
    this.novaSenhaInput = '';
    this.confirmarNovaSenhaInput = '';
    this.erroModal = '';
    this.sucessoModal = '';
    this.processandoModal = false;
  }

  // ─── Handlers de input do modal ──────────────────────────────────────────────

  atualizarSenhaModal(event: any) {
    this.senhaConfirmacao = event.target.value;
  }

  // ─── Lógica central de confirmação (bifurca pelo modo) ───────────────────────

  confirmarSeguranca() {
    if (this.modalModo === 'campo') {
      this._confirmarDesbloqueoCampo();
    } else {
      this.alterarSenha();
    }
  }

  private _confirmarDesbloqueoCampo() {
    if (!this.senhaConfirmacao) {
      this.erroModal = 'A senha é obrigatória.';
      return;
    }

    this.erroModal = '';
    this.sucessoModal = 'Validando senha e registrando alteração...';
    this.processandoModal = true;
    this.cdr.detectChanges();

    this.clienteService.validarSenhaESolicitarAlteracao(this.senhaConfirmacao).subscribe({
      next: () => {
        this.ngZone.run(() => {
          this.sucessoModal = 'Segurança validada! Campo liberado e e-mail de alerta enviado.';
          this.erroModal = '';
          this.processandoModal = false;

          if (this.campoParaAlterar === 'cpf') {
            this.cpfBloqueado = false;
          } else if (this.campoParaAlterar === 'rg') {
            this.rgBloqueado = false;
          }

          this.cdr.detectChanges();
          setTimeout(() => this.fecharModalSeguranca(), 2000);
        });
      },
      error: (err: any) => {
        this.ngZone.run(() => {
          this.erroModal = err.error?.message || 'Senha incorreta ou erro de servidor. Tente novamente.';
          this.sucessoModal = '';
          this.processandoModal = false;
          this.cdr.detectChanges();
        });
      }
    });
  }

  private _confirmarAlteracaoSenha() {
    // Validações no cliente antes de disparar a requisição
    if (!this.senhaAtualInput) {
      this.erroModal = 'Informe a sua senha atual.';
      return;
    }
    if (!this.novaSenhaInput || this.novaSenhaInput.length < 6) {
      this.erroModal = 'A nova senha deve ter no mínimo 6 caracteres.';
      return;
    }
    if (this.novaSenhaInput !== this.confirmarNovaSenhaInput) {
      this.erroModal = 'A confirmação de senha não confere com a nova senha.';
      return;
    }
    if (this.senhaAtualInput === this.novaSenhaInput) {
      this.erroModal = 'A nova senha deve ser diferente da senha atual.';
      return;
    }

    this.erroModal = '';
    this.sucessoModal = '';
    this.processandoModal = true;
    this.cdr.detectChanges();

    this.clienteService.alterarSenha(this.senhaAtualInput, this.novaSenhaInput).subscribe({
      next: () => {
        this.ngZone.run(() => {
          this.sucessoModal = 'Senha alterada com sucesso!';
          this.erroModal = '';
          this.processandoModal = false;
          this.cdr.detectChanges();
          setTimeout(() => this.fecharModalSeguranca(), 2500);
        });
      },
      error: (err: any) => {
        this.ngZone.run(() => {
          this.erroModal = err.error?.message || 'Erro ao alterar a senha. Verifique e tente novamente.';
          this.sucessoModal = '';
          this.processandoModal = false;
          this.cdr.detectChanges();
        });
      }
    });
  }

  // ─── Ciclo de vida ────────────────────────────────────────────────────────────

  ngOnInit() {
    this.formGroup = this.fb.group({
      nome: ['', Validators.required],
      email: ['', [Validators.required, Validators.email]],
      username: ['', Validators.required],
      cpf: ['', [Validators.required, Validators.pattern('^[0-9]{11}$')]],
      rg: ['', [Validators.required, Validators.pattern('^[0-9]{7,15}$')]]
    });

    this.senhaForm = this.fb.group({
      senhaAtual: ['', [Validators.required, Validators.minLength(6)]],
      novaSenha: ['', [Validators.required, Validators.minLength(6)]],
      confirmarSenha: ['', [Validators.required]]
    }, { validators: this.senhasIguaisValidator });

    this.carregarPerfil();
  }

  carregarPerfil() {
    this.clienteService.getMeuPerfil().subscribe({
      next: (dados: Cliente) => {
        this.ngZone.run(() => {
          this.cliente = dados;

          console.log('Dados do utilizador recebidos:', dados);

          const tokenData = this.authService.obterDadosToken();
          const preferredUsername = tokenData ? tokenData.preferred_username : '';

          this.formGroup.patchValue({
            nome: dados.nome,
            email: dados.email,
            username: preferredUsername || dados.username || dados.nome || '',
            cpf: dados.cpf,
            rg: dados.rg
          });

          this.cdr.detectChanges();
        });
      },
      error: (err: any) => {
        this.ngZone.run(() => {
          console.error('Erro ao carregar perfil', err);
          alert('Erro ao carregar perfil.');
          this.cdr.detectChanges();
        });
      }
    });
  }

  salvar() {
    if (this.formGroup.invalid || !this.cliente) return;

    const formValues = this.formGroup.getRawValue();

    const dadosAtualizados: Partial<Cliente> = {
      nome: formValues.nome,
      email: formValues.email,
      username: formValues.username,
      cpf: formValues.cpf,
      rg: formValues.rg,
      senha: '***'
    };

    this.clienteService.update(this.cliente.id, dadosAtualizados).subscribe({
      next: (res: Cliente) => {
        this.cliente = res;
        this.dialogService.showSuccess('Dados atualizados com sucesso!');
        this.formGroup.markAsPristine();
      },
      error: (err: any) => {
        console.error(err);
        alert('Erro ao atualizar os dados.');
      }
    });
  }

  apenasNumeros(event: KeyboardEvent) {
    const charCode = event.which ? event.which : event.keyCode;
    if (charCode > 31 && (charCode < 48 || charCode > 57)) {
      event.preventDefault();
    }
  }

  senhasIguaisValidator(group: AbstractControl): ValidationErrors | null {
    const nova = group.get('novaSenha')?.value;
    const confirmar = group.get('confirmarSenha')?.value;
    return nova === confirmar ? null : { senhasDiferentes: true };
  }

  alterarSenha(): void {
    if (this.senhaForm.invalid) return;

    this.erroSenha = null;
    const { senhaAtual, novaSenha } = this.senhaForm.value;

    this.clienteService.alterarSenha(senhaAtual, novaSenha).pipe(
      catchError(err => {
        this.ngZone.run(() => {
          if (err.status === 400) {
            this.erroSenha = 'Senha atual incorreta.';
            this.dialogService.showWarning('A senha atual informada está incorreta. Verifique e tente novamente.', 'Senha Incorreta');
          } else {
            this.erroSenha = 'Erro ao alterar senha. Tente novamente.';
            this.dialogService.showWarning('Ocorreu um erro ao tentar alterar a senha. Por favor, tente novamente.', 'Erro');
          }
        });
        return EMPTY;
      })
    ).subscribe(() => {
      this.ngZone.run(() => {
        this.senhaForm.reset();
        this.erroSenha = null;
        this.fecharModalSeguranca();
        this.dialogService.showSuccess('Senha alterada com sucesso!');
      });
    });
  }
}
