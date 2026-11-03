
-- Q1: Retrieve all customer records
SELECT *
FROM customers;

-- Q2: Display customer names, cities, and segments
SELECT customer_name, city, customer_segment
FROM customers;

-- Q3: Find customers living in Nairobi
SELECT *
FROM customers
WHERE city = 'Nairobi';

-- Q4: Find customers registered after January 1, 2025
SELECT *
FROM customers
WHERE registration_date > DATE '2025-01-01';

-- Q5: Display all unique customer cities
SELECT DISTINCT city
FROM customers
ORDER BY city;

-- Q6: Retrieve the 10 most recent orders
SELECT *
FROM orders
ORDER BY order_date DESC
LIMIT 10;

-- Q7: Find orders with unit prices above KSh 10,000
SELECT *
FROM orders
WHERE unit_price > 10000;

-- Q8: Find customers whose names start with A
SELECT *
FROM customers
WHERE customer_name LIKE 'A%';

-- Q9: Retrieve orders with quantities between 2 and 5
SELECT *
FROM orders
WHERE quantity BETWEEN 2 AND 5;

-- Q10: Find orders paid through M-Pesa
SELECT *
FROM orders
WHERE payment_method = 'M-Pesa';


-- ==========================================
-- SECTION B: AGGREGATION AND GROUPING
-- Questions 11-15
-- ==========================================

-- Q11: Count all customers
SELECT COUNT(*) AS total_customers
FROM customers;

-- Q12: Count all orders
SELECT COUNT(*) AS total_orders
FROM orders;

-- Q13: Calculate completed-order revenue
SELECT ROUND(
    SUM(quantity * unit_price * (1 - discount / 100.0)),
    2
) AS completed_order_revenue
FROM orders
WHERE order_status = 'Completed';

-- Q14: Calculate the average completed-order value
SELECT ROUND(
    AVG(quantity * unit_price * (1 - discount / 100.0)),
    2
) AS average_completed_order_value
FROM orders
WHERE order_status = 'Completed';

-- Q15: Find the highest and lowest product prices
SELECT
    MAX(unit_price) AS highest_unit_price,
    MIN(unit_price) AS lowest_unit_price
FROM orders;


-- ==========================================
-- SECTION B: AGGREGATION AND GROUPING
-- Questions 16-20
-- ==========================================

-- Q16: Calculate revenue by product category
SELECT
    product_category,
    ROUND(
        SUM(quantity * unit_price * (1 - discount / 100.0)),
        2
    ) AS total_revenue
FROM orders
WHERE order_status = 'Completed'
GROUP BY product_category
ORDER BY total_revenue DESC;

-- Q17: Count customers by city
SELECT
    city,
    COUNT(*) AS total_customers
FROM customers
GROUP BY city
ORDER BY total_customers DESC;

-- Q18: Calculate quantity sold by product
SELECT
    product_name,
    SUM(quantity) AS total_quantity_sold
FROM orders
WHERE order_status = 'Completed'
GROUP BY product_name
ORDER BY total_quantity_sold DESC;

-- Q19: Find categories generating more than KSh 100,000 in revenue
SELECT
    product_category,
    ROUND(
        SUM(quantity * unit_price * (1 - discount / 100.0)),
        2
    ) AS total_revenue
FROM orders
WHERE order_status = 'Completed'
GROUP BY product_category
HAVING SUM(quantity * unit_price * (1 - discount / 100.0)) > 100000
ORDER BY total_revenue DESC;

-- Q20: Calculate the percentage of cancelled orders
SELECT
    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE order_status = 'Cancelled'
        ) / NULLIF(COUNT(*), 0),
        2
    ) AS cancelled_order_percentage
FROM orders;


-- ==========================================
-- SECTION C: JOINS AND CUSTOMER ANALYTICS
-- Questions 21-25
-- ==========================================

-- Q21: Display orders with customer names and cities
SELECT
    o.order_id,
    c.customer_name,
    c.city,
    o.order_date,
    o.product_name,
    o.order_status
FROM orders o
INNER JOIN customers c
    ON o.customer_id = c.customer_id
ORDER BY o.order_date DESC;

-- Q22: Calculate total spending by customer
SELECT
    c.customer_id,
    c.customer_name,
    ROUND(
        SUM(o.quantity * o.unit_price *
            (1 - o.discount / 100.0)),
        2
    ) AS total_spending
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_status = 'Completed'
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spending DESC;

-- Q23: Identify customers who have never ordered
SELECT
    c.customer_id,
    c.customer_name,
    c.city
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL
ORDER BY c.customer_name;

