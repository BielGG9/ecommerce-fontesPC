package gabriel.fontes.br.quarkus.Service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import org.eclipse.microprofile.jwt.JsonWebToken;

import gabriel.fontes.br.quarkus.Dto.PedidoRequest;
import gabriel.fontes.br.quarkus.Dto.PedidoResponse;
import gabriel.fontes.br.quarkus.Dto.ItemPedidoRequest;
import gabriel.fontes.br.quarkus.Model.Boleto;
import gabriel.fontes.br.quarkus.Model.Cartao;
import gabriel.fontes.br.quarkus.Model.Cliente;
import gabriel.fontes.br.quarkus.Model.Endereco;
import gabriel.fontes.br.quarkus.Model.EnderecoEntrega;
import gabriel.fontes.br.quarkus.Model.Fonte;
import gabriel.fontes.br.quarkus.Model.ItemPedido;
import gabriel.fontes.br.quarkus.Model.Pedido;
import gabriel.fontes.br.quarkus.Model.Pix;
import gabriel.fontes.br.quarkus.Model.Abstratc.Pagamento;
import gabriel.fontes.br.quarkus.Repository.CartaoRepository;
import gabriel.fontes.br.quarkus.Repository.ClienteRepository;
import gabriel.fontes.br.quarkus.Repository.EnderecoRepository;
import gabriel.fontes.br.quarkus.Repository.FonteRepository;
import gabriel.fontes.br.quarkus.Repository.PagamentoRepository;
import gabriel.fontes.br.quarkus.Repository.PedidoRepository;
import io.quarkus.security.ForbiddenException;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.BadRequestException;
import jakarta.ws.rs.NotFoundException;
import gabriel.fontes.br.quarkus.Model.Enums.StatusPedido;

@ApplicationScoped
public class PedidoServiceImpl implements PedidoService {

    @Inject
    PedidoRepository pedidoRepository;

    @Inject
    FonteRepository fonteRepository;

    @Inject
    EnderecoRepository enderecoRepository;

    @Inject
    PagamentoRepository pagamentoRepository;

    @Inject
    CartaoRepository cartaoRepository;

    @Inject
    ClienteRepository clienteRepository;

    @Inject
    ClienteService clienteService;

    @Inject
    JsonWebToken jwt;

