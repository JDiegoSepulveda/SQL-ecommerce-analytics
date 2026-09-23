DROP DATABASE IF EXISTS Portfolio_ecommerce;

-- Cria o banco do zero
CREATE DATABASE Portfolio_ecommerce;

-- Seleciona o banco recém-criado
USE Portfolio_ecommerce;

/* Tabela de clientes */
CREATE TABLE clientes (
    cliente_id SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    pnome VARCHAR(50) NOT NULL,
    snome VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    rank_cliente ENUM('Prata', 'Ouro', 'Diamante'),
    data_nascimento DATE NOT NULL,
    data_de_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

/* Tabela de vendedores (lojas) */
CREATE TABLE vendedores (
    vendedor_id SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nome_loja VARCHAR(100) UNIQUE NOT NULL,
    cnpj VARCHAR(18) UNIQUE NOT NULL,
    status_loja ENUM('Pendente', 'Ativa', 'Suspensa', 'Fechada') DEFAULT 'Pendente',
    categoria VARCHAR(100),
    tipo_comercio ENUM('Varejo', 'Atacado'),
    data_de_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

/* Tabela de produtos */
CREATE TABLE produtos (
    produto_id SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    vendedor_id SMALLINT UNSIGNED NOT NULL COMMENT 'ID do lojista do produto',
    nome_produto VARCHAR(150) NOT NULL COMMENT 'Denominação do produto',
    descricao TEXT COMMENT 'Descrição do produto',
    preco DECIMAL(8,2) NOT NULL CHECK (preco > 0),
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_produto_vendedor FOREIGN KEY (vendedor_id)
        REFERENCES vendedores(vendedor_id)
        ON DELETE CASCADE
);

/* Tabela de pedidos */
CREATE TABLE pedidos (
    pedido_id SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    cliente_id SMALLINT UNSIGNED NOT NULL,
    status_pedido ENUM('Pendente', 'Pago', 'Enviado', 'Entregue', 'Cancelado') DEFAULT 'Pendente',
    valor_total DECIMAL(8,2) NOT NULL CHECK (valor_total >= 0),
    data_pedido TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_pedido_cliente FOREIGN KEY (cliente_id)
        REFERENCES clientes(cliente_id)
        ON DELETE RESTRICT
);

/* Tabela de itens do pedido */
CREATE TABLE itens_pedido (
    item_id SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    pedido_id SMALLINT UNSIGNED NOT NULL,
    produto_id SMALLINT UNSIGNED NOT NULL,
    quantidade SMALLINT UNSIGNED NOT NULL CHECK (quantidade > 0),
    preco_unitario DECIMAL(8,2) NOT NULL CHECK (preco_unitario > 0),
    
    CONSTRAINT fk_item_pedido FOREIGN KEY (pedido_id)
        REFERENCES pedidos(pedido_id)
        ON DELETE CASCADE,
        
    CONSTRAINT fk_item_produto FOREIGN KEY (produto_id)
        REFERENCES produtos(produto_id)
        ON DELETE RESTRICT
);

-- Validação da estrutura de todas as tabelas
DESC clientes;
DESC vendedores;
DESC produtos;
DESC pedidos;
DESC itens_pedido;