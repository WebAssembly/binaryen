;; RUN: wasm-opt %s -all --fuzz-exec-before --fuzz-exec-second=%s.second -q -o /dev/null 2>&1 | filecheck %s

;; Check that clearing the continuation store in linked modules clears it in-place,
;; so that continuations leaked from the primary module do not affect the second module.

(module
  (type $func_t (func))
  (type $cont_t (cont $func_t))
  (tag $tag)
  
  (func $f_suspend
    (suspend $tag)
  )
  
  (func $test1 (export "test1")
    (local $c (ref $cont_t))
    (local.set $c (cont.new $cont_t (ref.func $f_suspend)))
    (resume $cont_t (local.get $c))
  )
)

;; CHECK:      [fuzz-exec] export test1
;; CHECK-NEXT: [exception thrown: unhandled suspend]
;; CHECK:      [fuzz-exec] running second module
;; CHECK-NEXT: [fuzz-exec] export test2
;; CHECK-NEXT: [exception thrown: unhandled suspend]
