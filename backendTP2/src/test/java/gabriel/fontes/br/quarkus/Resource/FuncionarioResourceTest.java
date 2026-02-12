package gabriel.fontes.br.quarkus.Resource;

import io.quarkus.test.junit.QuarkusTest;
import io.quarkus.test.security.TestSecurity;
import io.restassured.http.ContentType;
import org.junit.jupiter.api.Test;

import gabriel.fontes.br.quarkus.Dto.FuncionarioRequest;

import static io.restassured.RestAssured.given;
import static org.hamcrest.CoreMatchers.is;
import static org.hamcrest.Matchers.greaterThan;
import static org.hamcrest.Matchers.notNullValue;

@QuarkusTest
@TestSecurity(user = "testUser", roles = {"ADM", "USER"})
public class FuncionarioResourceTest {

    private static final Long EXISTING_FUNCIONARIO_ID = 3L; 
    private static final Long NON_EXISTING_FUNCIONARIO_ID = 999L;
    
    // Usamos o ID 2 (TI) do import.sql para o departamento
    private static final String ID_DEPARTAMENTO_VALIDO = "2"; 

    // O MÉTODO @BeforeAll FOI REMOVIDO PARA EVITAR ERROS DE CONEXÃO

    @Test
    public void testFindAllEndpoint() {
        given()
                .when().get("/funcionarios")
                .then()
                .statusCode(200)
                .body("size()", greaterThan(0));
    }

    @Test
    public void testFindByIdEndpointFound() {
        given()
                .pathParam("id", EXISTING_FUNCIONARIO_ID)
                .when().get("/funcionarios/{id}")
                .then()
                .statusCode(200)
                .body("nome", is("Ana Dev")); 
    }

    @Test
    public void testCreateEndpoint() {
        FuncionarioRequest requestDto = new FuncionarioRequest(
                "Func Teste Create", "func.create@email.com", "777.888.999-00", "7654321 SSP/BA", "Analista Jr", ID_DEPARTAMENTO_VALIDO
        );

        given()
                .contentType(ContentType.JSON)
                .body(requestDto)
                .when().post("/funcionarios")
                .then()
                .statusCode(201)
                .body("cargo", is("Analista Jr"))
                .body("departamento", is("Tecnologia")); // O ID 2 é 'Tecnologia'
    }

    @Test
    public void testUpdateEndpoint() {
        FuncionarioRequest createDto = new FuncionarioRequest("Antes Update", "antes@func.com", "111", "111", "Cargo Antigo", ID_DEPARTAMENTO_VALIDO);
        var postResponse = given().contentType(ContentType.JSON).body(createDto).when().post("/funcionarios").then().statusCode(201).extract().response();
        Long idToUpdate = postResponse.jsonPath().getLong("id");

        FuncionarioRequest updateDto = new FuncionarioRequest(
                "Func Teste Update", "func.update@email.com", "222.333.444-55", "1231231 SSP/MG", "Analista Pleno", ID_DEPARTAMENTO_VALIDO
        );

        given()
                .contentType(ContentType.JSON)
                .body(updateDto)
                .pathParam("id", idToUpdate)
                .when().put("/funcionarios/{id}")
                .then()
                .statusCode(200)
                .body("nome", is("Func Teste Update"));
    }

    @Test
    public void testDeleteEndpoint() {
         FuncionarioRequest createDto = new FuncionarioRequest("Func Delete", "delete@func.com", "333", "333", "Cargo Delete", ID_DEPARTAMENTO_VALIDO);
         var response = given()
                            .contentType(ContentType.JSON)
                            .body(createDto)
                            .when().post("/funcionarios")
                            .then()
                            .statusCode(201)
                            .extract().response();
         Long idToDelete = response.jsonPath().getLong("id");

        given()
                .pathParam("id", idToDelete)
                .when().delete("/funcionarios/{id}")
                .then()
                .statusCode(200);
    }
}