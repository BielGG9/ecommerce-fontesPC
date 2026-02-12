package gabriel.fontes.br.quarkus.Model.Abstratc;

import jakarta.persistence.Entity;
import jakarta.persistence.PrimaryKeyJoinColumn;

@Entity
@PrimaryKeyJoinColumn(name = "id") // Liga esta tabela à tabela Pessoa pelo ID
public abstract class PessoaJuridica extends Pessoa {
    private String cnpj;
    private String inscricaoEstadual;

    public String getCnpj() { return cnpj; }
    public void setCnpj(String cnpj) { this.cnpj = cnpj; }
    public String getInscricaoEstadual() { return inscricaoEstadual; }
    public void setInscricaoEstadual(String inscricaoEstadual) { this.inscricaoEstadual = inscricaoEstadual; }
}