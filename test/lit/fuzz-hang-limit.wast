;; Test the  hang-limit flag.

;; By default we emit hang limit checks, and there is no change when we set
;; the limit to 100.
;; RUN: wasm-opt %s.dat -all -ttf                       -S -o - | filecheck %s --check-prefix=NORMAL
;; RUN: wasm-opt %s.dat -all -ttf --fuzz-hang-limit=100 -S -o - | filecheck %s --check-prefix=NORMAL
;; NORMAL: hangLimit

;; But if we set the limit to 0, that disables hang limit checks.
;; RUN: wasm-opt %s.dat -all -ttf --fuzz-hang-limit=0   -S -o - | filecheck %s --check-prefix=FLAG
;; FLAG-NOT: hangLimit

