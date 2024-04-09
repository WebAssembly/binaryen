;; RUN: foreach %s %t wasm-opt --asyncify --pass-arg=asyncify-verbose -q | filecheck %s

;; The import is reported as changing the state, as all imports can.
;;
;; CHECK: [asyncify] import is an import that can change the state

;; The function that calls the import can change the state too.
;;
;; CHECK: [asyncify] calls-import can change the state due to import

;; Likewise, further up the call chain as well.
;;
;; CHECK: [asyncify] calls-calls-import can change the state due to calls-import
;; CHECK: [asyncify] calls-calls-import-b can change the state due to calls-import
;; CHECK: [asyncify] calls-calls-calls-import can change the state due to calls-calls-import
;; CHECK: [asyncify] calls-calls-calls-import can change the state due to calls-calls-import-b

(module
  (import "env" "import" (func $import))

  (memory 1 2)

  (func $calls-import
    (call $import)
  )

  (func $calls-calls-import
    (call $calls-import)
  )

  (func $calls-calls-import-b
    (call $calls-import)
  )

  (func $calls-calls-calls-import
    (call $calls-calls-import)
    (call $calls-calls-import-b)
  )

  (func $nothing
    (nop)
  )
)

