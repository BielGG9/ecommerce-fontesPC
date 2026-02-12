package gabriel.fontes.br.quarkus.Model.Jpa;

import gabriel.fontes.br.quarkus.Model.Enums.TipoPagamento;
import jakarta.persistence.AttributeConverter;
import jakarta.persistence.Converter;

@Converter(autoApply = true)
public class TipoPagamentoConverter implements AttributeConverter<TipoPagamento, Long>{

    @Override
    public Long convertToDatabaseColumn(TipoPagamento tipoPagamento) {
        return (tipoPagamento == null) ? null : tipoPagamento.ID;
    }

    @Override
    public TipoPagamento convertToEntityAttribute(Long id) {
        return TipoPagamento.valueOf(id);
    }
    
}