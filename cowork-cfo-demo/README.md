# Aldwych CFO — Snowflake CoWork demo (synthetic, loan-level)

A self-contained, reproducible demo that lets **Andrew Harper (CFO)** ask
plain-English questions in **Snowflake CoWork** (Cortex Analyst under the hood)
over a synthetic Aldwych Bank finance/risk mart with a **50,000-loan SME book**
underneath — so top-line answers survive deep-dive interrogation by sector,
region, rating grade, vintage, and loan status.

> All data is **invented** for demo use. Every headline is computed **bottom-up
> from the loan book** — nothing is hand-asserted.

## What it demonstrates — CFO question set
Mapped to the Office-of-the-CFO playbook (trust / growth / risk / efficiency):

- **Trust the numbers:** *"Forecast SME credit-loss provisions for the next four quarters, and show which segment and sector drive the increase."*
- **Profitable growth:** *"If we reinstate the automated credit model, compare MANUAL vs MODEL — provisions, manual cost, RWA and capital freed. What's the payback?"*
- **Reduce risk:** *"What's our total exposure if we miss the FCA/BCBS 239 deadlines this quarter — split deterministic vs probabilistic?"*
- **Operate efficiently:** *"Why does regulatory reporting take three weeks and how much team capacity is lost to legacy maintenance?"*

Deep dives it can survive: *by sector, by region, by rating grade, by vintage,
by loan status* — e.g. "exposure and average PD by sector, highest first",
"which regions hold the most Default/Watch exposure".

## Run order (execute against a role that can create DBs, ML objects, agents)
| File | Creates |
|------|---------|
| `00_setup.sql` | `CFO_DEMO_WH`, `CFO_DEMO.ALDWYCH` |
| `01_dimensions.sql` | segment, division, sector, region, rating-grade dims |
| `02_loanbook.sql` | `FACT_LOAN` — 50k deterministic SME facilities |
| `03_derived.sql` | monthly provisions, model-vs-manual scenario, capital context, risk models, obligations, exposure, process effort (all bottom-up) |
| `04_forecast.sql` | `ML.FORECAST` over 24 (segment×sector) series → `FACT_PROVISIONS_FORECAST` |
| `05_semantic_view.sql` | `CFO_SEMANTIC` (Cortex Analyst / CoWork surface) |
| `06_agent.sql` | `ALDWYCH_CFO_AGENT` + grants |
| `99_teardown.sql` | Drops everything |

Then open **Snowsight » Snowflake Intelligence (CoWork) » Aldwych CFO Agent**.

## Shape of the data
- **~£17B** SME book, **50,000** facilities, **8 sectors × 12 UK regions × 10 rating grades**, vintages 2016–2026.
- **~£376M** slice flagged `model_portfolio` = the FCA-suspended SME credit model.
- **48 months** of provisions history → **12-month** forecast (~£593M/12mo, rising).

## Key figures the data produces (model portfolio)
- MANUAL vs MODEL: provisions **£12.9M → £10.4M**, manual cost **£4.2M → £0.3M**, capital held **£31.9M → £29.4M** (**~£2.55M freed**).
- Annual benefit ≈ **£6.4M/yr** vs a ~£2.5M implementation → **~4–5 month payback**.
- Regulatory exposure (2026-Q4): **£59.4M gross / £38.7M probability-weighted**, deterministic vs probabilistic flagged.

## Notes
- `timing_quarter` is text (`2026-Q4`, the deadline quarter); say the quarter explicitly rather than "this quarter".
- Deliberately avoids the unreconciled "£10.3M" headline from the meeting notes; all figures roll up from the loan book.