-- Q24: Find the 10 highest-spending customers
SELECT
    c.customer_id,
    c.customer_name,
    ROUND(
        SUM(o.quantity * o.unit_price *
            (1 - o.discount / 100.0)),
        2
    ) AS total_spending
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_status = 'Completed'
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spending DESC
LIMIT 10;

-- Q25: Calculate revenue by customer city
SELECT
    c.city,
    ROUND(
        SUM(o.quantity * o.unit_price *
            (1 - o.discount / 100.0)),
        2
    ) AS total_revenue
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_status = 'Completed'
GROUP BY c.city
ORDER BY total_revenue desc;


-- Q26: Identify customers with more than five orders
SELECT
    c.customer_id,
    c.customer_name,
    COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(o.order_id) > 5
ORDER BY total_orders DESC;


-- Q27: Calculate average customer spending by segment
WITH customer_spending AS (
    SELECT
        c.customer_id,
        c.customer_name,
        c.customer_segment,
        SUM(
            o.quantity * o.unit_price * (1 - o.discount / 100.0)
        ) AS total_spending
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    WHERE o.order_status = 'Completed'
    GROUP BY
        c.customer_id,
        c.customer_name,
        c.customer_segment
)
SELECT
    customer_segment,
    ROUND(AVG(total_spending), 2) AS average_customer_spending
FROM customer_spending
GROUP BY customer_segment
ORDER BY average_customer_spending DESC;


-- Q28: Identify the most popular category among VIP customers
SELECT
    o.product_category,
    SUM(o.quantity) AS total_quantity_sold
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
WHERE c.customer_segment = 'VIP'
  AND o.order_status = 'Completed'
GROUP BY o.product_category
ORDER BY total_quantity_sold DESC
LIMIT 1;


-- Q29: Find customers spending above the average
-- total spending per purchasing customer
WITH customer_spending AS (
    SELECT
        c.customer_id,
        c.customer_name,
        SUM(
            o.quantity * o.unit_price * (1 - o.discount / 100.0)
        ) AS total_spending
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    WHERE o.order_status = 'Completed'
    GROUP BY c.customer_id, c.customer_name
),
average_spending AS (
    SELECT AVG(total_spending) AS avg_spending
    FROM customer_spending
)
SELECT
    cs.customer_id,
    cs.customer_name,
    ROUND(cs.total_spending, 2) AS total_spending
FROM customer_spending cs
CROSS JOIN average_spending av
WHERE cs.total_spending > av.avg_spending
ORDER BY cs.total_spending DESC;


-- Q30: Find products priced above the overall average unit price
SELECT
    product_name,
    unit_price
FROM orders
WHERE unit_price > (
    SELECT AVG(unit_price)
    FROM orders
)
GROUP BY product_name, unit_price
ORDER BY unit_price DESC;


-- Q31: Use a CTE to identify the three highest-revenue months
WITH monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', order_date)::DATE AS month,
        SUM(
            quantity * unit_price * (1 - discount / 100.0)
        ) AS revenue
    FROM orders
    WHERE order_status = 'Completed'
    GROUP BY DATE_TRUNC('month', order_date)
)
SELECT
    month,
    ROUND(revenue, 2) AS revenue
FROM monthly_revenue
ORDER BY revenue DESC
LIMIT 3;


-- Q32: Find customers purchasing from at least three categories
SELECT
    c.customer_id,
    c.customer_name,
    COUNT(DISTINCT o.product_category) AS category_count
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_status = 'Completed'
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(DISTINCT o.product_category) >= 3
ORDER BY category_count DESC, c.customer_name;


-- Q33: Calculate category revenue, cost, profit, and profit margin
-- IMPORTANT: Replace unit_cost with the actual cost column
-- if your orders table contains one. Verify the schema first.
WITH category_financials AS (
    SELECT
        product_category,
        SUM(
            quantity * unit_price * (1 - discount / 100.0)
        ) AS revenue,
        SUM(quantity * unit_price) AS gross_sales_before_discount
    FROM orders
    WHERE order_status = 'Completed'
    GROUP BY product_category
)
SELECT
    product_category,
    ROUND(revenue, 2) AS revenue,
    ROUND(gross_sales_before_discount, 2) AS sales_before_discount,
    ROUND(revenue - gross_sales_before_discount, 2)
        AS difference_after_discount,
    ROUND(
        100.0 * (revenue - gross_sales_before_discount)
        / NULLIF(revenue, 0),
        2
    ) AS difference_percentage
FROM category_financials
ORDER BY revenue DESC;


