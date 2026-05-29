import { Injectable, inject } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { MessageDialogComponent } from '../components/message-dialog/message-dialog.component';

@Injectable({
  providedIn: 'root'
})
export class DialogService {
  private dialog = inject(MatDialog);

  showSuccess(message: string, title: string = 'Sucesso!'): void {
    this.dialog.open(MessageDialogComponent, {
      data: {
        title,
        message,
        type: 'success'
      },
      width: '380px',
      // panelClass é opcional, mas removemos estilos padrão indesejados se existirem
      panelClass: 'custom-message-dialog-panel'
    });
  }

  showInfo(message: string, title: string = 'Informação'): void {
    this.dialog.open(MessageDialogComponent, {
      data: {
        title,
        message,
        type: 'info'
      },
      width: '380px',
      panelClass: 'custom-message-dialog-panel'
    });
  }

  showWarning(message: string, title: string = 'Atenção'): void {
    this.dialog.open(MessageDialogComponent, {
      data: {
        title,
        message,
        type: 'warning'
      },
      width: '380px',
      panelClass: 'custom-message-dialog-panel'
    });
  }
}
