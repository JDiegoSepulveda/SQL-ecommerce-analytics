USE Porfolio_ecommerce;


/* PERGUNTA 1: Quais foram os produtos e os respectivos vendedores que geraram o maior 
faturamento e volume de vendas na plataforma durante o mês de maio de 2026, considerando
apenas pedidos efetivamente pagos? 
*/
SELECT
    v.vendedor_id,
    v.nome_loja,
    SUM(ip.quantidade) total_itens_vendidos,
    SUM(ip.quantidade * ip.preco_unitario) faturamento_total,
    pro.nome_produto,
    v.categoria,
    v.data_de_cadastro
FROM vendedores v
INNER JOIN produtos pro ON v.vendedor_id = pro.vendedor_id
INNER JOIN itens_pedido ip ON pro.produto_id = ip.produto_id
INNER JOIN pedidos ped ON ped.pedido_id = ip.pedido_id
WHERE ped.data_pedido >= '2026-05-01 00:00:00' 
AND ped.data_pedido <='2026-05-31 23:59:59' 
AND ped.status_pedido = 'Pago'
GROUP BY 
	v.vendedor_id, 
    v.nome_loja, 
    v.categoria, 
    v.data_de_cadastro, 
    pro.produto_id, 
    pro.nome_produto
ORDER BY 
	faturamento_total DESC;

/* PERGUNTA 2: Identificação de clientes inativos
Identifique clientes que não realizam uma compra há pelo menos 90 dias, considerando apenas pedidos pagos. 
Apresente a última compra e o valor histórico gasto por cada cliente, para apoiar ações de reativação.
*/

EXPLAIN
SELECT 
    c.cliente_id,
    c.pnome,
    c.snome,
    c.rank_cliente,
    MAX(ped.data_pedido) ultima_data,
    SUM(ped.valor_total) valor_total_historico
FROM clientes c
INNER JOIN pedidos ped ON c.cliente_id = ped.cliente_id
WHERE ped.status_pedido = 'Pago'
GROUP BY 
	c.cliente_id, 
    c.pnome, 
    c.snome, 
    c.rank_cliente
HAVING MAX(ped.data_pedido) <= date_sub('2026-08-01', INTERVAL 90 DAY);
    
/* PERGUNTA 3: Produtos de maior faturamento por categoria
categoria, identifique o produto que apresentou o maior faturamento em pedidos pagos e calcule sua participação 
percentual no faturamento total da respectiva categoria.
*/

WITH faturamento_produto AS (
    SELECT 
        v.categoria,
        pro.produto_id,
        pro.nome_produto,
        SUM(ip.quantidade * ip.preco_unitario) faturamento_total_produto
	   FROM produtos pro
	   INNER JOIN vendedores v ON v.vendedor_id  = pro.vendedor_id
	   INNER JOIN itens_pedido ip ON pro.produto_id = ip.produto_id
	   INNER JOIN pedidos ped ON ped.pedido_id = ip.pedido_id
    WHERE ped.status_pedido = 'Pago' 
    GROUP BY
        pro.produto_id,
        pro.nome_produto,
        v.categoria
),
rank_categoria AS (
    SELECT
        categoria,
        produto_id,
        nome_produto,
        faturamento_total_produto,
        SUM(faturamento_total_produto) OVER (PARTITION BY categoria) faturamento_total_categoria,
        ROW_NUMBER() OVER (PARTITION BY categoria ORDER BY faturamento_total_produto DESC) rank_produto
    FROM faturamento_produto
)
SELECT
    categoria,
    nome_produto,
    faturamento_total_produto,
    faturamento_total_categoria,
    ROUND(faturamento_total_produto / faturamento_total_categoria * 100, 2) participacao_percentual
FROM rank_categoria
WHERE rank_produto = 1;

/* PERGUNTA 4: Evolução e acumulado do faturamento
Analise a evolução mensal do faturamento por categoria ao longo de 2026 e calcule o faturamento acumulado de cada 
categoria durante o ano, permitindo acompanhar a evolução do desempenho comercial.
*/

explain
WITH faturamento_mensal AS(
	SELECT
		v.categoria,
		v.tipo_comercio,
		sum(ip.quantidade * ip.preco_unitario) valor_mensal,
		DATE_FORMAT(ped.data_pedido, '%M') periodo_mensal,
        MONTH(ped.data_pedido) mes
	FROM produtos pro
	INNER JOIN vendedores v on v.vendedor_id = pro.vendedor_id
	INNER JOIN itens_pedido ip ON pro.produto_id = ip.produto_id
	INNER JOIN pedidos ped ON ip.pedido_id = ped.pedido_id
	WHERE ped.status_pedido = 'Pago'
		AND YEAR(ped.data_pedido) = 2026
	GROUP BY
		v.categoria,
		v.tipo_comercio,
		MONTH(ped.data_pedido),
		DATE_FORMAT(ped.data_pedido, '%M')
	ORDER BY 
		MONTH(ped.data_pedido)
)
SELECT 
	categoria,
    tipo_comercio,
    valor_mensal,
    periodo_mensal,
    SUM(valor_mensal) OVER (PARTITION BY categoria, tipo_comercio ORDER BY mes
    ROWS BETWEEN unbounded preceding AND CURRENT ROW) valor_acumulado
