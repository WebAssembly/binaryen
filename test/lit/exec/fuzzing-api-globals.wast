;; Test logging of global exports. We don't do this using update_lit_checks as
;; global exports confuse the auto-updater.

(module
 (type $struct (struct))

 (global $global (mut i32) (i32.const 42))
 (global $global-immref anyref (struct.new $struct))
 (global $global-v128 v128 (v128.const i64x2 12 34))

 (export "global" (global $global))
 (export "global-immref" (global $global-immref))
 (export "global-v128" (global $global-v128))
)

;; RUN: wasm-opt %s -all --fuzz-exec -o /dev/null 2>&1 | filecheck %s

;; CHECK:      [fuzz-exec] export global
;; CHECK-NEXT: [LoggingExternalInterface logging 42]
;; CHECK-NEXT: [fuzz-exec] export global-immref
;; CHECK-NEXT: [LoggingExternalInterface logging object(null)]
;; CHECK-NEXT: [fuzz-exec] export global-v128
;; CHECK-NEXT: [LoggingExternalInterface logging i32x4 0x0000000c 0x00000000 0x00000022 0x00000000]

