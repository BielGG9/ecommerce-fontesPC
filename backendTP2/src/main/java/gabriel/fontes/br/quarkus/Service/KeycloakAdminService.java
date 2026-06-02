package gabriel.fontes.br.quarkus.Service;

public interface KeycloakAdminService {
    String criarUsuario(String username, String nome, String email, String senha, String cpf, String rg);
    void enviarEmailRecuperacaoSenha(String email);
    boolean validarSenhaUsuario(String username, String senha);
    void enviarEmailVerificacao(String email);

    /**
     * Altera a senha de um usuário diretamente via Keycloak Admin Client.
     * Utilizado após validação da senha atual no fluxo de troca de senha.
     *
     * @param userId   ID do usuário no Keycloak (campo sub do JWT)
     * @param novaSenha Nova senha em plain-text (o Keycloak cuida do hashing)
     */
    void alterarSenhaUsuario(String userId, String novaSenha);
}
