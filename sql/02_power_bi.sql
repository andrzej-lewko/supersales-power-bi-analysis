USE supersales;


/* ============================================================
   SOURCE DATA VALIDATION
   ============================================================ */

-- Check row counts in source tables
SELECT 'customers' AS table_name, COUNT(*) AS row_count FROM customers
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


/* ============================================================
   PRODUCTS
   ============================================================ */

-- Short product name used in Power BI visuals
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


/* ============================================================
   ORDERS
   ============================================================ */

-- Order-level attributes used in shipping and rating analysis
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


/* ============================================================
   CUSTOMER RFM SEGMENTATION
   ============================================================ */

-- RFM analysis uses complete years 2018-2021.
-- Returned orders are excluded from customer monetary value.
CREATE OR REPLACE VIEW vw_customer_rfm AS

WITH customer_rfm AS (

    SELECT
        c.customer_id,
        c.customer_name,

        MAX(o.order_date) AS last_order_date,

        DATEDIFF(
            '2022-01-01',
            MAX(o.order_date)
        ) AS recency,

        COUNT(DISTINCT o.order_id) AS frequency,

        ROUND(
            SUM(
                CASE
                    WHEN r.order_id IS NULL
                    THEN op.item_quantity
                         * p.product_price
                         * (1 - op.position_discount)
                    ELSE 0
                END
            ),
            2
        ) AS monetary

    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_positions op
        ON o.order_id = op.order_id
    JOIN products p
        ON op.product_id = p.product_id
    LEFT JOIN order_returns r
        ON o.order_id = r.order_id

    WHERE o.order_date < '2022-01-01'

    GROUP BY
        c.customer_id,
        c.customer_name
),

rfm_scores AS (

    SELECT
        customer_id,
        customer_name,
        last_order_date,
        recency,
        frequency,
        monetary,

        NTILE(5) OVER (
            ORDER BY recency DESC
        ) AS r_score,

        NTILE(5) OVER (
            ORDER BY frequency
        ) AS f_score,

        NTILE(5) OVER (
            ORDER BY monetary
        ) AS m_score

    FROM customer_rfm
),

rfm_segments AS (

    SELECT
        customer_id,
        customer_name,
        last_order_date,
        recency,
        frequency,
        monetary,
        r_score,
        f_score,
        m_score,

        CONCAT(
            r_score,
            f_score,
            m_score
        ) AS rfm_score,

        CASE
            WHEN r_score >= 4
             AND f_score >= 4
             AND m_score >= 4
                THEN 'Champions'

            WHEN r_score <= 2
             AND f_score >= 3
             AND m_score >= 3
                THEN 'At Risk'

            WHEN r_score >= 4
             AND f_score <= 2
                THEN 'New / Potential'

            WHEN f_score >= 4
             AND m_score >= 3
                THEN 'Loyal Customers'

            WHEN r_score <= 2
             AND f_score <= 2
             AND m_score <= 3
                THEN 'Inactive / Low Value'

            ELSE 'Regular Customers'
        END AS segment

    FROM rfm_scores
)

SELECT
    customer_id,
    customer_name,
    last_order_date,
    recency,
    frequency,
    monetary,
    r_score,
    f_score,
    m_score,
    rfm_score,
    segment
FROM rfm_segments;