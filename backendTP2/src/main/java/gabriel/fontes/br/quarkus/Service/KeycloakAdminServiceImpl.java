package gabriel.fontes.br.quarkus.Service;

import org.keycloak.admin.client.Keycloak;
import org.keycloak.representations.idm.CredentialRepresentation;
import org.keycloak.representations.idm.UserRepresentation;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;

import jakarta.ws.rs.core.Response;
import jakarta.ws.rs.WebApplicationException;
import jakarta.ws.rs.ProcessingException;

import java.util.Collections;

@ApplicationScoped
public class KeycloakAdminServiceImpl implements KeycloakAdminService {

    @Inject
    Keycloak keycloak;

    @Override
    public void enviarEmailRecuperacaoSenha(String email) {
        java.util.List<UserRepresentation> users = keycloak.realm("TP2").users().search(null, null, null, email, 0, 1);
        
        if (users == null || users.isEmpty()) {
            throw new jakarta.ws.rs.NotFoundException("Utilizador não encontrado no Keycloak.");
        }
        
        String userId = users.get(0).getId();
        keycloak.realm("TP2").users().get(userId).executeActionsEmail(java.util.Collections.singletonList("UPDATE_PASSWORD"));
    }

    @Override
    public void criarUsuario(String nome, String email, String senha) {
        try {
            // 1. Criar a credencial (senha)
            CredentialRepresentation credencial = new CredentialRepresentation();
            credencial.setType(CredentialRepresentation.PASSWORD);
            credencial.setValue(senha);
            credencial.setTemporary(false);

            // 2. Criar a representação do utilizador
            UserRepresentation usuario = new UserRepresentation();
            usuario.setUsername(nome);
            usuario.setFirstName(nome);
            usuario.setEmail(email);
            usuario.setEnabled(true);
            usuario.setCredentials(Collections.singletonList(credencial));

            // 3. Enviar o pedido para o Keycloak
            try (Response response = keycloak.realm("TP2").users().create(usuario)) {
                if (response.getStatus() != 201) {
                    throw new RuntimeException("Erro ao criar utilizador no Keycloak. Status: " + response.getStatus() + " - " + response.getStatusInfo().getReasonPhrase());
                }
            }

        } catch (WebApplicationException e) {
            // Repassa as nossas exceções amigáveis construídas acima
            throw e;
        } catch (ProcessingException e) {
            // ProcessingException mapeia erros de comunicação JAX-RS (Servidor caiu, Timeout, etc)
            throw new WebApplicationException("Erro de comunicação com o servidor Keycloak. Certifique-se de que ele se encontra online.", 500);
        } catch (Exception e) {
            // Captura de segurança genérica
            throw new WebApplicationException("Ocorreu um erro inesperado ao registar o utilizador no Keycloak: " + e.getMessage(), 500);
        }
    }
}
