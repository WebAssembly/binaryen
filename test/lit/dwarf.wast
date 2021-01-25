;; flatten should warn about DWARF incompatibility
;; RUN: wasm-opt -g unit/input/dwarf/cubescript.wasm --flatten 2>&1 | filecheck %s --check-prefix WARN
;; WARN: not fully compatible with DWARF

;; safe passes should not warn
;; RUN: wasm-opt -g unit/input/dwarf/cubescript.wasm --metrics 2>&1 | filecheck %s --check-prefix OK
;; OK-NOT: not fully compatible with DWARF
