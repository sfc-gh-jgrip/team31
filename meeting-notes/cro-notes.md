# Sarah Mitchell — Chief Risk Officer

> Economic sponsor & budget owner

## Notes
<!-- Date-stamped meeting notes. Newest on top. -->

### 2026-09-17 — Snowflake Risk & Data Governance Discussion with Bank's Risk/Data Team
**Participants:**
- Cliff (Speaker 1, Snowflake team)
- Kideny (Speaker 1 reference, Snowflake team)
- Speaker 2 (Unidentified, likely meeting facilitator or team member)
- Speaker 3 (Bank Risk/Data leader; has $1.8M budget; manager of Elena Torres)
- Speaker 4 (Snowflake colleague presenting governance demo)
- Elena Torres (mentioned; Director under Speaker 3)

**1. Summary**
- Purpose: Assess solutions for regulatory compliance challenges (data lineage/provenance, identity resolution across legal entities, audit traceability) impacting risk reporting, P&L, licensing, and AI strategy.
- Context: Bank has fragmented legacy pipelines (7 separate risk data feeds), manual lineage tracking, and difficulty with cross-entity analysis. A recent audit failed due to lack of column-level traceability. The organization is legally split between retail banking and finance, requiring strict data separation and selective sharing.
- Key insights:
  - 55% of the team's time is spent maintaining legacy pipelines; cross-product analysis takes weeks due to missing lineage.
  - Budget: $1.8M that expires at end of Q2; urgency to adopt a unified platform.
  - PoC: Internal test using Snowflake + Relational AI AML prototype achieved 3x better detection and passed BCBS audit on another platform; indicates viability.
- Proposed solution direction:
  - Snowflake's data governance: connectors, table popularity scoring, certification, data quality checks, column-level lineage, consumer tool integrations (Tableau/Power BI), and ability to operate as a unified platform.
  - Graph/AML chain analysis to be addressed via partners (Neo4j, Relational AI); Snowflake does not currently have GA native graph analytics.
  - Legal separation: Two Snowflake tenants (retail and finance) with separate contracts/access/governance; use Snowflake Direct Data Sharing for controlled data transfers without pipelines.
- Outcome: Customer needs a working demo quickly to validate lineage, governance, and operational flow; focus on lineage/audit compliance first, expand to identity resolution and AML chain analysis. Feedback requested for practical handling of "same-person across entities" use case.

