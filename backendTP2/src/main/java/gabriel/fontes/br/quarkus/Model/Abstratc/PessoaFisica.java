package gabriel.fontes.br.quarkus.Model.Abstratc;

import jakarta.persistence.Entity;
import jakarta.persistence.PrimaryKeyJoinColumn;

@Entity
@PrimaryKeyJoinColumn(name = "id") // Liga esta tabela à tabela Pessoa pelo ID
public abstract class PessoaFisica extends Pessoa {

    private String cpf;
    private String rg;

    public String getCpf() { return cpf; }
    public void setCpf(String cpf) { this.cpf = cpf; }
    public String getRg() { return rg; }
    public void setRg(String rg) { this.rg = rg; }
}