FROM faturamento_mensal
ORDER BY mes;

/*PERGUNTA 5: Curva ABC de produtos — gestão de estoque
Considerando os pedidos pagos realizados em 2026, identifique a participação de cada produto no
 faturamento acumulado da empresa e classifique-os nas categorias A, B ou C. O objetivo é identificar 
 quais produtos concentram a maior parcela da receita e fornecer um indicador que possa apoiar decisões de 
 gestão de estoque.
*/

EXPLAIN
WITH faturamento_por_produto AS (
SELECT
	v.categoria,
    pro.nome_produto,
    pro.produto_id,
    SUM(ip.quantidade) quantidade_vendida,
    sum(ip.quantidade * ip.preco_unitario) faturamento_total_produto
FROM produtos pro
INNER JOIN vendedores v ON v.vendedor_id = pro.vendedor_id
INNER JOIN itens_pedido ip ON pro.produto_id = ip.produto_id
INNER JOIN pedidos ped ON ip.pedido_id = ped.pedido_id
WHERE ped.status_pedido = 'Pago'
	AND YEAR(ped.data_pedido) = 2026
GROUP BY 
	pro.produto_id,
    pro.nome_produto,
	v.categoria
),
acumulado AS (
SELECT 
	categoria,
    nome_produto,
    quantidade_vendida,
    faturamento_total_produto,
    SUM(faturamento_total_produto) 
		OVER (ORDER BY faturamento_total_produto DESC) faturamento_acumulado,
    SUM(faturamento_total_produto) 
		OVER () faturamento_geral
    FROM faturamento_por_produto
)
SELECT
	categoria,
    nome_produto,
    quantidade_vendida,
    faturamento_total_produto,
    ROUND (faturamento_acumulado/faturamento_geral * 100,2) percentual_valor,
    CASE
		WHEN (faturamento_acumulado/faturamento_geral) <= 0.80 THEN 'Classe A'
        WHEN (faturamento_acumulado/faturamento_geral) <= 0.95 THEN 'Classe B'
        ELSE 'Classe C'
	END curva_abc
FROM acumulado
ORDER BY faturamento_total_produto DESC;

/* PERGUNTA 6: Quais são os 5 clientes que possuem o maior volime de compras acumulado em 2026,
qual é o ticket médio de cada um deles e qual a categoria de produtos eles mais consomem?
*/

WITH faturamento_por_cliente_categoria AS (
    SELECT
        c.cliente_id,
        c.pnome,
        c.snome,
        v.categoria,
        SUM(ip.quantidade * ip.preco_unitario) AS total_gasto_categoria,
        ROW_NUMBER() OVER (
            PARTITION BY c.cliente_id 
            ORDER BY SUM(ip.quantidade * ip.preco_unitario) DESC
        ) AS ranking_categoria_cliente
    FROM clientes c
    INNER JOIN pedidos ped ON ped.cliente_id = c.cliente_id
    INNER JOIN itens_pedido ip ON ip.pedido_id = ped.pedido_id
    INNER JOIN produtos pro ON pro.produto_id = ip.produto_id
    INNER JOIN vendedores v ON v.vendedor_id = pro.vendedor_id
    WHERE ped.status_pedido = 'Pago'
        AND YEAR(ped.data_pedido) = 2026
    GROUP BY
        c.cliente_id,
        c.pnome,
        c.snome,
        v.categoria
),
pedidos_por_cliente AS (
    -- Subconsulta dedicada para isolar a quantidade real de pedidos distintos de cada cliente em 2026
    SELECT
        c.cliente_id,
        COUNT(DISTINCT ped.pedido_id) AS total_pedidos,
        SUM(ip.quantidade * ip.preco_unitario) AS faturamento_total_cliente
    FROM clientes c
    INNER JOIN pedidos ped ON ped.cliente_id = c.cliente_id
    INNER JOIN itens_pedido ip ON ip.pedido_id = ped.pedido_id
    WHERE ped.status_pedido = 'Pago'
        AND YEAR(ped.data_pedido) = 2026
    GROUP BY c.cliente_id
),
metricas_clientes AS (
    SELECT
        fcc.cliente_id,
        fcc.pnome,
        fcc.snome,
        pc.faturamento_total_cliente,
        pc.total_pedidos,
        -- Calcula o ticket médio (Faturamento Total / Total de Pedidos)
        ROUND(pc.faturamento_total_cliente / pc.total_pedidos, 2) AS ticket_medio,
        MAX(CASE WHEN fcc.ranking_categoria_cliente = 1 THEN fcc.categoria END) AS categoria_mais_consumida
    FROM faturamento_por_cliente_categoria fcc
    INNER JOIN pedidos_por_cliente pc ON fcc.cliente_id = pc.cliente_id
    GROUP BY
        fcc.cliente_id,
        fcc.pnome,
        fcc.snome,
        pc.faturamento_total_cliente,
        pc.total_pedidos
)
SELECT
    pnome,
    snome,
    ROUND(faturamento_total_cliente, 2) AS faturamento_acumulado_cliente,
    ticket_medio,
    categoria_mais_consumida
FROM metricas_clientes
ORDER BY faturamento_total_cliente DESC
LIMIT 5;