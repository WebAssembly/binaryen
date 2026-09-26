;; Asyncify spills reference-typed locals (externref/funcref) into growable
;; per-heap-type tables.

;; RUN: foreach %s %t wasm-opt --enable-reference-types --asyncify -S -o - | filecheck %s

(module
  (import "env" "unwind" (func $unwind))
  (memory 1)
  (func (export "run") (param $r externref) (result i32)
    (local $x i32)
    (call $unwind)
    (drop (ref.is_null (local.get $r)))
    (local.get $x)
  )
)

;; CHECK:      (global $__asyncify_ref_pos_extern (mut i32) (i32.const 0))
;; CHECK:      (table $__asyncify_ref_table_extern 1 67108864 externref)

;; On rewind, the externref local is restored from the table at the cursor.
;; CHECK:      (global.set $__asyncify_ref_pos_extern
;; CHECK:      (local.set $r
;; CHECK:        (table.get $__asyncify_ref_table_extern
;; CHECK:          (i32.add
;; CHECK:            (global.get $__asyncify_ref_pos_extern)

;; On unwind, the table is grown if the cursor has reached the current size, and
;; the local is spilled to the table. Growth is what makes recursion safe.
;; CHECK:        (table.size $__asyncify_ref_table_extern)
;; CHECK:        (table.grow $__asyncify_ref_table_extern
;; CHECK:      (table.set $__asyncify_ref_table_extern
;; CHECK:        (global.get $__asyncify_ref_pos_extern)

;; The cursor is reset at the start of each unwind.
;; A nonzero cursor at the start of an unwind means two pauses overlap, which
;; asyncify does not support, so it traps before resetting the cursor.
;; CHECK:      (func $asyncify_start_unwind
;; CHECK:        (i32.ne
;; CHECK:          (global.get $__asyncify_ref_pos_extern)
;; CHECK:          (i32.const 0)
;; CHECK:        (unreachable)
;; CHECK:        (global.set $__asyncify_ref_pos_extern
;; CHECK:          (i32.const 0)
