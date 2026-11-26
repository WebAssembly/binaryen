;; Check that a manifest starting with a blank line produces an error rather
;; than crashing.
;; RUN: echo "" > %t.blank.manifest
;; RUN: echo "1:" >> %t.blank.manifest
;; RUN: echo "foo" >> %t.blank.manifest
;; RUN: not wasm-split --multi-split %s --manifest %t.blank.manifest --out-prefix=%t -o %t.wasm 2>&1 \
;; RUN:   | filecheck %s --check-prefix=EMPTY-NAME

;; Also check a module name consisting only of a colon.
;; RUN: echo ":" > %t.colon.manifest
;; RUN: echo "foo" >> %t.colon.manifest
;; RUN: not wasm-split --multi-split %s --manifest %t.colon.manifest --out-prefix=%t -o %t.wasm 2>&1 \
;; RUN:   | filecheck %s --check-prefix=EMPTY-NAME

;; Check that an empty module followed by two blank lines warns about the empty
;; module and then errors on the second blank line.
;; RUN: echo "1:" > %t.empty-mod.manifest
;; RUN: echo "" >> %t.empty-mod.manifest
;; RUN: echo "" >> %t.empty-mod.manifest
;; RUN: not wasm-split --multi-split %s --manifest %t.empty-mod.manifest --out-prefix=%t -o %t.wasm 2>&1 \
;; RUN:   | filecheck %s --check-prefix=EMPTY-MOD

;; Check that duplicate module names are rejected.
;; RUN: echo "1:" > %t.dup-mod.manifest
;; RUN: echo "foo" >> %t.dup-mod.manifest
;; RUN: echo "" >> %t.dup-mod.manifest
;; RUN: echo "1:" >> %t.dup-mod.manifest
;; RUN: echo "bar" >> %t.dup-mod.manifest
;; RUN: not wasm-split --multi-split %s --manifest %t.dup-mod.manifest --out-prefix=%t -o %t.wasm 2>&1 \
;; RUN:   | filecheck %s --check-prefix=DUP-MOD

;; Check that assigning the same function to two modules is rejected.
;; RUN: echo "1:" > %t.dup-func.manifest
;; RUN: echo "foo" >> %t.dup-func.manifest
;; RUN: echo "" >> %t.dup-func.manifest
;; RUN: echo "2:" >> %t.dup-func.manifest
;; RUN: echo "foo" >> %t.dup-func.manifest
;; RUN: not wasm-split --multi-split %s --manifest %t.dup-func.manifest --out-prefix=%t -o %t.wasm 2>&1 \
;; RUN:   | filecheck %s --check-prefix=DUP-FUNC

;; EMPTY-NAME: Fatal: Module name is empty

;; EMPTY-MOD: warning: Module 1 will be empty
;; EMPTY-MOD: Fatal: Module name is empty

;; DUP-MOD: Fatal: Module name 1 is listed more than once

;; DUP-FUNC: Fatal: Function foo cannot be assigned to module 2; it is already assigned to module 1

(module
  (func $foo)
  (func $bar)
)