-- Q34: Find customers whose latest completed order
-- is more than 90 days before the latest order date in the dataset
WITH latest_dataset_date AS (
    SELECT MAX(order_date) AS latest_order_date
    FROM orders
),
customer_last_order AS (
    SELECT
        c.customer_id,
        c.customer_name,
        MAX(o.order_date) AS last_completed_order
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    WHERE o.order_status = 'Completed'
    GROUP BY c.customer_id, c.customer_name
)
SELECT
    clo.customer_id,
    clo.customer_name,
    clo.last_completed_order,
    ld.latest_order_date,
    ld.latest_order_date - clo.last_completed_order AS days_since_order
FROM customer_last_order clo
CROSS JOIN latest_dataset_date ld
WHERE clo.last_completed_order < ld.latest_order_date - INTERVAL '90 days'
ORDER BY clo.last_completed_order;


-- Q35: Rank customers by completed-order spending using RANK()
WITH customer_spending AS (
    SELECT
        c.customer_id,
        c.customer_name,
        COALESCE(
            SUM(
                o.quantity * o.unit_price * (1 - o.discount / 100.0)
            ),
            0
        ) AS total_spending
    FROM customers c
    LEFT JOIN orders o
        ON c.customer_id = o.customer_id
       AND o.order_status = 'Completed'
    GROUP BY c.customer_id, c.customer_name
)
SELECT
    customer_id,
    customer_name,
    ROUND(total_spending, 2) AS total_spending,
    RANK() OVER (ORDER BY total_spending DESC) AS spending_rank
FROM customer_spending
ORDER BY spending_rank, customer_name;


-- Q36: Number each customer's orders by recency using ROW_NUMBER()
SELECT
    customer_id,
    order_id,
    order_date,
    order_status,
    ROW_NUMBER() OVER (
        PARTITION BY customer_id
        ORDER BY order_date DESC, order_id DESC
    ) AS order_recency_number
FROM orders
ORDER BY customer_id, order_recency_number;


-- Q37: Rank products within categories using DENSE_RANK()
WITH product_sales AS (
    SELECT
        product_category,
        product_name,
        SUM(
            quantity * unit_price * (1 - discount / 100.0)
        ) AS revenue
    FROM orders
    WHERE order_status = 'Completed'
    GROUP BY product_category, product_name
)
SELECT
    product_category,
    product_name,
    ROUND(revenue, 2) AS revenue,
    DENSE_RANK() OVER (
        PARTITION BY product_category
        ORDER BY revenue DESC
    ) AS category_rank
FROM product_sales
ORDER BY product_category, category_rank, product_name;


-- Q38: Calculate cumulative monthly revenue
WITH monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', order_date)::DATE AS month,
        SUM(
            quantity * unit_price * (1 - discount / 100.0)
        ) AS revenue
    FROM orders
    WHERE order_status = 'Completed'
    GROUP BY DATE_TRUNC('month', order_date)
)
SELECT
    month,
    ROUND(revenue, 2) AS monthly_revenue,
    ROUND(
        SUM(revenue) OVER (ORDER BY month),
        2
    ) AS cumulative_revenue
FROM monthly_revenue
ORDER BY month;


-- Q39: Compare monthly revenue using LAG()
WITH monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', order_date)::DATE AS month,
        SUM(
            quantity * unit_price * (1 - discount / 100.0)
        ) AS revenue
    FROM orders
    WHERE order_status = 'Completed'
    GROUP BY DATE_TRUNC('month', order_date)
)
SELECT
    month,
    ROUND(revenue, 2) AS monthly_revenue,
    ROUND(
        LAG(revenue) OVER (ORDER BY month),
        2
    ) AS previous_month_revenue
FROM monthly_revenue
ORDER BY month;


-- Q40: Calculate month-over-month revenue growth (%)
WITH monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', order_date)::DATE AS month,
        SUM(
            quantity * unit_price * (1 - discount / 100.0)
        ) AS revenue
    FROM orders
    WHERE order_status = 'Completed'
    GROUP BY DATE_TRUNC('month', order_date)
),
revenue_comparison AS (
    SELECT
        month,
        revenue,
        LAG(revenue) OVER (ORDER BY month) AS previous_revenue
    FROM monthly_revenue
)
SELECT
    month,
    ROUND(revenue, 2) AS monthly_revenue,
    ROUND(previous_revenue, 2) AS previous_month_revenue,
    ROUND(
        100.0 * (revenue - previous_revenue)
        / NULLIF(previous_revenue, 0),
        2
    ) AS month_over_month_growth_pct
FROM revenue_comparison
ORDER BY month;


