-- CONFIGURAÇÕES INICIAIS
-- Sequências para garantir IDs consistentes
SELECT setval('pessoa_id_seq', 10, true);
SELECT setval('departamento_id_seq', 10, true);
SELECT setval('marca_id_seq', 10, true);
SELECT setval('modelo_id_seq', 10, true);
SELECT setval('enderecos_id_seq', 10, true);
SELECT setval('telefones_id_seq', 10, true);
SELECT setval('fonte_id_seq', 10, true);
-- Reseta as sequências de pedido para começar do 1 quando você criar via API
SELECT setval('pedido_id_seq', 1, false);
SELECT setval('item_pedido_id_seq', 1, false);
SELECT setval('cartao_id_seq', 10, true);


-- 1. PRODUTOS (MARCA, MODELO, FONTE)
INSERT INTO marca(id, nome) VALUES(1, 'Corsair'); 
INSERT INTO marca(id, nome) VALUES(2, 'Seasonic');
INSERT INTO modelo(id, numeracao, marca_id) VALUES(1, 750, 1);
INSERT INTO modelo(id, numeracao, marca_id) VALUES(2, 1000, 2); 
INSERT INTO fonte(id, nome, potencia, preco, estoque, certificacao, modelo_id) 
VALUES(1, 'RM750x', 750, 800.00, 50, 'GOLD', 1);


-- 2. DEPARTAMENTO
INSERT INTO departamento(id, sigla, descricao) VALUES (1, 'VND', 'Vendas');
INSERT INTO departamento(id, sigla, descricao) VALUES (2, 'TI', 'Tecnologia');


-- 3. PESSOAS
-- ID 1: CLIENTE (Biel) - COM O SEU ID DO KEYCLOAK
INSERT INTO Pessoa(id, nome, email, idKeycloak) VALUES (1, 'biel', 'gabrielbr1503@gmail.com', '13086ed9-96da-48f3-bf2e-ffbb9b76ef2d');
INSERT INTO PessoaFisica(id, cpf, rg) VALUES (1, '111.111.111-11', '12345 SSP/SP');
INSERT INTO Cliente(id, dataCadastro) VALUES (1, '2025-01-01T10:00:00');

-- ID 2: FORNECEDOR
INSERT INTO Pessoa(id, nome, email) VALUES (2, 'Tech Distribuidora', 'contato@tech.com');
INSERT INTO PessoaJuridica(id, cnpj, inscricaoEstadual) VALUES (2, '99.999.999/0001-99', 'ISENTO');
INSERT INTO Fornecedor(id, razaoSocial) VALUES (2, 'Tech Distribuidora Ltda');

-- ID 3: FUNCIONÁRIO
INSERT INTO Pessoa(id, nome, email) VALUES (3, 'Ana Dev', 'ana@email.com');
INSERT INTO PessoaFisica(id, cpf, rg) VALUES (3, '222.222.222-22', '54321 SSP/RJ');
INSERT INTO Funcionario(id, cargo, departamento_id, password) VALUES (3, 'Desenvolvedora', 2, 'password');


-- 4. ENDEREÇOS E TELEFONES
INSERT INTO enderecos(id, rua, numero, complemento, bairro, cidade, estado, cep, pessoa_id) 
VALUES (1, 'Rua das Flores', '10', 'Apto 1', 'Centro', 'Palmas', 'TO', '77000-000', 1);
INSERT INTO telefones(id, ddd, numero, pessoa_id) 
VALUES (1, '63', '98765-4321', 1);


-- 5. CARTÕES (Já cadastrados para você usar no teste)
INSERT INTO cartao (id, numeroCartao, nomeImpresso, validade, cvv, status, cliente_id)
VALUES (1, '1234567890123456', 'GABRIEL BIEL', '12/2029', '123', 'ATIVO', 1);

INSERT INTO cartao (id, numeroCartao, nomeImpresso, validade, cvv, status, cliente_id)
VALUES (2, '9876543210987654', 'CARTAO TESTE 2', '10/2030', '999', 'ATIVO', 1);


-- 6. RELAÇÕES
INSERT INTO fonte_fornecedor(fonte_id, fornecedor_id) VALUES (1, 2);
