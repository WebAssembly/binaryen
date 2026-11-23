;; RUN: foreach %s %t wasm-opt --fpcast-emu --pass-arg=fpcast-emu-export-thunks -S -o - | filecheck %s

(module
  (import "env" "imp" (func $imp (param i32) (result i32)))
  (table 2 funcref)
  (elem (i32.const 0) $in_table)
  (global $g i32 (i32.const 42))
  ;; CHECK:      (table $0 2 funcref)
  ;; CHECK:      (elem $0 (i32.const 0) $byn$fpcast-emu$in_table)
  ;; CHECK:      (export "add" (func $add))
  ;; CHECK:      (export "add_alias" (func $add))
  ;; CHECK:      (export "in_table" (func $in_table))
  ;; CHECK:      (export "dynCall_ii" (func $dynCall_ii))
  ;; CHECK:      (export "reexport_import" (func $imp))
  ;; CHECK:      (export "g" (global $g))
  ;; CHECK:      (export "legalized" (func $legalstub))
  ;; CHECK:      (export "orig$legalized" (func $unlegalized))
  ;; CHECK:      (export "fpcast$add" (func $byn$fpcast-emu$add))
  ;; CHECK:      (export "fpcast$add_alias" (func $byn$fpcast-emu$add))
  ;; CHECK:      (export "fpcast$in_table" (func $byn$fpcast-emu$in_table))
  ;; CHECK:      (export "fpcast$legalized" (func $byn$fpcast-emu$unlegalized))
  ;; CHECK-NOT:  fpcast$dynCall_ii
  ;; CHECK-NOT:  fpcast$reexport_import
  ;; CHECK-NOT:  fpcast$g
  ;; CHECK-NOT:  fpcast$orig$legalized
  (export "add" (func $add))
  (export "add_alias" (func $add))
  (export "in_table" (func $in_table))
  (export "dynCall_ii" (func $dynCall_ii))
  (export "reexport_import" (func $imp))
  (export "g" (global $g))
  (export "legalized" (func $legalstub))
  (export "orig$legalized" (func $unlegalized))
  (func $add (param i32 i32) (result i32)
    (i32.add
      (local.get 0)
      (local.get 1)
    )
  )
  (func $in_table (param f32) (result f64)
    (f64.promote_f32
      (local.get 0)
    )
  )
  (func $dynCall_ii (param i32) (result i32)
    (local.get 0)
  )
  (func $legalstub (param i32 i32) (result i32)
    (i32.wrap_i64
      (call $unlegalized
        (i64.extend_i32_u
          (local.get 0)
        )
      )
    )
  )
  (func $unlegalized (param i64) (result i64)
    (local.get 0)
  )
)
