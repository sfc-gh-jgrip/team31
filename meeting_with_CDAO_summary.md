# 09-17 Meeting: CDO and Snowflake on Data Lineage, Regulatory Compliance, and AI Enablement
**CDO Meeting with Snowflake Team – Data Lineage, Regulatory Compliance, and AI Enablement**
**Date:** 2026-09-17
**Participants:** 
- Dr. Priya (Speaker 1) – Chief Data Officer (CDO)
- Cliff (Speaker 2) – Snowflake
- Ketki (Speaker 3) – Snowflake
- Julio (Speaker 4) – Snowflake
**1. Summary:**
- Purpose: Snowflake team met with Dr. Priya (CDO) to discuss resolving regulatory blockers (BCBS/FCA) impacting model deployment and P&L, align on a unified approach to data lineage/provenance, and explore AI enablement (self-service analytics, Snowflake Intelligence/Cortex, knowledge graphs).
- Key Issues:
  - Regulatory: FCA has suspended an SME credit risk ML model due to inadequate data lineage/provenance; BCBS calculation requirements also implicated. Consequence: ~£340–£350M SME credit portfolio is being manually assessed, impacting P&L and incurring labor cost.
  - Financial impact: Estimated P&L uplift of ~£10.3M from restoring model usage (108 bps on ~£350M) plus ~£4.2M annual labor cost currently spent on manual reviews.
  - Timeline: CDO needs tangible outcomes within two quarters to report to CFO.
- AI Strategy: Desire for bank-wide governed self-service (execs, chief modeling officer, CFOs) using natural language to query data; evaluating Snowflake Intelligence/Cortex vs. existing Sigma BI usage; interest in knowledge graphs for enterprise context.
- Vendor Differentiation: CDO requested clear, cost/benefit-driven differentiation and what can be delivered within two quarters.
- Next Steps from Snowflake:
  - Propose a unified lineage/provenance approach supporting both regulatory streams and AI governance.
  - Coordinate with Model Risk Engineering (David Chen) on fraud analytics opportunities that impact P&L before CFO meeting.
  - Clarify positioning of Snowflake Intelligence/Cortex vs. Sigma for different user profiles; both run on Snowflake compute.
  - Share work on knowledge graphs/enterprise ontology to improve AI trust and deployment readiness.
**2. Key Tasks/Commitments for Ralph Audörsch:**
- None assigned during this meeting.
**3. Detailed Breakdown by Topic:**
**Topic 1: Regulatory Compliance and Model Lineage (BCBS/FCA)**
- Discussion:
  - CDO confirmed two regulatory pressures share the same root cause: missing data provenance/lineage.
  - FCA halted an SME credit risk ML scoring model due to insufficient lineage/quality evidence; BCBS is driving calculation controls.
  - Current workaround requires manual assessment of ~£340–£350M SME credits; model performance itself is satisfactory but cannot be used without lineage assurance.
- Metrics shared:
  - Portfolio: ~£340–£350M SME credits impacted.
  - P&L impact: ~108 bps improvement expected if model returns to production (~£10.3M on ~£350M).
  - Manual labor cost: ~£4.2M (mix of internal staff; Accenture may be a partner, but CDO emphasized cost/effort vs. resourcing details).
- Decisions:
  - Align lineage/provenance as a single cross-regulatory workstream, not two separate streams (implied agreement; CDO “waiting for someone outside the bank to bring them together”).
- Tasks/Commitments:
  - Snowflake to propose an integrated lineage/provenance solution covering BCBS and FCA requirements with clear time-to-value and two-quarter delivery plan. Responsible: Cliff/Snowflake. Due: Proposal aligned to CDO’s two-quarter window; no exact date provided.
  - Snowflake to provide cost/benefit and differentiation vs. alternatives, explicitly tied to P&L recovery and labor cost reduction. Responsible: Cliff/Snowflake. Due: Before CDO/CFO updates; date not specified.
