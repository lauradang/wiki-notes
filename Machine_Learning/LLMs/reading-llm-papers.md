# Reading LLM Papers

Reading an **LLM paper** is mostly identifying which design levers changed: architecture, training objective, data, scale, post-training, inference behavior, and evaluation target.

## The idea

Most new LLM papers are not introducing an entirely new kind of model. They usually combine a few known choices:

```text
architecture + training objective + data recipe + scale + post-training + inference strategy + eval target
```

Once those levers are familiar, a new model paper becomes easier to skim. The key question is not "what is this model?" but "which levers changed compared with GPT, BERT, Llama, DeepSeek, etc.?"

## Core roadmap

| Order | Paper | Why read it |
|---|---|---|
| 1 | [BERT: Pre-training of Deep Bidirectional Transformers](https://arxiv.org/abs/1810.04805) | Encoder-only Transformer with masked-token prediction; useful contrast to GPT-style models |
| 2 | [Language Models are Few-Shot Learners](https://arxiv.org/abs/2005.14165) | GPT-3; decoder-only autoregressive scaling and few-shot prompting |
| 3 | [Exploring the Limits of Transfer Learning with a Unified Text-to-Text Transformer](https://arxiv.org/abs/1910.10683) | T5; encoder-decoder model where every NLP task is cast as text-to-text |
| 4 | [Scaling Laws for Neural Language Models](https://arxiv.org/abs/2001.08361) | Model/data/compute tradeoffs; why scale predictably improves loss |
| 5 | [Training Compute-Optimal Large Language Models](https://arxiv.org/abs/2203.15556) | Chinchilla; why many older models were undertrained relative to their size |
| 6 | [Training Language Models to Follow Instructions with Human Feedback](https://arxiv.org/abs/2203.02155) | InstructGPT; base model vs assistant model, SFT, reward models, RLHF |
| 7 | [Llama 2](https://arxiv.org/abs/2307.09288) or [Llama 3](https://arxiv.org/abs/2407.21783) | Modern open-weight dense Transformer recipes |

## Main LLM families

| Family | What changes | Examples |
|---|---|---|
| Dense decoder-only | One full model runs for every token; trained with next-token prediction | GPT-3, Llama, PaLM-style models |
| Encoder-only | Reads the whole input bidirectionally; strong for classification, retrieval, embeddings, NLU | BERT |
| Encoder-decoder | Separate encoder reads input, decoder generates output | T5 |
| Mixture-of-Experts (MoE) | Many expert networks exist, but only a subset activates per token | [Switch Transformer](https://arxiv.org/abs/2101.03961), [DeepSeek-V3](https://arxiv.org/abs/2412.19437) |
| Reasoning/RL models | Post-trained to spend more compute on hard tasks or optimize verifiable rewards | [Chain-of-Thought](https://arxiv.org/abs/2201.11903), [DeepSeek-R1](https://arxiv.org/abs/2501.12948) |
| Preference-trained models | Tuned to match human or AI preference judgments | InstructGPT, [DPO](https://arxiv.org/abs/2305.18290), [Constitutional AI](https://arxiv.org/abs/2212.08073) |
| Retrieval-augmented systems | Adds external document retrieval instead of relying only on model weights | [RAG](https://arxiv.org/abs/2005.11401), [Self-RAG](https://arxiv.org/abs/2310.11511) |
| Multimodal LLMs | Connects language models to vision/audio/video encoders or trains jointly on multiple modalities | [Flamingo](https://arxiv.org/abs/2204.14198), [LLaVA](https://arxiv.org/abs/2304.08485), [Gemini](https://arxiv.org/abs/2312.11805) |
| Long-context / efficient models | Changes attention or sequence modeling to handle longer contexts or cheaper inference | [Longformer](https://arxiv.org/abs/2004.05150), [RWKV](https://arxiv.org/abs/2305.13048), [Mamba](https://arxiv.org/abs/2312.00752) |
| Domain/code models | Same general recipe, but specialized data and evaluation | [Code Llama](https://arxiv.org/abs/2308.12950), [StarCoder2](https://arxiv.org/abs/2402.19173), [BloombergGPT](https://arxiv.org/abs/2303.17564), [Med-PaLM](https://arxiv.org/abs/2212.13138) |

## Paper reading checklist

For each new LLM paper, fill out this template:

```text
1. Base architecture:
   decoder-only, encoder-only, encoder-decoder, MoE, SSM/RNN hybrid, multimodal?

2. Training objective:
   next-token prediction, masked LM, denoising, preference loss, RL, verifier reward?

3. Data:
   how many tokens, what domains, what filtering, synthetic data, code/math/multilingual?

4. Scale:
   total parameters, active parameters, context length, training compute, tokenizer?

5. Post-training:
   SFT, RLHF, DPO, constitutional AI, RLVR, distillation?

6. Inference behavior:
   normal sampling, tool use, retrieval, chain-of-thought, test-time compute, long context?

7. What is actually new:
   architecture, data recipe, training recipe, efficiency, evaluation result, openness, product framing?

8. What benchmarks matter:
   MMLU, HumanEval, GSM8K/MATH, multilingual, safety, factuality, domain-specific evals?
```

## What to notice first

- **Base vs instruct/chat model**: base models predict text; instruct/chat models are post-trained to behave like assistants.
- **Parameters vs active parameters**: dense models use all parameters per token; MoE models may have huge total parameters but far fewer active parameters.
- **Pre-training vs post-training**: pre-training teaches broad language/statistical knowledge; post-training shapes behavior.
- **Data quality matters**: a smaller model trained on more relevant or cleaner data can beat a larger model on targeted tasks.
- **Benchmark fit matters**: coding, math, medicine, finance, multilinguality, and safety require different evals.
- **System vs model**: RAG, tools, guardrails, and agents may be wrapped around an LLM without changing the base model itself.

## Evaluation names worth recognizing

| Benchmark | Rough meaning |
|---|---|
| MMLU | Broad academic/multitask knowledge |
| GSM8K / MATH | Math reasoning |
| HumanEval / MBPP | Code generation |
| HELM | Broad, transparent model evaluation framework |
| BIG-bench | Collection of unusual/hard language model tasks |
| Domain-specific evals | More important than general benchmarks for medical, finance, legal, code, or scientific models |

## TL;DR

A new LLM paper usually differs by changing one to three levers: architecture, data, post-training, inference, or evaluation. Read the abstract and methods with those levers in mind, then decide whether the novelty is a true model change or a better recipe around a familiar Transformer.

## Related

- `Machine_Learning/LLMs/grpo.md` - reinforcement learning and reasoning post-training context
- `Machine_Learning/LLMs/guardrails.md` - example of LLM behavior controlled by a surrounding system
- `Machine_Learning/Natural_Language_Processing/n-gram-language-models.md` - older language modeling baseline before neural LMs
