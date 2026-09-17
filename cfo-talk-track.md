# CFO Talk Track — Andrew Harper, Aldwych Bank

**7 slides · about 15 minutes, leaving 15 for questions**

Read the bold line, then say the rest in your own words. Don't read this out.

---

## Before you start

**Your one sentence, if the meeting gets cut to 60 seconds:**

> "Your audit failed because you can't show how a number was calculated. Fixing that also restarts the SME model that's costing you £10M a year — and the budget is already sitting with your CRO."

**Three numbers to never get wrong:**

- **£4.2M a year** — manual credit-review labour. Hardest number you have.
- **£35–55M** — the FCA penalty exposure.
- **£2.3M** — what you're asking for. Already ring-fenced by the CRO.

**Tone:** you are not selling a platform. You are handing him a business case his own people gave you. Say "your team told us" as often as you can.

---

## Slide 1 — Cover
*Trusted, auditable regulatory reporting in days, not weeks*

**"Everything in here came from your own people — we haven't brought you a product pitch."**

We've spent today with your CRO, your CDAIO, your CTO, data architecture and model risk engineering. We're going to give you their numbers back, and one decision at the end.

Three things it does: clears the FCA notice before Q4, restarts the SME credit model, and frees regulatory capital.

⏱ *30 seconds. Don't linger.*

---

## Slide 2 — Your own numbers
*The money, to scale*

**"Look at the bottom bar. That's what we're asking for. Now look at the top one."**

The red bar is the FCA penalty exposure — £35 to £55M. The gold bars are what the current situation costs you every year: £10M of revenue the SME model should be generating but isn't, because credit scoring went back to manual. And £4.2M a year in people doing that manual review.

The blue sliver is the ask. **£2.3M — about 4% of the exposure it retires.**

On the right: 55% of your risk engineering team's week goes into keeping legacy pipelines alive, not managing risk. And your regulatory reporting cycle is three weeks. It should be days.

**Pause here.** Let him do the arithmetic himself.

⏱ *2–3 minutes. This is your most important slide.*

> **If he questions the £10M** — that's your CDAIO's estimate of what the automated model generates versus manual scoring. Offer to firm the derivation with her this week. Don't defend it too hard. The £4.2M and the penalty exposure are the numbers that carry the case.

---

## Slide 3 — The fix pays for itself
*Cost of delay*

**"The £2.3M isn't new money. It's the remediation budget Sarah has already ring-fenced."**

Judge this as total cost, not licence against licence. Seven systems and £4.2M a year of manual labour collapse into one platform.

Now the chart. Every month nothing changes costs you about £1.2M — roughly £0.83M of foregone revenue plus £0.35M of labour. **By month two, the delay costs more than the fix does.**

And you only pay for the foundation once. BCBS 239, PRA SS1/23 and Basel IV all land on the same platform — not three separate remediation projects in eighteen months.

⏱ *2 minutes.*

> **If he says "the CRO's budget needs the CTO's sign-off"** — he's right, and that's exactly why you're in the room. You're not asking him to find money. You're asking him to unblock money that already exists.

---

## Slide 4 — Two legal entities. One view of risk.
*The architecture, as your team described it*

**"Your model risk lead told us something today that explains the whole problem."**

The retail bank and the investment bank are separate legal companies. There's a border you're not allowed to cross. But BCBS 239 requires you to aggregate risk across both.

Right now you resolve that contradiction by hand. His words: *"we spend a lot of time trying to develop between those two."*

Walk the left panel: two source systems, Oracle and IBM. Seven systems of hand-built pipelines, rebuilt every time a new regulation lands. Then the red border between the two entities. Three things break there — **lineage stops, the same customer is a different person in each entity, and the SME model is suspended.**

Walk the right panel: same sources. Two Snowflake tenants, separate contracts and separate access. Between them, governed data sharing — no pipelines, no copies. Column-level lineage runs across both. Identity resolution is governed, not manual.

**The line to land:** "The ring-fence stops being manual effort and becomes policy you can evidence."

⏱ *3 minutes. Slow down here — this is the slide that proves you listened.*

---

## Slide 5 — One connected estate, on Azure
*Problem → capability*

**"Your current tooling tracks assets. BCBS 239 asks how a number was calculated. That's the gap."**

Don't read the table. Point at two rows.

Row one — proving how a regulatory figure was calculated. That's Horizon Context, column-level lineage. **This is the specific thing Synapse and Purview can't do** — they'll show you asset and row lineage, not transformation-level column lineage. That's why the audit failed.

Row two — identity resolution. Your model risk team asked for it and nothing they have answers it.

Then close: **this runs on Azure.** Your Microsoft commitment and your Azure consumption stay intact. This is coexistence, not rip-and-replace. And Accenture co-delivers — twelve years with you already.

⏱ *2 minutes.*

> **If he says "Fabric and Purview already do this"** — don't argue the whole platform. Stay on one point: transformation-level column lineage. Ask him to have his architects confirm whether Purview can show it. That question is the whole decision.

---

## Slide 6 — Better together
*Sigma and RelationalAI*

**"Both of these are already inside your bank."**

Sigma is the BI tool you've already chosen. It runs on live Snowflake data — no extracts, no second copy to govern — and lineage doesn't stop at the dashboard. Your POC covers investment banking; we extend it to retail. HSBC runs this exact combination live.

RelationalAI is the graph layer, and it runs inside your own Snowflake tenant — no data movement, no new perimeter to certify. It does the identity resolution across your two entities, and multi-hop AML chain analysis on the same foundation.

**And here's the thing** — your own team already proved it. Elena's prototype hit three to five times the AML detection rate, and it passed the audit your current platform failed. In about two weeks.

⏱ *90 seconds.*

> **Handle with care.** Andrew may not know about Elena's prototype — her words were that communications don't go well in the company. Frame it as a credit to his team, never as a gap in his awareness.

---

## Slide 7 — See it live, then a funded first step
*The ask*

**"Rather than talk about it, let us show you — and we'll use your questions, not ours."**

The demo is CoWork. You ask a question in plain English, on governed data, inside your access control. It shows its work — which tables, which columns, which model produced the answer. Your risk, finance and engineering people work it together on the same governed thread instead of emailing a spreadsheet. Then it hands off to Sigma for the board view — same numbers, same lineage.

Then the ask, and say it plainly:

**"Extend the proof-of-concept to cover retail and investment banking, with column-level lineage from source to BI, on Snowflake on Azure — and reinstate the SME credit model. £2.3M from budget already ring-fenced. Two quarters. Ahead of Q4."**

Then stop talking.

⏱ *2 minutes, then silence.*

---

## The three questions he will actually ask

**"Why not just fix what we have?"**
Because the gap isn't configuration, it's architecture. Purview tracks assets. BCBS 239 asks how a number was calculated. No amount of tuning closes that.

**"What's the risk this fails like the last programme?"**
Two quarters, not two years, and it's a proof before a commitment. Accenture bridges the legacy estate. And your own team has already built and audited a working prototype on this stack.

**"Why now?"**
The FCA notice has a Q4 date, and every month of delay costs about £1.2M. By month two, waiting costs more than acting.

---

## Don't do these

- Don't lead with Snowflake features. Lead with his numbers.
- Don't defend the £10M harder than the £4.2M.
- Don't say "rip and replace." Say "coexistence on Azure."
- Don't attack Microsoft. Attack one capability gap, precisely.
- Don't fill the silence after the ask.
