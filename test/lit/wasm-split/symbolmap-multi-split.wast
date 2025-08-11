;; RUN: wasm-split -all --multi-split %s --manifest %S/multi-split.wast.manifest --out-prefix=%t --symbolmap -o %t.wasm
;; RUN: filecheck %s --check-prefix PRIMARY-MAP < %t.wasm.symbols
;; RUN: filecheck %s --check-prefix MOD1-MAP < %t1.wasm.symbols
;; RUN: filecheck %s --check-prefix MOD2-MAP < %t2.wasm.symbols
;; RUN: filecheck %s --check-prefix MOD3-MAP < %t3.wasm.symbols

;; PRIMARY-MAP: 0:placeholder_0
;; PRIMARY-MAP: 1:placeholder_0_4
;; PRIMARY-MAP: 2:placeholder_0_5
;; PRIMARY-MAP: 3:trampoline_A
;; PRIMARY-MAP: 4:trampoline_B
;; PRIMARY-MAP: 5:trampoline_C

;; MOD1-MAP: 0:B
;; MOD1-MAP: 1:C
;; MOD1-MAP: 2:A

;; MOD2-MAP: 0:C
;; MOD2-MAP: 1:trampoline_A
;; MOD2-MAP: 2:B

;; MOD3-MAP: 0:trampoline_A
;; MOD3-MAP: 1:trampoline_B
;; MOD3-MAP: 2:C

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