-- Q41: Divide customers into four spending groups using NTILE(4)
WITH customer_spending AS (
    SELECT
        c.customer_id,
        c.customer_name,
        COALESCE(
            SUM(
                o.quantity * o.unit_price * (1 - o.discount / 100.0)
            ),
            0
        ) AS total_spending
    FROM customers c
    LEFT JOIN orders o
        ON c.customer_id = o.customer_id
       AND o.order_status = 'Completed'
    GROUP BY c.customer_id, c.customer_name
)
SELECT
    customer_id,
    customer_name,
    ROUND(total_spending, 2) AS total_spending,
    NTILE(4) OVER (ORDER BY total_spending DESC) AS spending_group
FROM customer_spending
ORDER BY spending_group, total_spending DESC;


-- Q42: Calculate each category's share of total revenue using a window function
WITH category_revenue AS (
    SELECT
        product_category,
        SUM(
            quantity * unit_price * (1 - discount / 100.0)
        ) AS revenue
    FROM orders
    WHERE order_status = 'Completed'
    GROUP BY product_category
)
SELECT
    product_category,
    ROUND(revenue, 2) AS category_revenue,
    ROUND(
        100.0 * revenue / NULLIF(SUM(revenue) OVER (), 0),
        2
    ) AS revenue_share_pct
FROM category_revenue
ORDER BY revenue DESC;


-- Q43: Create a monthly sales summary view, then select from it
-- NOTE: Actual cost and profit require a verified product-cost column.
CREATE OR REPLACE VIEW monthly_sales_summary AS
SELECT
    DATE_TRUNC('month', order_date)::DATE AS month,
    COUNT(*) AS orders,
    ROUND(
        SUM(quantity * unit_price * (1 - discount / 100.0)),
        2
    ) AS revenue,
    NULL::NUMERIC AS cost,
    NULL::NUMERIC AS profit
FROM orders
WHERE order_status = 'Completed'
GROUP BY DATE_TRUNC('month', order_date);

SELECT * FROM monthly_sales_summary
ORDER BY month;


-- Q44: Create a function returning completed-order revenue
-- for a supplied customer ID; return 0 for a missing ID
CREATE OR REPLACE FUNCTION completed_revenue_for_customer(
    p_customer_id INT
)
RETURNS NUMERIC
LANGUAGE plpgsql
AS $$
DECLARE
    customer_revenue NUMERIC;
BEGIN
    SELECT COALESCE(
        SUM(
            quantity * unit_price * (1 - discount / 100.0)
        ),
        0
    )
    INTO customer_revenue
    FROM orders
    WHERE customer_id = p_customer_id
      AND order_status = 'Completed';

    RETURN customer_revenue;
END;
$$;

-- Test with an existing customer ID (replace 1 if needed)
SELECT completed_revenue_for_customer(1);

-- Test with a customer ID that does not exist
SELECT completed_revenue_for_customer(-1);


-- Q45: Segment customers into High, Medium and Low Value
WITH customer_spending AS (
    SELECT
        c.customer_id,
        c.customer_name,
        COALESCE(
            SUM(
                o.quantity * o.unit_price * (1 - o.discount / 100.0)
            ),
            0
        ) AS total_spending
    FROM customers c
    LEFT JOIN orders o
        ON c.customer_id = o.customer_id
       AND o.order_status = 'Completed'
    GROUP BY c.customer_id, c.customer_name
)
SELECT
    customer_id,
    customer_name,
    ROUND(total_spending, 2) AS total_spending,
    CASE
        WHEN total_spending >= 100000 THEN 'High Value'
        WHEN total_spending >= 30000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS customer_value_segment
FROM customer_spending
ORDER BY total_spending DESC;


-- Q46: Management report
-- Top five customers by completed-order spending
WITH customer_spending AS (
    SELECT
        c.customer_id,
        c.customer_name,
        SUM(
            o.quantity * o.unit_price * (1 - o.discount / 100.0)
        ) AS total_spending
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    WHERE o.order_status = 'Completed'
    GROUP BY c.customer_id, c.customer_name
)
SELECT *
FROM customer_spending
ORDER BY total_spending DESC
LIMIT 5;

-- Top five products by completed-order revenue
SELECT
    product_name,
    ROUND(
        SUM(quantity * unit_price * (1 - discount / 100.0)),
        2
    ) AS revenue
FROM orders
WHERE order_status = 'Completed'
GROUP BY product_name
ORDER BY revenue DESC
LIMIT 5;

-- Most profitable category cannot be determined until
-- the actual product-cost information is verified.

-- Lowest-revenue month
SELECT
    DATE_TRUNC('month', order_date)::DATE AS month,
    ROUND(
        SUM(quantity * unit_price * (1 - discount / 100.0)),
        2
    ) AS revenue
FROM orders
WHERE order_status = 'Completed'
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY revenue ASC
LIMIT 1;