    @Override
    @Transactional
    public PedidoResponse create(PedidoRequest dto) {

        // 1. Obter dados do usuário autenticado via Keycloak
        String idUsuarioKeycloak = jwt.getSubject();

        // Buscar o cliente autenticado no banco de dados
        Cliente clienteAutenticado = clienteRepository.findByIdKeycloak(idUsuarioKeycloak);

        // Verificar se o cliente autenticado foi encontrado
        if (clienteAutenticado == null) {
            throw new ForbiddenException("Cadastro de cliente não encontrado para o usuário autenticado.");
        }

        // Validar o endereço de entrega
        Endereco enderecoBanco = enderecoRepository.findByIdOptional(dto.idEnderecoEntrega())
                .orElseThrow(() -> new NotFoundException("Endereço não encontrado com id: " + dto.idEnderecoEntrega()));

        // Verificar se o endereço pertence ao cliente autenticado
        if (!enderecoBanco.getPessoa().getId().equals(clienteAutenticado.getId())) {
            throw new ForbiddenException("O endereço informado não pertence ao cliente autenticado.");
        }

        // 3. Mapear Pedido
        Pedido pedido = new Pedido();
        pedido.setStatus(StatusPedido.PENDENTE);
        pedido.setIdUsuario(idUsuarioKeycloak);
        pedido.setCliente(clienteAutenticado); // Importante: Setar o objeto Cliente também
        pedido.setNomeClienteSnapshot(clienteAutenticado.getNome());
        pedido.setData(LocalDateTime.now());

        // 4. Mapear Endereço (Snapshot)
        EnderecoEntrega enderecoEntrega = new EnderecoEntrega();
        enderecoEntrega.setRua(enderecoBanco.getRua());
        enderecoEntrega.setNumero(enderecoBanco.getNumero());
        enderecoEntrega.setComplemento(enderecoBanco.getComplemento());
        enderecoEntrega.setBairro(enderecoBanco.getBairro());
        enderecoEntrega.setCidade(enderecoBanco.getCidade());
        enderecoEntrega.setEstado(enderecoBanco.getEstado());
        enderecoEntrega.setCep(enderecoBanco.getCep());
        pedido.setEnderecoEntrega(enderecoEntrega);

        // 6. Mapear Itens e Calcular Total
        double total = 0.0;
        List<ItemPedido> itensParaSalvar = new ArrayList<>();

        for (ItemPedidoRequest itemDto : dto.itensPedido()) {

            // Buscar a fonte pelo ID fornecido
            Fonte fonte = fonteRepository.findByIdOptional(itemDto.fonteId())
                    .orElseThrow(() -> new BadRequestException("Fonte não encontrada: " + itemDto.fonteId()));

            // Verificar estoque
            if (fonte.getEstoque() < itemDto.quantidade()) {
                throw new BadRequestException("Estoque insuficiente para a fonte: " + fonte.getNome());
            }

            // Baixar estoque
            fonte.setEstoque(fonte.getEstoque() - itemDto.quantidade());

            // Mapear ItemPedido
            ItemPedido itemPedido = new ItemPedido();
            itemPedido.setFonte(fonte);
            itemPedido.setQuantidade(itemDto.quantidade());
            itemPedido.setPreco(fonte.getPreco());
            itemPedido.setPedido(pedido);

            total += fonte.getPreco() * itemDto.quantidade();
            itensParaSalvar.add(itemPedido);
        }

        // 7. Finalizar Pedido
        pedido.setTotal(total);
        pedido.setItens(itensParaSalvar);

        Pagamento pagamentoEntity = null;
        Cartao cartaoVinculadoAoPedido = null; // Variável auxiliar para vincular no pedido

        // Normaliza a string para evitar erros de maiúscula/minúscula
        String tipoPagamento = dto.pagamento().toLowerCase();

        switch (tipoPagamento) {
            case "boleto":
                Boleto boleto = new Boleto();
                boleto.setCodigoBarras("34191.79001.01043.510047.910201.5.000000000");
                boleto.setDataVencimento(LocalDateTime.now().plusDays(3));
                pagamentoEntity = boleto;
                break;

            case "pix":
                Pix pix = new Pix();
                pix.setChavePix("00020126360014BR.GOV.BCB.PIX...");
                pix.setValidade(LocalDateTime.now().plusMinutes(30));
                pagamentoEntity = pix;
                break;

            case "cartao":

                Cartao cartaoParaPagamento = null;

                // Opção A: Usar cartão existente pelo ID
                if (dto.idCartao() != null) {
                    cartaoParaPagamento = cartaoRepository.findById(dto.idCartao());
                    if (cartaoParaPagamento == null) {
                        throw new NotFoundException("Cartão informado não encontrado.");
                    }
                    // Segurança: verificar se o cartão pertence ao usuário logado
                    if (cartaoParaPagamento.getCliente() != null
                            && !cartaoParaPagamento.getCliente().getId().equals(clienteAutenticado.getId())) {
                        throw new ForbiddenException("Este cartão não pertence ao usuário autenticado.");
                    }
                }
                else if (dto.novoCartao() != null) {
    
    String numeroCartaoInput = dto.novoCartao().numeroCartao();

    // 1. Busca se o cartão já existe no banco
    Cartao cartaoExistenteNoBanco = cartaoRepository.find("numeroCartao", numeroCartaoInput).firstResult();

    if (cartaoExistenteNoBanco != null) {
        
        // CENÁRIO A: Cartão existe, mas é de OUTRA PESSOA (Bloqueia)
        if (!cartaoExistenteNoBanco.getCliente().getId().equals(clienteAutenticado.getId())) {
            throw new ForbiddenException("Este cartão já está associado a outra conta.");
        } 
        
        // CENÁRIO B: Cartão existe e é DO MESMO DONO (Reutiliza)
        else {
            // Não salvamos um novo. Usamos o que já está no banco.
            cartaoParaPagamento = cartaoExistenteNoBanco;
        }

    } else {
        // CENÁRIO C: Cartão não existe (Cria Novo)
        Cartao novo = new Cartao();
        novo.setNomeImpresso(dto.novoCartao().nomeImpresso());
        novo.setNumeroCartao(numeroCartaoInput); 
        novo.setValidade(dto.novoCartao().validadeCartao()); 
        novo.setCvv(dto.novoCartao().cvv());
        
        novo.setCliente(clienteAutenticado);
        
        cartaoRepository.persist(novo);
        cartaoParaPagamento = novo;
    }
                } else {
                    throw new BadRequestException(
                            "Para pagamento com cartão, informe o idCartao ou os dados de um novoCartao.");
                }

                // Cria o registro de Pagamento vinculado aos dados do cartão
                Cartao pagamentoCartao = new Cartao();

                // Vamos assumir que você quer salvar os dados históricos do pagamento:
                pagamentoCartao.setNomeImpresso(cartaoParaPagamento.getNomeImpresso());
                pagamentoCartao.setNumeroCartao(cartaoParaPagamento.getNumeroCartao());
                pagamentoCartao.setValidade(cartaoParaPagamento.getValidadeCartao());
                pagamentoCartao.setCvv(cartaoParaPagamento.getCvv());

                pagamentoEntity = pagamentoCartao;
                cartaoVinculadoAoPedido = cartaoParaPagamento; // Guarda a referência para setar no Pedido
                break;

            default:
                throw new BadRequestException("Tipo de pagamento inválido: " + tipoPagamento);
        }

    // Dados Comuns a todos os pagamentos
    pagamentoEntity.setValor(total);pagamentoEntity.setDataPagamento(LocalDateTime.now());

    // Persistir e Vincular
    pagamentoRepository.persist(pagamentoEntity);pedido.setPagamento(pagamentoEntity);

    // Se houve uso de cartão, vincula a entidade Cartão ao Pedido (Chave
    // Estrangeira)
    if(cartaoVinculadoAoPedido!=null)

    {
        pedido.setCartao(cartaoVinculadoAoPedido);
    }

    pedidoRepository.persist(pedido);

    return PedidoResponse.fromEntity(pedido);
    }

