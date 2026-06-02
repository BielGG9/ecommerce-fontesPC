package gabriel.fontes.br.quarkus.Service;

import java.util.List;

import gabriel.fontes.br.quarkus.Dto.ClienteRequest;
import gabriel.fontes.br.quarkus.Dto.ClienteResponse;
public interface ClienteService {
    
    // CRUD - Create, Read, Update, Delete
    ClienteResponse create(ClienteRequest dto);
    ClienteResponse update(Long id, ClienteRequest dto);
    ClienteResponse delete(Long id);
    List<ClienteResponse> findAll();
    ClienteResponse findById(Long id);
    ClienteResponse getMeuPerfil();
    
    void recuperarSenha(String email);
    void solicitarAlteracaoSegura(String senha);

    /**
     * Valida a senha atual do usuário logado e, se correta,
     * altera para a nova senha diretamente no Keycloak.
     */
    void alterarSenha(String senhaAtual, String novaSenha);

    gabriel.fontes.br.quarkus.Model.Cliente sincronizarUsuarioLogado();
}
