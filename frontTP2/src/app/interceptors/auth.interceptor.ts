import { HttpInterceptorFn, HttpErrorResponse } from '@angular/common/http';
import { inject } from '@angular/core';
import { Router } from '@angular/router';
import { catchError } from 'rxjs/operators';
import { throwError } from 'rxjs';
import { AuthService } from '../services/auth.service';

export const authInterceptor: HttpInterceptorFn = (req, next) => {
  const token = localStorage.getItem('token');
  const router = inject(Router);
  const authService = inject(AuthService);

  let clonedReq = req;
  if (token) {
    // Só injeta o token se ele NÃO estiver expirado
    if (!authService.isTokenExpired(token)) {
      clonedReq = req.clone({
        setHeaders: {
          Authorization: `Bearer ${token}`
        }
      });
    } else {
      // Token expirado — limpa sessão silenciosamente (sem redirecionar)
      authService.limparSessao();
    }
  }

  return next(clonedReq).pipe(
    catchError((error: HttpErrorResponse) => {
      if (error.status === 401) {
        authService.limparSessao();
        
        // Só redireciona para a tela de login se o usuário estiver em uma rota protegida
        const protectedPaths = [
          '/admin',
          '/marca',
          '/fontes',
          '/modelos',
          '/funcionarios',
          '/departamentos',
          '/fornecedores',
          '/checkout',
          '/minha-conta'
        ];
        const currentPath = router.url.split('?')[0].split('#')[0];
        const isProtectedRoute = protectedPaths.some(p => currentPath === p || currentPath.startsWith(p + '/'));
        
        if (isProtectedRoute) {
          router.navigate(['/login']);
        }
      }
      return throwError(() => error);
    })
  );
};
