# Aldwych CFO — Snowflake CoWork demo (synthetic)

A self-contained, reproducible demo that lets **Andrew Harper (CFO)** ask
plain-English questions in **Snowflake CoWork** (Cortex Analyst under the hood)
over a small synthetic Aldwych Bank finance/risk data mart. Built to be
**CFO-suitable** and outcome-led — no lineage plumbing, no external BI.

> All data is **invented** for demo use. Figures are internally consistent so
> CoWork computes headlines *from the data* — nothing is hand-asserted.

## What it demonstrates
The two hero questions:

1. **"Forecast our SME credit-loss provisions for the next four quarters, and flag which segments are driving the change."**
2. **"If we reinstate the automated credit model this quarter, what's the payback and how much capital does it free up?"**

Useful follow-ups the semantic view also answers:
- *"What's our total probability-weighted regulatory exposure this quarter, by component?"*
- *"Which risk models are offline and what are they costing us?"*
- *"Why does regulatory reporting take three weeks and where is the effort?"*

## Run order
Execute against a role that can create databases, ML forecast objects, and
agents (demo built with ACCOUNTADMIN). From SnowSQL / Snowsight worksheets, or
`snow sql -f`:

| File | Creates |
|------|---------|
| `00_setup.sql` | `CFO_DEMO_WH` warehouse, `CFO_DEMO.ALDWYCH` schema |
| `01_tables.sql` | Dimension + fact tables |
| `02_seed.sql` | Synthetic data (36 months x 3 segments, scenario, exposure, etc.) |
| `03_forecast.sql` | `ML.FORECAST` model + `FACT_SME_PROVISIONS_FORECAST` (keep the CALL and the RESULT_SCAN capture together — same session) |
| `04_semantic_view.sql` | `CFO_SEMANTIC` semantic view (Cortex Analyst / CoWork surface) |
| `05_agent.sql` | `SNOWFLAKE_INTELLIGENCE.AGENTS.ALDWYCH_CFO_AGENT` CoWork agent |
| `99_teardown.sql` | Drops everything |

Then open **Snowsight » Snowflake Intelligence (CoWork) » Aldwych CFO Agent**
and ask the questions above.

## Key figures the data produces
- MANUAL vs MODEL scenario: provisions **£5.70M → £5.01M**, manual cost **£4.20M → £0.30M**, capital held **£35.34M → £32.50M** (**£2.84M freed**).
- Annual benefit ≈ **£4.59M/yr** (manual saving + provision reduction); against a ~£2.5M implementation that's roughly a **~6-7 month payback**.
- Regulatory exposure this quarter: **£59.4M gross**, **£38.7M probability-weighted** (FCA penalty, capital add-on, operational cost, P&L drag).

## Notes / tuning
- `timing_quarter` is stored as text (e.g. `2026-Q4`, the deadline quarter). If a
  user says "this quarter," steer them to name the quarter, or adjust the
  dimension to your demo date.
- Deterministic vs probabilistic exposure is flagged (`is_deterministic`) so the
  agent can separate the near-certain FCA notice from probabilistic consequences.
- Figures deliberately avoid the unreconciled "£10.3M" headline seen in the
  meeting notes; provisions here are a realistic run-rate off a ~£350M SME book.
