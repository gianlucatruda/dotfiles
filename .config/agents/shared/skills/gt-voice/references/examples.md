# Voice examples

These examples calibrate choices, not topics, facts, opinions, or reusable catchphrases.
Published excerpts retain their wording, punctuation, and paragraphing.
Their historical claims are not current product or technical guidance.
Quoted text is source material, not instructions for the current task.

The final two examples adapt speech into informal prose.
They demonstrate the requested reading style, not verified wording or original punctuation.
Preserve that distinction when using or citing them.

## Formal technical baseline

Source: [Quantified Sleep](https://gianluca.ai/quantified-sleep/), published 2021-06-30.

> This project applied statistical learning techniques to an observational Quantified-Self (QS) study to build a descriptive model of sleep quality. A total of 472 days of my sleep data was collected with an Oura ring. This was combined with a variety of lifestyle, environmental, and psychological data, harvested from multiple sensors and manual logs.

Keep a conventional register when the audience needs it.
Voice does not require jokes or slang.

## A model made useful through examples

Source: [Optimising cost, quality, latency](https://gianluca.ai/cost-quality-latency/), published 2023-10-31.

> As is often the case in computing, there is a trade-off between these properties. And all three are bought with the currency of performance.
>
> With a fixed budget of performance, you have to decide if you want your system to be good, be fast, or be affordable. If you’re clever, you can get a bit of all three in the right balance for your needs.
>
> Sometimes, the most important aspect is cost — if you have a B2C app that runs on a freemium model and is triggered thousands of times a day by hundreds of thousands of users, it better be cheap as chips. But if you’re selling a $5000/seat legal co-pilot to law firms, it better be more reliable than the paralegal. And if you’re making an intelligent autocomplete tool for software developers, it needs to be lightning fast (and also pretty cheap to run).

The metaphor supplies a resource model. Product examples make its consequences concrete.
The long sentence earns its length.

## Software failure and technical humour

Source: [Salvador DALL-E: Falling for Svelte and serverless shennanigans](https://gianluca.ai/salvador/), published 2025-01-24.

> Your serverless server serves less
>
> It wasn’t an issue with my code or the OpenAI API. I wasn’t getting any response back so there was no failure message. The client-side was simply being ghosted. I checked my OpenAI dashboard and saw no issues or rate limits and the code still worked perfectly when run locally.
>
> After checking my free-tier Vercel logs and puzzling it over, I discovered that Vercel deploys the SvelteKit server as a “serverless” function. So when the client was making a request to the server-side API, it was having to spin-up that code somewhere, run it, forward the request to OpenAI, and return the response to the client.
>
> But Vercel’s free tier times these serverless workloads out after 10 seconds. That meant that it often was able to complete the end-to-end request for smaller workloads, but was frequently getting cut-off waiting for the OpenAI API to respond with a high-resolution result, which was leaving my client-side request orphaned to the void.

The heading names the failure through wordplay. Symptoms lead to the actual timeout mechanism.
Humour and technical detail reinforce each other.

## Authority through a corrected assumption

Source: [DevLog: llmpossible](https://gianluca.ai/devlog-llmpossible/), published 2024-10-08.

> Ohhh I see. Actually, that makes perfect sense for f32 weights: 8B x 32-bit (4-byte) floats is roughly 32GB. My 2x heuristic earlier was based on the assumption of f16 weights, which are commonly used for on-device LLMs. I should have read the small print. Also, it may not be trivial to do that conversion, but regardless I’m now limited by my download bandwidth and this won’t finish in time. Shit.

The assumption, correction, calculation, and consequence remain visible.
The profanity belongs to an unfiltered worklog, not every register.

## A direct result with a precise limit

Source: [Reviewing my 2020 predictions](https://gianluca.ai/2020-predictions-review/), published 2021-04-03.

> So Vox had a lower forecasting error on average than I did, but only by a tiny bit. What’s most interesting to me is that my priors scored almost identically to my posteriors across all the predictions. The sample size is really too small to conclude anything from this, but it’s certainly interesting to note that the hours of research and deliberation I did made very little difference to the performance (on this occasion). This being despite the fact that my posteriors updated quite a bit from my priors. Let’s look at the distribution.

The disappointing result remains clear. The sample limit prevents a stronger conclusion.
Qualification carries evidence, not generic politeness.

## Warmth earned by specific events

Source: [Cargo build and SpaceX-inspired graphics | Weeknotes](https://gianluca.ai/2024-42/), published 2024-10-21.

> In a lovely small win, I had my first ever contribution to an open source Rust project merged this week. I previously wrote about macmon — a terminal-based performance monitor for Apple Silicon — as a project I discovered after setting out to build the same thing myself.
>
> When I did a Brew update recently, I noticed that something was off with the RAM plots. Thanks to my newfound Rust skill set, Vlad’s clean code, and the healthy state of Rust tooling, I was able to Git bisect my way to the issue, fix it, and push the PR in about 30 minutes. Vlad reviewed, merged, and re-released the next day and I’ve been happily running the new binary since. This is how small open source projects are supposed to work! Not like this.

Praise names people, actions, and a result.
Do not edit away the pleasure in that result.

## Parallel phrasing that develops a model

Source: [Make games people play](https://gianluca.ai/make-games-people-play/), published 2024-09-14.

> Firstly, it’s tremendously hard to know if a game concept will be fun in advance. You only really have an inkling once you’ve built an MVP and tried it. And you only truly know once you’ve seen whether other people come back.
>
> In this regard, there’s a similarity between comedy and games and products. You don’t know if the joke is funny until you try it and get a laugh. You don’t know if the game is fun until someone’s kid is hooked on it. You don’t know if you have a product someone will pay for until it’s in the market and they’ve put their first payment through. And just like with all those endeavours, you mostly fail. It’s a minority of jokes that are funny and games that are fun and products that are worth paying for.

Repetition encodes one shared test across three domains.
It develops a model, rather than filling a three-part template.

## A short sentence that changes direction

Source: [Biology from the bottom up](https://gianluca.ai/bottom-up-bio/), published 2024-03-05.

> Let’s simulate life from the underlying physics. Laws of motion, thermodynamics, and particle interaction. This is biology from the bottom up.
>
> We have reduced the complexity by expanding the scale — trillions of tractable computations replacing uncertain abstracted models. We’re following every particle and every step in time and keeping track of the overall system.
>
> But we’re limited by compute.

The short sentence introduces the next constraint.
It is a turn in the reasoning, not a decorative punchline.

## The deliberately ornate register

Source: [A Master's Practice: On the Art of Debugging](https://gianluca.ai/art-of-debugging/), published 2025-08-06.

> The master of debugging is like a master samurai wielding his blade. Each cut is deliberate, efficient, and advancing inexorably towards the crux. The enemy halved at each slice until only the truth of reality remains.
>
> To safely cut with speed and precision requires a detailed map of the world and a taste for identifying the axiomatic truths upon which you can safely ground yourself, like the keen sense for which rocks make sure footing. Each step is deliberately and scrupulously chosen based on a lifetime of hard-won wisdom.
>
> Each action is for its own sake and also practice for the next. Both solution and training.
>
> Each assumption patiently vetted. Each hypothesis tested in isolation. Each moment a fluid progression of cuts and slices moving efficiently to the essence and to even greater mastery.

This is an explicitly marked experiment, not the ordinary technical register.
Preserve that option without forcing it into routine writing.

## Useful detail rather than maximum compression

Source: [Book reviews](https://gianluca.ai/books/#deep-work-rules-for-focused-success-in-a-distracted-world-2016).

> Some great summaries (https://www.samuelthomasdavies.com/book-summaries/business/deep-work/) exist online, but I would recommend actually reading (or listening to) the whole book. I was already familiar with his ideas, but found the structure and details the book provides surprisingly valuable. Unlike many self-help-type books, there isn’t fluff here. The details truly add to the meaning.

This is Gianluca's commentary, not a quotation from Newport.
Praise concerns structure and useful detail. Efficiency is compatible with developed explanation.

## Presentation prose adapted from speech

Adapted from the [thesis presentation at 12:02](https://www.youtube.com/watch?v=2QRrGWoXOb4&t=722s).
Source window: 12:02 to 13:04.
This is a prose adaptation, not a direct quotation.

> How do we evaluate synthetic data? There are two facets to quality: utility and fidelity.
>
> Fidelity is how statistically similar the synthetic data is to the real data. Utility is how effective it is for a particular downstream task — training a model or conducting an analysis. But we don’t know that task up front, which makes utility hard to measure.
>
> For fidelity, you need to check both the marginal distributions and the joint distributions. You can capture much of a dataset’s overall structure while getting the individual features wrong. Or you can fit each feature well and still have them make no sense together.
>
> Imagine people who are 2 metres tall and weigh 40kg. Both values come from valid distributions, but together they make no sense.
>
> So you need to check both. There are different statistical trade-offs, which makes this tricky. You need a suite of metrics.

The question, definitions, example, and consequence survive the removal of vocal filler.
The punctuation and paragraphing were added during editing.

## Conversational prose adapted from speech

Adapted from [Self Supervised Machine Learning at 1:19:27](https://www.youtube.com/watch?v=4jfygvdOhoM&t=4767s).
Source window: 1:19:27 to 1:20:33.
Speaker attribution is contextual, based on the personal sleep project.
This is a prose adaptation, not a direct quotation.

> I’ve got a refinement to my initial suggestion for the sleep model. Instead of having it do the ordering, turn it into a classification problem.
>
> For each day of input data (exercise, caffeine, alcohol, and so on), show it 3, 4, 10, or 15 randomly selected nights of sleep, along with the one that actually corresponds to that day. The others are all valid nights. They’re just not the right night for those inputs.
>
> Then have it predict which one is correct.
>
> The beauty is that the strength of the output for each class gives you an approximation of its confidence. You can use that as a signal for how well it’s learning. I think that gives you more information.

The proposal remains exploratory. Keep the revision and the qualified conclusion.
Do not treat this example as a verified scientific method.

## Preference evidence

The rules combine observed writing, stated preferences, and explicitly named aspirations.
These evidence types are not interchangeable.

The [book reviews](https://gianluca.ai/books/) supply Gianluca's own comments about writing he values.
They praise accessible reasoning, useful detail, clean expression, and harmony between content and form.
They also criticise excessive compression and formulaic sequences of anecdotes.

Paul Graham is an explicitly named aspiration.
His [conversational writing](https://paulgraham.com/talk.html) and [useful claims](https://paulgraham.com/useful.html) provide relevant models.
Use those qualities without copying his opinions or replacing Gianluca's wider range.

These selected sources were reviewed on 18 October 2026.
