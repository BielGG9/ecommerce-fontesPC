package gabriel.fontes.br.quarkus.Dto;

import gabriel.fontes.br.quarkus.Model.Fonte;
import gabriel.fontes.br.quarkus.Model.Enums.Certificacao;

public class FonteResponse {
    private Long id;
    private String nome;
    private Integer potencia;
    private double preco;
    private Integer estoque;
    private String marca;
    private Long idMarca;
    private Long idModelo;
    private Certificacao certificacao;
    private java.util.List<Long> idFornecedores;
    private java.util.List<ArquivoResponse> imagens;

    public FonteResponse() {}

    public FonteResponse(
        Long id,
        String nome,
        Integer potencia,
        double preco,
        Integer estoque,
        String marca,
        Long idMarca,
        Long idModelo,
        Certificacao certificacao,
        java.util.List<Long> idFornecedores,
        java.util.List<ArquivoResponse> imagens
    ) {
        this.id = id;
        this.nome = nome;
        this.potencia = potencia;
        this.preco = preco;
        this.estoque = estoque;
        this.marca = marca;
        this.idMarca = idMarca;
        this.idModelo = idModelo;
        this.certificacao = certificacao;
        this.idFornecedores = idFornecedores;
        this.imagens = imagens;
    }

    public static FonteResponse fromEntity(Fonte fonte) {
        java.util.List<Long> fornecedoresIds = (fonte.getFornecedores() != null)
            ? fonte.getFornecedores().stream().map(f -> f.getId()).collect(java.util.stream.Collectors.toList())
            : new java.util.ArrayList<>();

        java.util.List<ArquivoResponse> arquivosList = (fonte.getArquivos() != null)
            ? fonte.getArquivos().stream().map(ArquivoResponse::fromEntity).collect(java.util.stream.Collectors.toList())
            : new java.util.ArrayList<>();

        FonteResponse response = new FonteResponse();
        response.setId(fonte.getId());
        response.setNome(fonte.getNome());
        response.setPotencia(fonte.getPotencia());
        response.setPreco(fonte.getPreco());
        response.setEstoque(fonte.getEstoque());
        response.setMarca(fonte.getModelo().getMarca().getNome());
        response.setIdMarca(fonte.getModelo().getMarca().getId());
        response.setIdModelo(fonte.getModelo().getId());
        response.setCertificacao(fonte.getCertificacao());
        response.setIdFornecedores(fornecedoresIds);
        response.setImagens(arquivosList);

        return response;
    }

    // Getters e Setters padrão
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public Integer getPotencia() {
        return potencia;
    }

    public void setPotencia(Integer potencia) {
        this.potencia = potencia;
    }

    public double getPreco() {
        return preco;
    }

    public void setPreco(double preco) {
        this.preco = preco;
    }

    public Integer getEstoque() {
        return estoque;
    }

    public void setEstoque(Integer estoque) {
        this.estoque = estoque;
    }

    public String getMarca() {
        return marca;
    }

    public void setMarca(String marca) {
        this.marca = marca;
    }

    public Long getIdMarca() {
        return idMarca;
    }

    public void setIdMarca(Long idMarca) {
        this.idMarca = idMarca;
    }

    public Long getIdModelo() {
        return idModelo;
    }

    public void setIdModelo(Long idModelo) {
        this.idModelo = idModelo;
    }

    public Certificacao getCertificacao() {
        return certificacao;
    }

    public void setCertificacao(Certificacao certificacao) {
        this.certificacao = certificacao;
    }

    public java.util.List<Long> getIdFornecedores() {
        return idFornecedores;
    }

    public void setIdFornecedores(java.util.List<Long> idFornecedores) {
        this.idFornecedores = idFornecedores;
    }

    public java.util.List<ArquivoResponse> getImagens() {
        return imagens;
    }

    public void setImagens(java.util.List<ArquivoResponse> imagens) {
        this.imagens = imagens;
    }

    // Métodos de compatibilidade (estilo Record)
    public Long id() {
        return this.id;
    }

    public String nome() {
        return this.nome;
    }

    public Integer potencia() {
        return this.potencia;
    }

    public double preco() {
        return this.preco;
    }

    public Integer estoque() {
        return this.estoque;
    }

    public String marca() {
        return this.marca;
    }

    public Long idMarca() {
        return this.idMarca;
    }

    public Long idModelo() {
        return this.idModelo;
    }

    public Certificacao certificacao() {
        return this.certificacao;
    }

    public java.util.List<Long> idFornecedores() {
        return this.idFornecedores;
    }

    public java.util.List<ArquivoResponse> imagens() {
        return this.imagens;
    }
}