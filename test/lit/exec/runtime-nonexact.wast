;; Disable validation and see that we error at runtime when an exact
;; reference contains a subtype. (We disable validation so that the error is
;; caught only at runtime; this would allow us to catch bugs that validation
;; misses.)

;; RUN: not wasm-opt %s -all --no-validation --fuzz-exec 2>&1 | filecheck %s

;; CHECK: Fatal: expected (ref (exact $A)), seeing (ref (exact $B)) from

(module
  (rec
    (type $A (sub (struct)))
    (type $B (sub $A (struct)))
  )

  (func $test (export "test")
    (drop
      (block (result (ref (exact $A)))
        (struct.new $B)
      )
    )
  )
)

