# Relatório de Auditoria A2 - E-Commerce FontesPC

Abaixo está o diagnóstico completo do código atual cruzado com a lista de requisitos oficiais (A2). 

### 1. Página principal: produtos com card e filtro
🟡 **Incompleto**
- **Status:** Os cards de produtos foram implementados e a vitrine exibe os itens corretamente consumindo a API. O botão de adicionar ao carrinho também está funcional.
- **Pendência:** Não há nenhum mecanismo de **filtro** (nem no HTML, nem lógica no `HomeComponent`) para buscar por nome, marca ou categoria.

### 2. Página detalhe do produto: adicionar no carrinho de compras e adicionar à lista de desejos
🔴 **Não Implementado**
- **Status:** A rota para acessar os detalhes de um produto específico (`/produto/:id`) e o respectivo componente não existem. 
- **Pendência:** Criar a página com mais informações do produto e os botões de adicionar ao carrinho/lista de desejos.

### 3. Lista de desejos: o usuário deve estar logado, relacionamento n -> n
🔴 **Não Implementado**
- **Status:** O link "Favoritos" aparece no Perfil, mas a rota em `app.routes.ts` está marcada como não implementada. Também não há entidade ou recurso de "Desejo/Favorito" no backend (Quarkus).
- **Pendência:** Criar backend (tabela de relacionamento Cliente <-> Fonte), rotas e o frontend (tela de lista de desejos).

### 4. Cupom de desconto
🔴 **Não Implementado**
- **Status:** Não há nenhuma menção a "cupom" ou "desconto" no repositório inteiro (nem backend, nem front no Checkout/Carrinho).
- **Pendência:** Modelagem no banco de dados, API no Quarkus e integração na tela de Checkout.

### 5. Tela de carrinho de compras
🟢 **Concluído**
- **Status:** Implementado no `CarrinhoComponent`. Permite visualizar os itens, aumentar/diminuir quantidade e remover itens.

### 6. Tela de login (com 'Esqueceu a senha?')
🟢 **Concluído**
- **Status:** Componentes `LoginComponent` e `RecuperarSenhaComponent` criados e devidamente roteados. Integração com Keycloak ativa.

### 7. Tela de finalizar compra (selecionar o endereço, forma de pagamento)
🟡 **Incompleto**
- **Status:** O `CheckoutComponent` permite selecionar a forma de pagamento (PIX, Boleto, Cartão) e preencher um endereço.
- **Pendência:** O sistema obriga o preenchimento de um *novo endereço* a cada compra (chamando `enderecoService.create`). Falta a opção de **selecionar um endereço já existente** do perfil do usuário.

### 8. Tela de resumo da compra e finalização
🟢 **Concluído**
- **Status:** A barra lateral direita no próprio `CheckoutComponent` exibe os itens da "Sua Compra" e o valor total a pagar em tempo real, cobrindo este requisito.

### 9. Parte administrativa (CRUDs)
🟢 **Concluído**
- **Status:** Telas baseadas em Admin (Marca, Fonte, Modelo, Departamento, Funcionário, Fornecedor, Pedidos) estão implementadas com AuthGuard baseada em Role.

### 10. Upload de imagem (já iniciado)
🟢 **Concluído**
- **Status:** Os serviços de upload de imagem (`FonteFileServiceImpl`, `MarcaFileServiceImpl`) e de recuperação no frontend (`getImagemUrl` no HomeComponent) estão presentes.

### 11. Tela de cadastro de usuário, pelo usuário (não é CRUD administrativo)
🟢 **Concluído**
- **Status:** Componente `CadastroClienteComponent` permite a criação de conta independente, integrada ao backend (`clienteService.registrar`).

### 12. Perfil do usuário logado 
🟡 **Incompleto**
- **Status:** A área "Minha Conta" gerencia Dados, Telefones, Endereços, Cartões, Histórico de Pedidos e possui a funcionalidade de "alteração no perfil mediante confirmação de senha" perfeitamente integrada.
- **Pendência:** Falta apenas a funcionalidade de **Alteração de Senha** do próprio usuário (trocar a senha atual por uma nova, estando logado).


---
**Resumo:**
* 🟢 **6 itens concluídos**
* 🟡 **3 itens incompletos / precisando de refinamentos**
* 🔴 **3 itens não implementados**
