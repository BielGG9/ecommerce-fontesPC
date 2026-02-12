package gabriel.fontes.br.quarkus.Model.Enums;

import java.util.stream.Stream;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonProperty;

@JsonFormat(shape = JsonFormat.Shape.OBJECT)
public enum Certificacao {
    
    BRONZE(1, "80 Plus Bronze"),
    SILVER(2, "80 Plus Silver"),
    GOLD(3, "80 Plus Gold"),
    PLATINUM(4, "80 Plus Platinum"),
    TITANIUM(5, "80 Plus Titanium");

    @JsonProperty("id")
    private final int id;

    @JsonProperty("fontcert")
    private final String fontcert;

    Certificacao(int id, String fontcert) {
        this.id = id;
        this.fontcert = fontcert;
    }
    
    public int getId() {
        return id;
    }

    public String getFontcert() {
        return fontcert;
    }

    public static Certificacao getById(int id) {
        return Stream.of(Certificacao.values())
                .filter(c -> c.getId() == id)
                .findFirst()
                .orElseThrow(() -> new IllegalArgumentException("ID da certificação inválido: " + id));
    }
}