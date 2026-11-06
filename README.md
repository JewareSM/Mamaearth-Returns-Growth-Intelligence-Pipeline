
<img width="1500" height="500" alt="mamaearth-Capital-Mall-Vasai" src="https://github.com/user-attachments/assets/04476674-3d61-4268-b6a3-9ff0cd5bc32b" />



# Mamaearth-Returns-Growth-Intelligence-Pipeline
End-to-end Mamaearth returns analysis and growth intelligence covering SQL reporting, data cleaning and exploratory data analysis (EDA) using Python and Pandas, and a Gemini-powered Situation-Complication-Resolution (SCR) business narrative with an offline fallback.

Three connected layers: **SQL -> Python/pandas -> GenAI narrator**.

## Data flow
- `data/*.csv` are loaded into SQL (`sql/`) for independent reports.
- The same CSVs are cleaned and analysed in `analysis/clean_and_eda.py`, which **writes `narrator/findings.json`**.
- `narrator/generate_narrative.py` reads only `findings.json`, so no number reaches the narrative that was not computed upstream.

## Repo structure
```
README.md, requirements.txt
sql/            schema.sql, seed_data.sql, reports.sql
data/           customers.csv, products.csv, orders.csv
analysis/       clean_and_eda.py, visualize.py
visualizations/ return_rate_by_payment.png, monthly_revenue_trend.png
narrator/       findings.json, generate_narrative.py, sample_output.txt
```

## Run order

### 1. SQL layer (MySQL or SQLite)
1. MySQL: run `CREATE DATABASE IF NOT EXISTS mamaearth; USE mamaearth;`. SQLite: no setup.
2. Run `sql/schema.sql`, then `sql/seed_data.sql`.
3. Check counts: customers 45, products 16, orders 180.
4. Run `sql/reports.sql` (report (i) alters a table; to re-run, redo steps 2 and 3 first).

### 2. Python layer
1. `pip install -r requirements.txt`
2. Run `analysis/clean_and_eda.py` (run from the repo root). It prints every intermediate result and writes `narrator/findings.json`.
3. Run `analysis/visualize.py`. It writes both PNGs into `visualizations/`.
In Colab, use `!python analysis/clean_and_eda.py` and `!python analysis/visualize.py`.

### 3. Narrator layer
- **No API key (offline path, works with zero setup):** run `narrator/generate_narrative.py`.
- **Gemini path:** set `GEMINI_API_KEY` (free Google AI Studio key) as an environment variable, then run the same script. In Colab, use Secrets and `os.environ["GEMINI_API_KEY"] = userdata.get("GEMINI_API_KEY")`.
- Add `--save-sample` to write `narrator/sample_output.txt`. The script prints a PASS/FAIL checker for the five required figures.

## Key numbers to confirm
| Item | Value |
|---|---|
| Raw revenue (SQL report a) | 99,860.20 |
| Cleaned revenue (pandas) | 97,358.30 |
| Duplicate delta | 2,501.90 |
| Return rate COD / CARD / UPI | 44.4% / 14.7% / 18.9% |
| Highest-risk segment | COD + Tier-2, 54.5% |
| True peak month | March 2026, 20,318.90 |
