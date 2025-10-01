(module
 (type $s (sub (struct)))
 (type $t (sub $s (struct)))

  (func $br_on_null (param $x (ref null $s)) (result (ref $s))
    (block $label0
      (return (br_on_null $label0 (local.get $x))))
    (struct.new $s))

  (func $br_on_non_null (param $x (ref null $s)) (result (ref $s))
    (return (block $label0 (result (ref $s))
      (br_on_non_null $label0 (local.get $x))
      (struct.new $s))))

  (func $br_on_cast (param $x (ref $s)) (result (ref $t))
    (return (block $label0 (result (ref $t))
      (drop (br_on_cast $label0 (ref $s) (ref $t) (local.get $x)))
      (struct.new $t))))

  (func $br_on_cast_fail (param $x (ref $s)) (result (ref $t))
    (drop (block $label0 (result (ref $s))
      (return (br_on_cast_fail $label0 (ref $s) (ref $t) (local.get $x)))))
    (struct.new $t))
  )
