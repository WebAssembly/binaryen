;; Test the flag to avoid emitting invoker functions in fuzzer generation.

;; Normally we emit invokers.
;; RUN: wasm-opt %s.dat -all -ttf                   -S -o - | filecheck %s --check-prefix=NORMAL
;; NORMAL: invoker

;; But not with the flag.
;; RUN: wasm-opt %s.dat -all -ttf --fuzz-no-invokes -S -o - | filecheck %s --check-prefix=FLAG
;; FLAG-NOT: invoker

