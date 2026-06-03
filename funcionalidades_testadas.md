# Funcionalidades Implementadas e Testadas

Este documento resume todas as funcionalidades que o projeto E-Commerce FontesPC possui até o momento e que já foram desenvolvidas, integradas e **testadas com sucesso**.

---

## 1. Fluxo de Compra (Checkout e Carrinho)
*   **Carrinho de Compras:** Funcionamento completo para visualizar os itens adicionados, alterar a quantidade, remover itens e visualizar o cálculo do subtotal e total em tempo real.
*   **Seleção de Endereço de Entrega:** O checkout permite que o cliente selecione facilmente um endereço que já possui cadastrado no seu perfil, além de manter a opção de cadastrar um endereço novo no momento da compra.
*   **Cupons de Desconto:** Sistema robusto de cupons (ex: `DESCONTO10`, `WELCOME20`). O usuário aplica no frontend, o valor é recalculado na hora, e o backend recebe o cupom e aplica a redução com segurança ao salvar o registro final no banco de dados.
*   **Formas de Pagamento:** Suporte para seleção entre PIX, Boleto ou Cartão de Crédito. Para cartões, o usuário pode selecionar um previamente cadastrado ou inserir as informações de um novo.
*   **Resumo e Finalização:** O sistema processa o pedido completamente, vinculando os itens, o endereço escolhido, a forma de pagamento e o valor com desconto, salvando tudo de forma consistente na tabela `pedido`.

## 2. Área do Cliente (Minha Conta / Perfil)
*   **Meus Endereços:** CRUD completo integrado. O usuário pode visualizar seus endereços salvos, criar novos, editar existentes (ex: mudança de rua/número) e deletar. Todos os formulários estão testados e alinhados com o backend (campos logradouro, cep, etc).
*   **Meus Pedidos:** O cliente pode consultar todo o seu histórico. Ao expandir um pedido, ele enxerga detalhes minuciosos: lista de produtos comprados, quantidades, preços unitários e qual foi o **endereço de entrega exato** utilizado naquela compra.
*   **Alteração de Senha:** Recurso seguro para o cliente alterar sua senha de acesso a qualquer momento através do perfil. A funcionalidade está 100% integrada e validada com o provedor de identidade Keycloak.
*   **Meus Dados e Telefones:** Gerenciamento contínuo de informações pessoais (nome, CPF) e lista de telefones para contato.

## 3. Autenticação e Segurança (Keycloak)
*   **SSO (Keycloak):** A plataforma de e-commerce confia toda a autenticação, controle de sessão e tokens para o Keycloak.
*   **Cadastro e Recuperação:** Formulário público e independente (`CadastroClienteComponent`) testado e criando contas reais no backend e no Keycloak simultaneamente. Fluxos de recuperar senha e login ativos.
*   **Proteção de Rotas:** Utilização de AuthGuards nativos no Angular (`canActivateUser` e `canActivateAuthRole`) para blindar o acesso indevido às rotas de Perfil (precisa estar logado) e Admin (precisa ter role Admin/Funcionario).

## 4. Backoffice (Área Administrativa)
*   **Gestão de Cadastros:** Telas de CRUDs protegidas e operacionais para gerenciar o ecossistema da loja: Marcas, Fontes (Produtos), Modelos, Departamentos, Fornecedores e Funcionários.
*   **Upload e Exibição de Imagens:** Testado e aprovado o upload de fotos para Marcas e Fontes (Produtos). As imagens são salvas, seus nomes de arquivo persistidos, e depois servidas e exibidas com sucesso na vitrine (`HomeComponent`).

## 5. Backend Quarkus e Banco de Dados
*   **APIs REST:** Endpoints de alta performance usando RESTEasy para servir o front-end, mapeados em serviços claros (`PedidoServiceImpl`, `CupomServiceImpl`, etc).
*   **Banco de Dados Estruturado:** Integração via Panache ORM com o banco PostgreSQL. As entidades refletem heranças reais (`Pessoa` -> `Cliente`) e lidam bem com chaves estrangeiras complexas e cascades.
*   **Testabilidade:** O ambiente dev e os scripts de massa de dados iniciais (`import.sql`) proporcionam fácil teste com contas, produtos e cupons pré-fabricados.

---

### 📌 O Que Falta do Escopo Original (Próximos Passos)
De acordo com os requisitos passados, as seguintes funcionalidades ainda precisam ser implementadas futuramente:
1.  **Filtros e Buscas:** Mecanismos de pesquisa por nome/categoria na página inicial (Vitrine).
2.  **Página Detalhada de Produto:** Uma tela exclusiva para um único produto (Ex: `/produto/:id`) com mais informações e fotos.
3.  **Lista de Desejos:** Opção de favoritar produtos para acesso posterior na área Minha Conta.
