
;; RUN: wasm-opt %s -all --fuzz-exec-before --fuzz-exec-second=%s.second -q -o /dev/null 2>&1 | filecheck %s

;; Export a function reference from the first module to the second. The second
;; can create a continuation with out without erroring.

(module
 (type $func (func))

 (global $global (ref $func) (ref.func $func))

 (export "global$func" (global $global))

 (func $func
 )
)

;; CHECK:      [fuzz-exec] running second module
;; CHECK-NEXT: [fuzz-exec] calling export
;; CHECK-NEXT: [fuzz-exec] note result: export => 42

