Business Insights — Duka Smart Electronics
Overview
This document outlines the business questions investigated using PostgreSQL for Duka Smart Electronics, a Kenyan electronics retailer. The analysis covers customer behaviour, product performance, sales trends, order status, and revenue.
Important: The findings below describe what to investigate and how management can act on the results. Specific conclusions should be added after verifying the actual query outputs.
1. Customer Spending and Customer Value
Analysis: Customer spending was calculated from completed orders, accounting for discounts.
Business value: Identifying high-value customers can help the business prioritize customer retention and targeted promotions.
Recommendation: Compare total spending across customers and customer segments. Consider loyalty offers for valuable repeat customers, while investigating ways to encourage occasional customers to return.
2. Product and Category Performance
Analysis: Sales quantity and revenue were grouped by product and product category.
Business value: These results can help management distinguish products that sell frequently from those that generate the most revenue.
Recommendation: Review top-performing products when planning stock replenishment. Investigate consistently weak products before committing additional inventory.
3. Monthly Sales Trends
Analysis: Completed-order revenue was grouped by month, with cumulative revenue and month-over-month comparisons.
Business value: Monthly trends can reveal periods of growth or decline and help with sales planning.
Recommendation: Compare strong and weak months, then investigate possible explanations such as promotions, stock availability, seasonality, and changes in customer demand.
4. Order Status and Fulfilment
Analysis: Orders were grouped by status to measure the distribution of completed, pending, and cancelled orders.
Business value: A high cancellation rate or a large backlog of pending orders could indicate issues with fulfilment, stock availability, payment, or customer experience.
Recommendation: Monitor cancellation and pending-order rates regularly. Investigate the reasons behind cancellations before deciding which operational changes are needed.
5. Customer Segments and Retention
Analysis: Customers were examined by segment, order frequency, product-category preferences, and spending.
Business value: Different customer groups may have different purchasing patterns and needs.
Recommendation: Use verified segment-level results to tailor product recommendations and marketing campaigns. Encourage repeat purchases without relying on discounts alone.
6. Profitability — Requires Cost Data
Revenue is not the same as profit. Actual profit and profit margin require reliable product-cost information.
Recommendation: Confirm that the business maintains accurate product costs. Once verified costs are available, calculate:
•	Profit: Revenue minus cost of goods sold.
•	Profit margin: Profit divided by revenue, multiplied by 100.
Do not use selling price or discount amounts as substitutes for product cost.
7. Management Recommendations
1.	Track completed-order revenue and order status regularly.
2.	Use verified customer-spending results to support customer retention.
3.	Review product and category performance when planning inventory.
4.	Investigate month-over-month revenue changes before making sales forecasts.
5.	Collect and validate product-cost data before making profitability decisions.
Limitations
•	The analysis depends on the completeness and accuracy of the supplied customer and order records.
•	Revenue calculations use quantity, unit price, and discount, and should be checked against the business's official accounting rules.
•	The dataset's recorded orders may not explain why customers cancelled or stopped purchasing.
•	Profitability cannot be reliably determined until product costs are available.
•	Recommendations should be refined using the actual query results and additional business context.
Conclusion
PostgreSQL provides a structured way to analyze customer spending, product performance, order status, and sales trends. These analyses can support better inventory planning and customer-retention decisions. The strongest final recommendations should be based on verified results, and any profitability claims should use actual cost data.

