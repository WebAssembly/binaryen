;; RUN: foreach %s %t wasm-opt --asyncify --pass-arg=asyncify-verbose -q | filecheck %s

;; The import is reported as changing the state, as all imports can. The
;; function that calls it, consequently, is also reported as such, and so on
;; further up the chain.
;;
;; CHECK: [asyncify] a-import is an import that can change the state
;; CHECK: [asyncify] calls-a-import can change the state due to a-import
;; CHECK: [asyncify] calls-calls-a-import can change the state due to calls-a-import
;; CHECK: [asyncify] calls-calls-a-import-b can change the state due to calls-a-import
;; CHECK: [asyncify] calls-calls-calls-a-import can change the state due to calls-calls-a-import
;; CHECK: [asyncify] calls-calls-calls-a-import can change the state due to calls-calls-a-import-b

(module
  (import "env" "import" (func $a-import))

  (memory 1 2)

  (func $calls-a-import
    (call $a-import)
  )

  (func $calls-calls-a-import
    (call $calls-a-import)
  )

  (func $calls-calls-a-import-b
    (call $calls-a-import)
  )

  (func $calls-calls-calls-a-import
    (call $calls-calls-a-import)
    (call $calls-calls-a-import-b)
  )

  (func $nothing
    (nop)
  )
)

