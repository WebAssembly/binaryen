;; RUN: wasm-opt %s --remove-unused-module-elements -all -S -o - | filecheck %s

;; Non-exported and unused tags can be removed
(module
  (type $0 (func (param i32)))

  ;; CHECK-NOT: (tag $e-remove
  ;; CHECK: (tag $e-export
  ;; CHECK: (tag $e-throw
  ;; CHECK: (tag $e-catch
  (tag $e-remove (attr 0) (type $0))   ;; can be removed
  (tag $e-export (attr 0) (param i64)) ;; cannot be removed (exported)
  (tag $e-throw (attr 0) (type $0))    ;; cannot be removed (used in throw)
  (tag $e-catch (attr 0) (type $0))    ;; cannot be removed (used in catch)

  (export "e-export" (tag $e-export))
  (import "env" "e" (tag $e-import (attr 0) (param i32)))

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
