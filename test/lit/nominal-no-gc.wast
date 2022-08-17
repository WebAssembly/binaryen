;; Using --nominal without GC is not allowed.

;; RUN: not wasm-opt %s --nominal --disable-gc -g -o %t.wasm 2>&1 | filecheck %s

;; CHECK: Nominal typing is only allowed when GC is enabled
