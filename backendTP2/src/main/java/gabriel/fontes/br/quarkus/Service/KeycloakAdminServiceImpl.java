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
    public String criarUsuario(String username, String nome, String email, String senha, String cpf, String rg) {
        try {
            // 1. Criar a credencial (senha)
            CredentialRepresentation credencial = new CredentialRepresentation();
            credencial.setType(CredentialRepresentation.PASSWORD);
            credencial.setValue(senha);
            credencial.setTemporary(false);

            // 2. Criar a representação do utilizador
            UserRepresentation usuario = new UserRepresentation();
            usuario.setUsername(username);
            
            // Separar Nome Completo em First Name e Last Name
            String firstName = nome;
            String lastName = "";
            if (nome != null && nome.trim().contains(" ")) {
                int primeiroEspaco = nome.trim().indexOf(" ");
                firstName = nome.trim().substring(0, primeiroEspaco);
                lastName = nome.trim().substring(primeiroEspaco + 1);
            }
            
            usuario.setFirstName(firstName);
            if (!lastName.isEmpty()) {
                usuario.setLastName(lastName);
            }
            usuario.setEmail(email);
            usuario.setEnabled(true);
            usuario.setCredentials(Collections.singletonList(credencial));

            // Adiciona atributos customizados para CPF e RG no Keycloak
            usuario.setAttributes(java.util.Map.of(
                "cpf", java.util.Collections.singletonList(cpf),
                "rg", java.util.Collections.singletonList(rg)
            ));

            // 3. Enviar o pedido para o Keycloak
            try (Response response = keycloak.realm("TP2").users().create(usuario)) {
                if (response.getStatus() == 201) {
                    // Extrair ID do usuário criado
                    String path = response.getLocation().getPath();
                    String userId = path.substring(path.lastIndexOf('/') + 1);

                    // Associar role 'USER' padrão
                    try {
                        org.keycloak.representations.idm.RoleRepresentation userRole = keycloak.realm("TP2").roles().get("USER").toRepresentation();
                        keycloak.realm("TP2").users().get(userId).roles().realmLevel().add(Collections.singletonList(userRole));
                    } catch (Exception ex) {
                        System.err.println("Aviso: Falha ao atribuir role USER ao novo usuário " + email + ". Certifique-se de que a role 'USER' existe no Keycloak.");
                    }
                    
                    return userId;
                } else if (response.getStatus() == 409) {
                    throw new WebApplicationException(
                        Response.status(409).entity(java.util.Map.of("message", "Este e-mail já está cadastrado no sistema Keycloak. Se você limpou o banco local recentemente, precisará deletar seu usuário no painel do Keycloak ou usar outro e-mail.")).build()
                    );
                } else {
                    String errorBody = response.readEntity(String.class);
                    throw new RuntimeException("Erro ao criar utilizador no Keycloak. Status: " + response.getStatus() + " - " + response.getStatusInfo().getReasonPhrase() + " - Detalhes: " + errorBody);
                }
            }

        } catch (WebApplicationException e) {
            // Repassa as nossas exceções amigáveis construídas acima
            throw e;
        } catch (ProcessingException e) {
            // ProcessingException mapeia erros de comunicação JAX-RS (Servidor caiu, Timeout, etc)
            throw new WebApplicationException(
                Response.status(500).entity(java.util.Map.of("message", "Erro de comunicação com o servidor Keycloak. Certifique-se de que ele se encontra online.")).build()
            );
        } catch (Exception e) {
            // Captura de segurança genérica
            throw new WebApplicationException(
                Response.status(500).entity(java.util.Map.of("message", "Ocorreu um erro inesperado ao registar o utilizador no Keycloak: " + e.getMessage())).build()
            );
        }
    }

    @Override
    public boolean validarSenhaUsuario(String username, String senha) {
        try {
            org.keycloak.admin.client.Keycloak tempKeycloak = org.keycloak.admin.client.KeycloakBuilder.builder()
                .serverUrl("http://localhost:8080")
                .realm("TP2")
                .clientId("quarkuss")
                .username(username)
                .password(senha)
                .build();
            
            tempKeycloak.tokenManager().getAccessToken();
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    @Override
    public void enviarEmailVerificacao(String email) {
        java.util.List<UserRepresentation> users = keycloak.realm("TP2").users().search(null, null, null, email, 0, 1);
        
        if (users == null || users.isEmpty()) {
            throw new jakarta.ws.rs.NotFoundException("Utilizador não encontrado no Keycloak.");
        }
        
        String userId = users.get(0).getId();
        keycloak.realm("TP2").users().get(userId).executeActionsEmail(java.util.Collections.singletonList("VERIFY_EMAIL"));
    }
}