    @Override
    @Transactional
    public List<PedidoResponse> findAll() {
        List<Pedido> pedidos = pedidoRepository.listAll();
        return pedidos.stream()
                .map(PedidoResponse::fromEntity)
                .toList();
    }

    @Override
    @Transactional
    public PedidoResponse findById(Long id) {
        Pedido pedido = pedidoRepository.findByIdOptional(id)
                .orElseThrow(() -> new NotFoundException("Pedido não encontrado com id: " + id));
        return PedidoResponse.fromEntity(pedido);
    }

    @Override
    @Transactional
    public PedidoResponse delete(Long id) {
        Pedido pedido = pedidoRepository.findByIdOptional(id)
                .orElseThrow(() -> new NotFoundException("Pedido não encontrado com id: " + id));

        PedidoResponse resposta = PedidoResponse.fromEntity(pedido);
        pedidoRepository.delete(pedido);
        return resposta;
    }

    @Override
    @Transactional
    public PedidoResponse update(Long id, PedidoRequest dto) {
        Pedido pedido = pedidoRepository.findByIdOptional(id)
                .orElseThrow(() -> new NotFoundException("Pedido não encontrado com id: " + id));

        pedido.setNomeClienteSnapshot(dto.nomeCliente());
        return PedidoResponse.fromEntity(pedido);
    }

    @Override
    public List<PedidoResponse> MeusPedidos() {
        String idUsuarioKeycloak = jwt.getSubject();
        List<Pedido> pedidosDoUsuario = pedidoRepository.findByUsuarioId(idUsuarioKeycloak);
        return pedidosDoUsuario.stream()
                .map(PedidoResponse::fromEntity)
                .toList();
    }

    @Override
    @Transactional
    public void realizarPedido(PedidoRequest pedidoRequest) {
        throw new BadRequestException("Use o endpoint create padrão.");
    }
}