# 09-17 Meeting: Risk Data Lineage and Operational Resilience POC
**Risk Data Lineage, Compliance, and Operational Resilience Enablement (Snowflake + Sigma POC Next Steps)**
**Date:** 2026-09-17
**Participants:** 
- Sarah (Bank Risk Leader; responsible for compliance, operational resilience, and capital allocation decisions)
- Cliff (Solutions Engineer, Snowflake)
- Abhijit (Solutions Engineer, Snowflake)
- Andrew (CTO/Executive Stakeholder; platform decision and budget allocation authority; discussed but not present)
- Charlotte (Microsoft contact; discussed but not present)
- Chief Data Officer (CDO; discussed but not present)
- Head of Risk/Data Engineering (David’s team; discussed but not present; Director Elena Torres delivered prototype)
- Ralph Audörsch (Insurance broker and generational advisor; recipient of notes)
**1. Summary:**
- Purpose: Align Snowflake/Sigma capabilities with the bank’s risk, compliance (BCBS, PRA, FCA, AML), and operational resilience requirements; validate data lineage to the attribute level; and define next steps to support a platform decision and enable self-service reporting and risk workflows.
- Key Discussion Points:
  - Attribute-level data lineage is mandatory for audit and model risk justification; table-level lineage is insufficient.
  - Prior POC success: Engineering team demonstrated lineage to attribute level and achieved 5x improvement in AML identification in ~2 weeks, indicating strong risk reduction and rapid implementation potential.
  - Current gap: Sigma POC covered only investment banking data; risk needs both retail and investment banking data accessible with lineage and workflow visibility.
  - Operational resilience focus: Ability to produce reports on time (three weeks to launch) and show end-to-end risk decision workflows (inputs, analysis, outputs, reporting) across disparate systems/spreadsheets.
  - Budget: 2–3 million ring-fenced for remediation; pending platform decision and allocation by Andrew. Sarah’s budget covers remediation; platform fixes require Andrew’s allocation.
  - Governance and access: Need cross-domain visibility (Azure, enterprise sources) while enforcing strict access controls (“only the right people”).
- Outcomes:
  - Agreement on next step: Extend/shape POC to include both retail and investment banking data in Sigma, demonstrate attribute-level lineage, and show an operational resilience-compliant workflow for risk decisioning.
  - Snowflake team to tailor demo/POC narrative to value outcomes (capital allocation, revenue upside, proactive risk function), beyond lineage “tick-box.”
  - Sarah to influence stakeholders (Andrew, Charlotte, executives) and confirm platform decision timeline; maintains urgency with Q4 approaching.
**2. Key Tasks/Commitments for Ralph Audörsch:**
- None explicitly assigned in this meeting. These notes are for Ralph’s review and follow-up tracking.
Additional Tasks/Commitments Identified:
- Extend POC to include retail + investment banking datasets with attribute-level lineage in Sigma; demonstrate end-to-end risk workflow.
  - Responsible: Snowflake (Cliff, Abhijit) with David’s engineering team (Elena Torres)
  - Deadline: Not specified; implied urgency due to Q4 and three-week launch window
- Prepare demo narrative highlighting operational resilience workflow, capital allocation impact, cost savings, and revenue upside; include customer references.
  - Responsible: Snowflake (Cliff, Abhijit)
  - Deadline: Not specified; prior to Andrew-facing demo
- Enforce role-based access controls across domains (Azure/enterprise) for cross-domain visibility while restricting to authorized “recipe/right people.”
  - Responsible: Bank Tech/CTO team (Andrew’s team), supported by Snowflake
  - Deadline: Not specified
- Confirm platform decision and budget allocation for platform fixes to proceed with remediation.
  - Responsible: Andrew
  - Deadline: Not specified; urgent with Q4 approaching
- Provide count/impact of models affected and clarify model usage mapping for processes and reporting.
  - Responsible: Sarah to obtain from her risk/model team
  - Deadline: Not specified
- Align CDO and Risk teams on governance and operational workflows to ensure model outputs are correctly used and traceable in tools.
  - Responsible: Sarah and CDO, supported by Snowflake
  - Deadline: Not specified
