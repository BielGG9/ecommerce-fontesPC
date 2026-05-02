# E-commerce Fontes PC - Documentação do Sistema

Esta documentação foi elaborada baseada **exclusivamente nas funcionalidades e lógicas atualmente implementadas** no código-fonte (.java, .ts) do front-end e back-end do sistema. 

---

## 1. Requisitos Funcionais (RF)

Abaixo estão listadas as funcionalidades core desenvolvidas e operacionais no sistema. Elas respeitam a estrutura de paginação de back-end com busca dinâmica.

### 1.1 Controle de Acesso e Perfil de Usuários
- **RF01 - Cadastro de Clientes:** O sistema permite que novos visitantes se registrem, fornecendo nome, e-mail validado, senha forte, RG e CPF (tratando o Cliente como uma extensão/herança de Pessoa).
- **RF02 - Autenticação e Autorização:** O sistema possui integração com arquitetura JWT de autenticação. Usuários autenticam recebendo Tokens com funções baseadas em cargos (ex: Admin vs Cliente). 

### 1.2 Backoffice Administrativo (CRUDS ADM)
*Acesso restrito apenas aos Administradores do e-commerce.*
- **RF03 - Gerenciar Marcas:** O administrador pode Adicionar, Editar, Deletar e Consultar os fabricantes através de painel paginado.
- **RF04 - Gerenciar Modelos:** O administrador manipula os modelos de fontes conectando a cardinalidade (N:1) obrigatoriamente a uma Marca existente.
- **RF05 - Gerenciar Fontes:** CRUD central do Catálogo. O ADM cria Fontes atribuindo Preço, Estoque, Enumeração de Certificações, Modelo atrelado e seleção múltipla de Fornecedores daquela fonte (N:N).
- **RF06 - Gerenciar Departamentos:** Inserção e manutenção departamental interna.
- **RF07 - Gerenciar Fornecedores:** Gerenciar parceiros logísticos B2B com CNPJ (Herança Pessoa Jurídica).
- **RF08 - Gerenciar Funcionários:** Cadastro da folha com associação (1:N) ao seu respectivo Departamento.

### 1.3 Vitrine e Compras (Jornada do Cliente)
- **RF09 - Navegação na Vitrine:** Qualquer visitante acessa a vitrine em tempo real observando detalhes da fonte listada e se o estoque está zerado/esgotado ou não.
- **RF10 - Modulação de Carrinho:** O cliente pode adicionar produtos ao carrinho virtual e observar incrementos através dos Services isolados com Signal do Angular, decrementando virtualmente o alerta estoque conforme simula reservas.


---

## 2. Diagrama de Classes

Representação oficial das lógicas orientadas a objetos, isolando Heranças (Extends), Associações (N:N, 1:N) e Composições atualmente operantes nas models.

```mermaid
classDiagram
    %% Agrupamento Autenticação e Perfis (Herança)
    class Pessoa {
        <<abstract>>
        -String nome
        -String email
        -String idKeycloak
    }

    class PessoaFisica {
        <<abstract>>
        -String cpf
        -String rg
    }

    class PessoaJuridica {
        <<abstract>>
        -String cnpj
        -String inscricaoEstadual
    }

    class Fornecedor {
        -String razaoSocial
    }

    class Cliente {
        -LocalDate dataCadastro
    }

    class Funcionario {
        -String cargo
        -LocalDate dataAdmissao
    }

    class Departamento {
        -String sigla
        -String descricao
    }

    %% Relacionamentos de Pessoas
    Pessoa <|-- PessoaFisica
    Pessoa <|-- PessoaJuridica
    PessoaFisica <|-- Cliente
    PessoaFisica <|-- Funcionario
    PessoaJuridica <|-- Fornecedor
    Departamento "1" <-- "n" Funcionario : trabalha_em

    %% Agrupamento Vitrine
    class Marca {
        -String nome
    }

    class Modelo {
        -String numeracao
    }

    class Fonte {
        -String nome
        -Double preco
        -Integer potencia
        -Integer estoque
        -Certificacao certificacao
    }

    %% Relacionamentos Produto
    Marca "1" <-- "n" Modelo : associado_a
    Modelo "1" <-- "n" Fonte : construida_por
    Fornecedor "n" <-- "n" Fonte : fornecida_por

    %% Carrinho e Transacionais
    class Pedido {
        -LocalDateTime dataHora
        -Double valorTotal
        -Enum StatusPedido
    }

    class ItemPedido {
        -Integer quantidade
        -Double precoUnitario
        -Double subTotal
    }

    %% Composições e Associações de compra
    Cliente "1" <-- "n" Pedido : realiza
    Pedido "1" *-- "n" ItemPedido : composto_por
    ItemPedido "n" <-- "1" Fonte : referenciam
```

---

## 3. Diagrama de Casos de Uso

Mapeamento de quem interage com quais barreiras no ecossistema (Baseado no `AuthGuard` ativo que roteia usuários normais e admins separadamente).

```mermaid
flowchart LR
    %% Atores
    Visitante(((Visitante Anônimo)))
    ClienteActor(((Cliente Autenticado)))
    Admin(((Administrador)))

    %% Casos de Navegação Pública
    UC1([Visualizar Vitrine])
    UC2([Adicionar ao Carrinho])
    UC3([Acessar Login])
    UC4([Criar Cadastro])

    Visitante --> UC1
    Visitante --> UC2
    Visitante --> UC3
    Visitante --> UC4

    %% Casos de Checkout
    ClienteActor -.->|Herda privilégios| Visitante
    UC5([Realizar Checkout])
    UC6([Consultar Pedidos])
    
    ClienteActor --> UC5
    ClienteActor --> UC6

    %% Casos de Backoffice ADM
    UC7([Gerenciar Marcas])
    UC8([Gerenciar Modelos])
    UC9([Gerenciar Fontes])
    UC10([Gerenciar Fornecedores])
    UC11([Gerenciar Departamentos])
    UC12([Gerenciar Funcionários])

    Admin --> UC7
    Admin --> UC8
    Admin --> UC9
    Admin --> UC10
    Admin --> UC11
    Admin --> UC12
    
    %% Inclusões Obrigatórias
    JWT([Validação JWT do Backend])
    UC9 -.->|include| JWT
    UC5 -.->|include| JWT
```

> [!NOTE] 
> O modelo respeita à risca o fato de que toda a camada transacional de `Pedidos` em andamento está contruída (DTOs feitos, Models fechadas com Composição para os `ItensPedidos`) embora a tela gráfica para listagem dos pedidos dependa do avanço do módulo de pagamento nos próximos ciclos.
