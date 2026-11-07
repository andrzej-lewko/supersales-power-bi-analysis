USE supersales;

-- Kontrola danych przed podłączeniem Power BI

SELECT 'customers' AS tabela, COUNT(*) AS liczba_wierszy FROM customers
UNION ALL
SELECT 'product_groups', COUNT(*) FROM product_groups
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'order_positions', COUNT(*) FROM order_positions
UNION ALL
SELECT 'order_ratings', COUNT(*) FROM order_ratings
UNION ALL
SELECT 'order_returns', COUNT(*) FROM order_returns
UNION ALL
SELECT 'cost_forecast', COUNT(*) FROM cost_forecast;


-- Produkty przygotowane dla Power BI

CREATE OR REPLACE VIEW vw_products AS
SELECT
    product_id,
    group_id,
    product_name,
    TRIM(
        REPLACE(
            SUBSTRING_INDEX(product_name, '-', 3),
            '-',
            ' '
        )
    ) AS product_short_name,
    product_price
FROM products;


-- Zamówienia przygotowane dla Power BI

CREATE OR REPLACE VIEW vw_orders AS
SELECT
    o.order_id,
    o.customer_id,
    o.order_date,
    o.shipping_date,
    o.shipping_mode,
    o.delivery_city,
    o.delivery_state,
    o.delivery_zip_code,

    CONCAT(
        o.delivery_city,
        ', ',
        o.delivery_state,
        ', USA'
    ) AS location,

    DATEDIFF(
        o.shipping_date,
        o.order_date
    ) AS processing_time,

    CASE
        WHEN r.order_id IS NOT NULL THEN 'Rated'
        ELSE 'Unrated'
    END AS rating_status,

    CASE
        WHEN DATEDIFF(o.shipping_date, o.order_date) = 0
            THEN '0 days (same day)'
        WHEN DATEDIFF(o.shipping_date, o.order_date) = 1
            THEN '1 day'
        ELSE CONCAT(
            DATEDIFF(o.shipping_date, o.order_date),
            ' days'
        )
    END AS processing_time_label

FROM orders o
LEFT JOIN order_ratings r
    ON o.order_id = r.order_id;



