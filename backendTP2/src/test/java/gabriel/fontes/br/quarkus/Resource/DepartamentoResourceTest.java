package gabriel.fontes.br.quarkus.Resource;

import io.quarkus.test.junit.QuarkusTest;
import io.quarkus.test.security.TestSecurity;
import io.restassured.http.ContentType;
import org.junit.jupiter.api.Test;

import gabriel.fontes.br.quarkus.Dto.DepartamentoRequest;

import static io.restassured.RestAssured.given;
import static org.hamcrest.CoreMatchers.is;
import static org.hamcrest.Matchers.greaterThan;

@QuarkusTest
@TestSecurity(user = "testUser", roles = {"ADM", "USER"})
public class DepartamentoResourceTest {

    // Helper para criar DTO rápido
    private DepartamentoRequest criarDto(String sigla) {
        return new DepartamentoRequest(sigla, "Departamento Teste " + sigla, "ATIVO");
    }

    @Test
    public void testFindAllEndpoint() {
        // Garante que tem pelo menos um antes de listar
        given()
            .contentType(ContentType.JSON)
            .body(criarDto("ALL"))
            .when().post("/departamentos")
            .then().statusCode(201);

        given()
            .when().get("/departamentos")
            .then()
            .statusCode(200)
            .body("size()", greaterThan(0));
    }

    @Test
    public void testFindByIdEndpointFound() {
        // 1. Cria um departamento novo
        Integer idCriado = given()
            .contentType(ContentType.JSON)
            .body(criarDto("FIND"))
            .when().post("/departamentos")
            .then()
            .statusCode(201)
            .extract().path("id");

        // 2. Busca pelo ID gerado (sem usar ID fixo 1L)
        given()
            .pathParam("id", idCriado)
            .when().get("/departamentos/{id}")
            .then()
            .statusCode(200)
            .body("id", is(idCriado))
            .body("sigla", is("FIND"));
    }

    @Test
    public void testCreateEndpoint() {
        DepartamentoRequest requestDto = new DepartamentoRequest("MKT", "Departamento de Marketing", "ATIVO");

        given()
            .contentType(ContentType.JSON)
            .body(requestDto)
            .when().post("/departamentos")
            .then()
            .statusCode(201)
            .body("sigla", is("MKT"));
    }

    @Test
    public void testUpdateEndpoint() {
        // 1. Cria primeiro
        Integer idParaAtualizar = given()
            .contentType(ContentType.JSON)
            .body(criarDto("UPD-BEFORE"))
            .when().post("/departamentos")
            .then()
            .statusCode(201)
            .extract().path("id");

        // 2. Atualiza
        DepartamentoRequest requestDto = new DepartamentoRequest("VND-UPD", "Vendas Atualizado", "INATIVO");

        given()
            .contentType(ContentType.JSON)
            .body(requestDto)
            .pathParam("id", idParaAtualizar)
            .when().put("/departamentos/{id}")
            .then()
            .statusCode(200)
            .body("sigla", is("VND-UPD"));
    }

    @Test
    public void testDeleteEndpoint() {
        // 1. Cria
        DepartamentoRequest createDto = new DepartamentoRequest("DEL", "Deletar", "ATIVO");
        Integer idToDelete = given()
            .contentType(ContentType.JSON)
            .body(createDto)
            .when().post("/departamentos")
            .then()
            .statusCode(201)
            .extract().path("id");

        // 2. Deleta
        given()
            .pathParam("id", idToDelete)
            .when().delete("/departamentos/{id}")
            .then()
            .statusCode(204); 
    }
}