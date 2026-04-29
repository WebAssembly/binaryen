#!/usr/bin/env python3
"""Analyze /tmp/ci_stats.csv produced by instrumented checkInvalidations.

Usage:
  1. Apply instrumentation to SimplifyLocals.cpp (see ci_instrument.patch)
  2. Build and run:  wasm-opt --simplify-locals ... -o /dev/null input.wasm
  3. Run:  python3 scripts/analyze_ci_stats.py
"""

import csv
import sys
from collections import Counter

CSV_PATH = sys.argv[1] if len(sys.argv) > 1 else "/tmp/ci_stats.csv"


def main():
    total = 0
    total_work = 0
    fast = 0
    slow = 0
    fast_sinkables = 0
    slow_sinkables = 0
    fast_candidates = 0
    fast_breakdown = Counter()
    categories = {}  # category -> (calls, work)
    slow_sink_sizes = []
    fast_sink_sizes = []

    with open(CSV_PATH) as f:
        reader = csv.DictReader(f)
        for row in reader:
            total += 1
            s = int(row["sinkables"])
            c = int(row["candidates"])
            rl = int(row["readsLocal"])
            wl = int(row["writesLocal"])
            ca = int(row["calls"])
            mem = int(row["memory"])
            gc = int(row["gc"])
            trap = int(row["trap"])
            cf = int(row["controlFlow"])
            gs = int(row["globalState"])
            total_work += s

            # Categorize by what effects are present
            cats = []
            if rl or wl:
                cats.append("local")
            if ca:
                cats.append("calls")
            if mem:
                cats.append("mem")
            if gc:
                cats.append("gc")
            if trap:
                cats.append("trap")
            if cf:
                cats.append("cf")
            if gs:
                cats.append("gs")
            key = "+".join(sorted(cats)) if cats else "none"
            if key not in categories:
                categories[key] = [0, 0]
            categories[key][0] += 1
            categories[key][1] += s

            if row["path"] == "fast":
                fast += 1
                fast_sinkables += s
                fast_candidates += c
                if s > 0:
                    fast_sink_sizes.append(s)
                if not rl and not wl:
                    fast_breakdown["no_local_effects"] += 1
                elif rl and not wl:
                    fast_breakdown["only_reads"] += 1
                elif not rl and wl:
                    fast_breakdown["only_writes"] += 1
                else:
                    fast_breakdown["reads_and_writes"] += 1
            else:
                slow += 1
                slow_sinkables += s
                if s > 0:
                    slow_sink_sizes.append(s)

    fast_sink_sizes.sort()
    slow_sink_sizes.sort()

    def percentile(lst, p):
        if not lst:
            return 0
        k = int(len(lst) * p / 100)
        return lst[min(k, len(lst) - 1)]

    print(f"=== checkInvalidations analysis ({CSV_PATH}) ===")
    print(f"Total calls: {total:,}")
    print(f"Total orderedAfter work: {total_work:,}")
    print()

    # --- By effect category ---
    print(f"{'Category':<45} {'Calls':>10} {'Work':>15} {'Work%':>7}")
    print("-" * 80)
    for k, (count, work) in sorted(categories.items(), key=lambda x: -x[1][1]):
        if work > 0 or count > 1000:
            print(f"{k:<45} {count:>10,} {work:>15,} {100*work/max(total_work,1):>6.1f}%")
    print()

    # --- Fast path ---
    print(f"FAST PATH: {fast:,} ({100*fast/max(total,1):.1f}%)")
    fast_nonempty = len(fast_sink_sizes)
    print(f"  With sinkables>0: {fast_nonempty:,}")
    print(
        f"  Avg sinkables (when >0): {fast_sinkables/max(fast_nonempty,1):.1f}"
    )
    print(f"  Total sinkables (work if no fast path): {fast_sinkables:,}")
    print(f"  Total candidates actually checked: {fast_candidates:,}")
    saved = fast_sinkables - fast_candidates
    print(
        f"  Work saved: {saved:,} ({100*saved/max(fast_sinkables,1):.1f}%)"
    )
    print(f"  Breakdown:")
    for k, v in fast_breakdown.most_common():
        print(f"    {k}: {v:,} ({100*v/max(fast,1):.1f}%)")
    if fast_sink_sizes:
        print(
            f"  Sinkable distribution: p50={percentile(fast_sink_sizes, 50)}, "
            f"p90={percentile(fast_sink_sizes, 90)}, "
            f"p99={percentile(fast_sink_sizes, 99)}, "
            f"max={fast_sink_sizes[-1]}"
        )
    print()

    # --- Slow path ---
    print(f"SLOW PATH: {slow:,} ({100*slow/max(total,1):.1f}%)")
    slow_nonempty = len(slow_sink_sizes)
    print(f"  With sinkables>0: {slow_nonempty:,}")
    print(
        f"  Avg sinkables (when >0): {slow_sinkables/max(slow_nonempty,1):.1f}"
    )
    print(f"  Total orderedAfter checks: {slow_sinkables:,}")
    if slow_sink_sizes:
        print(
            f"  Sinkable distribution: p50={percentile(slow_sink_sizes, 50)}, "
            f"p90={percentile(slow_sink_sizes, 90)}, "
            f"p99={percentile(slow_sink_sizes, 99)}, "
            f"max={slow_sink_sizes[-1]}"
        )
    print()

    # --- Overall ---
    print(f"OVERALL:")
    print(f"  Without optimization: {total_work:,} orderedAfter calls")
    opt_work = fast_candidates + slow_sinkables
    print(f"  With fast path: {opt_work:,} orderedAfter calls")
    print(f"  Reduction: {100*(1 - opt_work/max(total_work,1)):.1f}%")


if __name__ == "__main__":
    main()
