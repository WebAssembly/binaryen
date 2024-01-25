;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.
;; NOTE: This test was ported using port_passes_tests_to_lit.py and could be cleaned up.

;; RUN: foreach %s %t wasm-opt --remove-unused-module-elements -all      -S -o - | filecheck %s
;; RUN: foreach %s %t wasm-opt --remove-unused-module-elements -tnh -all -S -o - | filecheck %s --check-prefix=T_N_H

;; The segments here will trap during startup as they are out of bounds. We
;; can only remove such segments if we assume TrapsNeverHappen.
;;
;; The passive segments, however, can be removed: they do nothing during
;; startup, and have no uses.
(module
 ;; CHECK:      (memory $0 16 17 shared)
 (memory $0 16 17 shared)

 ;; CHECK:      (data $0 (i32.const -1) "")
 (data $0 (i32.const -1) "")

 (data $1 "")

 ;; CHECK:      (table $0 1 1 funcref)
 (table $0 1 1 funcref)

 ;; CHECK:      (elem $0 (i32.const -1))
 (elem $0 (i32.const -1))

 (elem $1 func)
)

;; Some segments can be removed: any segment that writes to address 131072 or
;; higher will trap, and must be kept (unless TNH). Only the $bad segment
;; should remain for that reason, however, it keeps the memory alive which
;; keeps the $ok* segments alive too.
(module
 ;; CHECK:      (memory $0 2 2)
 (memory $0 2 2)

 ;; CHECK:      (data $ok1 (i32.const 0) "a")
 (data $ok1 (i32.const 0) "a")
 ;; CHECK:      (data $ok2 (i32.const 1000) "a")
 (data $ok2 (i32.const 1000) "a")
 ;; CHECK:      (data $ok3 (i32.const 131071) "a")
 (data $ok3 (i32.const 131071) "a")
 ;; CHECK:      (data $bad (i32.const 131071) "ab")
 (data $bad (i32.const 131071) "ab")
)

;; The following modules have variations on the bad segment.
(module
 ;; CHECK:      (memory $0 2 2)
 (memory $0 2 2)

 ;; CHECK:      (data $ok1 (i32.const 0) "a")
 (data $ok1 (i32.const 0) "a")
 ;; CHECK:      (data $ok2 (i32.const 1000) "a")
 (data $ok2 (i32.const 1000) "a")
 ;; CHECK:      (data $ok3 (i32.const 131071) "a")
 (data $ok3 (i32.const 131071) "a")
 ;; CHECK:      (data $bad (i32.const 131072) "a")
 (data $bad (i32.const 131072) "a")
)

(module
 ;; CHECK:      (memory $0 2 2)
 (memory $0 2 2)

 ;; CHECK:      (data $ok1 (i32.const 0) "a")
 (data $ok1 (i32.const 0) "a")
 ;; CHECK:      (data $ok2 (i32.const 1000) "a")
 (data $ok2 (i32.const 1000) "a")
 ;; CHECK:      (data $ok3 (i32.const 131071) "a")
 (data $ok3 (i32.const 131071) "a")
 ;; CHECK:      (data $bad (i32.const 9999999) "a")
 (data $bad (i32.const 9999999) "a")
)

(module
 ;; CHECK:      (memory $0 2 2)
 (memory $0 2 2)

 ;; CHECK:      (data $ok1 (i32.const 0) "a")
 (data $ok1 (i32.const 0) "a")
 ;; CHECK:      (data $ok2 (i32.const 1000) "a")
 (data $ok2 (i32.const 1000) "a")
 ;; CHECK:      (data $ok3 (i32.const 131071) "a")
 (data $ok3 (i32.const 131071) "a")
 ;; CHECK:      (data $bad (i32.const -2) "a")
 (data $bad (i32.const 4294967294) "a")
)

(module
 ;; CHECK:      (memory $0 2 2)
 (memory $0 2 2)

 ;; CHECK:      (data $ok1 (i32.const 0) "a")
 (data $ok1 (i32.const 0) "a")
 ;; CHECK:      (data $ok2 (i32.const 1000) "a")
 (data $ok2 (i32.const 1000) "a")
 ;; CHECK:      (data $ok3 (i32.const 131071) "a")
 (data $ok3 (i32.const 131071) "a")
 ;; CHECK:      (data $bad (i32.const -2) "abcdefg")
 (data $bad (i32.const 4294967294) "abcdefg")
)

