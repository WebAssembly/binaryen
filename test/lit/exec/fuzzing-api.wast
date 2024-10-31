;; NOTE: Assertions have been generated by update_lit_checks.py --output=fuzz-exec and should not be edited.

;; RUN: wasm-opt %s -all --fuzz-exec -o /dev/null 2>&1 | filecheck %s

;; Test the fuzzing-support module imports.

(module
 (import "fuzzing-support" "log-i32" (func $log-i32 (param i32)))
 (import "fuzzing-support" "log-f64" (func $log-f64 (param f64)))

 (import "fuzzing-support" "throw" (func $throw))

 (import "fuzzing-support" "table-set" (func $table.set (param i32 funcref)))
 (import "fuzzing-support" "table-get" (func $table.get (param i32) (result funcref)))

 (import "fuzzing-support" "call-export" (func $call.export (param i32)))
 (import "fuzzing-support" "call-export-catch" (func $call.export.catch (param i32)))

 (table $table 10 20 funcref)

 (export "table" (table $table))

 ;; CHECK:      [fuzz-exec] calling logging
 ;; CHECK-NEXT: [LoggingExternalInterface logging 42]
 ;; CHECK-NEXT: [LoggingExternalInterface logging 3.14159]
 (func $logging (export "logging")
  (call $log-i32
   (i32.const 42)
  )
  (call $log-f64
   (f64.const 3.14159)
  )
 )

 ;; CHECK:      [fuzz-exec] calling throwing
 ;; CHECK-NEXT: [exception thrown: __private ()]
 (func $throwing (export "throwing")
  (call $throw)
 )

 ;; CHECK:      [fuzz-exec] calling table.setting
 ;; CHECK-NEXT: [exception thrown: __private ()]
 (func $table.setting (export "table.setting")
  (call $table.set
   (i32.const 5)
   (ref.func $table.setting)
  )
  ;; Out of bounds sets will throw.
  (call $table.set
   (i32.const 9999)
   (ref.func $table.setting)
  )
 )

 ;; CHECK:      [fuzz-exec] calling table.getting
 ;; CHECK-NEXT: [LoggingExternalInterface logging 0]
 ;; CHECK-NEXT: [LoggingExternalInterface logging 1]
 ;; CHECK-NEXT: [exception thrown: __private ()]
 ;; CHECK-NEXT: warning: no passes specified, not doing any work
 (func $table.getting (export "table.getting")
  ;; There is a non-null value at 5, and a null at 6.
  (call $log-i32
   (ref.is_null
    (call $table.get
     (i32.const 5)
    )
   )
  )
  (call $log-i32
   (ref.is_null
    (call $table.get
     (i32.const 6)
    )
   )
  )
  ;; Out of bounds gets will throw.
  (drop
   (call $table.get
    (i32.const 9999)
   )
  )
 )

 (func $export.calling (export "export.calling")
  ;; At index 1 in the exports we have $logging, so we will do those loggings.
  (call.export
   (i32.const 1)
  )
  ;; At index 0 we have a table, so we will error.
  (call.export
   (i32.const 0)
  )
 )

 (func $export.calling.catching (export "export.calling.catching")
  ;; At index 1 in the exports we have $logging, so we will do those loggings,
  ;; then log a 0 as no exception happens.
  (call $log-i32
   (call.export.catch
    (i32.const 1)
   )
  )
  ;; At index 0 we have a table, so we will error, catch it, and log 1.
  (call $log-i32
   (call.export.catch
    (i32.const 0)
   )
  )
  ;; At index 999 we have nothing, so we'll error, catch it, and log 1.
  (call $log-i32
   (call.export.catch
    (i32.const 999)
   )
  )
 )
)
;; CHECK:      [fuzz-exec] calling logging
;; CHECK-NEXT: [LoggingExternalInterface logging 42]
;; CHECK-NEXT: [LoggingExternalInterface logging 3.14159]

;; CHECK:      [fuzz-exec] calling throwing
;; CHECK-NEXT: [exception thrown: __private ()]

;; CHECK:      [fuzz-exec] calling table.setting
;; CHECK-NEXT: [exception thrown: __private ()]

;; CHECK:      [fuzz-exec] calling table.getting
;; CHECK-NEXT: [LoggingExternalInterface logging 0]
;; CHECK-NEXT: [LoggingExternalInterface logging 1]
;; CHECK-NEXT: [exception thrown: __private ()]
;; CHECK-NEXT: [fuzz-exec] comparing logging
;; CHECK-NEXT: [fuzz-exec] comparing table.getting
;; CHECK-NEXT: [fuzz-exec] comparing table.setting
;; CHECK-NEXT: [fuzz-exec] comparing throwing
