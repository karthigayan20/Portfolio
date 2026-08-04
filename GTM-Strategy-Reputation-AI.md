# Go-to-Market Strategy: Reputation AI

**Product:** LumaLocal Reputation AI — an AI review-response module inside a local marketing platform
**Channel:** Partner-led (agency resellers) with direct self-serve secondary
**Market:** United States SMB local services
**Author:** RP Karthigayan · karthickoffical2009@gmail.com
**Document status:** Launch package, retrospectively annotated with 90-day results

> **Data disclosure.** LumaLocal is a fictional product and the launch results in Section 9 come from
> a simulated dataset (`launch_scorecard_90day.csv`), built so this work can be published openly.
> The framework, sequencing and measurement design are what I would use on a real launch.

---

## 1. Executive summary

LumaLocal sells local marketing software to US small businesses. Most revenue arrives through agency
partners who resell the platform under their own brand. A new AI module — Reputation AI, which drafts
replies to customer reviews and reports sentiment by location — was built without a plan for how
partners would sell it. Previous module launches attached to fewer than 20% of active accounts.

**The strategic bet:** in a partner-led channel, attach rate is won or lost on partner economics and
enablement, not on product messaging to end customers. So the plan put a 51% partner margin and a
default-on trial ahead of everything else.

**Targets set before launch (90 days):** 55% attach rate on active accounts, 275 partner reps
enabled, 900 demos booked, 185 closed-won accounts, $9,500 module MRR added.

**What happened:** attach rate reached **61.7%** and **284** reps were enabled — both ahead of plan.
But demos came in at **770** against 900, and closed-won at **169** against 185, so module MRR landed
at **$8,562** — about 10% short. The constraint was demand generation, not the product story. Details
and the retrospective are in Sections 9 and 10.

---

## 2. The market and the problem

**Who has the problem.** US local service businesses — dental practices, home services, restaurants,
auto repair, salons — where a public review rating is a direct input to revenue.

**The problem in their words:** *"Reviews are the thing clients ask us about, and the thing we're
worst at."*

Three things make review response fail in practice:

1. **It is unscheduled work.** Reviews arrive at random. Anything unscheduled loses to anything on a
   calendar.
2. **Each reply starts from scratch.** Writing a considered response to an unhappy customer is
   genuinely hard, so it gets postponed and then abandoned.
3. **Nobody owns the outcome.** Agencies bill for SEO, ads and content. Review response is usually
   absorbed as unbilled goodwill, so it is nobody's priority.

**Why now.** Response time and reply coverage are increasingly visible signals, and AI has made a
good first draft cheap. The wedge is not "AI writes replies" — it is that a draft removes the blank
page, which is the actual reason replies do not happen.

**What we are really competing with:** doing nothing. That framing changed the messaging. See
Section 5.

---

## 3. Ideal customer profile

Segments are deliberately **ranked**, because ranking decides where enablement budget goes.

### Priority 1 — The agency partner (the channel)

| Attribute | Detail |
|---|---|
| Profile | 5–50 SMB clients, 2–10 staff, retainers of $500–$2,500/month |
| Buyer | Agency owner or account lead |
| Pain | Review management is manual, inconsistent and mostly unbilled |
| Buying trigger | A client asks why their rating dropped |
| What wins | A billable line item they can white-label and defend in a monthly report |
| What loses | Anything that reads as "another tool to learn" or cuts their margin |

One partner carries dozens of accounts, so a single enablement conversation compounds. This is why
Priority 1 receives roughly 70% of launch effort.

### Priority 2 — Multi-location operator (expansion)

| Attribute | Detail |
|---|---|
| Profile | 3–20 locations: dental groups, home services, restaurant groups |
| Buyer | Marketing manager or operations director |
| Pain | No consistent voice across locations, no comparable view of sentiment |
| Buying trigger | One location dragging the brand average down |
| What wins | Location-level comparison plus an approval step before anything posts |
| What loses | No approval workflow — brand risk kills the deal instantly |

Highest revenue per account because pricing is per location.

### Priority 3 — Single-location owner (volume)

| Attribute | Detail |
|---|---|
| Profile | Owner-operator, no marketing staff, self-serve signup |
| Buyer | The owner |
| Pain | Does not know what to write, so leaves reviews unanswered |
| Buying trigger | A bad review they cannot answer |
| What wins | A draft already waiting in the inbox |
| What loses | Price. This segment is the most sensitive and got the least attention — a known gap |

### Explicitly out of scope

Enterprise multi-brand (needs SSO, procurement and a security review), non-US markets (review
platform coverage and language quality untested), and businesses without public review profiles.

---

## 4. Positioning

**Positioning statement**

> For **US local businesses and the agencies that manage them**, who lose customers to reviews that
> sit unanswered for days, **Reputation AI** is a review-response layer inside the marketing platform
> they already log into. It drafts on-brand replies in minutes and reports sentiment by location.
> Unlike standalone reputation tools, **it needs no new login, no new contract, and it bills through
> the partner.**

