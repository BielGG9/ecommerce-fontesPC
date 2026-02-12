package gabriel.fontes.br.quarkus.Model.Jpa;

import gabriel.fontes.br.quarkus.Model.Enums.StatusPedido;
import jakarta.persistence.AttributeConverter;
import jakarta.persistence.Converter;


@Converter(autoApply = true)
public class StatusPedidoConverter implements AttributeConverter<StatusPedido, Long> {

    @Override
    public Long convertToDatabaseColumn(StatusPedido statusPedido) {
        if (statusPedido == null) {
            return null;
        }
        return statusPedido.getId(); 
        
    }

    @Override
    public StatusPedido convertToEntityAttribute(Long id) {
        if (id == null) {
            return null;
        }
        return StatusPedido.valueOf(id);
    }
}