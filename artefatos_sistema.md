# Artefatos do Sistema - E-commerce de Fontes PC

Com base na estrutura atual percebida tanto no back-end (entidades, enumeradores e relações do banco) quanto no front-end (crud administrativos web implementados), formalizei este documento contendo os principais achados. Ele detalha todas as operações já suportadas e previstas pelo domínio mapeado.

---

## 1. Requisitos Funcionais

A especificação indica o que o sistema E-commerce deve fazer. Os requisitos foram divididos entre operações de administração da loja (Backoffice) e operações da Loja (Storefront).

### Módulo de Backoffice (Administrativo)
*   **RF01 - Gestão de Fontes:** O sistema deve permitir aos administradores o cadastro, edição, visualização e remoção (CRUD) de fontes de alimentação para computador, contendo detalhes como preço, potência, stock, modelo, marca e certificação.
*   **RF02 - Gestão de Fornecedores:** O sistema deve permitir o registo e a manutenção de fornecedores de componentes (CRUD com nome, razão social, CNPJ e Inscrição Estadual).
*   **RF03 - Associação Fonte-Fornecedor:** Uma mesma Fonte pode ser providenciada por múltiplos fornecedores, logo, o sistema deve permitir gerir essa lista associativa.
*   **RF04 - Gestão de Funcionários:** O sistema deve permitir criar gerenciar as fichas de funcionários, controlando o seu cargo, data de admissão e informações pessoais (CPF, RG e E-mail).
*   **RF05 - Gestão de Departamentos:** O sistema deve permitir categorizar os funcionários pelas suas áreas corporativas através do CRUD de Departamentos.
*   **RF06 - Gestão de Modelos e Marcas:** A aplicação dita que as fontes têm um relacionamento com um `Modelo`, e um modelo com uma `Marca`. O sistema garante o CRUD separadamente para organizar a estrutura do catálogo.
*   **RF07 - Paginação e Consulta:** Em todos os registos listados acima, o sistema deve oferecer buscas rápidas por nome/título, de preferência de forma paginada para poupar o carregamento de dados.

### Módulo Frontoffice (Loja e Clientes)
*   **RF08 - Gestão de Clientes:** O sistema deve permitir o cadastro de novos perfis para compra, convertendo Utilizadores em perfil Cliente.
*   **RF09 - Realização de Pedido:** O sistema deve permitir que um Cliente realize compras compondo um carrinho convertido num Objeto Pedido. Esse Pedido guarda dados do frete (Endereço de Entrega), do valor total, de quem comprou e do estado atual (novo, aguardando pagamento, processando etc.).
*   **RF10 - Gestão do Carrinho/Itens de Pedido:** O pedido deve conseguir agrupar múltiplos relatórios quantificáveis na base de uma peça para compor o total (ItemPedido guardando unidades x preço de prateleira).
*   **RF11 - Gestão de Pagamentos:** O sistema deve dar a capacidade de o cliente pagar via múltiplas abstrações como BOLETO, PIX e CARTAO.

---

## 2. Diagrama de Classes
Diagrama construído segundo o código Java encontrado na estrutura das entidades:

```mermaid
classDiagram
    class DefaultEntity {
        <<MappedSuperclass>>
        +Long id
    }
    class Pessoa {
        <<MappedSuperclass>>
        +String nome
        +String email
        +List~Telefone~ telefones
    }
    class PessoaFisica {
        <<MappedSuperclass>>
        +String cpf
        +String rg
    }
    DefaultEntity <|-- Pessoa
    Pessoa <|-- PessoaFisica
    
    PessoaFisica <|-- Cliente
    class Cliente {
        +LocalDateTime dataCadastro
    }
    
    PessoaFisica <|-- Funcionario
    class Funcionario {
        +String cargo
        +LocalDateTime dataAdmissao
    }
    
    class Departamento {
        +String sigla
        +String descricao
    }
    Funcionario "N" --> "1" Departamento : locadoEm

    Pessoa <|-- Fornecedor
    class Fornecedor {
        +String cnpj
        +String razaoSocial
        +String inscricaoEstadual
    }
    
    class Marca {
        +String nome
    }
    
    class Modelo {
        +String numeracao
    }
    Modelo "N" --> "1" Marca : refMarc
    
    class Fonte {
        +String nome
        +Integer potencia
        +Double preco
        +Integer estoque
        +Certificacao certificacao
    }
    DefaultEntity <|-- Fonte
    Fonte "N" --> "1" Modelo : modeloDaFonte
    Fonte "N" --> "N" Fornecedor : fornecidaPor
    
    class Pedido {
        +LocalDateTime data
        +Double total
        +String idUsuario
        +StatusPedido status
    }
    DefaultEntity <|-- Pedido
    Pedido "N" --> "1" Cliente : realizadoPor
    
    class ItemPedido {
        +Integer quantidade
        +Double preco
    }
    DefaultEntity <|-- ItemPedido
    ItemPedido "N" --> "1" Pedido : pertenceA
    ItemPedido "N" --> "1" Fonte : refernciaProduto
    
    class Pagamento {
        <<abstract>>
    }
    Pedido "1" --> "1" Pagamento : efetuadoVia
    Pagamento <|-- Pix
    Pagamento <|-- Boleto
    Pagamento <|-- Cartao
    
    class EnderecoEntrega {
        +String cep
        +String logradouro
        +String numero
    }
    Pedido "1" --> "1" EnderecoEntrega : entregueVia
```

---

## 3. Diagrama de Caso de Uso
Abordagem das intenções do utilizador dependendo do seu perfil.

```mermaid
flowchart LR
    %% Atores Globais
    Admin((Funcionário\n/Admin))
    Cli((Cliente))
    
    %% Casos de Uso Sub-sistema Admin
    subgraph Backoffice / Configuração
        UC1([Gerenciar Fontes])
        UC2([Gerenciar Marcas e Modelos])
        UC3([Gerenciar Fornecedores])
        UC4([Gerenciar Funcionários])
        UC5([Gerenciar Departamentos])
        UC6([Consultar Relatórios])
    end
    
    %% Casos de Uso Sub-sistema Loja
    subgraph Storefront / Loja Virtual
        UC7([Navegar no Catálogo])
        UC8([Adicionar Fontes ao Carrinho])
        UC9([Realizar Fechamento / Pedido])
        UC10([Acompanhar Meus Pedidos])
        UC11([Criar Perfil / Entrar])
    end
    
    %% Relações Admin
    Admin --> UC1
    Admin --> UC2
    Admin --> UC3
    Admin --> UC4
    Admin --> UC5
    Admin --> UC6
    
    %% Relações Cliente
    Cli --> UC7
    Cli --> UC8
    Cli --> UC9
    Cli --> UC10
    Cli --> UC11
    
    %% Conexões Complexas
    UC9 -.-> |<< includes >>| UC11
    UC8 -.-> |<< extends >>| UC7
```
