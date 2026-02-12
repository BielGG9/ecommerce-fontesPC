package gabriel.fontes.br.quarkus.Model;

import gabriel.fontes.br.quarkus.Model.Abstratc.DefaultEntity;
import jakarta.persistence.Entity;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

@Entity
@Table(name = "modelo")
public class Modelo  extends DefaultEntity {
    
    private int numeracao;
    // Relação Muitos-para-Um com Marca
    @ManyToOne(optional = false)
    private Marca marca;

    public Modelo () {

    }

    public Modelo(int numeracao) {
        this.numeracao = numeracao;
    }
    public int getNumeracao() {
        return numeracao;
    }
    public void setNumeracao(int numeracao){
        this.numeracao = numeracao;
    }

    public Marca getMarca() {
        return marca;
    }
    public void setMarca(Marca marca) {
        this.marca = marca;
    }
}
