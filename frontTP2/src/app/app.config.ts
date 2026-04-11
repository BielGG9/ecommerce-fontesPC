import { ApplicationConfig, ErrorHandler } from '@angular/core';
import { provideRouter } from '@angular/router';
import { provideHttpClient, withInterceptors } from '@angular/common/http';
import { routes } from './app.routes';
import { provideAnimationsAsync } from '@angular/platform-browser/animations/async';
import { authInterceptor } from './interceptors/auth.interceptor';

export class GlobalErrorHandler implements ErrorHandler {
  handleError(error: any): void {
    console.error('ERRO FATAL:', error);
  }
}

export const appConfig: ApplicationConfig = {
  providers: [
    provideAnimationsAsync(),
    { provide: ErrorHandler, useClass: GlobalErrorHandler },
    provideRouter(routes),
    provideHttpClient(withInterceptors([authInterceptor]))
  ]
};