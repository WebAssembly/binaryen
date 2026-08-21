## Summary

Fixes [#8785](https://github.com/WebAssembly/binaryen/issues/8785): `wasm-opt` / `wasm-as` now reject Wasm operand-stack underflow at parse time (e.g. `(block (unreachable)) (drop)`), matching engines like V8, while **valid Wasm still parses to the same Binaryen IR as `main`**.

## Problem

Binaryen IR types void unreachable control flow as bottom (`unreachable`), so IRBuilder historically accepted patterns that are invalid on the Wasm stack. After a void `(block (unreachable))` completes, the Wasm stack is empty, but Binaryen still treated the block as a poppable IR operand. `WasmValidator` cannot catch this because it never models the Wasm operand stack.

## Approach

Track a **shadow** Wasm stack type (`StackEntry::wasmStackType`) alongside each parsed expression, mirroring `StackIRGenerator::makeStackInst` in `wasm-stack.cpp`:

- **IR packaging** still uses `expr->type` (same as `main`): `hoistLastValue`, `ChildPopper::pop`, and `finishScope` are unchanged from baseline IR behavior.
- **Validation overlay** runs only when `PassOptions.validate` is true. Underflow on the shadow stack returns `popping from empty stack`.
- **`pushControlFlow`** records the **declared** Wasm block result (`none`, concrete, or multivalue tuple), not Binaryen bottom typing. Void unreachable blocks do **not** enter polymorphic mode in the parent scope (unlike plain `unreachable` instructions).
- Control-flow isolation uses the existing per-`ScopeCtx` `exprStack`; no global Wasm stack.

## Opt-out

Reuses existing flags (no new CLI option):

- `wasm-opt` / most tools: `--no-validation` / `-n` → `PassOptions.validate = false` → skips Wasm stack checks during parse.
- `wasm-as`: also respects `--validate=none`.
- Internal IR reconstruction (`Outlining.cpp`) constructs `IRBuilder` with `validateWasmStack = false`.

## Non-goals

- No IR-shape changes for valid Wasm modules (reverted ~91 lit `-S` expectation diffs from the prior PR attempt).
- No full Wasm spec validator in `WasmValidator` (IR lacks enough stack detail; parser is the right place).
- Tests that intentionally parse valid Binaryen IR / invalid Wasm use `--no-validation` on those RUN lines only.

## Performance

Parse-only benchmark on `wat-kitchen-sink.wasm` (~5 KB), 100 iterations, `-all`:

| Mode | Total time | Per parse (approx.) |
|------|------------|---------------------|
| Validation ON (default) | 724 ms | ~7.2 ms |
| `--no-validation` | 570 ms | ~5.7 ms |

Overhead for shadow-stack tracking: **~21%** on this small module (fixed per-entry work; expect lower relative overhead on large binaries).

## Tests

- New/updated `test/lit/validation/unreachable-*.wast`: #8785 rejection, `--no-validation` bypass, multivalue, stack isolation, folded vs linear WAT.
- Restored lit `-S` expectations from `main` (except new validation tests).
- Targeted regressions: `array-multibyte`, `wat-kitchen-sink`, `remove-unused-brs_enable-multivalue`, `wasm-split/split-module-items` (pipe/opt-out where input is Binaryen-IR-shaped).
- `binaryen-unittests`: 379/379.

## Test plan

- [x] `binaryen-lit test/lit/validation/unreachable-*.wast`
- [x] `binaryen-lit` IR-shape fixtures listed above
- [x] `binaryen-unittests`
- [x] Manual: `wasm-opt jj.wat -all` rejects #8785; `--no-validation` accepts
