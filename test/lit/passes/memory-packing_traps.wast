;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.

;; RUN: foreach %s %t wasm-opt --memory-packing -all --zero-filled-memory      -S -o - | filecheck %s
;; RUN: foreach %s %t wasm-opt --memory-packing -all --zero-filled-memory -tnh -S -o - | filecheck %s --check-prefix=TNH__

(module
  ;; We should not optimize out a segment that will trap, as that is an effect
  ;; we need to preserve (unless TrapsNeverHappen).
  (memory 1 2 shared)
  (data (i32.const -1) "\00")
)

;; CHECK:      (memory $0 1 2 shared)

;; CHECK:      (data $0 (i32.const -1) "\00")

;; TNH__:      (memory $0 1 2 shared)
(module
  ;; We should handle the possible overflow in adding the offset and size, and
  ;; see this might trap.
  (memory 1 2 shared)
  (data (i32.const -2) "\00\00\00")
)

;; CHECK:      (memory $0 1 2 shared)

;; CHECK:      (data $0 (i32.const -2) "\00\00\00")

;; TNH__:      (memory $0 1 2 shared)
(module
  ;; This segment will almost trap, but not.
  (memory 1 2 shared)
  (data (i32.const 65535) "\00")
)

;; CHECK:      (memory $0 1 2 shared)

;; TNH__:      (memory $0 1 2 shared)
(module
  ;; This one is slightly larger, and will trap.
  (memory 1 2 shared)
  (data (i32.const 65535) "\00\00")
)

;; CHECK:      (memory $0 1 2 shared)

;; CHECK:      (data $0 (i32.const 65535) "\00\00")

;; TNH__:      (memory $0 1 2 shared)
(module
  ;; This one is slightly larger, but the offset is lower so it will not trap.
  (memory 1 2 shared)
  (data (i32.const 65534) "\00\00")
)

;; CHECK:      (memory $0 1 2 shared)

;; TNH__:      (memory $0 1 2 shared)
(module
  ;; This one's offset is just large enough to trap.
  (memory 1 2 shared)
  (data (i32.const 65536) "\00")
)

;; CHECK:      (memory $0 1 2 shared)

;; CHECK:      (data $0 (i32.const 65536) "\00")

;; TNH__:      (memory $0 1 2 shared)
(module
  ;; This offset is unknown, so assume the worst.
  ;; TODO: We could remove it in TNH mode

  ;; CHECK:      (import "a" "b" (global $g i32))
  ;; TNH__:      (import "a" "b" (global $g i32))
  (import "a" "b" (global $g i32))
  (memory 1 2 shared)
  (data (global.get $g) "\00")
)

;; CHECK:      (memory $0 1 2 shared)

;; CHECK:      (data $0 (global.get $g) "\00")

;; TNH__:      (memory $0 1 2 shared)

;; TNH__:      (data $0 (global.get $g) "\00")
(module
  ;; Passive segments cannot trap during startup and are removable if they have
  ;; no uses, like here.
  (memory 1 2 shared)
  (data $data "\00\00\00")
)
;; CHECK:      (memory $0 1 2 shared)

;; TNH__:      (memory $0 1 2 shared)
