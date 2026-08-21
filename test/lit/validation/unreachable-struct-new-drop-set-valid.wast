;; RUN: wasm-as %s -all -o /dev/null
;; RUN: wasm-opt %s -all -o /dev/null

;; After dropping unreachable struct.new, subsequent unreachable GC ops in the
;; same function must remain parseable (gufa-vs-cfp module 11).

(module
  (type $struct (struct (mut i32)))
  (func $test
    (drop
      (struct.new $struct
        (i32.const 10)
        (unreachable)
      )
    )
    (struct.set $struct 0
      (struct.get $struct 0
        (unreachable)
      )
      (i32.const 20)
    )
  )
)
