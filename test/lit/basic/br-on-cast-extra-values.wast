;; RUN: wasm-opt %s -all -S -o %t
;; RUN: wasm-opt %s -all --roundtrip -S -o %t.roundtrip

(module
  (type $s (struct))
  (func (param $s (ref $s)) (result (ref $s) (ref $s))
    local.get $s
    local.get $s
    br_on_cast 0 (ref $s) (ref $s)
  )
  (func (param $s (ref (exact $s)))
        (result (ref (exact $s)) (ref null (exact $s)))
    local.get $s
    local.get $s
    br_on_cast 0 (ref (exact $s)) (ref null (exact $s))
  )
)
