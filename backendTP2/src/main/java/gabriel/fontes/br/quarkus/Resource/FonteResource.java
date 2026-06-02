package gabriel.fontes.br.quarkus.Resource;

import gabriel.fontes.br.quarkus.Service.FonteService;
import gabriel.fontes.br.quarkus.Dto.FonteRequest;
import gabriel.fontes.br.quarkus.Dto.FonteResponse;
import jakarta.annotation.security.PermitAll;
import jakarta.annotation.security.RolesAllowed;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;

@Path("/fontes")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class FonteResource {

    @Inject
    FonteService service;

    private static final Logger logger = Logger.getLogger(FonteResource.class.getName());

    @POST
    @Transactional
    @RolesAllowed("ADM")
    public Response cadastrarFonte(FonteRequest fonteRequest) {
        FonteResponse fonteCriada = service.create(fonteRequest);
        logger.info("Fonte criada: " + fonteCriada.id());
        return Response.status(Response.Status.CREATED).entity(fonteCriada).build();
    }

    @GET
    @PermitAll
    public Response findAll(
        @QueryParam("page") @DefaultValue("1") int page,
        @QueryParam("pageSize") @DefaultValue("12") int pageSize,
        @QueryParam("nome") String nome,
        @QueryParam("marca") Long idMarca,
        @QueryParam("categoria") String categoria) {

        List<FonteResponse> fontes = service.findAll(
            page, pageSize, nome, idMarca, categoria);
        long total = service.count(nome, idMarca, categoria);

        Map<String, Object> response = new HashMap<>();
        response.put("items", fontes);
        response.put("total", total);
        response.put("page", page);
        response.put("pageSize", pageSize);

        return Response.ok(response)
                .header("Cache-Control", "no-cache, no-store, must-revalidate")
                .header("Pragma", "no-cache")
                .header("Expires", "0")
                .build();
    }

    @GET
    @Path("/count")
    @PermitAll
    public Response count(@QueryParam("nome") String nome,
                          @QueryParam("marca") Long idMarca,
                          @QueryParam("categoria") String categoria) {
        long total = service.count(nome, idMarca, categoria);
        logger.info("Contando fontes (Busca: " + nome + ", Marca: " + idMarca + ", Categoria: " + categoria + ") - Total: " + total);
        return Response.ok(total).build();
    }

    @GET
    @Path("/certificacoes")
    @PermitAll
    public Response getCertificacoes() {
        logger.info("Buscando todas as certificações");
        return Response.ok(service.getCertificacoes()).build();
    }

    @GET
    @Path("/{id}")
    @PermitAll
    public Response findById(@PathParam("id") Long id) {
        FonteResponse fonte = service.findById(id);
        logger.info("Buscando fonte pelo ID: " + id);
        return Response.ok(fonte)
                .header("Cache-Control", "no-cache, no-store, must-revalidate")
                .header("Pragma", "no-cache")
                .header("Expires", "0")
                .build();
    }

    @DELETE
    @Path("/{id}")
    @Transactional
    @RolesAllowed("ADM")
    public Response delete(@PathParam("id") Long id) {
        FonteResponse fonteDeletada = service.delete(id);
        logger.info("Fonte deletada: " + fonteDeletada.id());
        return Response.ok(fonteDeletada).build();
    }

    @PUT
    @Path("/{id}")
    @Transactional
    @RolesAllowed("ADM")
    public Response update(@PathParam("id") Long id, FonteRequest fonteRequest) {
        FonteResponse fonteAtualizada = service.update(id, fonteRequest);
        logger.info("Fonte atualizada: " + fonteAtualizada.id());
        return Response.ok(fonteAtualizada).build();
    }

    @Inject
    gabriel.fontes.br.quarkus.Service.FileService fileService;

    @GET
    @Path("/image/download/{fid}")
    @Produces(MediaType.APPLICATION_OCTET_STREAM)
    @PermitAll
    public Response downloadImage(@PathParam("fid") String fid) {
        gabriel.fontes.br.quarkus.Service.ArquivoDownload download = fileService.download(fid);
        Response.ResponseBuilder response = Response.ok(download.content(), download.contentType());
        response.header("Content-Disposition", "attachment; filename=\"" + download.fileName().replace("\"", "") + "\"");
        return response.build();
    }

    @PATCH
    @Path("/image/upload")
    @Consumes(MediaType.MULTIPART_FORM_DATA)
    @RolesAllowed("ADM")
    public Response salvarImagem(
            @org.jboss.resteasy.reactive.RestForm("idFonte") 
            Long idFonte,
            @org.jboss.resteasy.reactive.RestForm("file") 
            org.jboss.resteasy.reactive.multipart.FileUpload file) {

        if (idFonte == null || file == null) {
            return Response.status(Response.Status.BAD_REQUEST).entity("idFonte ou arquivo ausente").build();
        }

        try {
            fileService.salvar(idFonte, file);
            return Response.noContent().build();
        } catch (java.io.IOException e) {
            return Response.status(Response.Status.CONFLICT).entity("Erro ao salvar o arquivo.").build();
        }
    }

    @DELETE
    @Path("/image/{fid}")
    @RolesAllowed("ADM")
    public Response removerImagem(@PathParam("fid") String fid) {
        fileService.remover(fid);
        return Response.noContent().build();
    }
}