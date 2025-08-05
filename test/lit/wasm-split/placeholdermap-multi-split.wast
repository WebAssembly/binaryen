;; RUN: wasm-split -all --multi-split %s --manifest %S/multi-split.wast.manifest --out-prefix=%t --placeholdermap -o %t.wasm
;; RUN: filecheck %s --check-prefix MOD1-MAP < %t1.wasm.placeholders
;; RUN: filecheck %s --check-prefix MOD2-MAP < %t2.wasm.placeholders
;; RUN: filecheck %s --check-prefix MOD3-MAP < %t3.wasm.placeholders

;; MOD1-MAP: 0:A

;; MOD2-MAP: 0:B

;; MOD3-MAP: 0:C

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
