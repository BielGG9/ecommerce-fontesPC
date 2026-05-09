package gabriel.fontes.br.quarkus.Service;

public record ArquivoDownload(
    byte[] content,
    String contentType,
    String fileName
) { }
