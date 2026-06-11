import { Injectable, inject } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { MessageDialogComponent } from '../components/message-dialog/message-dialog.component';
import { Observable } from 'rxjs';

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

  showError(message: string, title: string = 'Erro'): void {
    this.dialog.open(MessageDialogComponent, {
      data: {
        title,
        message,
        type: 'error'
      },
      width: '380px',
      panelClass: 'custom-message-dialog-panel'
    });
  }

  showConfirm(message: string, title: string = 'Confirmar'): Observable<boolean> {
    const dialogRef = this.dialog.open(MessageDialogComponent, {
      data: {
        title,
        message,
        type: 'confirm'
      },
      width: '380px',
      panelClass: 'custom-message-dialog-panel'
    });
    return dialogRef.afterClosed();
  }
}
