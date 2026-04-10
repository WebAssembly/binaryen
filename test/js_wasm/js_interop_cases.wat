(module
  (rec
    (type $Base (sub (descriptor $Base.vtable) (struct (field $val (mut i32)))))
    (type $Base.vtable (sub (describes $Base) (struct
      (field $proto (ref extern))
      (field $getValue (ref $getValue_t))
      (field $setValue (ref $setValue_t))
    )))
    (type $getValue_t (func (param (ref null $Base)) (result i32)))
    (type $setValue_t (func (param (ref null $Base)) (param i32)))

    (type $Derived (sub $Base (descriptor $Derived.vtable) (struct (field $val (mut i32)) (field $extra i32))))
    (type $Derived.vtable (sub $Base.vtable (describes $Derived) (struct
      (field $proto (ref extern))
      (field $getValue (ref $getValue_t))
      (field $setValue (ref $setValue_t))
      (field $getExtra (ref $getExtra_t))
    )))
    (type $getExtra_t (func (param (ref null $Derived)) (result i32)))
    (type $staticMethod_t (func (result i32)))
  )

  (type $newBase_t (func (param i32) (result (ref $Base))))
  (type $newDerived_t (func (param i32 i32) (result (ref $Derived))))

  ;; Types for prototype configuration
  (type $prototypes (array (mut externref)))
  (type $functions (array (mut funcref)))
  (type $data (array (mut i8)))
  (type $configureAll (func (param (ref null $prototypes))
                            (param (ref null $functions))
                            (param (ref null $data))
                            (param externref)))

  (import "protos" "Base.proto" (global $Base.proto (ref extern)))
  (import "protos" "Derived.proto" (global $Derived.proto (ref extern)))

  (import "env" "constructors" (global $constructors externref))

  (import "wasm:js-prototypes" "configureAll"
    (func $configureAll (type $configureAll)))

  (elem $prototypes externref
    (global.get $Base.proto)
    (global.get $Derived.proto)
  )

  (elem $functions funcref
    (ref.func $Base.new)
    (ref.func $Base.getValue)
    (ref.func $Base.getValue)
    (ref.func $Base.setValue)
    (ref.func $Derived.new)
    (ref.func $Derived.staticMethod)
    (ref.func $Derived.getExtra)
  )

  ;; \02 - 2 protoconfigs
  ;;   Base:
  ;;   \01 - 1 constructorconfig
  ;;     \04Base - "Base"
  ;;     \00 - 0 static methods
  ;;   \03 - 3 methodconfigs
  ;;     \00\08getValue - method "getValue"
  ;;     \01\05value    - getter "value"
  ;;     \02\05value    - setter "value"
  ;;   \7f - parentidx -1
  ;;   Derived:
  ;;   \01 - 1 constructorconfig
  ;;     \07Derived - "Derived"
  ;;     \01 - 1 static method
  ;;       \00\0cstaticMethod
  ;;   \01 - 1 methodconfig
  ;;     \00\08getExtra
  ;;   \00 - parentidx 0 (Base)
  (data $data "\02\01\04Base\00\03\00\08getValue\01\05value\02\05value\7f\01\07Derived\01\00\0cstaticMethod\01\00\08getExtra\00")

  (global $Base.vtable (export "Base.vtable") (ref (exact $Base.vtable))
    (struct.new $Base.vtable
      (global.get $Base.proto)
      (ref.func $Base.getValue)
      (ref.func $Base.setValue)
    )
  )

  (global $Derived.vtable (export "Derived.vtable") (ref (exact $Derived.vtable))
    (struct.new $Derived.vtable
      (global.get $Derived.proto)
      (ref.func $Base.getValue)
      (ref.func $Base.setValue)
      (ref.func $Derived.getExtra)
    )
  )

  (func $Base.new (type $newBase_t) (param $val i32) (result (ref $Base))
    (struct.new_desc $Base
      (local.get $val)
      (global.get $Base.vtable)
    )
  )

  (func $Base.getValue (type $getValue_t) (param $this (ref null $Base)) (result i32)
    (struct.get $Base $val (local.get $this))
  )

  (func $Base.setValue (type $setValue_t) (param $this (ref null $Base)) (param $val i32)
    (struct.set $Base $val (local.get $this) (local.get $val))
  )

  (func $Derived.new (type $newDerived_t) (param $val i32) (param $extra i32) (result (ref $Derived))
    (struct.new_desc $Derived
      (local.get $val)
      (local.get $extra)
      (global.get $Derived.vtable)
    )
  )

  (func $Derived.getExtra (type $getExtra_t) (param $this (ref null $Derived)) (result i32)
    (struct.get $Derived $extra (local.get $this))
  )

  (func $Derived.staticMethod (type $staticMethod_t) (result i32)
    (i32.const 42)
  )

  (func $start
    (call $configureAll
      (array.new_elem $prototypes $prototypes (i32.const 0) (i32.const 2))
      (array.new_elem $functions $functions (i32.const 0) (i32.const 7))
      (array.new_data $data $data (i32.const 0) (i32.const 70))
      (global.get $constructors)
    )
  )

  (start $start)

  ;; Additional tests for descriptor instructions
  (func (export "get_base_val") (param $b (ref $Base)) (result i32)
    (call $Base.getValue (local.get $b))
  )

  (func (export "checkDesc") (param $b (ref $Base)) (result i32)
    (block $derived (result (ref $Derived))
      (block $base (result (ref $Base))
        (br_on_cast_desc_eq $base (ref $Base) (ref $Base) (local.get $b) (global.get $Base.vtable))
        (br_on_cast_desc_eq $derived (ref $Base) (ref $Derived) (local.get $b) (global.get $Derived.vtable))
        (return (i32.const 0))
      )
      (drop)
      (return (i32.const 1))
    )
    (drop)
    (return (i32.const 2))
  )

  (func (export "isDerived") (param $b (ref $Base)) (result i32)
    (if (result i32)
      (ref.test (ref $Derived) (local.get $b))
      (then (i32.const 1))
      (else (i32.const 0))
    )
  )
)