**3. Detailed Breakdown by Topic:**
**Topic 1: Compliance and Data Lineage (BCBS, PRA, FCA, AML)**
- Discussion:
  - Sarah emphasized need for attribute-level lineage to justify model outputs to auditors; table/source-level is insufficient.
  - Cliff reported prior success proving attribute-level lineage and rapid AML improvements (5x) in two weeks via Snowflake + partners.
  - FCA compliance failures risk substantial penalties (£35–55 million). No penalties paid yet.
- Decisions:
  - Attribute-level lineage is a non-negotiable requirement for any platform choice.
- Tasks:
  - Extend POC to demonstrate attribute-level lineage across both retail and investment banking datasets in Sigma. Responsible: Snowflake (Cliff, Abhijit) + David’s engineering team (Elena). Deadline: Not specified.
**Topic 2: Operational Resilience and Reporting Workflow**
- Discussion:
  - Sarah’s priority is producing reports on time (three weeks to launch) and documenting workflows: data inputs, analysis steps, decision-making, and reporting.
  - Current state: fragmented across spreadsheets and systems; risk decisions and model outputs don’t surface back into tools, reducing decision quality.
  - CTO (Andrew) handles downtime/region resilience; risk focuses on timely, traceable workflows.
- Decisions:
  - The demo must show end-to-end workflow supporting operational resilience, not just lineage.
- Tasks:
  - Build/demo a workflow showing how risk analysts trace inputs to outputs and reporting in tools (Sigma/BI), satisfying operational resilience. Responsible: Snowflake (Cliff, Abhijit). Deadline: Not specified.
**Topic 3: Platform Decision, Budget, and Governance**
- Discussion:
  - Sarah has 2–3 million ring-fenced for remediation; Andrew must allocate platform budget/fixes. Q4 urgency noted.
  - Need cross-domain visibility (Azure, enterprise) while maintaining strict access control.
  - Sarah engages executives (Andrew, Charlotte) to influence decisions.
- Decisions:
  - Proceed with POC enhancements to inform Andrew’s platform decision.
- Tasks:
  - Confirm platform decision and budget allocation. Responsible: Andrew. Deadline: Not specified.
  - Implement/validate RBAC and data access governance across domains. Responsible: Bank Tech/CTO team; support from Snowflake. Deadline: Not specified.
**Topic 4: Scope of POC and Demonstration Enhancements**
- Discussion:
  - Sigma POC only covered investment banking data; risk needs both retail and investment banking with lineage visibility.
  - Snowflake should expand demo narrative: beyond compliance “tick-box” to value—capital allocation accuracy, cost savings, revenue upside (e.g., AML wins).
  - Include customer references and show how risk function becomes proactive.
- Decisions:
  - POC scope to include retail + investment banking; demo to highlight business value and operational workflow.
- Tasks:
  - Extend POC scope and prepare enhanced demo narrative; include references. Responsible: Snowflake (Cliff, Abhijit). Deadline: Not specified.
**Topic 5: Risk Model Usage and Impact**
- Discussion:
  - Sarah’s team needs clarity on which models to use for which processes and how outputs change results; automation desired.
  - Not about “stopping models” but mapping usage and demonstrating impact.
- Decisions:
  - Capture model-to-process mapping and demonstrate impact of outputs on risk/financial results.
- Tasks:
  - Gather data on affected models and usage mapping from risk/model team. Responsible: Sarah. Deadline: Not specified.
**Topic 6: Feedback to Snowflake Team (Demo Approach)**
- Discussion:
  - Sarah praised preparation and understanding; asked for:
    - Elevating POC success early in narrative
    - Spending more time on operational resilience workflow
    - Digging deeper into value drivers (cost savings, revenue upside)
    - Discussing tools beyond Sigma (dashboarding is not everything) and integration into broader ecosystem
    - Asking targeted questions about how outcomes change risk analysts’ daily work
- Decisions:
  - Snowflake to incorporate feedback into next demo.
- Tasks:
  - Adjust demo content and discovery questions accordingly. Responsible: Snowflake (Cliff, Abhijit). Deadline: Before Andrew-facing demo.
---