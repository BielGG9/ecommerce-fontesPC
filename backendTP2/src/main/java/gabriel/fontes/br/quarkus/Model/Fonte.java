package gabriel.fontes.br.quarkus.Model;

import java.util.List;

import gabriel.fontes.br.quarkus.Model.Abstratc.DefaultEntity;
import gabriel.fontes.br.quarkus.Model.Enums.Certificacao;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.JoinTable;
import jakarta.persistence.ManyToMany;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

@Entity
@Table(name = "fonte")
public class Fonte extends DefaultEntity {


    private String nome;

    private Integer potencia;

    private double preco;
    private Integer estoque;

    // Relação Muitos-para-Muitos com Fornecedor
    @ManyToMany
    @JoinTable(
    name = "fonte_fornecedor", 
    joinColumns = @JoinColumn(name = "fonte_id"),
    inverseJoinColumns = @JoinColumn(name = "fornecedor_id")
)
private List<Fornecedor> fornecedores;

    @ManyToOne(optional = false)
    private Modelo modelo;

    @Enumerated(EnumType.STRING)
    private Certificacao certificacao;

    public Fonte() {
    }

    public Fonte(String nome, Integer potencia, double preco, String fabricante) {
        this.nome = nome;
        this.potencia = potencia;
        this.preco = preco;
    }
    public Fonte(String nome, Integer potencia) {
        this.nome = nome;
        this.potencia = potencia;
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

    public Modelo getModelo() {
        return modelo;
    }
    public void setModelo(Modelo modelo) {
        this.modelo = modelo;
    }
   
    public Certificacao getCertificacao() {
        return certificacao;
    }
    public void setCertificacao(Certificacao certificacao) {
        this.certificacao = certificacao;
    }

    public List<Fornecedor> getFornecedores() {
        return fornecedores;
    }
    public void setFornecedores(List<Fornecedor> fornecedores) {
        this.fornecedores = fornecedores;
    }
}
