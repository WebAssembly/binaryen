(module
  (memory 256 256)
  (func $a (call $a))
  (func $b (call $b) (call $b))
  (func $c (call $c) (call $c) (call $c))
)
