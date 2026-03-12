import { inject } from '@angular/core';
import { Router, CanActivateFn } from '@angular/router';
import { KeycloakService } from 'keycloak-angular';

export const canActivateAuthRole: CanActivateFn = async (route, state) => {
  const router = inject(Router);
  const keycloak = inject(KeycloakService);

  const logado = await keycloak.isLoggedIn();

  if (!logado) {
    await keycloak.login({
      redirectUri: window.location.origin + state.url
    });
    return false;
  }

  return true;
};
