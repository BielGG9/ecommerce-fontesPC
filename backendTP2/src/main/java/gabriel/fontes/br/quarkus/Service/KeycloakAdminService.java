package gabriel.fontes.br.quarkus.Service;

public interface KeycloakAdminService {
    String criarUsuario(String username, String nome, String email, String senha);
    void enviarEmailRecuperacaoSenha(String email);
}
