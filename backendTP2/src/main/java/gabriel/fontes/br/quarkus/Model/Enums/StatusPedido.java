package gabriel.fontes.br.quarkus.Model.Enums;

import com.fasterxml.jackson.annotation.JsonFormat;

@JsonFormat(shape = JsonFormat.Shape.OBJECT) 
public enum StatusPedido {
    
    PENDENTE(1L, "Pendente"),
    PAGO(2L, "Pago"),
    ENVIADO(3L, "Enviado"),
    ENTREGUE(4L, "Entregue"),
    CANCELADO(5L, "Cancelado");
    
    // Boas práticas: atributos privados e getters públicos
    private final Long id;
    private final String stts;

    // O Construtor DEVE ter o nome do Enum (StatusPedido)
    StatusPedido(Long id, String stts) {
        this.id = id;
        this.stts = stts;
    }

    public Long getId() {
        return id;
    }

    public String getStts() {
        return stts;
    }

    // Método estático para converter ID numérico -> Enum
    public static StatusPedido valueOf(Long id) {
        if (id == null) {
            return null;
        }

        for (StatusPedido status : StatusPedido.values()) {
            if (status.getId().equals(id)) {
                return status;
            }
        }
        
        throw new IllegalArgumentException("Id de Status inválido: " + id);
    }  
}