**2. Key Tasks/Commitments for Ralph Audörsch**
- No direct tasks assigned to Ralph in this meeting. The discussion was between the Snowflake team and the bank's risk/data team. Below are tasks and commitments captured for the involved parties to inform follow-up coordination.
- Working demo of Snowflake governance and lineage capabilities [Owner: Cliff/Kideny/Speaker 4 (Snowflake); Due: As soon as possible, to enable action before end of Q2 budget expiry]
- Confirm/connectors coverage (Oracle, IBM DB2) and Azure Data Factory compatibility [Owner: Snowflake team; Due: ASAP]
- Provide architecture plan for dual-tenant setup (retail and finance) with Direct Data Sharing policies [Owner: Snowflake team; Due: ASAP]
- Outline approach for identity resolution across legal entities ("David" use case) with practical steps and governance controls [Owner: Snowflake team; Due: ASAP]
- Evaluate/prepare partner integration path for AML chain analysis (Neo4j/Relational AI) aligned to audit requirements [Owner: Snowflake team; Due: Within next two quarters; initial guidance ASAP]
- Share PoC details and internal findings (Elena Torres' AML prototype and BCBS audit pass) with broader stakeholders to improve communication [Owner: Speaker 3 (Bank), Elena Torres; Due: ASAP]
- Prioritize migration/decommissioning using table popularity and certification workflow; align data stewards/owners [Owner: Bank data governance team; Due: Post-demo]

**3. Detailed Breakdown by Topic**

*Topic 1: Regulatory Compliance & Audit Traceability (Data Lineage/Provenance)*
- Discussion:
  - Audit failed due to inability to trace at column level back to source systems (Oracle, IBM DB).
  - Manual lineage tracking and fragmented pipelines (7 risk data feeds) hinder cross-entity analysis and create delays.
  - 55% of team effort is maintenance; need a platform decision not as a preference but as necessity.
- Decisions/Positions:
  - Prioritize lineage and audit traceability to restore regulatory compliance and free team capacity.
  - Snowflake presented column-level lineage and governance features; bank needs a working demo.
- Tasks:
  - Snowflake to deliver a working demo showcasing end-to-end column-level lineage and governance [Owner: Snowflake; Due: ASAP].
  - Confirm connector support (Oracle available; DB2 "in pipeline"; Azure Data Factory workable) [Owner: Snowflake; Due: ASAP].

*Topic 2: Platform Consolidation & Timelines/Budget*
- Discussion:
  - Desire for "one platform that does it all" to avoid multi-tool sprawl (Azure Stack currently used).
  - Budget: $1.8M expiring end of Q2; need to act fast.
  - PoC with Snowflake + Relational AI yielded strong results (3x detection rate; BCBS audit pass); indicates potential to meet deadlines.
- Decisions/Positions:
  - Snowflake is viable; next step is hands-on demo to accelerate decision and implementation.
- Tasks:
  - Snowflake to propose a migration acceleration plan leveraging built-in AI-assisted migration capabilities [Owner: Snowflake; Due: ASAP].
  - Bank to plan rapid implementation contingent on demo validation [Owner: Speaker 3's team; Due: ASAP].

*Topic 3: Legal Entity Separation & Data Sharing*
- Discussion:
  - Bank operates legally separated entities (retail and finance); needs strict borders yet selective data sharing.
- Decisions/Positions:
  - Use two separate Snowflake tenants with distinct contracts/access/governance.
  - Employ Snowflake Direct Data Sharing for controlled inter-entity data transfer (no pipelines).
- Tasks:
  - Snowflake to provide a detailed architecture and governance policy template for dual-tenant setup and data sharing [Owner: Snowflake; Due: ASAP].

*Topic 4: Identity Resolution Across Entities ("Same Person" Problem)*
- Discussion:
  - Difficulty identifying that "David" in retail and "David" in finance are the same person; current process is manual.
  - Customer requested practical steps for handling this in Snowflake.
- Decisions/Positions:
  - Not fully resolved during meeting; requires a practical, governed approach (e.g., entity resolution models, hash-based joins, privacy-preserving linkage).
- Tasks:
  - Snowflake to deliver a practical methodology for identity resolution across legally separated tenants, covering data models, matching rules, stewardship workflows, and compliance controls [Owner: Snowflake; Due: ASAP].

*Topic 5: AML Chain Analysis & Graph Capabilities*
- Discussion:
  - Need to track funds movement across accounts (multi-hop chains) for AML; asked if Snowflake handles this natively.
  - Snowflake currently relies on partners (Neo4j, Relational AI); no GA native graph capability at present.
- Decisions/Positions:
  - Proceed with partner solutions integrated on Snowflake data; focus on robust architecture now, expand to AML graph later.
- Tasks:
  - Snowflake to outline partner integration plan and reference architectures for AML graph analytics, aligned to compliance timelines [Owner: Snowflake; Due: Within next two quarters; initial guidance ASAP].

*Topic 6: Data Governance Features & Quality Controls*
- Discussion:
  - Snowflake demo highlighted: external data connections, table popularity scoring, certification by data stewards/owners, data preview, ratings, data quality checks (freshness, volume).
  - Bank has internal data quality framework; interested in trustworthy information and alignment.
- Decisions/Positions:
  - Use popularity/certification to guide migration and decommissioning; integrate existing DQ controls.
- Tasks:
  - Bank governance team to align stewards/owners and adopt certification workflow post-demo [Owner: Bank; Due: Post-demo].

*Topic 7: Communication & Internal Alignment*
- Discussion:
  - Speaker 3 noted poor internal communication; PoC success (Elena Torres) not widely known.
  - Feedback: Good that Snowflake asked about prior work; customer wants clearer practical guidance on identity resolution.
- Decisions/Positions:
  - Share PoC outcomes broadly to build momentum; request Snowflake to present concrete identity resolution approach.
- Tasks:
  - Speaker 3/Elena Torres to circulate PoC findings and BCBS audit result internally [Owner: Bank; Due: ASAP].
  - Snowflake to prepare targeted materials addressing the "same-person across entities" case [Owner: Snowflake; Due: ASAP].

### YYYY-MM-DD — <meeting title>
- 

## Follow-ups
- [ ] 
