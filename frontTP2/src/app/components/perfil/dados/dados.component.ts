import { Component, OnInit, inject, ChangeDetectorRef, NgZone } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormBuilder, FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';
import { ClienteService } from '../../../services/cliente.service';
import { AuthService } from '../../../services/auth.service';
import { Cliente } from '../../../models/cliente.model';
import { RouterModule } from '@angular/router';
import { DialogService } from '../../../services/dialog.service';

@Component({
  selector: 'app-perfil-dados',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule, RouterModule],
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

  // Propriedades para o fluxo de segurança independente
  cpfBloqueado = true;
  rgBloqueado = true;
  campoParaAlterar: 'cpf' | 'rg' | null = null;
  senhaConfirmacao = '';
  erroModal = '';
  sucessoModal = '';
  mostrarModalSeguranca = false;

  abrirModalSeguranca(campo: 'cpf' | 'rg') {
    this.campoParaAlterar = campo;
    this.senhaConfirmacao = '';
    this.erroModal = '';
    this.sucessoModal = '';
    this.mostrarModalSeguranca = true;
    this.cdr.detectChanges();
  }

  fecharModalSeguranca() {
    this.mostrarModalSeguranca = false;
    this.campoParaAlterar = null;
    this.cdr.detectChanges();
  }

  atualizarSenhaModal(event: any) {
    this.senhaConfirmacao = event.target.value;
  }

  confirmarSeguranca() {
    if (!this.senhaConfirmacao) {
      this.erroModal = 'A senha é obrigatória.';
      return;
    }

    this.erroModal = '';
    this.sucessoModal = 'Validando senha e registrando alteração...';
    this.cdr.detectChanges();

    this.clienteService.validarSenhaESolicitarAlteracao(this.senhaConfirmacao).subscribe({
      next: (res: any) => {
        this.ngZone.run(() => {
          this.sucessoModal = 'Segurança validada! Campo liberado e e-mail de alerta enviado.';
          this.erroModal = '';
          
          // Desbloqueia apenas o campo solicitado pelo usuário
          if (this.campoParaAlterar === 'cpf') {
            this.cpfBloqueado = false;
          } else if (this.campoParaAlterar === 'rg') {
            this.rgBloqueado = false;
          }
          
          this.cdr.detectChanges();
          
          setTimeout(() => {
            this.fecharModalSeguranca();
          }, 2000);
        });
      },
      error: (err: any) => {
        this.ngZone.run(() => {
          this.erroModal = err.error?.message || 'Senha incorreta ou erro de servidor. Tente novamente.';
          this.sucessoModal = '';
          this.cdr.detectChanges();
        });
      }
    });
  }

  ngOnInit() {
    this.formGroup = this.fb.group({
      nome: ['', Validators.required],
      email: ['', [Validators.required, Validators.email]],
      username: ['', Validators.required],
      cpf: ['', [Validators.required, Validators.pattern('^[0-9]{11}$')]],
      rg: ['', [Validators.required, Validators.pattern('^[0-9]{7,15}$')]]
    });

    this.carregarPerfil();
  }

  carregarPerfil() {
    this.clienteService.getMeuPerfil().subscribe({
      next: (dados: Cliente) => {
        this.ngZone.run(() => {
          this.cliente = dados;

          console.log('Dados do utilizador recebidos:', dados);

          // Mapeamento direto e exato usando exatamente as chaves do backend
          this.formGroup.patchValue({
            nome: dados.nome,
            email: dados.email,
            username: dados.username || dados.nome || '',
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
      senha: '***' // Backend shouldn't change password if passed like this, or we handle it in Quarkus
    };

    this.clienteService.update(this.cliente.id, dadosAtualizados).subscribe({
      next: (res: Cliente) => {
        this.cliente = res;
        this.dialogService.showSuccess('Dados atualizados com sucesso!');
        // Mark form as pristine so the button gets disabled again
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
}
