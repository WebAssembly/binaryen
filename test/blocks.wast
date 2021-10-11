(module
  (type $ty (func (param) (result i32)))

;;  (func $withblock-result (param) (result i32)
;;    (block $label (result i32)
;;      (i32.const 0)))

  (func $withblock-typeref (param) (result i32)
    (block $label (type $ty)
      (i32.const 0))))