# Supersales – Power BI Analysis

Supersales is a Power BI portfolio project I developed as part of my data analytics training with KajoData.

The report explores sales performance from several perspectives: revenue, products, shipping, returns and forecast performance. My focus was on preparing the source data, building a relational data model, creating DAX measures and understanding the limitations of the available data.

## Live Report

[View the interactive Power BI report](https://app.powerbi.com/view?r=eyJrIjoiYjVlNjgwMGQtYWIzYS00YTQ1LThmMzEtOWE3ODE3MGRkNzc0IiwidCI6IjVhZmVlYTZlLTRhYTItNGU4OC1iY2UyLWIyMzA4N2VjZDRlYSJ9&pageName=0e9dd8108441ba3ebe72)

## Report Overview

![Executive Overview](images/executive-overview.png)

The report consists of six pages:

- Executive Overview
- Product Analysis
- Revenue Analysis
- Shipping Analysis
- Returns Analysis
- Forecast Performance

Each page focuses on a different aspect of the sales process, from overall performance and product categories to order processing, customer ratings and returns.

The report also includes custom report page tooltips that provide additional context when hovering over selected visuals.

These tooltips allow users to explore supporting information without leaving the current report page.

## Key Insights

### Executive Overview

- Revenue increased throughout the analysed period, reaching approximately **$2.16M** in total.
- Revenue CAGR for the analysed period was approximately **22.4%**.
- Revenue growth was accompanied by a strong increase in both the number of orders and the number of products sold.
- At the same time, **Average Order Value declined from $477 in 2018 to $446 in 2021**.
- This indicates that revenue growth was primarily **volume-driven rather than driven by increasing order value**.
- Sales also show a visible seasonal pattern, with particularly strong results in **Q4**.
- Revenue and Order Count on the Overview exclude orders recorded as returned, keeping the main sales KPIs methodologically consistent.

### Product Analysis

- Revenue increased across all three product categories over the analysed period.
- **Technology became the strongest revenue-generating category**, reaching approximately **$270K in 2021**. Furniture temporarily led in 2019 but subsequently showed much slower revenue growth.
- **Office Supplies generated the highest sales volume**, despite having the lowest Average Selling Price at approximately **$30–33**.
- This suggests that Office Supplies revenue is primarily **volume-driven**.
- Technology combines the **highest Average Selling Price with the lowest discount levels** and generates the highest revenue in the final analysed years.
- Furniture receives the **highest average discounts**, but this does not translate into superior revenue performance. This makes the effectiveness of the discounting strategy in this category worth further investigation.
- The available data is not sufficient to conclude that reducing discounts would automatically increase Furniture performance; margin and profitability data would be required for such a recommendation.

### Revenue Analysis

- Total analysed revenue amounts to approximately **$2.16M**.
- **Technology generated the highest revenue — approximately $789K**, while Furniture and Office Supplies each generated approximately **$683–687K**.
- Revenue shows clear seasonality. The strongest sales periods tend to occur toward the **end of the year**, while February and March are generally among the weaker months.
- The increasing annual revenue trend combined with recurring seasonal peaks suggests that business growth did not eliminate the underlying seasonal sales pattern.
- The decomposition tree shows that revenue concentration can be investigated further from **Category → Product Group → Product**, rather than treating category-level results as the end of the analysis.

### Shipping Analysis

- **California is the largest market** in both order volume and revenue, with approximately **970 orders** and **$435K in revenue**.
- New York and Texas are the next largest states by order volume, but their revenue contribution differs substantially. This shows that **order volume alone does not fully explain revenue performance across states**.
- **Standard Class dominates shipping activity**, generating approximately **$1.30M in revenue**, but it also has the longest average order processing time at approximately **5 days**.
- Faster shipping modes account for considerably smaller revenue volumes.
- The results show a clear relationship between shipping mode and processing time, but the dataset does not allow us to determine whether customers deliberately select slower shipping, whether this is driven by cost, or whether other operational factors are involved.

### Returns Analysis

- **101 orders were recorded as returned**, resulting in an overall **Return Rate of 2.09%** for the analysed period.
- The calculated revenue associated with returned orders is approximately **$46.17K**. This represents the value of orders marked as returned and should **not be interpreted as a confirmed refund amount**.
- Rated orders have a Return Rate of approximately **2.49%**, compared with approximately **2.02% for unrated orders**.
- However, only **723 orders have customer ratings**, so the rated sample represents a relatively small subset of all orders.
- A high customer rating does **not consistently correspond to a lower probability of return**. For example, the observed Return Rate varies considerably between individual rating levels.
- Similarly, there is **no clear relationship between order processing time and Return Rate**. The rate does not consistently increase or decrease as processing time changes.
- Therefore, the available data does not provide sufficient evidence to identify either customer rating or processing time as a meaningful driver of returns.
- Because returns are recorded only at **order level**, the dataset also does not allow identification of the specific products, quantities or reasons responsible for a return.

### Forecast Performance

- Total Forecast for 2018–2021 was approximately **$2.48M**, compared with Actual Revenue of approximately **$2.16M**.
- Overall **Forecast Achievement was approximately 87%**, corresponding to a negative variance of approximately **$316K**.
- Before excluding orders recorded as returned, revenue would have been approximately **$2.21M**, corresponding to roughly **89% Forecast Achievement**. Returned orders therefore reduce achievement by approximately **1.9 percentage points**, but they do not explain the majority of the forecast shortfall.
- Performance differs substantially by shipping mode:
  - **Second Class: 101%** — slightly above forecast.
  - **Same Day: 98%** — close to forecast.
  - **First Class: 86%** — 14 percentage points below target.
  - **Standard Class: 83%** — 17 percentage points below target.
- Standard Class accounts for approximately **$267K of the total $316K negative variance**, meaning that roughly **85% of the overall forecast shortfall is concentrated in this shipping mode**.
- Standard Class remained below forecast in **every analysed year**, suggesting a persistent pattern rather than a single-year deviation.
- However, the available dataset does not establish whether this gap results from overly optimistic forecasts, weaker-than-expected sales or another business factor.
- The interpretation of `cost_forecast` as a revenue/budget-like benchmark remains an **analytical assumption**, because its exact business definition is not documented.

### Overall Conclusion

Across 2018–2021, Supersales shows **strong revenue growth driven primarily by increasing sales volume**, while Average Order Value gradually declines. Technology emerges as the strongest revenue category, while Office Supplies relies heavily on volume. Sales exhibit clear seasonality, with stronger performance toward the end of the year.

Returns represent a relatively small proportion of orders and slightly reduce overall forecast achievement, but the available ratings, processing-time and return data do not provide sufficient evidence to identify the underlying causes of returns.

The largest gap between forecast and actual performance is concentrated in **Standard Class**, which accounts for the majority of the overall negative forecast variance and remains below forecast throughout the analysed period.

## Dataset and Data Preparation

The project uses the Supersales dataset provided as part of the KajoData training materials.

The source data consists of eight CSV files:

- `orders.csv`
- `order_positions.csv`
- `customers.csv`
- `products.csv`
- `product_groups.csv`
- `order_ratings.csv`
- `order_returns.csv`
- `cost_forecast.csv`

I used Power Query to prepare the source files, correct data types and resolve data formatting issues, including decimal separators.

I then worked with a relational data model in Power BI to analyze data across orders, order positions, customers, products, ratings and returns.

An important part of the project was understanding the granularity of each table. Order positions represent individual products within an order, while ratings and returns are recorded at order level.

## Analytical Approach

### Revenue Calculation

Revenue is not stored directly in the order positions table.

I calculated it using product price, quantity and discount:

`Revenue = Quantity × Product Price × (1 - Discount)`

The DAX measure uses `SUMX` to calculate revenue for individual order positions and `RELATED` to retrieve prices from the products table.

One limitation is that product prices come from the product catalog rather than being stored separately at the time of each transaction. Therefore, the calculated historical revenue depends on the available catalog prices.

### Time Analysis and Data Coverage

The source dataset contains transactions from January 29, 2018 to January 25, 2022.

The report focuses on the analytical period from January 29, 2018 to December 31, 2021. Although transactions are available for 2022, they cover only the first 25 days of January. Including this period in annual or quarterly trend analysis would create misleading comparisons with substantially longer periods.

For this reason, 2022 was intentionally excluded from the report analysis while the underlying source data was retained in the data model.

The 2018 data begins on January 29. This starting point was retained as the beginning of the observed dataset and is documented as a data coverage limitation.

Revenue CAGR is calculated using comparable annual periods and therefore does not include the partial 2022 period.

### Product Analysis

The product analysis focuses on four main measures:

- Revenue
- Products Sold
- Average Discount
- Average Selling Price

These measures help compare product categories in terms of sales value, volume, discount levels and average realized selling price.

### Shipping Analysis

The shipping analysis compares order volume and revenue across delivery states and shipping modes.

I also calculated average order processing time using the difference between order date and shipping date.

This allows processing times to be compared across shipping modes.

### Returns Analysis

Returns are recorded at order level rather than individual product level.

The dataset identifies orders with a recorded return, but it does not specify which products were returned, their quantities or whether the entire order was refunded.

For this reason, the report does not assume that the full value of a returned order represents an actual refund.

The analysis includes:

- Returned Orders
- Return Rate
- Value of Returned Orders
- Return Rate by Customer Rating
- Return Rate: Rated vs Unrated Orders
- Return Rate by Processing Time

The KPI named `Value of Returned Orders` represents the calculated revenue associated with orders that have a recorded return. It should not be interpreted as a confirmed refund amount.

Customer ratings are available only for a subset of orders. Missing ratings are treated as missing information rather than a rating of zero.

The relationships between ratings, processing time and returns are descriptive and do not establish causation.

### Forecast Analysis and Business Assumption

The `cost_forecast` table contains forecast values for 2018–2021, broken down by shipping mode.

Although the source column is named `cost_forecast`, I decided to treat these values as a budget-like financial benchmark rather than literal shipping costs.

This decision was based on the scale of the figures:

- Total forecast: approximately $2.48 million
- Actual revenue for the comparable period: approximately $2.16 million

The forecast values are comparable in magnitude to total sales revenue. This raised doubts about interpreting them as shipping costs alone.

For the purpose of this analysis, I therefore compared the forecast values with actual revenue and used the neutral label **Forecast** in the report.

The analysis includes:

- Forecast
- Actual
- Forecast Variance
- Forecast Achievement %

The calculations are:

`Forecast Variance = Actual - Forecast`

`Forecast Achievement % = Actual / Forecast`

The comparison covers 2018–2021 because forecast values are not available for 2022.

**Important:** Treating `cost_forecast` as a budget-like benchmark is my analytical assumption, not a confirmed business definition. The available documentation does not clearly establish whether these values represent a sales budget, another financial forecast or a different cost category.

The forecast-versus-actual results should be interpreted with this limitation in mind.

## Selected DAX Measures

The report includes measures such as:

- Revenue
- Order Count
- Products Sold
- Customers Count
- Average Order Value
- Average Selling Price
- Average Discount
- Revenue CAGR
- Returned Orders
- Return Rate
- Average Order Processing Time
- Forecast Variance
- Forecast Achievement %

I used DAX iterator functions such as `SUMX` and `AVERAGEX`, along with functions including `CALCULATE`, `DIVIDE`, `ALL`, `ALLSELECTED` and `REMOVEFILTERS`.

An important part of the work was understanding filter context and ensuring that measures produced meaningful results across different report selections.

## Report Pages

### Product Analysis

![Product Analysis](images/product-analysis.png)

Analysis of revenue, products sold, average discount and average selling price across product categories.

### Revenue Analysis

![Revenue Analysis](images/revenue-analysis.png)

Revenue analysis using a decomposition tree and monthly revenue trend.

The decomposition tree allows exploration from product category through product group down to individual products.

### Shipping Analysis

![Shipping Analysis](images/shipping-analysis.png)

Comparison of orders and revenue by state, revenue by shipping mode and average order processing time.

### Returns Analysis

![Returns Analysis](images/returns-analysis.png)

Analysis of return rates by customer rating and order processing time, including a comparison between rated and unrated orders.

### Forecast Performance

![Forecast Performance](images/forecast-performance.png)

Comparison of forecast and actual revenue by year and shipping mode, including variance and achievement percentage.

The results are based on the documented assumption about the meaning of the `cost_forecast` values.

## Data Limitations and Assumptions

Several characteristics of the dataset affected the analytical approach:

1. **Data coverage:** The source dataset spans January 29, 2018 to January 25, 2022. The report analysis is limited to January 29, 2018–December 31, 2021. The partial 2022 period was intentionally excluded to avoid misleading annual and quarterly comparisons. The beginning of 2018 is also partial and is retained as the starting point of the observed dataset.
2. **Historical prices:** Product prices are retrieved from the product catalog rather than stored at transaction level.
3. **Missing ratings:** Only a subset of orders has a recorded customer rating. Rated orders may not be representative of all orders.
4. **Order-level returns:** Return records do not identify returned products, quantities or confirmed refund amounts.
5. **Forecast coverage:** Forecast data is available only for 2018–2021.
6. **Forecast interpretation:** The business meaning of `cost_forecast` is not clearly documented. I treated it as a budget-like benchmark because its magnitude appears inconsistent with shipping costs alone. This assumption would require confirmation from the data owner.

These limitations were considered when defining measures and interpreting the results.

## Tools and Skills

- Power BI Desktop
- Power Query
- DAX
- Relational Data Modeling
- Data Visualization
- KPI Design
- Variance Analysis

## Repository Structure

```text
supersales-power-bi-analysis/
│
├── images/          # Report screenshots
├── dax/             # Selected DAX measures
├── documentation/   # Additional project documentation
└── README.md
```

## Project Summary

This project gave me practical experience in preparing data, working with a relational Power BI model and developing DAX measures.

It also showed me the importance of understanding data granularity, documenting assumptions and distinguishing calculated results from confirmed business facts.
