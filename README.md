# Mamaearth-Returns-Growth-Intelligence-Pipeline


<img width="1500" height="500" alt="mamaearth-Capital-Mall-Vasai" src="https://github.com/user-attachments/assets/04476674-3d61-4268-b6a3-9ff0cd5bc32b" />

End-to-end Mamaearth returns analysis and growth intelligence covering SQL reporting, data cleaning and exploratory data analysis (EDA) using Python and Pandas, and a Gemini-powered Situation-Complication-Resolution (SCR) business narrative with an offline fallback.

# 📦 Mamaearth Returns & Growth Intelligence Pipeline

![Python](https://img.shields.io/badge/Python-3.x-blue?logo=python&logoColor=white)
![Pandas](https://img.shields.io/badge/Pandas-EDA-150458?logo=pandas&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-MySQL%20Workbench-4479A1?logo=mysql&logoColor=white)
![Gemini](https://img.shields.io/badge/Gemini%20API-SCR%20Narrator-8E75B2?logo=googlegemini&logoColor=white)
![Colab](https://img.shields.io/badge/Google%20Colab-Notebooks-F9AB00?logo=googlecolab&logoColor=white)

An end-to-end analytics project that starts with raw order data, finds out **why orders are being returned**, and ends with a short business story written with the help of the Gemini API.

> Capstone project for the **E&ICT Academy, IIT Roorkee** program.

---

## 📑 Table of Contents

1. [Project Overview](#-project-overview)
2. [Business Problem](#-business-problem)
3. [Objectives](#-objectives)
4. [Workflow](#-end-to-end-workflow)
5. [Datasets](#-datasets)
6. [Tools and Technologies](#-tools-and-technologies)
7. [Part 1: SQL Reporting](#-part-1-sql-reporting)
8. [Part 2: Python and Pandas](#-part-2-python-and-pandas)
9. [Visualizations](#-visualizations)
10. [Part 3: GenAI Narrator](#-part-3-genai-narrator-gemini)
11. [Key Findings](#-key-findings)
12. [Business Recommendations](#-business-recommendations)
13. [Project Structure](#-project-structure)
14. [How to Run](#-how-to-run)
15. [Limitations](#-limitations)
16. [Author](#-author)

---

## 🎯 Project Overview

An online beauty and personal-care brand sells through three payment options (Card, UPI and Cash on Delivery) and gets a share of its orders back as returns. The raw order data is messy: payment methods are spelled in several ways, some orders were submitted twice, some values are missing, and two very large orders hide the real monthly trend.

This project cleans that data and answers three questions:

- **Where do returns come from?** Which payment method and which type of city?
- **What does revenue really look like** once duplicates and bulk-order outliers are handled?
- **How can the results be explained simply** to operations and finance managers?

The work is split into three parts: **SQL** for reporting, **Python/Pandas** for cleaning and analysis, and a **Gemini-powered narrator** that turns the verified numbers into a Situation–Complication–Resolution (SCR) summary.

---

## 💼 Business Problem

Returns cost money. Every returned order means lost revenue plus shipping and handling effort. The business needs to know **which orders are most likely to come back**, so it can act on the real cause instead of guessing.

Two data problems made the first look at the numbers misleading:

| Problem | Effect |
|---|---|
| Duplicate (double-submitted) orders | Revenue was overstated by **INR 2,501.90** |
| Two bulk orders in January (25 and 30 units) | January looked like the best month when it was not |

---

## ✅ Objectives

- Build a small relational database and answer business questions with SQL.
- Clean the data in Pandas: standardize text, remove duplicates, fill missing values and flag outliers.
- Test two ideas with data: *"COD orders are returned more often"* and *"higher discounts reduce returns"*.
- Show the main results in two clear charts.
- Use the Gemini API to write an SCR business narrative from verified numbers only, with an **offline fallback** that works without an API key.

---

## 🔄 End-to-End Workflow

```
 Raw CSVs (customers, products, orders)
        │
        ├──► PART 1  SQL ───────► schema, data loading, 9 business reports
        │
        ├──► PART 2  Pandas ────► clean ► merge ► outliers ► return-rate analysis ► monthly revenue
        │                │
        │                ├──► Charts (bar chart + line chart)
        │                └──► findings.json  (written by code, never typed by hand)
        │
        └──► PART 3  Narrator ──► reads findings.json ► Gemini (or offline template)
                                  ► SCR narrative ► accuracy checker ► sample_output.txt
```

---

## 🗂 Datasets

Three CSV files, all in the `data/` folder.

| Table | Rows | Columns | What it contains |
|---|---|---|---|
| `customers` | 45 | 6 | `customer_id`, `name`, `city`, `city_tier`, `signup_date`, `acquisition_source` |
| `products` | 16 | 4 | `product_id`, `product_name`, `category`, `price` |
| `orders` | 180 | 9 | `order_id`, `customer_id`, `product_id`, `order_date`, `quantity`, `discount_pct`, `payment_method`, `rating`, `returned` |

**How they are related**

```
customers (1) ───< orders >─── (1) products
  customer_id                       product_id
```

Each order belongs to one customer and one product. Order value is calculated as:

```
order_value = quantity × price × (1 − discount_pct / 100)
```

Orders cover **January to June 2026**.

---

## 🛠 Tools and Technologies

| Area | Tools |
|---|---|
| Database / SQL | MySQL Workbench (queries are also SQLite-compatible) |
| Data analysis | Python, Pandas, NumPy |
| Charts | Matplotlib, Seaborn |
| GenAI | Google Gemini API (`google-genai`), model `gemini-2.5-flash` |
| Environment | Google Colab, Google Drive |
| Version control | GitHub |

---

## 🧮 Part 1: SQL Reporting

Files are in the `sql/` folder.

| File | Purpose |
|---|---|
| `schema.sql` | Creates the three tables with primary keys, foreign keys and nullable `discount_pct` / `rating` |
| `seed_data.sql` | `INSERT` statements that load all 45 + 16 + 180 rows |
| `reports.sql` | Nine business reports, with the actual output written above each query |

**What the reports answer**

| Report | Business question | Result |
|---|---|---|
| (a) | How many orders and how much revenue? | 180 orders, **INR 99,860.20** total, **INR 554.78** average order |
| (b) | How many ratings are missing? | `COUNT(*)` = 180, `COUNT(rating)` = 165, so **15 missing** |
| (c) | Which customers never ordered? | **C045 (Vihaan)**, found with both `LEFT JOIN` and `NOT IN` |
| (d) | Which cities return more than 20% of orders? | **Jaipur 42.1%, Lucknow 30.6%, Bangalore 24.2%** |
| (e) | Who are the top 5 customers by spend? | Top spender **C043, INR 12,920.00** (ties are broken by `customer_id`; `LIMIT/OFFSET` returns ranks 3–5) |
| (f) | Which category earns the most? | **Haircare, INR 44,956.10**, then Skincare 27,346.00, Babycare 16,805.00, PersonalCare 10,753.10 |
| (g) | Which customers have a name starting with "A"? | 10 customers (`LIKE 'A%'`) |
| (h) | What are the acquisition sources? | Ad, Organic, Referral, Social (`DISTINCT`) |
| (i) | Add a loyalty tier | `ALTER TABLE` + `UPDATE ... CASE`: Tier-1 cities = Gold (28), Tier-2 = Silver (17) |

**SQL concepts used:** `COALESCE`, `JOIN` (two and three tables), `LEFT JOIN`, subqueries, `GROUP BY` / `HAVING`, `ORDER BY` with a tie-breaker, `LIMIT` / `OFFSET`, `LIKE`, `DISTINCT`, `ALTER TABLE`, `CASE`.

> Report (i) changes the table, so it is placed last. To run `reports.sql` again, run `schema.sql` and `seed_data.sql` first. In MySQL Workbench, `SET SQL_SAFE_UPDATES = 0;` is needed before the `UPDATE` in report (i).

---

## 🐼 Part 2: Python and Pandas

The analysis lives in `final_clean.ipynb` (one task per cell, with output and an Observation after each) and in `analysis/clean_and_eda.py`.

### Data cleaning

| Task | What was done | Result |
|---|---|---|
| 1. Load | Read the three CSVs | `(45, 6)`, `(16, 4)`, `(180, 9)` |
| 2. Payment casing | `strip()` and `upper()` on `payment_method` | **7 spellings became 3**: CARD 70, UPI 55, COD 55 |
| 3. Duplicates | Dropped rows identical in every column except `order_id` | **5 duplicates removed** (O0176 to O0180), 175 rows left |
| 4. Missing values | `discount_pct` filled with 0, `rating` filled with the median | 12 discounts and 15 ratings filled, median rating **3.0** |
| 5. Merge and reconcile | Joined orders, products and customers | Cleaned total **INR 97,358.30** |

**Reconciliation with SQL:** the SQL total (INR 99,860.20) minus the cleaned total (INR 97,358.30) is **INR 2,501.90**. This equals the combined value of the 5 duplicate orders, calculated separately. Filling missing values does not change the total.

### Missing values: heatmaps

Heatmaps were drawn before and after imputation. Missing values appear **only in `discount_pct` and `rating`**, and after filling, no gaps remain.

### Outlier detection

The IQR rule was applied to `quantity`:

| Q1 | Q3 | IQR | Lower limit | Upper limit |
|---|---|---|---|---|
| 1.0 | 2.0 | 1.0 | -0.5 | 3.5 |

Exactly **2 outliers** were found: **O0011 (25 units)** and **O0098 (30 units)**. A box plot shows them clearly. They are **flagged, not deleted**, because they are real orders.

### Hypothesis tests and EDA

- **COD return rate:** COD has the highest return rate (see Key Findings).
- **Segmentation:** return rate by payment method and city tier.
- **Correlation:** six pairs among `rating`, `returned`, `discount_pct` and `quantity`.
- **Monthly revenue:** calculated with and without the two outliers.

---

## 📊 Visualizations

Two charts, drawn from the cleaned data (`analysis/visualize.py` and Task 11 of the notebook).

### 1. Return rate by payment method

![Return rate by payment method](visualizations/return_rate_by_payment.png)

Bars are sorted from highest to lowest, each bar shows its exact percentage, and the title is built from the numbers: COD returns at 44.4%, about 3 times Card.

### 2. Outlier-corrected monthly revenue

![Monthly revenue trend](visualizations/monthly_revenue_trend.png)

The line chart uses revenue **without** the two bulk orders. The real peak month is **March 2026 (INR 20,318.90)**.

---

## 🤖 Part 3: GenAI Narrator (Gemini)

Everything is in `narrator/` and in `generate_narrative.ipynb`.

### How it works

1. **`findings.json`** holds the verified numbers. It is written by code at the end of the Pandas analysis, so it cannot drift away from the results.
2. A **system instruction** (kept separate from the user prompt) sets the role, the three sections (Situation, Complication, Resolution) and the rule that every number must come from the findings.
3. The **user prompt** is built from the findings dictionary, so a different `findings.json` gives a different narrative.
4. The Gemini call uses `temperature=0.0` (a factual report should be predictable), an explicit `max_output_tokens`, and a timeout. The whole call is wrapped in `try/except` and always returns a dictionary:
   - success: `{"status": "success", "narrative": ..., "tokens": ...}`
   - error: `{"status": "error", "narrative": None, "message": ...}`
5. **Offline fallback:** if there is no API key, or the call fails, a template function builds the same three sections directly from `findings`. It needs no network and no key.
6. **Accuracy checker:** confirms that the narrative contains the five required figures (97,358.30, 44.4, 54.5, 2,501.90, and March with 20,318.90) and prints PASS or FAIL for each.
7. The narrative is saved to `sample_output.txt`, and the checker is run on the saved file.

### Free API key

Get a free key from [Google AI Studio](https://aistudio.google.com) and store it as `GEMINI_API_KEY` in **Colab Secrets** (or as an environment variable). Never paste the key into a notebook or commit it to GitHub.

---

## 🔍 Key Findings

### Return rate by payment method

| Payment method | Orders | Return rate |
|---|---|---|
| **COD** | 54 | **44.4%** |
| UPI | 53 | 18.9% |
| CARD | 68 | 14.7% |

COD orders are returned about **3 times as often as Card** and about 2.3 times as often as UPI.

### Highest-risk segment (payment method × city tier)

| Payment | Tier-1 | Tier-2 |
|---|---|---|
| CARD | 8.9% | 26.1% |
| **COD** | 37.5% | **54.5%** |
| UPI | 19.4% | 18.2% |

**COD in Tier-2 cities has the highest return rate: 54.5%** (22 orders). The blended COD rate of 44.4% hides this difference.

### Discounts do not explain returns

All six correlations are **negligible** (below 0.2 in size). Discount vs returned is only **-0.088**, so the idea that *"higher discounts reduce returns"* is **busted**.

### Revenue picture

| Month | With outliers (INR) | Without outliers (INR) |
|---|---|---|
| Jan 2026 | 29,582.10 | 11,637.10 |
| Feb 2026 | 13,195.50 | 13,195.50 |
| Mar 2026 | 20,318.90 | 20,318.90 |
| Apr 2026 | 9,495.30 | 9,495.30 |
| May 2026 | 13,151.10 | 13,151.10 |
| Jun 2026 | 11,615.40 | 11,615.40 |

January only looked like the best month because of the two bulk orders (O0011 and O0098). **March 2026 is the true peak**, and April is the weakest month.

---

## 💡 Business Recommendations

These follow directly from the findings above.

1. **Focus COD controls on Tier-2 cities.** COD + Tier-2 is the highest-risk segment (54.5%). Order-confirmation calls or messages before dispatch are a sensible first step.
2. **Encourage prepaid payment.** Card and UPI orders are returned far less often than COD. A small incentive for prepaid orders could be tested.
3. **Do not rely on discounts to reduce returns.** The data shows almost no link between discount and returns.
4. **Check Tier-2 Card orders too.** Card returns are 26.1% in Tier-2 versus 8.9% in Tier-1.
5. **Report revenue trends without bulk-order outliers.** Use March as the real peak when planning, and review very large orders separately.
6. **Remove duplicate orders at the source.** The 5 double-submitted orders inflated revenue by INR 2,501.90.

---

## 📁 Project Structure

```
mamaearth-returns-growth-intelligence/
│
├── README.md
├── requirements.txt
│
├── data/
│   ├── customers.csv
│   ├── products.csv
│   └── orders.csv
│
├── sql/
│   ├── schema.sql
│   ├── seed_data.sql
│   └── reports.sql
│
├── analysis/
│   ├── clean_and_eda.py          # Tasks 1-10 + writes narrator/findings.json
│   └── visualize.py              # the two charts
│
├── notebooks/
│   ├── final_clean.ipynb         # cleaning + EDA + charts (Tasks 1-12)
│   ├── visualize.ipynb           # chart code as a notebook
│   └── generate_narrative.ipynb  # Part 3 narrator (Tasks 1-5)
│
├── visualizations/
│   ├── return_rate_by_payment.png
│   └── monthly_revenue_trend.png
│
└── narrator/
    ├── findings.json
    ├── generate_narrative.py
    └── sample_output.txt
```

---

## ▶️ How to Run

### 1. SQL (MySQL Workbench)

1. Create a database: `CREATE DATABASE mamaearth; USE mamaearth;`
2. Run `sql/schema.sql`, then `sql/seed_data.sql`.
3. Check the row counts: 45 customers, 16 products, 180 orders.
4. Run `sql/reports.sql` (report (i) is last, because it changes the table).

### 2. Notebooks (Google Colab)

1. Upload the three CSV files to your Google Drive folder `MyDrive/IITR_Capstone_Project`.
2. Open `final_clean.ipynb` in Colab and run all cells from top to bottom. Allow Drive access when asked. The last cell downloads the two charts and `findings.json`.
3. Copy `findings.json` into the same Drive folder.
4. Open `generate_narrative.ipynb` and run it top to bottom. To use Gemini, first add `GEMINI_API_KEY` in Colab Secrets. Without a key, the offline fallback runs.

### 3. Python scripts (local or Colab)

```bash
pip install -r requirements.txt

python analysis/clean_and_eda.py     # prints every result and writes narrator/findings.json
python analysis/visualize.py         # saves the two charts in visualizations/
python narrator/generate_narrative.py --save-sample   # writes narrator/sample_output.txt
```

`requirements.txt`:

```
pandas
numpy
matplotlib
seaborn
google-genai
```

---

## ⚠️ Limitations

- The dataset is small (180 raw orders, 175 after cleaning), so results such as COD + Tier-2 (22 orders) show a clear pattern but should be confirmed with more data.
- Correlation does not prove cause. The analysis shows **where** returns are high, not **why**.
- The Gemini narrative can change slightly between runs, so the saved `sample_output.txt` and the accuracy checker are used to verify it. The offline fallback always passes the checker.

---

## 👤 Author

**Shubham Jeware**
BI / Data Analyst

If you found this project useful, please give it a ⭐
