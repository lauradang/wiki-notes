# Guardrails

https://github.com/NVIDIA/NeMo-Guardrails/blob/aa07d889e9437dc687cd1c0acf51678ad435516e/docs/architecture/README.md#the-guardrails-process

## Guardrails Runtime

1. Generate canonical user message

2. Decide next step and execute

3. Generate bot utterance

Each of the above stages can involve one or more calls to the LLM.

### Generate canonical user message

- generate canonical form for user utterance (captures 1. user intent 2. allows GR to trigger flows)

```
define flow generate user intent
  """Turn the raw user utterance into a canonical form."""

  event UtteranceUserActionFinished(final_transcript="...")
  execute generate_user_intent
```

**`Generate_user_intent` action**:

1. vector search on all canonical form examples in GR configs

2. Take top 5

3. Include them in prompt

4. Ask LLM to generate canonical form for current user utterance

5. new `UserIntent` even created

### Decide Next Steps

potential next paths:

1. pre-defined flow already defined

2. LLM used to decide next step

    1. vector search performed for most relevant flows from GR config

    2. take top 5 flows

    3. include in prompt

    ```
    define flow generate next step
        """Generate the next step when there isn't any.

        We set the priority at 0.9 so it is lower than the default which is 1. So, if there
        is a flow that has a next step, it will have priority over this one.
        """
        priority 0.9

        user ...
        execute generate_next_step
    ```

This will happen for either step:

bot should say something (`BotIntent` events)

    -> invokes `generate_bot_message` action (explained in next step)

### Generate Bot Utterances

1. vector search for most relevant bot utterance examples in GR configs

    - also vector search on knowledge base if provided to include in prompt (`retrieve_relevant_chunks` action)

2. included in prompt

3. ask LLM to generate utterance for current bot intent

```
define extension flow generate bot message
  """Generate the bot utterance for a bot message.

  We always want to generate an utterance after a bot intent, hence the high priority.
  """
  priority 100

  bot ...
  execute retrieve_relevant_chunks
  execute generate_bot_message
```

### Overall

```yaml
- type: UtteranceUserActionFinished
  final_transcript: "how many unemployed people were there in March?"

# Stage 1: generate canonical form
- type: StartInternalSystemAction
  action_name: generate_user_intent

- type: InternalSystemActionFinished
  action_name: generate_user_intent
  status: success

- type: UserIntent
  intent: ask about headline numbers

# Stage 2: generate next step
- type: StartInternalSystemAction
  action_name: generate_next_step

- type: InternalSystemActionFinished
  action_name: generate_next_step
  status: success

- type: BotIntent
  intent: response about headline numbers

# Stage 3: generate bot utterance
- type: StartInternalSystemAction
  action_name: retrieve_relevant_chunks

- type: ContextUpdate
  data:
    relevant_chunks: "The number of persons not in the labor force who ..."

- type: InternalSystemActionFinished
  action_name: retrieve_relevant_chunks
  status: success

- type: StartInternalSystemAction
  action_name: generate_bot_message

- type: InternalSystemActionFinished
  action_name: generate_bot_message
  status: success

- type: StartInternalSystemAction
  content: "According to the US Bureau of Labor Statistics, there were 8.4 million unemployed people in March 2021."

- type: Listen
```