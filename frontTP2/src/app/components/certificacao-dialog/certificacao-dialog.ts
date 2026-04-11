import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatDialogRef } from '@angular/material/dialog';
import { MatButtonModule } from '@angular/material/button';
import { MatListModule } from '@angular/material/list';
import { Certificacao, CERTIFICACOES } from '../../models/certificacao.model';

@Component({
  selector: 'app-certificacao-dialog',
  standalone: true,
  imports: [CommonModule, MatButtonModule, MatListModule],
  templateUrl: './certificacao-dialog.html',
  styleUrl: './certificacao-dialog.css',
})
export class CertificacaoDialog {

  listaCertificacoes: Certificacao[] = CERTIFICACOES;
  constructor(public dialogRef: MatDialogRef<CertificacaoDialog>) { }

  selecionar(cert: Certificacao) {
    this.dialogRef.close(cert);
  }
  cancelar() {
    this.dialogRef.close();
  }
}
