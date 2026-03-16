WITH allOrders AS (
    SELECT O.*,
        OI.COST_PRICE,
        OI.DISCOINT_AMOUNT,
        OI.PRODUCT_ID,
        OI.QUANTITY,
        OI.UNIT_PRICE
    FROM {{ ref('transformed_orders_data') }} O
    RIGHT JOIN {{ ref('transformed_orders_items_data') }} OI
        ON OI.ORDER_ID = O.ORDER_ID
),
orders AS ( 
SELECT
    product_id,
    store_id,
    CAST(order_date AS DATE) AS order_date,
    SUM(quantity) AS sold_quantity 
FROM allOrders
GROUP BY
    product_id,
    store_id,
    CAST(order_date AS DATE) 
), 
product_info AS ( 
SELECT
    product_id,
    supplier_id,
    stock_quantity,
    reorder_level,
    cost_price 
FROM {{ ref('dim_product') }} 
), 
date_dim AS ( 
SELECT
    date_key,
    full_date 
FROM {{ ref('dim_date') }} 
), 
/*----------------------------------*/
/* Join Orders with Product Data */
/*----------------------------------*/ 
inventory_base AS ( 
SELECT 
    o.product_id,
    o.store_id,
    o.order_date, 
    p.supplier_id,
    p.stock_quantity,
    p.reorder_level,
    p.cost_price, 
    o.sold_quantity 
FROM orders o 
LEFT JOIN product_info p
    ON o.product_id = p.product_id 
),
 
/*----------------------------------*/
/* Purchased Quantity Logic */
/*----------------------------------*/ 
inventory_calc AS ( 
SELECT 
    product_id,
    store_id,
    supplier_id,
    order_date, 
    stock_quantity AS beginning_inventory, 
    sold_quantity, 
    cost_price, 
    reorder_level, 
    /* Correct Purchase Logic */ 
    CASE
        WHEN (stock_quantity - sold_quantity) < reorder_level
        THEN reorder_level - (stock_quantity - sold_quantity)
        ELSE 0
    END AS purchased_quantity 
FROM inventory_base 
), 
/*----------------------------------*/
/* Supplier Purchase Totals */
/*----------------------------------*/ 
supplier_totals AS ( 
SELECT
    supplier_id,
    SUM(purchased_quantity) AS supplier_purchase 
FROM inventory_calc 
GROUP BY supplier_id 
), 
total_purchases AS ( 
SELECT
    SUM(purchased_quantity) AS total_purchase 
FROM inventory_calc 
), 
/*----------------------------------*/
/* Join Dimension Keys */
/*----------------------------------*/ 
dim_join AS ( 
SELECT 
    dp.product_key,
    ds.store_key,
    sp.supplier_key,
    dd.date_key, 
    ic.beginning_inventory,
    ic.purchased_quantity,
    ic.sold_quantity,
    ic.cost_price,
    ic.supplier_id 
FROM inventory_calc ic 
LEFT JOIN {{ ref('dim_product') }} dp
    ON ic.product_id = dp.product_id 
LEFT JOIN {{ ref('dim_store') }} ds
    ON ic.store_id = ds.store_id 
LEFT JOIN {{ ref('dim_supplier') }} sp
    ON ic.supplier_id = sp.supplier_id 
LEFT JOIN {{ ref('dim_date') }} dd
    ON ic.order_date = dd.full_date 
), 
/*----------------------------------*/
/* Final Calculations */
/*----------------------------------*/ 
final AS ( 
SELECT 
    {{ dbt_utils.generate_surrogate_key([
        'product_key',
        'store_key',
        'supplier_key',
        'date_key'
    ]) }} AS inventory_key, 
    product_key,
    date_key,
    store_key,
    supplier_key, 
    beginning_inventory, 
    purchased_quantity, 
    sold_quantity, 
    /* Ending Inventory */ 
    beginning_inventory + purchased_quantity - sold_quantity
    AS ending_inventory, 
    /* Inventory Value */ 
    (beginning_inventory + purchased_quantity - sold_quantity) * cost_price
    AS inventory_value, 
    /* Average Inventory */ 
    (beginning_inventory +
     (beginning_inventory + purchased_quantity - sold_quantity)) / 2
    AS average_inventory, 
    /* Stock Turnover Ratio */ 
    CASE
        WHEN (beginning_inventory +
             (beginning_inventory + purchased_quantity - sold_quantity)) / 2 > 0
        THEN sold_quantity /
             ((beginning_inventory +
             (beginning_inventory + purchased_quantity - sold_quantity)) / 2)
        ELSE NULL
    END AS stock_turnover_ratio, 
    /* Supplier Contribution Percentage */ 
    CASE
        WHEN tp.total_purchase > 0
        THEN (st.supplier_purchase / tp.total_purchase) * 100
        ELSE 0
    END AS supplier_contribution_percentage 
FROM dim_join dj 
LEFT JOIN supplier_totals st
    ON dj.supplier_id = st.supplier_id 
CROSS JOIN total_purchases tp 
) 
SELECT *
FROM final