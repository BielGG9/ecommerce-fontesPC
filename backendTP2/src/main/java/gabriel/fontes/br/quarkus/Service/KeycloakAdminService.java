package gabriel.fontes.br.quarkus.Service;

public interface KeycloakAdminService {
    String criarUsuario(String username, String nome, String email, String senha, String cpf, String rg);
    void enviarEmailRecuperacaoSenha(String email);
    boolean validarSenhaUsuario(String username, String senha);
    void enviarEmailVerificacao(String email);
}
