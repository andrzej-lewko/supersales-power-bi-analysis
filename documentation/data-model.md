# Supersales – Data Model

## Model Overview

The Power BI model combines sales transactions with customer, product, rating, return, forecast and RFM customer segmentation data.

![Power BI Data Model](data-model.png)

The original CSV files were imported into MySQL. Most source tables are loaded directly from MySQL into Power BI, while SQL views handle transformations and analytical logic that are more appropriate at the database layer:

- `vw_products` creates the shortened product name used in the report.
- `vw_orders` adds location, processing time, rating status and the processing-time label.
- `vw_customer_rfm` calculates customer-level RFM metrics, scores and customer segments.

Power Query is used mainly for connecting Power BI to MySQL, selecting the required columns and assigning data types.

## Relationships

The main sales structure is:

`Customers → Orders → OrderPositions → Products → ProductGroups`

Ratings and Returns are connected to Orders because both are recorded at order level.

The Calendar table is connected to Orders through the order date.

`CustomerRFM` contains one row per customer and is connected to `Customers` through `customer_id`. It provides the customer-level analytical layer used on the Customer Analysis page without changing the transaction-level grain of the main sales model.

Forecast data has a different grain from the sales data, so `DimYear` and `DimShippingMode` are used as shared dimensions. This allows forecast and actual results to be compared by year and shipping mode.

The `_Measure` table is used only to keep DAX measures in one place.

## Data Granularity

The model contains data at several levels:

- `Orders` – one row per order
- `OrderPositions` – one row per product position within an order
- `Products` – one row per product
- `ProductGroups` – one row per product group
- `Customers` – one row per customer
- `CustomerRFM` – one row per customer with RFM metrics and segment assignment
- `Ratings` – one row per rated order
- `Returns` – one row per returned order
- `Forecast` – one row per year and shipping mode combination

This distinction is important because revenue is calculated from order positions, while ratings and returns apply to whole orders and RFM segmentation is calculated at customer level.

## RFM Customer Segmentation

Customer segmentation is calculated in MySQL rather than Power BI.

The `vw_customer_rfm` view calculates:

- **Recency** – number of days since the customer's last order
- **Frequency** – number of distinct orders
- **Monetary** – customer revenue excluding returned orders

Customers receive Recency, Frequency and Monetary scores from 1 to 5 using SQL `NTILE()` window functions.

These scores are used to assign customers to six analytical segments:

- Champions
- Loyal Customers
- At Risk
- New / Potential
- Inactive / Low Value
- Regular Customers

The resulting view is loaded into Power BI as `CustomerRFM` and used by the Customer Analysis page.

## Notes and Limitations

Revenue is calculated from quantity, product catalog price and discount. Product prices are not stored separately for each historical transaction, so the calculation relies on the available catalog price.

Returns are recorded only at order level. The data does not identify which products or quantities were returned and does not contain confirmed refund amounts.

Ratings are available only for a subset of orders. Missing ratings are treated as missing information, not as a rating of zero.

RFM segmentation is based on relative scores within the analysed customer population and predefined analytical rules. The resulting segments should therefore be interpreted as an analytical classification rather than externally validated customer categories.

Forecast values are available for 2018–2021. The meaning of the `cost_forecast` field is not documented clearly enough to confirm that it represents shipping costs. In the report it is treated as a budget-like benchmark because its scale is comparable to sales revenue. This remains an analytical assumption.

The source contains transactions from January 29, 2018 to January 25, 2022. The report uses data through December 31, 2021 because 2022 contains only a partial month. The 2022 records remain in the source data.
