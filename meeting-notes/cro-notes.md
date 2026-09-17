# Sarah Mitchell — Chief Risk Officer

> Economic sponsor & budget owner

## Notes
<!-- Date-stamped meeting notes. Newest on top. -->

### 2026-09-17 — Risk Data Lineage & Operational Resilience POC (Snowflake + Sigma next steps)
_Full summary + transcript in `cro-notes/`._
**Participants:** Sarah (Bank Risk Leader), Cliff & Abhijit (Snowflake SEs); discussed but not present: Andrew (CTO — platform decision/budget authority), Charlotte Davies (Head of Group Data Architecture — see note), the CDO, and David's Risk/Data Engineering team (Director Elena Torres delivered the prototype).

_Note: the summary lists "Charlotte (Microsoft contact)" — treating this as the same Charlotte Davies per team judgement, not a separate person._

- **Attribute-level lineage is non-negotiable** for any platform choice — table/source-level is insufficient to justify model outputs to auditors.
- **Proof point:** prior POC demonstrated attribute-level lineage and a **5x improvement in AML identification in ~2 weeks** via Snowflake + partners — strong risk reduction, rapid implementation.
- **Regulatory exposure:** FCA compliance failures risk **£35–55M** penalties; none paid yet.
- **Budget:** Sarah has **£2–3M ring-fenced for remediation**, but **platform fixes require Andrew's (CTO) allocation** — her sponsorship is real but gated by his sign-off. Q4 urgency.
- **POC gap:** Sigma POC covered only investment-banking data; risk needs **both retail + investment banking** with lineage and workflow visibility.
- **Operational resilience:** priority is producing reports on time (three-week launch window) and showing end-to-end risk-decision workflows (inputs → analysis → outputs → reporting) across fragmented systems/spreadsheets. (Andrew owns downtime/region resilience; Sarah owns timely, traceable workflows.)
- **Governance:** cross-domain visibility (Azure, enterprise sources) with strict RBAC — "only the right people."
- **Feedback to Snowflake:** lead with the POC success earlier, spend more time on the operational-resilience workflow, dig into value drivers (capital allocation, cost savings, revenue upside) beyond a lineage "tick-box," and discuss tools beyond Sigma.
- **Next step:** extend the POC to cover retail + investment banking with attribute-level lineage and an operational-resilience-compliant risk workflow; tailor the narrative to value outcomes ahead of an Andrew-facing demo.

<!-- The "Snowflake Risk & Data Governance Discussion with Bank's Risk/Data Team" entry
     that previously sat here was David Chen's Model Risk / Risk-Data Engineering meeting
     (Speaker 3 = the $1.8M-budget risk/data leader, Elena Torres's manager). Moved to
     model-risk-notes.md on 2026-09-17. -->

### YYYY-MM-DD — <meeting title>
- 

## Follow-ups
- [ ] 
