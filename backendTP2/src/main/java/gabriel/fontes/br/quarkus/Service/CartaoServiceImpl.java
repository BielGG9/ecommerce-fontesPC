package gabriel.fontes.br.quarkus.Service;

import gabriel.fontes.br.quarkus.Dto.CartaoRequest;
import gabriel.fontes.br.quarkus.Dto.CartaoResponse;
import gabriel.fontes.br.quarkus.Model.Cartao;
import gabriel.fontes.br.quarkus.Model.Cliente;
import gabriel.fontes.br.quarkus.Repository.CartaoRepository;
import gabriel.fontes.br.quarkus.Repository.ClienteRepository;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.NotFoundException;
import org.eclipse.microprofile.jwt.JsonWebToken;

import java.util.List;

@ApplicationScoped
public class CartaoServiceImpl implements CartaoService {

    @Inject
    CartaoRepository cartaoRepository;

    @Inject
    ClienteRepository clienteRepository;

    @Inject
    JsonWebToken jwt;

    @Override
    @Transactional
    public CartaoResponse create(CartaoRequest dto) {
        // 1. Pega o usuário logado
        String idUsuarioKeycloak = jwt.getSubject();
        Cliente cliente = clienteRepository.findByIdKeycloak(idUsuarioKeycloak);

        if (cliente == null) {
            throw new NotFoundException("Cliente não encontrado.");
        }

        // 2. Cria o Cartão
        Cartao cartao = new Cartao();
        cartao.setNumeroCartao(dto.numeroCartao());
        cartao.setNomeImpresso(dto.nomeImpresso());
        cartao.setValidade(dto.validadeCartao());
        cartao.setCvv(dto.cvv());
        
        // Dados obrigatórios da herança Pagamento
        cartao.setValor(0.0); 
        cartao.setStatus("SALVO"); 

        // 3. VINCULA AO CLIENTE (Essencial para o findById funcionar depois)
        cartao.setCliente(cliente);

        cartaoRepository.persist(cartao);

        return CartaoResponse.fromEntity(cartao);
    }

    @Override
    public List<CartaoResponse> findAll() {
        String idUsuarioKeycloak = jwt.getSubject();
        
        // Busca apenas os cartões deste cliente específico
        // "cliente.idKeycloak" assume que sua entidade Cliente tem esse campo mapeado no JPA
        return cartaoRepository.find("cliente.idKeycloak", idUsuarioKeycloak).list().stream()
                .map(CartaoResponse::fromEntity)
                .toList();
    }

    @Override
    public CartaoResponse findById(Long id) {
        Cartao cartao = cartaoRepository.findById(id);

        if (cartao == null) {
            throw new NotFoundException("Cartão não encontrado");
        }

        return CartaoResponse.fromEntity(cartao);
    }

    @Override
    @Transactional
    public CartaoResponse update(Long id, CartaoRequest dto) {
        Cartao cartao = cartaoRepository.findById(id);

        if (cartao == null) {
            throw new NotFoundException("Cartão não encontrado");
        }

        // Atualiza os dados
        cartao.setNumeroCartao(dto.numeroCartao());
        cartao.setNomeImpresso(dto.nomeImpresso());
        cartao.setValidade(dto.validadeCartao());
        cartao.setCvv(dto.cvv());

        return CartaoResponse.fromEntity(cartao);
    }

    @Override
    @Transactional
    public CartaoResponse delete(Long id) {
        Cartao cartao = cartaoRepository.findById(id);
        
        if (cartao == null) {
            throw new NotFoundException("Cartão não encontrado");
        }

        cartaoRepository.delete(cartao);
        return CartaoResponse.fromEntity(cartao);
    }
    }