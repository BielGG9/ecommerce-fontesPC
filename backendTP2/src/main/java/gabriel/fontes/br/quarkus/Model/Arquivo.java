package gabriel.fontes.br.quarkus.Model;

import gabriel.fontes.br.quarkus.Model.Abstratc.DefaultEntity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;

@Entity
public class Arquivo extends DefaultEntity {

    @Column(nullable = false, unique = true, length = 120)
    private String fid;

    @Column(nullable = false, name = "nome_original", length = 255)
    private String nomeOriginal;

    @Column(nullable = false, name = "mime_type", length = 120)
    private String mimeType;

    @Column(nullable = false, name = "tamanho_bytes")
    private Long tamanhoBytes;

    @Column(nullable = false, length = 64)
    private String sha256;

    public String getFid() {
        return fid;
    }

    public void setFid(String fid) {
        this.fid = fid;
    }

    public String getNomeOriginal() {
        return nomeOriginal;
    }

    public void setNomeOriginal(String nomeOriginal) {
        this.nomeOriginal = nomeOriginal;
    }

    public String getMimeType() {
        return mimeType;
    }

    public void setMimeType(String mimeType) {
        this.mimeType = mimeType;
    }

    public Long getTamanhoBytes() {
        return tamanhoBytes;
    }

    public void setTamanhoBytes(Long tamanhoBytes) {
        this.tamanhoBytes = tamanhoBytes;
    }

    public String getSha256() {
        return sha256;
    }

    public void setSha256(String sha256) {
        this.sha256 = sha256;
    }
}
