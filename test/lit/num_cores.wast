;; REQUIRES: linux
;; Test that getNumCores honors thread affinity on linux

(module
  (func $a)
)

;; RUN: taskset -c 0 wasm-opt -O1 --debug=threads %s 2>&1 | filecheck %s
;; RUN: taskset -c 0,2 wasm-opt -O1 --debug=threads %s 2>&1 | filecheck %s --check-prefix=TWO

;; CHECK: getNumCores: 1

;; TWO: getNumCores: 2
