package gabriel.fontes.br.quarkus.Model;

import gabriel.fontes.br.quarkus.Model.Abstratc.Pagamento;
import jakarta.persistence.Entity;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

@Entity
@Table(name = "cartao") 
public class Cartao extends Pagamento{
    
    private String numeroCartao;
    private String nomeImpresso;
    private String validadeCartao;
    private String cvv;

    @ManyToOne
    @JoinColumn(name = "id_cliente")
    private Cliente cliente;

    public Cartao() {
    }

    public String getNumeroCartao() {
        return numeroCartao;
    }

    public void setNumeroCartao(String numeroCartao) {
        this.numeroCartao = numeroCartao;
    }

    public String getNomeImpresso() {
        return nomeImpresso;
    }

    public void setNomeImpresso(String nomeImpresso) {
        this.nomeImpresso = nomeImpresso;
    }

    public String getValidadeCartao() {
        return validadeCartao;
    }

    public void setValidade(String validadeCartao) {
        this.validadeCartao = validadeCartao;
    }

    public String getCvv() {
        return cvv;
    }

    public void setCvv(String cvv) {
        this.cvv = cvv;
    }

    public Cliente getCliente() { 
        return cliente; 
    }

    public void setCliente(Cliente cliente) { 
        this.cliente = cliente; 
    }

}
