# TypeScript API Changelog

## Current Trunk
- Replace old `Feature.RelaxedAtomics` with `Feature.AcquireReleaseAtomics`,
	then add new `Feature.RelaxedAtomics`. (#8982, #8983)
- Add `MemoryOrder.Relaxed`. (#8984)
- Replace `parseTextWithFeatures()` with an optional features parameter to `parseText()`. (#8901)
- Replace `readBinaryWithFeatures()` with an optional features parameter to `readBinary()`. (#8954)
- Add `ExpressionBuilder#string.const()`. (#8951)

## v0.1.0 (`2026-07-08T00:43Z`)
- Init.