(module
 ;; CHECK:      (memory $0 2 2)
 (memory $0 2 2)

 ;; CHECK:      (data $ok1 (i32.const 0) "a")
 (data $ok1 (i32.const 0) "a")
 ;; CHECK:      (data $ok2 (i32.const 1000) "a")
 (data $ok2 (i32.const 1000) "a")
 ;; CHECK:      (data $ok3 (i32.const 131071) "a")
 (data $ok3 (i32.const 131071) "a")
 ;; CHECK:      (data $bad (i32.const -2) "a")
 (data $bad (i32.const -2) "a")
)

;; An imported global is an unknown offset, so it might trap.
(module
 ;; CHECK:      (import "a" "b" (global $imported i32))
 (import "a" "b" (global $imported i32))

 ;; CHECK:      (memory $0 2 2)
 (memory $0 2 2)

 ;; CHECK:      (data $ok1 (i32.const 0) "a")
 (data $ok1 (i32.const 0) "a")
 ;; CHECK:      (data $ok2 (i32.const 1000) "a")
 (data $ok2 (i32.const 1000) "a")
 ;; CHECK:      (data $ok3 (global.get $imported) "a")
 (data $ok3 (global.get $imported) "a")
 ;; CHECK:      (data $bad (i32.const -2) "a")
 (data $bad (i32.const -2) "a")
)

;; Finally, a module with no bad segments. We can remove all the contents.
(module
 (memory $0 2 2)

 (data $ok1 (i32.const 0) "a")
 (data $ok2 (i32.const 1000) "a")
 (data $ok3 (i32.const 131071) "a")
)

;; Similar testing for element segments. One bad segment keeps it all alive
;; here.
(module
 (table 10 10 funcref)

 ;; CHECK:      (type $0 (func))

 ;; CHECK:      (table $0 10 10 funcref)

 ;; CHECK:      (elem $ok1 (i32.const 0) $func)
 (elem $ok1 (i32.const 0) $func)
 ;; CHECK:      (elem $ok2 (i32.const 8) $func $func)
 (elem $ok2 (i32.const 8) $func $func)
 ;; CHECK:      (elem $ok3 (i32.const 9) $func)
 (elem $ok3 (i32.const 9) $func)
 ;; CHECK:      (elem $bad (i32.const 10) $func)
 (elem $bad (i32.const 10) $func)

 ;; CHECK:      (func $func (type $0)
 ;; CHECK-NEXT:  (nop)
 ;; CHECK-NEXT: )
 ;; T_N_H:      (type $0 (func))

 ;; T_N_H:      (func $func (type $0)
 ;; T_N_H-NEXT:  (nop)
 ;; T_N_H-NEXT: )
 (func $func)
)

;; A different bad segment.
(module
 (table 10 10 funcref)

 ;; CHECK:      (type $0 (func))

 ;; CHECK:      (table $0 10 10 funcref)

 ;; CHECK:      (elem $ok1 (i32.const 0) $func)
 (elem $ok1 (i32.const 0) $func)
 ;; CHECK:      (elem $ok2 (i32.const 8) $func $func)
 (elem $ok2 (i32.const 8) $func $func)
 ;; CHECK:      (elem $ok3 (i32.const 9) $func)
 (elem $ok3 (i32.const 9) $func)
 ;; CHECK:      (elem $bad (i32.const 9) $func $func)
 (elem $bad (i32.const 9) $func $func)

 ;; CHECK:      (func $func (type $0)
 ;; CHECK-NEXT:  (nop)
 ;; CHECK-NEXT: )
 ;; T_N_H:      (type $0 (func))

 ;; T_N_H:      (func $func (type $0)
 ;; T_N_H-NEXT:  (nop)
 ;; T_N_H-NEXT: )
 (func $func)
)

;; No bad segments: all element segments vanish. TODO: the function could too
(module
 (table 10 10 funcref)

 (elem $ok1 (i32.const 0) $func)
 (elem $ok2 (i32.const 8) $func $func)
 (elem $ok3 (i32.const 9) $func)

 ;; CHECK:      (type $0 (func))

 ;; CHECK:      (func $func (type $0)
 ;; CHECK-NEXT:  (nop)
 ;; CHECK-NEXT: )
 ;; T_N_H:      (type $0 (func))

 ;; T_N_H:      (func $func (type $0)
 ;; T_N_H-NEXT:  (nop)
 ;; T_N_H-NEXT: )
 (func $func)
)

