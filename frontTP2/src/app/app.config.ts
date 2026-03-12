import { ApplicationConfig, APP_INITIALIZER, ErrorHandler } from '@angular/core';
import { provideRouter } from '@angular/router';
import { provideHttpClient, withInterceptorsFromDi, HTTP_INTERCEPTORS } from '@angular/common/http';
import { routes } from './app.routes';
import { KeycloakService, KeycloakBearerInterceptor } from 'keycloak-angular';
import { provideAnimationsAsync } from '@angular/platform-browser/animations/async';


export class GlobalErrorHandler implements ErrorHandler {
  handleError(error: any): void {
    console.error('ERRO FATAL:', error);
  }
}

// 1. A FUNÇÃO DE IGNIÇÃO: Configura e arranca o Keycloak
function initializeKeycloak(keycloak: KeycloakService) {
  return () => {
    try {
    keycloak.init({
      config: {
        url: 'http://localhost:8080',
        realm: 'meu-realm',
        clientId: 'quarkuss'
      },
      initOptions: {
        onLoad: 'check-sso',
        checkLoginIframe: false, 
        silentCheckSsoRedirectUri: 'http://localhost:4200/silent-check-sso.html'
      },
      enableBearerInterceptor: true,
      bearerPrefix: 'Bearer'
    });
    } catch (error) {
      console.error('Erro ao inicializar o Keycloak (offline), mas vamos continuar com o modo visitante:', error);
    }
  };
}

export const appConfig: ApplicationConfig = {
  providers: [
    provideAnimationsAsync(),
    { provide: ErrorHandler, useClass: GlobalErrorHandler },
    provideRouter(routes),
    provideHttpClient(withInterceptorsFromDi()),

    // 2. Avisamos o Angular que este serviço EXISTE (Mata o erro NG0201)
    KeycloakService,

    // 3. Obriga o Angular a rodar a Ignição ANTES de desenhar a tela
    {
      provide: APP_INITIALIZER,
      useFactory: initializeKeycloak,
      multi: true,
      deps: [KeycloakService]
    },

    // 4. O Carteiro que leva o Token para o Quarkus
    {
      provide: HTTP_INTERCEPTORS,
      useClass: KeycloakBearerInterceptor,
      multi: true
    }
  ]
};