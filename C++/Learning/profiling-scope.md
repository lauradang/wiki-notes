# Profiling — What Exactly Are You Measuring?

A common mistake when reading profiling numbers: assuming the timer covers the whole program. It usually doesn't.

## Manual timing with chrono

The standard pattern in C++:

```cpp
auto start_time = std::chrono::high_resolution_clock::now();   // START

bool success = doTheWork(config, input, output);               // THE WORK

auto end_time = std::chrono::high_resolution_clock::now();     // END
```

The timer measures **only what's between start and end**. That excludes:
- Loading input files from disk
- Saving output files
- Printing to terminal
- Setup and teardown

So when you report a number like "140ms," that's 140ms of the work call — not the whole binary's wall time.

## Manual timing vs `gprof`

Two different things:

| Tool | What it measures |
|---|---|
| `chrono` start/end | One specific section of code you wrap |
| `gprof` | The whole program — every function gets a sample-based percentage |

If file I/O is negligible compared to compute, `gprof` percentages effectively reflect what's happening inside the timed region anyway. But that's a coincidence of the workload, not a guarantee.

## Why this matters

When someone says "function X is 18% of runtime," ask:
1. **18% of what?** The whole binary, or just the timed compute region?
2. **What's excluded?** If file I/O is in the program but not in the timer, it's invisible to the percentage but still real wall-clock cost.
3. **Is the workload representative?** Profiling a 10ms run tells you almost nothing — startup costs dominate. Profile something long enough that the steady state is what you're measuring.

## Rule of thumb

Always know exactly where your timer starts and ends. If you can't point at the two lines of code, you don't know what your number means.
