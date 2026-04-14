;; https://github.com/WebAssembly/custom-descriptors/blob/main/proposals/custom-descriptors/Overview.md

(module
  (rec
    (type $counter (descriptor $counter.vtable) (struct (field $val (mut i32))))
    (type $counter.vtable (describes $counter) (struct
      (field $proto (ref extern))
      (field $get (ref $get_t))
      (field $inc (ref $inc_t))
    ))
    (type $get_t (func (param (ref null $counter)) (result i32)))
    (type $inc_t (func (param (ref null $counter))))
  )
  (type $new_t (func (param i32) (result (ref $counter))))

  ;; Types for prototype configuration
  (type $prototypes (array (mut externref)))
  (type $functions (array (mut funcref)))
  (type $data (array (mut i8)))
  (type $configureAll (func (param (ref null $prototypes))
                            (param (ref null $functions))
                            (param (ref null $data))
                            (param externref)))

  (import "protos" "counter.proto" (global $counter.proto (ref extern)))

  ;; The object where configured constructors will be installed.
  (import "env" "constructors" (global $constructors externref))

  (import "wasm:js-prototypes" "configureAll"
    (func $configureAll (type $configureAll)))

  ;; Segments used to create arrays passed to $configureAll
  (elem $prototypes externref
    (global.get $counter.proto)
  )
  (elem $functions funcref
    (ref.func $counter.new)
    (ref.func $counter.get)
    (ref.func $counter.inc)
  )
  ;; \01  one protoconfig
  ;; \01    one constructorconfig
  ;; \07      length of name "Counter"
  ;; Counter    constructor name
  ;; \00      no static methods
  ;; \02    two methodconfigs
  ;; \00      method (not getter or setter)
  ;; \03        length of name "get"
  ;; get        method name
  ;; \00      method (not getter or setter)
  ;; \03        length of name "inc"
  ;; inc        method name
  ;; \7f    no parent prototype (-1 s32)
  (data $data "\01\01\07Counter\00\02\00\03get\00\03inc\7f")

  (global $counter.vtable (ref (exact $counter.vtable))
    (struct.new $counter.vtable
      (global.get $counter.proto)
      (ref.func $counter.get)
      (ref.func $counter.inc)
    )
  )

  (func $counter.get (type $get_t) (param (ref null $counter)) (result i32)
    (struct.get $counter $val (local.get 0))
  )

  (func $counter.inc (type $inc_t) (param (ref null $counter))
    (struct.set $counter $val
      (local.get 0)
      (i32.add
        (struct.get $counter $val (local.get 0))
        (i32.const 1)
      )
    )
  )

  (func $counter.new (type $new_t) (param i32) (result (ref $counter))
    (struct.new_desc $counter
      (local.get 0)
      (global.get $counter.vtable)
    )
  )

  (func $start
    (call $configureAll
      (array.new_elem $prototypes $prototypes
        (i32.const 0)
        (i32.const 1)
      )
      (array.new_elem $functions $functions
        (i32.const 0)
        (i32.const 3)
      )
      (array.new_data $data $data
        (i32.const 0)
        (i32.const 23)
      )
      (global.get $constructors)
    )
  )

  (start $start)
)
