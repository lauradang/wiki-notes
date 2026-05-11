# GRPO (Group Relative Policy Optimization)

## RLHF Background

- OpenAI collected human preference data (which answer is preferred) for **preference fine-tuning**, known as RLHF (Reinforcement Learning from Human Feedback)
- Requires training a separate **reward model** that predicts human preferences
- The optimization algorithm that updates model weights is **PPO** (Proximal Policy Optimization)
- GRPO is a successor to PPO

## RLVR (RL with Verifiable Rewards)

- Suspected to be what OpenAI's o1 uses; DeepSeek R1 brought it to wider attention
- For reasoning fine-tuning, you can use either PPO or GRPO

## RL Concepts for LLMs

| Concept | General RL | LLM context |
|---|---|---|
| Agent | e.g. Roomba | The LLM |
| Environment | Physical space | Outside world: humans, datasets, Python interpreter, etc. |
| Action (`a_t`) | Robot movement | Token generated |
| State (`s_t`) | Robot position | Cumulative tokens so far |
| Reward (`r_t`) | Score from env | Quality signal at end of response |
| Trajectory (`τ`) | Full episode | Full sequence of tokens |
| Policy | Decision function | The LLM itself |

### Rewards in LLMs

- Reward is typically only assigned at the **end** of a response (sparse reward)
- If the model answers correctly, it gets a positive reward (e.g. R=1)
- DeepSeek scores on both **correctness AND formatting**
- Some approaches use intermediate models to score partial responses before completion

## GRPO Mechanics

- GRPO finds the **baseline by averaging rewards across a sampled group** of responses (hence "Group Relative")
- Avoids needing a separate value/critic network (unlike PPO)

## Process Supervision (GRPO variant)

- DeepSeek separated responses into **reasoning steps** and added a reward model that provides **intermediate rewards** for each step
- Called **GRPO with process supervision**
- DeepSeek's paper conclusion: intermediate rewards are **not worth the overhead**
