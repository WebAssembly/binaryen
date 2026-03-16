;; Test logging of global exports. We don't do this using update_lit_checks as
;; global exports confuse the auto-updater.

(module
 (type $struct (struct))

 (global $global (mut i32) (i32.const 42))

 (global $global-immref anyref (struct.new $struct))

 (export "global" (global $global))
 (export "global-immref" (global $global-immref))
)

;; RUN: wasm-opt %s -all --fuzz-exec -o /dev/null 2>&1 | filecheck %s

;; CHECK:      [fuzz-exec] calling global
;; CHECK-NEXT: [LoggingExternalInterface logging 42]
;; CHECK-NEXT: [fuzz-exec] calling global-immref
;; CHECK-NEXT: [LoggingExternalInterface logging object]

