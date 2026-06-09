# Language Models Are Few-Shot Learners

A **few-shot language model** can adapt to a task from instructions and examples placed in the prompt, without updating model weights.

Source: [Brown et al., 2020](https://arxiv.org/abs/2005.14165), `arXiv:2005.14165`.

## The idea

GPT-3 tested whether a very large autoregressive language model could perform new NLP tasks through **in-context learning**:

```text
pre-train once -> describe the task in the prompt -> add examples if needed -> run forward passes only
```

The paper's central result: scaling up language models makes this prompt-based adaptation much stronger. GPT-3 has **175B parameters** and was evaluated across zero-shot, one-shot, and few-shot settings without task-specific gradient updates.

## Evaluation settings

| Setting | Prompt contains | Weight updates? | Main tradeoff |
|---|---|---|---|
| Fine-tuning | Many labeled task examples | Yes | Strong benchmark performance, but needs task-specific data and training |
| Zero-shot | Natural language instruction only | No | Cheapest, but the model gets the least task signal |
| One-shot | Instruction + 1 example | No | Shows the desired format with one demonstration |
| Few-shot | Instruction + as many examples as fit in context | No | Usually strongest prompt-only setting, but uses context budget |

The paper uses "learning" carefully here. The model is not learning by backpropagation at inference time. It is conditioning on the prompt, and the paper stays agnostic about whether the model is truly learning a new task from scratch or recognizing patterns learned during pre-training.

## Corrected takeaways

- GPT-3 performs well on many tasks without being fine-tuned on those task datasets.
- This does **not** mean fine-tuning is obsolete. The paper focuses on task-agnostic evaluation, and many fine-tuned systems still outperform GPT-3.
- In-context learning reduces the need for per-task training runs, but it shifts work into prompt design, example selection, evaluation, and very expensive pre-training.
- Performance generally improves with model size. The paper trained models from 125M to 175B parameters and found relatively smooth scaling on many tasks.
- Few-shot generally beats zero-shot, and the few-shot advantage often grows with model size. This is a trend, not a guarantee on every task.

## Results to remember

- GPT-3 is strong on many language tasks: translation, question answering, cloze tasks, and some rapid-adaptation tasks.
- On closed-book TriviaQA, GPT-3 improves from zero-shot to one-shot to few-shot: `64.3% -> 68.0% -> 71.2%`.
- On CoQA, it similarly improves: `81.5 F1 -> 84.0 F1 -> 85.0 F1`.
- It also shows surprising qualitative behavior: arithmetic, word unscrambling, using a newly defined word in a sentence, and generating news-like articles.
- It struggles on some natural language inference and reading-comprehension tasks, including ANLI, WIC, RACE, and QuAC.
- Data contamination matters because large web corpora can accidentally include benchmark examples.

## Why it mattered

GPT-3 made prompting feel like a real adaptation interface, not just a convenience. The important shift was:

```text
task-specific training -> task specification in context
```

That made a single base model useful across many tasks, but it did not remove the need for careful evaluation, domain-specific data, fine-tuning in some cases, or safety analysis.

## TL;DR

- GPT-3 showed that large language models can do many tasks from instructions and examples alone.
- Zero-shot, one-shot, and few-shot prompting require no task-specific weight updates.
- Larger models are better at using in-context examples.
- Few-shot usually beats zero-shot, but not universally.
- The right correction is: prompting reduces per-task fine-tuning pressure; it does not make fine-tuning irrelevant.

## Related

- `Machine_Learning/LLMs/reading-llm-papers.md` - places GPT-3 in the LLM paper roadmap
- `Machine_Learning/Research_Papers/attention-is-all-you-need.md` - Transformer background for GPT-style models
- `Machine_Learning/Natural_Language_Processing/n-gram-language-models.md` - older language-modeling baseline