**Category.** We do not compete in "AI writing". We compete for the reputation-management line item
an agency already sells, or the hour an owner already spends. Naming the category this way is what
makes the pricing defensible — it is measured against existing spend, not against a free chatbot.

**Primary value:** response time and consistency — the two things manual replying always fails at.

**Proof we lead with:** median response time and reply coverage per location, shown inside the
partner's own monthly client report. The report is the sales asset, not the product tour.

**Three things we deliberately do not claim:** that AI replies are indistinguishable from human ones,
that it improves star ratings directly (we can only evidence response time and coverage), or that it
replaces a community manager.

---

## 5. Competitive set

Competitors are described as **archetypes** rather than named vendors: it keeps the framework
portable and avoids making claims about a specific company's product that I cannot verify.

| Alternative | Strength | Weakness | Our counter | Threat |
|---|---|---|---|---|
| **Standalone reputation suite** | Deep feature set, wide integrations, strong brand | Another login, another invoice, poor economics for agencies reselling at margin | Already inside the platform partners use; no new procurement | High |
| **All-in-one agency platform** | Owns the partner relationship, bundles everything | Reputation is a checkbox; reply quality is generic | Compete on reply quality and per-location reporting, not breadth | High |
| **General AI writing tool** | Cheap, flexible, already on the owner's phone | No review data, no posting, no audit trail, no reporting | Connected to the review source and to the client report | Medium |
| **Status quo — reply by hand** | Free, familiar, no approval needed | Slow, inconsistent, quietly abandoned when the team gets busy | Lead with time-to-reply and coverage, not with "AI" | **Highest** |

**The most important line in this table is the last one.** Most deals are lost to inertia, not to a
competitor. That is why the discovery question is *"how fast do your reviews get answered today?"* —
it makes the status quo visible and quantified before price is discussed.

---

## 6. Pricing and packaging

| Lever | Decision | Reasoning |
|---|---|---|
| Retail price | **$39 per location / month** | Anchors below a standalone tool while clearing the margin requirement |
| Partner wholesale | **$19 per location / month** | 51% partner margin — the level at which partners actively sell rather than absorb |
| Unit | **Per location** | Lets multi-location accounts expand without a renegotiation |
| Trial | **30 days, auto-enabled, opt-out** | Removes the partner's decision to introduce it |
| Target ARPA uplift | **$50** on a $149 average account | Roughly a 34% ARPA increase where it attaches |
| Bundling | Not bundled into base | Bundling would have hidden the revenue and removed the partner's margin |

**The decision that mattered most** was auto-enabling the trial. Attach rate in a partner-led channel
is throttled by partner attention, not customer demand. Making the module present by default moved
the partner's job from "introduce a new product" to "keep something the client is already using" —
and that is the single biggest reason attach rate beat target.

**Objection handling**

| Objection | Response |
|---|---|
| "AI replies will sound robotic." | Approval workflow is on by default. Every reply is a draft until a human posts it. |
| "My clients won't pay more." | Sell against staff time, then show the per-location coverage report at the next client review. |
| "We already reply to reviews." | Median response time is the wedge. Nearly every account replies to *some* reviews; almost none reply to all of them. |
| "What if it replies to something sensitive?" | Configurable hold rules: 1–2 star reviews and flagged keywords always route to a human. |

---

## 7. Message map

One row per audience. No shared "value props" slide — a message that works for an agency owner and a
single-location owner simultaneously is a message that persuades neither.

| Audience | Their words for the problem | Message | Proof point | Primary CTA |
|---|---|---|---|---|
| **Agency partner** | "Reviews are what clients ask about and what we do worst." | Turn review management into a billable, reportable service you don't have to staff. | 51% margin, white-labelled client report | Enable on 3 clients |
| **Multi-location operator** | "One location is dragging our rating down and I find out late." | See sentiment by location, reply in one voice, approve before anything posts. | Per-location coverage and response-time view | Book a walkthrough |
| **Single-location owner** | "I don't know what to write, so I leave it." | A reply is already drafted and waiting. Read it, change it, post it. | Median reply time under a day | Turn on the free trial |
| **Internal sales & support** | "Another module to explain on a crowded call." | One question to ask: how fast do their reviews get answered today? | One-page battlecard, 4-minute demo script | Use the discovery question |

---

## 8. Launch plan

### Phase 1 · T−6 to T−3 weeks — Readiness

**Objective:** get the story straight before anyone tries to sell it.

- Positioning statement signed off by product and sales (not circulated — signed off)
- Pricing modelled against partner margin; wholesale set at 51%
- Competitive archetypes documented, including the status-quo case
- **Success metrics and targets agreed in writing** — before launch, so success could not be
  redefined afterwards. This is the step most launches skip and the reason most launch retros are
  arguments.

### Phase 2 · T−2 weeks — Partner beta

**Objective:** find out what breaks, from people who will say so.

- 12 partners, ~40 accounts, one week of structured feedback
- Deliberately recruited the partners most likely to complain loudly
- **Two changes came out of it:** approval workflow moved to on-by-default, and the client-facing
  report was rebuilt around *response time* rather than review volume

