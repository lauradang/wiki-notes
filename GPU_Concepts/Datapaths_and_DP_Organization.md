# Subpartitions and DP Organization

## The hierarchy at a glance

A GPU's SM (Streaming Multiprocessor) has tensor-core hardware that performs matrix multiplies. That hardware is organized into a small hierarchy:

```text
SM (Streaming Multiprocessor)
 └── 8 subpartitions (SPs)   -- fixed count per SM
      └── datapaths          -- one or more per subpartition, count varies by workload
```

Two things to hold in your head:

- The number **8** always refers to **subpartitions per SM**. That count is fixed.
- The number of **datapaths** inside each subpartition is **not fixed**. It depends on the workload (matrix size, sparsity, etc.).

## What is a subpartition (SP)?

A subpartition is a compute unit inside the SM that owns a piece of a matrix-multiply operation. When the GPU runs one matrix-multiply-accumulate instruction, the output is sliced up and each subpartition is responsible for one slice.

There are always 8 of them, numbered 0 through 7.

Simple mental model:

- think of a bakery with 8 ovens
- a big order (one matrix-multiply instruction) gets split into 8 pieces
- each oven (subpartition) bakes its piece in parallel

## What is a datapath?

A datapath is the actual silicon inside a subpartition that does the math. You can think of a subpartition as a *container* that holds one or more datapaths.

How many datapaths live in one subpartition depends on the shape of the workload. Software configures this at runtime.

Mental model:

- a subpartition = one oven
- a datapath = one tray inside that oven
- more trays mean the oven can bake more in one batch, but the oven itself is still the same container

## What is "DP organization"?

**DP organization is the rule that decides how the OUTPUT MATRIX is sliced across the 8 subpartitions.**

When code refers to the output matrix, it has two dimensions:

- **M** = number of rows
- **N** = number of columns

DP organization answers one question: *how do we cut the output matrix so each of the 8 SPs gets a piece?*

There are three standard answers. All three produce 8 pieces total (one per SP), but they shape those pieces differently.

## Before the diagrams: what you are looking at

Every grid in this note represents **the OUTPUT MATRIX only**. Not an input. Not a tile. Not a subpartition.

Each cell inside a grid is **one tile of the output matrix**. The number written in the cell is **the SP (0 through 7) that computes that tile**.

Keep this in mind: the grids are pictures of the output matrix, painted with SP assignments.

## The three layouts

### DP4x1 — cut along M only

Fits a tall-skinny output matrix.

```text
=== OUTPUT MATRIX ===           (layout: DP4x1)

       (N direction,
        no cuts)
     ┌─────────────┐
     │      0      │
     ├─────────────┤
     │      1      │
     ├─────────────┤
     │      2      │
     ├─────────────┤
     │      3      │
     ├─────────────┤
     │      4      │
     ├─────────────┤
     │      5      │
     ├─────────────┤
     │      6      │
     ├─────────────┤
     │      7      │
     └─────────────┘
      (M direction,
       cut 4 major
        ways)
```

All 8 SPs stack vertically — they share the same N columns, each SP takes a different horizontal strip of rows.

### DP2x2 — one major cut along M, one major cut along N

Fits a roughly-square output matrix.

```text
=== OUTPUT MATRIX ===           (layout: DP2x2)

               (N direction, cut in half)
               ◄─ N-left half ─►◄─ N-right half ─►
              ┌──────────────┬──────────────┐
              │              │              │
              │      0       │      2       │
              │              │              │
              ├──────────────┼──────────────┤
              │              │              │
              │      1       │      3       │
              │              │              │
              ╞══════════════╪══════════════╡  ← major M cut
              │              │              │
              │      4       │      6       │
              │              │              │
              ├──────────────┼──────────────┤
              │              │              │
              │      5       │      7       │
              │              │              │
              └──────────────┴──────────────┘
                             ▲
                      major N cut
```

The thick line (`══`) is the major M cut. The vertical divider between the two columns is the major N cut. Those two cuts create a coarse **2x2 grid of quadrants** — that is what gives the name "DP2x2."

The thin lines inside each quadrant are a finer secondary split that fits 2 SPs into each quadrant (4 quadrants × 2 SPs = 8 SPs).

### DP1x4 — cut along N only

Fits a short-wide output matrix.

```text
=== OUTPUT MATRIX ===           (layout: DP1x4)

               (N direction, cut 4 major ways)
        ┌─────────┬─────────┬─────────┬─────────┐
        │    0    │    2    │    4    │    6    │
        ├─────────┼─────────┼─────────┼─────────┤
        │    1    │    3    │    5    │    7    │
        └─────────┴─────────┴─────────┴─────────┘
         (M direction, no major cuts — 2 SPs stacked per column)
```

All 8 SPs spread horizontally — they share the same rows of M, each SP takes a different vertical strip of columns.

## Why "2x2" looks like 4x2 cells

This is the single most common source of confusion.

In the DP2x2 diagram, if you count cells you see **4 rows × 2 columns = 8 cells**. That looks like a 4x2 grid, not a 2x2 grid.

The name refers to the **coarse cut pattern**, not the cell count:

- **2 major cuts along M** (halves the M axis once)
- **2 major cuts along N** (halves the N axis once)
- → 4 big quadrants, arranged in a 2×2 shape
- Each quadrant is then further split into 2 SPs, which is where the extra rows come from

Cake analogy: cut a cake into quadrants (one horizontal cut, one vertical cut). Now cut each quadrant in half again. You have 8 slices, but you still call the cake "cut into quadrants" — the quadrant structure is the main story. The sub-cut is incidental.

So **the name "DP2x2" describes the coarse 2×2 quadrant structure**, and each quadrant quietly holds 2 subpartitions.

## Reading the layout names consistently

The numbers in every layout name mean **major cuts along M × major cuts along N**:

| Name      | Major cuts (M × N) | Shape of the cut pattern | Fits an output that is |
|-----------|--------------------|--------------------------|------------------------|
| **DP4x1** | 4 × 1              | tall stack               | tall and skinny        |
| **DP2x2** | 2 × 2              | 2×2 grid of quadrants    | roughly square         |
| **DP1x4** | 1 × 4              | wide row                 | short and wide         |

In every case there are still **8 subpartitions total** — the layouts only change how those 8 are arranged across the output.

## Tile size vs. DP organization

When reading code in this area, it helps to separate two levels:

1. **Tile size** — the dimensions of one atomic piece of work (for example, 16 rows × 8 cols). This is the unit a single subpartition handles at one moment.
2. **DP organization** — the layout pattern that arranges multiple tiles across the 8 subpartitions to cover the full output.

Tile size is a measurement in rows and columns. DP organization is a layout shape. They describe **different levels** of the same computation. The layout does not change the tile size, and the tile size does not change the layout.

## Why have more than one layout?

Different output shapes compute more efficiently with different cut patterns:

- a tall, skinny output fits DP4x1 naturally
- a square-ish output fits DP2x2
- a short, wide output fits DP1x4

The compiler or scheduler picks the layout when the matrix-multiply instruction is issued, based on the expected output shape.

## Best takeaway

- the hierarchy is **SM → 8 subpartitions (SPs) → datapaths**; the count of 8 is fixed
- every grid in this note is a picture of **the output matrix**, with cells labeled by the SP that owns them
- **DP organization** decides how the output is sliced across the 8 SPs
- layout names read as *major cuts along M × major cuts along N*, not total cell count
- the grid in DP2x2 has 8 cells because each of the 4 quadrants holds 2 SPs — the name still describes the coarse 2×2 quadrant structure
- tile size and DP organization live at two different levels and should not be confused
- the right layout depends on the shape of the output
