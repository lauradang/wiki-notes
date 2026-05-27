# Ray Basics

**Ray** is a Python framework for distributed execution. It gives you primitives for running Python functions and class instances across a cluster of machines, with automatic placement, RPC, and shared-memory data passing.

## The components

| Component | What it is | Lifetime | Lives in |
|---|---|---|---|
| Cluster | Set of nodes joined via `ray start` | Until torn down | — |
| Node | One physical/virtual machine (one VM, one K8s pod) | One per machine | Cluster |
| Raylet | Per-node scheduler daemon | Pod lifetime | Node |
| Plasma | Per-node shared-memory object store | Pod lifetime | Node |
| GCS | Global Control Store — metadata & actor directory | Cluster lifetime | Head node only |
| Worker process | A Python interpreter, one OS process | Until reaped | Node |
| Driver | The worker process running your `python script.py` | Until script exits | Head node |
| Actor | A worker dedicated to one `@ray.remote` class instance | Until killed | Some node |
| Task | One call to a `@ray.remote` function, run in any free worker | One call | Some node |
| Placement group | Reserved set of resource bundles across nodes | Until released | Cluster |
| Bundle | One unit of reserved resources, e.g. `{"GPU": 4, "CPU": 32}` | Lives in a PG | Node |

## Hierarchy

```
Cluster
└── Node                          (one machine = one K8s pod)
    ├── Raylet                    (scheduler)
    ├── Plasma                    (shared-mem object store)
    └── Worker processes
        ├── Driver                (one, on head node)
        ├── Actor                 (dedicated, one process per @ray.remote class instance)
        └── Task worker           (pooled, short-lived, runs one @ray.remote function call)
```

Head node also runs the **GCS** — cluster-wide metadata and actor directory.

## Actors vs tasks

| | Actor | Task |
|---|---|---|
| Decorator | `@ray.remote` on a class | `@ray.remote` on a function |
| Worker | Dedicated, long-lived | Pooled, picked per call |
| State | Holds class instance state | Stateless |
| Use when | You need state (model on GPU, KV cache, DB connection) | Pure function calls |

Calling either returns an `ObjectRef` — a future. `ray.get(ref)` blocks until the result is available.

```python
@ray.remote
class Foo:
    def bar(self, x): return x + 1

handle = Foo.remote()         # spawn actor (one process, one node)
ref = handle.bar.remote(3)    # RPC call, returns ObjectRef
result = ray.get(ref)         # → 4
```

`handle.bar(3)` without `.remote()` would error — actor methods are only reachable via Ray RPC.

## Resources and placement

Resources are labels with budgets that Ray tracks per node — `num_cpus`, `num_gpus`, plus custom ones. When you ask for an actor with `num_gpus=1`, the GCS finds a Raylet that has a free GPU slot, asks it to fork a worker process there, and deducts the budget. Ray sets `CUDA_VISIBLE_DEVICES` based on the slot — it doesn't actually allocate the GPU, it just trusts your code to respect the label.

**Placement groups** pin groups of actors together. A PG is a list of bundles, each `{"GPU": n, "CPU": m, ...}`. Ray atomically reserves the bundles across nodes according to a strategy:

| Strategy | Behavior |
|---|---|
| `PACK` | Cram as many bundles per node as possible |
| `SPREAD` | Fan out across nodes |
| `STRICT_PACK` / `STRICT_SPREAD` | Same but fail if the layout isn't achievable |

Each actor is then pinned to a specific bundle:

```python
cls.options(
    scheduling_strategy=PlacementGroupSchedulingStrategy(pg, bundle_index=i),
    num_gpus=1,
).remote(...)
```

This is how you get "this actor on these 4 GPUs of that node" — the building block for TP / PP / DP groups in distributed training.

## Decorator options

| Option | What it does |
|---|---|
| `num_gpus=1`, `num_cpus=8` | Reserve resources on a node before placement |
| `max_restarts=-1` | Restart on crash; `-1` = unlimited |
| `max_task_retries=-1` | Retry calls that fail because the actor died |
| `resources={"head_node": 1}` | Pin to nodes with a custom label |
| `runtime_env={...}` | Per-actor virtualenv, env vars, working dir |

Per-method options live on `@ray.method(...)` or per-call `.options(...)`. Don't nest `@ray.remote` on methods — that breaks the wrapper.

## Communication protocols

| Between | Protocol |
|---|---|
| Driver ↔ actor, actor ↔ actor | Ray RPC (gRPC) via `.method.remote(args)` |
| Worker ↔ local plasma | Shared memory |
| Plasma ↔ remote plasma | Network copy when `ray.get(ref)` crosses nodes |
| Actor ↔ anything outside Ray | Whatever you implement — HTTP, NCCL, sockets |

Ray RPC is its own binary protocol — not HTTP. If you need HTTP (e.g. an OpenAI-compatible endpoint), you run a uvicorn/FastAPI server *inside* the actor's process.

## Lifecycle: who creates what

```
1. ray start --head             → head node's Raylet/GCS/Plasma come up
2. ray start --address=HEAD     → worker nodes' Raylet/Plasma come up, join cluster
3. python my_script.py          → driver process forks on head node
4. ray.init(address="auto")     → driver ATTACHES to the existing cluster
5. Class.remote(...)            → driver asks GCS to place an actor
6. GCS picks a node             → that node's Raylet forks a new Python worker
7. Worker imports class, runs __init__   → an actor is born
```

Pods/VMs are created by Kubernetes (KubeRay) or your VM provisioner, not by Ray. Ray operates on already-running nodes.

## Related
- `DevOps/Kubernetes/kubernetes-architecture.md` — Ray often runs inside K8s pods via KubeRay
- `Work/LLM/nemo-rl-architecture.md` — concrete example of Ray actors used for LLM training
