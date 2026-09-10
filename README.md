# Swedish Retail Demand Recovery: Post-Inflation Volume Forecasting by Category (2015–2026)

## Power BI Dashboard

https://app.powerbi.com/groups/me/reports/469a2114-39e9-450d-aa63-f4ee0993975e/c6a1449fe9de48a529c2?experience=power-bi

The dashboard covers:

- Category-level demand recovery index (2021 = 100 benchmark)
- Recovery gap by category showing distance from benchmark
- Year-over-year demand growth trends
- Six-month forward forecast by category (August 2026 to January 2027)

---
## Project Overview

Swedish retail experienced a substantial inflationary shock during 2021 to 2023.
Looking only at nominal sales figures is misleading: revenue can rise simply because
prices rose, even when the actual volume of goods sold is declining.

This project answers three connected business questions:

1. **What happened?** How did real retail demand evolve across five Swedish retail
   categories from 2015 onward?
2. **Where are we now?** Which categories have recovered toward their pre-inflation
   benchmark, and which remain below it?
3. **What happens next?** Based on historical demand patterns, what is the expected
   demand trajectory through January 2027?

---

## Business Problem

A retailer or category manager relying on nominal sales data risks misreading the
market. A category can appear commercially healthy while its underlying real demand
remains structurally weak.

This project focuses on constant-price retail demand indices sourced from Statistics
Sweden (SCB), separating genuine volume recovery from price-driven nominal growth.

---

## Key Findings

- Recovery is **highly uneven across categories**, not broad-based.
- **Furniture** remains approximately 18% below its 2021 demand benchmark as of
  July 2026.
- **Sports** remains approximately 14% below benchmark, broadly flat through
  January 2027.
- **Clothing** has essentially returned to its 2021 benchmark level.
- **Medical/cosmetic/toilet** stands approximately 49% above its 2021 benchmark
  and continues modestly upward.
- **Food** is broadly stable but its forecasting series only begins January 2023,
  limiting historical depth.

---

## Forecast Performance (Out-of-Sample Validation on 2025 Actuals)

| Category | MAPE | RMSE |
|---|---|---|
| Mostly food | 0.83% | 1.00 |
| Sports shops | 2.03% | 2.23 |
| Furniture | 2.79% | 2.51 |
| Clothing | 2.85% | 3.49 |
| Medical/cosmetic/toilet | 6.88% | 10.98 |

Models were trained through December 2024 and validated on January to December 2025
actuals before generating the final August 2026 to January 2027 forecast. This
out-of-sample framework ensures honest model evaluation.

---

## Methodology

### Phase 1: Data Inspection and Cleaning
Raw SCB extract validated, cleaned, and reshaped from wide to long format in Python.
Two overlapping source files compared and reconciled. Missing values retained
explicitly rather than imputed. Final dataset: 2,085 rows across 5 categories,
3 observation types, and 139 months.

### Phase 2: SQL Business Analytics
Clean data loaded into MySQL. Three analytical views built:

- **yoy_growth:** Year-over-year demand growth by category and month.
- **recovery_index:** Current demand relative to each category's 2021 average.
- **recovery_gap:** Percentage-point deviation from the 2021 benchmark.

### Phase 3: Forecasting
Holt-Winters exponential smoothing applied to the seasonally adjusted,
working-day adjusted, constant-price series. Additive trend model used
without an additional seasonal component, because the source series is
already seasonally adjusted. Models validated out-of-sample on 2025 actuals
using MAPE and RMSE before final forecast generation.

---

## Technology Stack

| Area | Tool |
|---|---|
| Data source | Statistics Sweden (SCB) |
| Data preparation | Python, pandas |
| Statistical modelling | Python, statsmodels (Holt-Winters) |
| Visualisation | matplotlib |
| Database | MySQL, DBeaver |
| Business analytics | SQL |
| Business dashboard | Power BI |
| Version control | GitHub |
| Development environment | Google Colab |

---

## Repository Structure
swedish-retail-demand-recovery/
│
├── README.md
│
├── data/
│ └── README.md # Data source description and download instructions
│
├── python/
│ ├── 01_data_inspection_cleaning.ipynb
│ └── 02_forecasting.ipynb
│
├── sql/
│ └── 01_retail_demand_analysis.sql
│
├── powerbi/
│ └── swedish_retail_demand_recovery.pbix
│
├── outputs/
│ ├── figures/ # Python analytical visualisations
│ └── forecasts/ # Final forecast CSV outputs
│
└── requirements.txt


---

## Data Source

**Statistics Sweden (SCB)**
Dataset: Retail sale by industry, NACE Rev. 2
Coverage: January 2015 to July 2026
Index base: 2021 = 100
Access: [SCB Statistical Database](https://www.scb.se/en/finding-statistics/statistics-by-subject-area/trade-in-goods-and-services/retail-and-wholesale-trade/retail-trade-index/)

The longer 2015 to 2026 file was selected as the source of truth after
validating identical values in the overlapping 2018 to 2026 period across
both available SCB files.

---

## Key Limitations

- The food category forecasting series is unavailable from January 2015 through
  December 2022. Its forecast is based on a shorter historical window and should
  be interpreted with additional caution.
- The medical/cosmetic/toilet category showed the highest forecast error (MAPE
  6.88%) due to its substantially elevated demand level. Treat its forecast with
  greater caution than other categories.
- Results are based on SCB index values, not direct revenue or unit sales figures.
  They describe demand index movements and should not be interpreted as exact SEK
  revenue forecasts.
- Holt-Winters was selected for its strong out-of-sample performance across most
  categories. It is not claimed to be universally optimal.

---

## About the Author

Harsha Vardhan Gobanna
MSc Industrial Management and Innovation, Uppsala University

[GitHub](https://github.com/Harshaa20) |
[LinkedIn](https://linkedin.com/in/harsha-vardhan-g-b21747246)

---

## Related Projects

**Part 1: Swedish Food Price Inflation — Supply Chain Price Transmission Analysis
(2018-2023)**
Analyses the cost side of the same inflationary period: where upstream import
price pressure concentrated, how it transmitted to consumer prices, and what
it means for procurement and demand planning teams.

https://github.com/Harshaa20/Sweden-Food-Price-Inflation-Analysis-2018-2023
