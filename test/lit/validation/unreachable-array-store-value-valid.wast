;; RUN: wasm-as %s -all -o /dev/null
;; RUN: wasm-opt %s -all -o /dev/null

;; After unreachable makes the stack polymorphic, array.store operands must still
;; parse when the unreachable is the value slot (not only the index slot).

(module
  (type $i8_array (array (mut i8)))

  (global $arr (ref $i8_array)
    (array.new_default $i8_array (i32.const 4)))

  (func $stores_value_unreachable
    (i32.store8 (type $i8_array)
      (global.get $arr)
      (i32.const 1)
      (unreachable)))

  (func $stores_index_unreachable
    (i32.store8 (type $i8_array)
      (global.get $arr)
      (unreachable)
      (i32.const 2)))
)
