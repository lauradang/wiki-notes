# Prefill / Decode

![Prefill & Decode: two phases of LLM inference — prompt in one parallel pass, then one pass per output token; KV cache grows by one entry per decode step](images/prefill-decode-overview.png)

![Prefill vs. decoding data flow: prompt → wQ/wK/wV → QKᵀ → softmax → A, with K and V written to the KV cache; decoding loop computes one new token's Q/K/V and concats K/V onto the cached matrices](images/kv-cache-prefill-vs-decode-flow.png)

https://www.youtube.com/watch?v=3SBUCJzogj4

![Q·Kᵀ·V computation with KV caching: prefill vs. decode](https://developer-blogs.nvidia.com/wp-content/uploads/2023/11/key-value-caching_.png)

**Annotated** — same diagram with the example ("What is a capital", 4 tokens) filled in:

![Annotated KV cache diagram: prefill vs. decode for "What is a capital"](images/kv-cache-annotated.png)

**Full layer** — every step the diagram above skips (attention matrix, feed-forward, 32 layers, picking the next token):

![Inside one layer during prefill: attention matrix, feed-forward, and next-token selection](images/full-layer.png)

**Example**: What is a capital?

## Prefill

Simply put, you can think of it like each word ("What", "is", "a", "capital") is a row in the $Q$ & $K^T$ matrices.

With a longer sentence, you can see that the matrices grow, which means bigger matrix computation needs to be done.

**Note**: Since this is a matrix, each word's computation can be done in parallel.

## Decode