### Phase 3 · Launch week — Go live

**Objective:** enablement first, announcement second.

Shipped to partner reps *before* the customer announcement:

- One-page battlecard (positioning, discovery question, objections, pricing)
- 4-minute demo script with the report as the closing frame
- Pricing calculator showing partner margin per client
- Objection sheet

Then, and only then: in-app announcement, partner webinar, help-centre articles, email to active
accounts.

### Phase 4 · Weeks 2–13 — Scale

- Weekly scorecard: attach rate, demos, closed-won, reps enabled
- Fortnightly reallocation of enablement effort toward lagging partner tiers
- Re-run enablement for lagging tiers rather than assuming the first session landed
- **Co-marketing kit for partners landed in week 5 — too late.** Consequences in Section 10.

---

## 9. Measurement framework and 90-day results

Targets were fixed pre-launch. Actuals computed from `launch_scorecard_90day.csv`.

| Metric | Target | Actual | Variance | Status |
|---|---|---|---|---|
| Module attach rate (weeks 10–13) | 55.0% | **61.7%** | +12.2% | Beat |
| Partner reps enabled | 275 | **284** | +3.3% | Beat |
| Demos booked | 900 | **770** | −14.4% | Missed |
| Closed-won accounts | 185 | **169** | −8.6% | Near |
| Module MRR added | $9,500 | **$8,562** | −9.9% | Near |

**Leading vs lagging.** Attach rate and enablement are leading indicators and both beat plan. Demos
and closed-won are lagging and both missed. That pattern is diagnostic: the offer and the enablement
worked; the pipeline feeding them did not.

**What the weekly view shows.** Attach rate crossed target in week 9 and held, which fits the
default-on trial hypothesis. Demo volume was flat for the first four weeks and only inflected after
the co-marketing kit shipped in week 5 — partners were enabled but had nothing to run a campaign with.

**Secondary metrics tracked:** trial-to-paid on the module, replies published per account, median
response time before and after enabling, module-level churn at day 60.

---

## 10. Retrospective

### What worked

1. **Trial on by default.** The highest-leverage decision in the launch. It converted the partner's
   task from selling something new to retaining something in use.
2. **Enablement before announcement.** Partner reps were never the bottleneck — the first inbound
   question always had an answer waiting.
3. **Targets agreed in writing pre-launch.** Made the shortfall diagnosable instead of arguable.
4. **Recruiting difficult partners into beta.** The two changes they forced (approval default, report
   redesign) both showed up in the results.

### What did not work

1. **Demand generation lagged enablement by five weeks.** Demos finished 14% under target. Partners
   were ready and had nothing to run.
2. **Revenue followed demand, not readiness.** $8,562 against a $9,500 target, despite attach rate
   beating plan by 12%.
3. **Priority 3 pricing was never tested.** The most price-sensitive segment received the least
   attention, and there is no data to say whether $39 is right for a single location.

### What I would change

1. **Treat the partner co-marketing kit as a launch blocker,** not a phase-two asset. No launch date
   without it.
2. **Add a demand-side target** — booked demos per enabled rep per week — so the scorecard cannot
   look healthy while pipeline is flat. This is the specific measurement failure: every target was a
   supply-side or conversion metric.
3. **Run a pricing test on the single-location segment during the beta window,** when it is still
   cheap to change.

---

## Appendix A — Assumptions

| Assumption | Value | Basis |
|---|---|---|
| Average account MRR | $149 | Platform average plan price |
| Module ARPA uplift where attached | ~$50 | $39 retail with a multi-location blend |
| Gross margin | 72% | Used for payback calculations |
| Active accounts in scope | ~2,800 | Accounts with a connected review profile |
| Partner reps in scope | ~340 | Reps at partners with 5+ active clients |

## Appendix B — Discovery questions for partner reps

1. How fast do your clients' reviews get answered today? *(Makes the status quo measurable.)*
2. Who writes the replies — you, or the client?
3. Which client asked you about their rating most recently?
4. Do you bill for review management today? If not, why not?
5. Would you need to approve replies before they post? *(Qualifies the approval-workflow objection early.)*

## Appendix C — Battlecard summary

- **One-line pitch:** Every review gets a reply, drafted for you, reported to your client.
- **Lead metric:** median response time, then reply coverage per location.
- **Never lead with:** "AI-powered". Lead with the time problem.
- **Price:** $39/location retail, $19 wholesale, 51% partner margin.
- **Disqualify if:** no public review profiles, or approval workflow is a hard no for legal reasons.
- **Most common loss reason:** inertia. Always quantify the current response time first.

---

## Files in this project

| File | Contents |
|---|---|
| `project-1-gtm-launch.html` | Interactive launch brief with the weekly scorecard charts |
| `launch_scorecard_90day.csv` | 13 weeks × demos, wins, attach rate, reps enabled, module MRR |
| `GTM-Strategy-Reputation-AI.md` | This document |
