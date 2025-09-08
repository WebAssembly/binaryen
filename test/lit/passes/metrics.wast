;; Test that we can pass an optional title to metrics instances.
;;
;; RUN: wasm-opt %s --metrics --metrics=second --remove-unused-module-elements --metrics=third --metrics -q | filecheck %s
;;
;; The number of functions decreases to 0 after --remove-unused-module-elements,
;; showing that we display the proper metrics at each point in time.
;;
;; CHECK:      Metrics
;; CHECK-NEXT: total
;; CHECK-NEXT:  [exports]      : 0
;; CHECK-NEXT:  [funcs]        : 1
;;
;; CHECK:      Metrics: second
;; CHECK-NEXT: total
;; CHECK-NEXT:  [exports]      : 0
;; CHECK-NEXT:  [funcs]        : 1
;;
;; CHECK:      Metrics: third
;; CHECK-NEXT: total
;; CHECK-NEXT:  [exports]      : 0
;; CHECK-NEXT:  [funcs]        : 0             -1
;;
;; CHECK:      Metrics
;; CHECK-NEXT: total
;; CHECK-NEXT:  [exports]      : 0
;; CHECK-NEXT:  [funcs]        : 0

(module
  (func $foo)
)
