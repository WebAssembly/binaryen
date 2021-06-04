;; RUN: wasm-opt %s --remove-unused-module-elements -all -S -o - | filecheck %s

;; Non-exported and unused events can be removed
(module
  (type $0 (func (param i32)))

  ;; CHECK-NOT: (event $e-remove
  ;; CHECK: (event $e-export
  ;; CHECK: (event $e-throw
  ;; CHECK: (event $e-catch
  (event $e-remove (attr 0) (type $0))   ;; can be removed
  (event $e-export (attr 0) (param i64)) ;; cannot be removed (exported)
  (event $e-throw (attr 0) (type $0))    ;; cannot be removed (used in throw)
  (event $e-catch (attr 0) (type $0))    ;; cannot be removed (used in catch)

  (export "e-export" (event $e-export))
  (import "env" "e" (event $e-import (attr 0) (param i32)))

  (start $start)
  (func $start
    (try
      (do
        (throw $e-throw (i32.const 0))
      )
      (catch $e-catch
        (drop (pop i32))
      )
    )
  )
)