**Topic 2: P&L Impact Quantification**
- Discussion:
  - CDO provided numeric framing: 108 bps on ~£350M ≈ £10.3M P&L uplift if model resumes; plus ~£4.2M current manual processing cost.
  - Snowflake requested additional exposure/acceptance metrics (e.g., declines/over-leverage) but only above figures were confirmed.
- Decisions:
  - Use these figures as headline benefits in business case.
- Tasks/Commitments:
  - Snowflake to incorporate these metrics into the business case and quantify value realization within two quarters. Responsible: Cliff/Snowflake. Due: With proposal.
**Topic 3: AI Enablement and Self-Service Analytics**
- Discussion:
  - CDO’s long-term strategy: open governed data access across the bank; enable natural-language querying for risk modelers, chief modeling officer, and CFOs.
  - Evaluation of Snowflake Intelligence (aka Snowflake Cortex) vs. Sigma:
    - Snowflake: NLQ for non-SQL users, automation/artifacts; exec-friendly.
    - Sigma: BI with Excel-like experience; some user segments prefer this paradigm.
    - Both ultimately use Snowflake compute; can coexist to serve different user profiles.
- Decisions:
  - No tool displacement decision; acknowledgment that both Sigma and Snowflake Intelligence can have roles.
- Tasks/Commitments:
  - Snowflake to map personas (execs, modeling officers, finance) to recommended tool/workflow (Cortex vs. Sigma), access controls, and governance model. Responsible: Ketki/Snowflake. Due: With overall proposal.
  - Provide demo showcasing NLQ for execs and model performance monitoring for the chief modeling officer. Responsible: Ketki/Snowflake. Due: Not specified.
**Topic 4: Fraud Analytics and Model Risk Engineering**
- Discussion:
  - CDO flagged potential P&L opportunities in fraud analysis with Model Risk Engineering (David Chen).
  - Snowflake had not yet met the team; meeting planned “in a few hours.”
- Decisions:
  - Treat fraud analytics as a parallel opportunity area tied to P&L improvement.
- Tasks/Commitments:
  - Snowflake to meet David Chen (Model Risk Engineering), assess fraud analytics needs, and connect value to P&L; brief CDO and incorporate into CFO briefing preparation. Responsible: Cliff/Snowflake. Due: Prior to CFO meeting “tomorrow” (i.e., 2026-09-18).
**Topic 5: Knowledge Graphs / Enterprise Ontology**
- Discussion:
  - CDO has high interest in knowledge graphs as a hot topic for AI trust and context.
  - Snowflake described efforts to build an enterprise context layer/ontology from documentation and usage to make AI agents more accurate and production-ready.
- Decisions:
  - None; interest noted.
- Tasks/Commitments:
  - Snowflake to outline approach, prerequisites, and timeline for a knowledge graph pilot aligned to governance and lineage initiatives. Responsible: Cliff/Snowflake. Due: With proposal or as a follow-on workstream.
**Topic 6: Differentiation and Time-to-Value**
- Discussion:
  - CDO requested clear differentiation beyond marketing: what can be delivered within two quarters, with costs and benefits.
  - Snowflake positioning: out-of-the-box governance/lineage, minimal configuration, prior G20 bank experience, accelerated delivery via established patterns.
- Decisions:
  - Target delivery window: two quarters for meaningful outcomes to report to CFO.
- Tasks/Commitments:
  - Snowflake to deliver a two-quarter roadmap with milestones, costs, benefits, and dependency assumptions; include regulatory acceptance criteria and P&L impact checkpoints. Responsible: Cliff/Snowflake. Due: As soon as possible for CFO planning; date not specified.
**Additional Notes:**
- Stakeholders referenced: Sarah (responsible for models impacted by FCA stop), David Chen (Head/Lead, Model Risk Engineering).
- Urgency: CDO had limited time; reiterated need to show P&L impact opportunities and regulatory progress within two quarters.