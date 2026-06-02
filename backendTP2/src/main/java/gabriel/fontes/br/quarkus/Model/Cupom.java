package gabriel.fontes.br.quarkus.Model;

import io.quarkus.hibernate.orm.panache.PanacheEntity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;

@Entity
@Table(name = "cupom")
public class Cupom extends PanacheEntity {

    @Column(unique = true)
    private String codigo;

    private Double porcentagem;

    private Boolean ativo;

    public Cupom() {
    }

    public Cupom(String codigo, Double porcentagem, Boolean ativo) {
        this.codigo = codigo;
        this.porcentagem = porcentagem;
        this.ativo = ativo;
    }

    public String getCodigo() {
        return codigo;
    }

    public void setCodigo(String codigo) {
        this.codigo = codigo;
    }

    public Double getPorcentagem() {
        return porcentagem;
    }

    public void setPorcentagem(Double porcentagem) {
        this.porcentagem = porcentagem;
    }

    public Boolean getAtivo() {
        return ativo;
    }

    public void setAtivo(Boolean ativo) {
        this.ativo = ativo;
    }
}
