;; RUN: wasm-split -all --multi-split %s --manifest %S/multi-split.wast.manifest --out-prefix=%t --emit-module-names -o %t.wasm
;; RUN: wasm-dis %t.wasm | filecheck %s --check-prefix=PRIMARY-WASM
;; RUN: wasm-dis %t1.wasm | filecheck %s --check-prefix=MOD1-WASM
;; RUN: wasm-dis %t2.wasm | filecheck %s --check-prefix=MOD2-WASM
;; RUN: wasm-dis %t3.wasm | filecheck %s --check-prefix=MOD3-WASM

;; Check if --emit-text with --emit-module-names works.
;; RUN: wasm-split -all --multi-split %s --manifest %S/multi-split.wast.manifest --out-prefix=%t --emit-module-names -S -o %t.wast
;; RUN: cat %t.wast | filecheck %s --check-prefix=PRIMARY-WAST
;; RUN: cat %t1.wast | filecheck %s --check-prefix=MOD1-WAST
;; RUN: cat %t2.wast | filecheck %s --check-prefix=MOD2-WAST
;; RUN: cat %t3.wast | filecheck %s --check-prefix=MOD3-WAST

;; PRIMARY-WASM: (module $module-names-multi-split.wast.tmp.wasm
;; MOD1-WASM: (module $module-names-multi-split.wast.tmp1.wasm
;; MOD2-WASM: (module $module-names-multi-split.wast.tmp2.wasm
;; MOD3-WASM: (module $module-names-multi-split.wast.tmp3.wasm

;; PRIMARY-WAST: (module $module-names-multi-split.wast.tmp.wast
;; MOD1-WAST: (module $module-names-multi-split.wast.tmp1.wast
;; MOD2-WAST: (module $module-names-multi-split.wast.tmp2.wast
;; MOD3-WAST: (module $module-names-multi-split.wast.tmp3.wast

(module
 (type $ret-i32 (func (result i32)))
 (type $ret-i64 (func (result i64)))
 (type $ret-f32 (func (result f32)))

 (func $A (type $ret-i32) (result i32)
  (drop
   (call_ref $ret-i32
    (ref.func $A)
   )
  )
  (drop
   (call_ref $ret-i64
    (ref.func $B)
   )
  )
  (drop
   (call_ref $ret-f32
    (ref.func $C)
   )
  )
  (i32.const 0)
 )

 (func $B (type $ret-i64) (result i64)
  (drop
   (call_ref $ret-i32
    (ref.func $A)
   )
  )
  (drop
   (call_ref $ret-i64
    (ref.func $B)
   )
  )
  (drop
   (call_ref $ret-f32
    (ref.func $C)
   )
  )
  (i64.const 0)
 )

 (func $C (type $ret-f32) (result f32)
  (drop
   (call_ref $ret-i32
    (ref.func $A)
   )
  )
  (drop
   (call_ref $ret-i64
    (ref.func $B)
   )
  )
  (drop
   (call_ref $ret-f32
    (ref.func $C)
   )
  )
  (f32.const 0)
 )
)
