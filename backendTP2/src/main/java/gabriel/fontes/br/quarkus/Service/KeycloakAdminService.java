package gabriel.fontes.br.quarkus.Service;

public interface KeycloakAdminService {
    void criarUsuario(String nome, String email, String senha);
    void enviarEmailRecuperacaoSenha(String email);
}
