;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.
;; NOTE: This test was ported using port_passes_tests_to_lit.py and could be cleaned up.

;; Test that this instrumentation pass discards global effects, which it must do
;; as it adds calls to imports. We can optimize below when we do not instrument,
;; and cannot when we do.
;;
;; In NO_INSTRMT below we run another pass, just to prove that not every pass
;; causes global effects to be discarded.

;; RUN: foreach %s %t wasm-opt --generate-global-effects --instrument-locals --vacuum -S -o - | filecheck %s --check-prefix INSTRUMENT
;; RUN: foreach %s %t wasm-opt --generate-global-effects --coalesce-locals   --vacuum -S -o - | filecheck %s --check-prefix NO_INSTRMT

(module
  ;; INSTRUMENT:      (type $0 (func))

  ;; INSTRUMENT:      (type $1 (func (param i32 i32 i32) (result i32)))

  ;; INSTRUMENT:      (type $2 (func (param i32 i32 i64) (result i64)))

  ;; INSTRUMENT:      (type $3 (func (param i32 i32 f32) (result f32)))

  ;; INSTRUMENT:      (type $4 (func (param i32 i32 f64) (result f64)))

  ;; INSTRUMENT:      (import "env" "get_i32" (func $get_i32 (param i32 i32 i32) (result i32)))

  ;; INSTRUMENT:      (import "env" "get_i64" (func $get_i64 (param i32 i32 i64) (result i64)))

  ;; INSTRUMENT:      (import "env" "get_f32" (func $get_f32 (param i32 i32 f32) (result f32)))

  ;; INSTRUMENT:      (import "env" "get_f64" (func $get_f64 (param i32 i32 f64) (result f64)))

  ;; INSTRUMENT:      (import "env" "set_i32" (func $set_i32 (param i32 i32 i32) (result i32)))

  ;; INSTRUMENT:      (import "env" "set_i64" (func $set_i64 (param i32 i32 i64) (result i64)))

  ;; INSTRUMENT:      (import "env" "set_f32" (func $set_f32 (param i32 i32 f32) (result f32)))

  ;; INSTRUMENT:      (import "env" "set_f64" (func $set_f64 (param i32 i32 f64) (result f64)))

  ;; INSTRUMENT:      (func $past-get
  ;; INSTRUMENT-NEXT:  (call $use-local)
  ;; INSTRUMENT-NEXT:  (call $nop)
  ;; INSTRUMENT-NEXT: )
  ;; NO_INSTRMT:      (type $0 (func))

  ;; NO_INSTRMT:      (func $past-get
  ;; NO_INSTRMT-NEXT:  (nop)
  ;; NO_INSTRMT-NEXT: )
  (func $past-get
    ;; The called function only sets a local, so we can vacuum it away using
    ;; global effects. But, if we instrumented it, then it gets an import call,
    ;; which we should not remove.
    (call $use-local)
    ;; If we instrument, then we discard all global effects, even of a non-
    ;; instrumented function (we don't track individual functions), so we'll
    ;; lose the ability to vacuum this function away as well in that case.
    (call $nop)
  )

  ;; INSTRUMENT:      (func $use-local
  ;; INSTRUMENT-NEXT:  (local $x i32)
  ;; INSTRUMENT-NEXT:  (local.set $x
  ;; INSTRUMENT-NEXT:   (call $set_i32
  ;; INSTRUMENT-NEXT:    (i32.const 0)
  ;; INSTRUMENT-NEXT:    (i32.const 0)
  ;; INSTRUMENT-NEXT:    (i32.const 10)
  ;; INSTRUMENT-NEXT:   )
  ;; INSTRUMENT-NEXT:  )
  ;; INSTRUMENT-NEXT: )
  ;; NO_INSTRMT:      (func $use-local
  ;; NO_INSTRMT-NEXT:  (local $0 i32)
  ;; NO_INSTRMT-NEXT:  (nop)
  ;; NO_INSTRMT-NEXT: )
  (func $use-local
    (local $x i32)
    ;; This function uses a local, and will get instrumented with a call to log
    ;; the value out.
    (local.set $x
      (i32.const 10)
    )
  )

  ;; INSTRUMENT:      (func $nop
  ;; INSTRUMENT-NEXT:  (nop)
  ;; INSTRUMENT-NEXT: )
  ;; NO_INSTRMT:      (func $nop
  ;; NO_INSTRMT-NEXT:  (nop)
  ;; NO_INSTRMT-NEXT: )
  (func $nop
    ;; This function does nothing.
  )
)
