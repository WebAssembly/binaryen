;; Same as jspi-hooks.wast, but the module already uses legacy exception
;; handling, so the pass emits the legacy try/catch wrapper form; the engine
;; would reject a module mixing the two. The trace must be identical.

;; REQUIRES: linux

;; RUN: wasm-opt %s --enable-exception-handling --enable-reference-types --jspi-hooks --pass-arg=jspi-imports@env.susp --pass-arg=jspi-exports@main --pass-arg=jspi-dyncalls -o %t.wasm -q
;; RUN: v8 --wasm-staging %S/jspi-hooks.js -- %t.wasm | filecheck %s

;; CHECK: async success: result=10
;; CHECK-NEXT:   ENTER#1 sid=1 | SUSPEND#1 sid=1 | RESUME#1 sid=1 | EXIT#1 sid=1
;; CHECK-NEXT:   sid after: 0
;; CHECK-NEXT: rejected import: threw Error (same object) "boom"
;; CHECK-NEXT:   ENTER#2 sid=2 | SUSPEND#2 sid=2 | RESUME#2 err sid=2 | EXIT#2 err sid=2
;; CHECK-NEXT:   sid after: 0
;; CHECK-NEXT: throwing inner (wasm tag): threw WebAssembly.Exception
;; CHECK-NEXT:   ENTER#3 sid=3 | EXIT#3 err sid=3
;; CHECK-NEXT:   sid after: 0
;; CHECK-NEXT: sync completion, no import: result=77
;; CHECK-NEXT:   ENTER#4 sid=4 | EXIT#4 sid=4
;; CHECK-NEXT:   sid after: 0
;; CHECK-NEXT: nested promising from plain import: result=99
;; CHECK-NEXT:   ENTER#5 sid=5 | nested-start sid=5 | ENTER#6 sid=6 | SUSPEND#6 sid=6 | nested-after sid=5 promise=true | EXIT#5 sid=5 | RESUME#6 sid=6 | EXIT#6 sid=6
;; CHECK-NEXT:   sid after: 0
;; CHECK-NEXT: import via call_indirect: result=10
;; CHECK-NEXT:   ENTER#7 sid=7 | SUSPEND#7 sid=7 | RESUME#7 sid=7 | EXIT#7 sid=7
;; CHECK-NEXT:   sid after: 0
;; CHECK-NEXT: plain export calling main internally: no events: result=77
;; CHECK-NEXT: {{^ *$}}
;; CHECK-NEXT:   sid after: 0
;; CHECK-NEXT: suspending import outside any fiber (id 0): threw SuspendError "trying to suspend without WebAssembly.promising"
;; CHECK-NEXT:   SUSPEND#0 sid=0 | RESUME#0 err sid=0
;; CHECK-NEXT:   sid after: 0
;; CHECK-NEXT: function pointer via dyncall trampoline: result=10
;; CHECK-NEXT:   ENTER#8 sid=8 | SUSPEND#8 sid=8 | RESUME#8 sid=8 | EXIT#8 sid=8
;; CHECK-NEXT:   sid after: 0
;; CHECK-NEXT: concurrent fibers: result=20
;; CHECK-NEXT:   ENTER#9 sid=9 | SUSPEND#9 sid=9 | ENTER#10 sid=10 | SUSPEND#10 sid=10 | RESUME#9 sid=9 | EXIT#9 sid=9 | RESUME#10 sid=10 | EXIT#10 sid=10
;; CHECK-NEXT:   sid after: 0

(module
  (import "env" "susp" (func $susp (param i32) (result i32)))
  (import "env" "log" (func $log (param i32 i32 i32)))
  (import "env" "nested" (func $nested (param i32) (result i32)))
  (tag $cpp (param i32))
  (global $cur (mut i32) (i32.const 0))
  (global $next (mut i32) (i32.const 0))
  (table $indirect funcref (elem $susp))

  ;; host_ids[id]: the id of whoever entered or last resumed fiber id, restored
  ;; when the fiber leaves at SUSPEND and EXIT (ids stay below 64 here). The
  ;; token the wrappers carry from ENTER to EXIT and SUSPEND to RESUME is the
  ;; fiber id.
  (memory 1)
  (func $host_id (param $id i32) (result i32)
    (i32.load (i32.mul (local.get $id) (i32.const 4))))
  (func (export "__jspi_enter") (result i64)
    ;; new id, remember who entered us
    (global.set $next (i32.add (global.get $next) (i32.const 1)))
    (i32.store (i32.mul (global.get $next) (i32.const 4)) (global.get $cur))
    (global.set $cur (global.get $next))
    (call $log (i32.const 0) (global.get $cur) (i32.const 0))
    (i64.extend_i32_u (global.get $cur)))
  (func (export "__jspi_exit") (param $tok64 i64) (param $error i32)
    ;; back to whoever entered or last resumed us
    (local $tok i32)
    (local.set $tok (i32.wrap_i64 (local.get $tok64)))
    (call $log (i32.const 1) (local.get $tok) (local.get $error))
    (global.set $cur (call $host_id (local.get $tok))))
  (func (export "__jspi_suspend") (result i64)
    ;; the current fiber leaves; its id is the token
    (local $id i32)
    (local.set $id (global.get $cur))
    (call $log (i32.const 2) (local.get $id) (i32.const 0))
    (if (local.get $id)
      (then (global.set $cur (call $host_id (local.get $id)))))
    (i64.extend_i32_u (local.get $id)))
  (func (export "__jspi_resume") (param $tok64 i64) (param $error i32)
    ;; remember who resumed us, become current
    (local $tok i32)
    (local.set $tok (i32.wrap_i64 (local.get $tok64)))
    (if (local.get $tok)
      (then (i32.store (i32.mul (local.get $tok) (i32.const 4)) (global.get $cur))))
    (global.set $cur (local.get $tok))
    (call $log (i32.const 3) (local.get $tok) (local.get $error)))

  (func (export "stack_id") (result i32) (global.get $cur))

  (func $legacy_user (param $x i32) (result i32)
    (try (result i32)
      (do (call $inner (local.get $x)))
      (catch $cpp (drop (pop i32)) (i32.const -1))))
  (func $inner (param $x i32) (result i32)
    (if (i32.eq (local.get $x) (i32.const 7)) (then (return (i32.const 77))))
    (if (i32.eq (local.get $x) (i32.const 3)) (then (throw $cpp (i32.const 42))))
    (if (i32.eq (local.get $x) (i32.const 5)) (then (return (call $nested (local.get $x)))))
    (if (i32.eq (local.get $x) (i32.const 6))
      (then (return (call_indirect $indirect (type $sig) (i32.const 1) (i32.const 0)))))
    (call $susp (local.get $x)))
  (type $sig (func (param i32) (result i32)))

  ;; promising export; also called internally by "plain" (must not get events there)
  (func $main (export "main") (param $x i32) (result i32) (call $inner (local.get $x)))
  (func (export "plain") (param $x i32) (result i32) (call $main (local.get $x)))
)
