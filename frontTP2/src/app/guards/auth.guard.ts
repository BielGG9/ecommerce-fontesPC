import { inject } from '@angular/core';
import { Router, CanActivateFn } from '@angular/router';
import { AuthService } from '../services/auth.service';

export const canActivateAuthRole: CanActivateFn = async (route, state) => {
  const router = inject(Router);
  const authService = inject(AuthService);

  const logado = !!localStorage.getItem('token');

  if (!logado) {
    router.navigate(['/login']);
    return false;
  }

  if (!authService.hasRole('ADM')) {
    alert('Acesso Restrito: Necessita de privilégios de Administrador.');
    router.navigate(['/']);
    return false;
  }

  return true;
};
