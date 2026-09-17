# James O'Brien — Managing Director, UK Banking Practice · Accenture

> Partner · orientation & co-seller

## Notes
<!-- Date-stamped meeting notes. Newest on top. -->

### 2026-09-17 — Bank Data Platform Decision: Snowflake vs. Microsoft Fabric
**Participants:** Speaker 1, Speaker 2, Speaker 3 (Accenture), Speaker 4

**1. Summary**
- Purpose: Discuss the bank's reevaluation of its data platform due to regulatory compliance gaps with Synapse, understand decision drivers and stakeholders, and explore how Snowflake could address lineage and compliance requirements while maintaining the bank's Microsoft relationship.
- Key findings:
  - Current issue: Synapse (even with Purview) supports asset/row-level lineage but lacks transformation and query-level column lineage needed for regulatory compliance. This is the primary blocker for the CFO, driving a platform review.
  - Microsoft's position: Pushing Fabric + Purview as the solution; the bank has a longstanding Microsoft commitment and preference to stay within the ecosystem.
  - Opportunity for Snowflake: Run Snowflake on Azure to preserve Microsoft commercial commitments and Azure consumption, while demonstrating lineage capabilities that satisfy compliance.
  - Decision dynamics: CFO will sign off but relies on CTO and architects to confirm compliance; the Office of the CTO is the key champion target. Head of Data is another relevant persona; BI/ETL stack appears mixed (Sigma mentioned, unclear ETL tools).
  - What will move the needle: A focused demonstration of Snowflake's capability to deliver query-level, transformation-level column lineage and compliance pathways; secondary benefits include business continuity and cross-cloud/region resilience.

**2. Key Tasks/Commitments for Ralph Audörsch**
- Develop and present lineage-focused Snowflake demo [Responsible: Ralph Audörsch; Deadline: Not specified]
  - Show query-level and transformation-level column lineage meeting regulatory requirements.
  - Map how this satisfies the bank's compliance needs.
- Prepare Azure-aligned commercial and architecture positioning [Responsible: Ralph Audörsch; Deadline: Not specified]
  - Explain Snowflake on Azure, how it preserves Microsoft commitments and drives Azure consumption.
  - Outline how existing Microsoft relationships remain intact.
- Stakeholder engagement plan for Office of the CTO [Responsible: Ralph Audörsch; Deadline: Not specified]
  - Identify and request meetings with the CTO (Marcus), chief architect, and Head of Data.
  - Tailor messaging: compliance-first for CTO/architects; commercial reassurance for CFO.
- Compile supporting materials with Accenture delivery alignment [Responsible: Ralph Audörsch; Deadline: Not specified]
  - Provide deployment playbooks, compliance documentation, and case studies (especially banking).
  - Highlight Snowflake-Accenture joint successes and implementation readiness.
- Investigate current BI/ETL landscape and Fabric POC status [Responsible: Ralph Audörsch; Deadline: Not specified]
  - Confirm whether a Fabric POC exists and its scope.
  - Clarify use of Sigma vs. Power BI and implications for lineage coverage (within vs. across tools).

**3. Detailed Breakdown by Topic**

*Topic 1: Current Platform and Compliance Gap (Synapse/Purview)*
- Discussion:
  - Speaker 3: Bank implemented Synapse; non-compliant due to lineage requirements. Synapse/Purview can track asset/row-level lineage but not transformation-level or query-level column lineage.
  - Speaker 1/4: Clarified lineage scope (calculation/transformation vs. asset); performance acceptable—compliance is the blocker.
  - Speaker 3: Compliance is the main driver for change; Microsoft proposes Fabric + Purview as fix.
- Decisions: No final decision; acknowledged lineage capability is the critical requirement to address.
- Tasks/Commitments: Ralph to build a demo proving Snowflake's transformation-level/query-level column lineage for regulatory compliance.

*Topic 2: Vendor Ecosystem and Commercial Considerations*
- Discussion:
  - Speaker 3/4: Bank has strong Microsoft relationship; preference not to move away. Snowflake can run on Azure, supporting Microsoft commercial commitments via Azure consumption.
  - Speaker 2: Two pillars to address—lineage compliance and preserving Microsoft commitment; both support a Snowflake move.
- Decisions: Position Snowflake as Azure-aligned to reduce perceived vendor shift risk.
- Tasks/Commitments: Ralph to prepare Azure-based Snowflake positioning, including commercial implications and alignment with Microsoft agreements.

*Topic 3: Stakeholders, Champions, and Decision Flow*
- Discussion:
  - Speaker 3: CTO's office is the platform decision-maker; CFO relies on CTO for compliance assurance. Architects will assess feature fit. Head of Data is another persona involved.
  - Speaker 1/4: Aim to meet CTO (Marcus), chief architect, and Head of Data; focus messaging on compliance features.
- Decisions: Target champion in Office of the CTO; CFO as economic buyer who signs off based on CTO's recommendation.
- Tasks/Commitments: Ralph to create a stakeholder engagement plan and schedule meetings with CTO (Marcus), chief architect, and Head of Data.

*Topic 4: Capability Demonstration Priorities*
- Discussion:
  - Speaker 2/3: Most impactful is demonstrating Snowflake's compliance path via detailed lineage (query-level and transformation-level columns).
  - Speaker 1: Additional differentiators—business continuity and cross-cloud/region support; interoperability discussions can follow after lineage.
- Decisions: Lead with lineage compliance; follow with resilience and interoperability if needed.
- Tasks/Commitments: Ralph to craft a focused demo emphasizing lineage, with a secondary section on continuity and cross-region capabilities.

*Topic 5: Current Tooling Landscape and Fabric POC*
- Discussion:
  - Speaker 1/3: BI/ETL tools are mixed; Sigma mentioned despite Power BI being part of Fabric—reason possibly commercial; ETL stack unclear. Fabric POC is being considered but not yet seen.
  - Speaker 1: Question whether Fabric provides 360 lineage across sources or only within Fabric.
- Decisions: Need clarity on tooling and POC status to tailor demo and messaging.
- Tasks/Commitments: Ralph to verify Fabric POC existence and scope; assess BI/ETL tools in use (Sigma, Power BI, ETL) and implications for end-to-end lineage coverage.

*Topic 6: Delivery Confidence and Partnership*
- Discussion:
  - Speaker 3: Accenture has implemented Snowflake for other customers; cautious about projects that fail midstream.
  - Speaker 1/4/2: Snowflake–Accenture partnership is proven; offer materials, support, and joint delivery to ensure success; banking track record emphasized.
- Decisions: Present joint delivery approach to mitigate risk and reassure stakeholders.
- Tasks/Commitments: Ralph to compile Accenture/Snowflake case studies, deployment guides, and compliance documentation tailored to banking.

### YYYY-MM-DD — <meeting title>
- 

## Follow-ups
- [ ] 
