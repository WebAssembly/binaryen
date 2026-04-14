(module
  (rec
    ;; A -> B -> C inheritance chain
    (type $A (sub (descriptor $A.desc) (struct (field $a (mut i32)))))
    (type $A.desc (sub (describes $A) (struct (field $proto (ref extern)) (field $getA (ref $getA_t)))))
    (type $getA_t (func (param (ref null $A)) (result i32)))

    (type $B (sub $A (descriptor $B.desc) (struct (field $a (mut i32)) (field $b (mut i32)))))
    (type $B.desc (sub $A.desc (describes $B) (struct (field $proto (ref extern)) (field $getA (ref $getA_t)) (field $getB (ref $getB_t)))))
    (type $getB_t (func (param (ref null $B)) (result i32)))

    (type $C (sub $B (descriptor $C.desc) (struct (field $a (mut i32)) (field $b (mut i32)) (field $c (mut i32)))))
    (type $C.desc (sub $B.desc (describes $C) (struct (field $proto (ref extern)) (field $getA (ref $getA_t)) (field $getB (ref $getB_t)) (field $getC (ref $getC_t)))))
    (type $getC_t (func (param (ref null $C)) (result i32)))

    ;; Type with meta-descriptor (descriptor for the descriptor)
    (type $Meta (sub (descriptor $Meta.desc) (struct (field $m (mut i32)))))
    (type $Meta.desc (sub (describes $Meta) (descriptor $Meta.meta-desc) (struct (field $proto (ref extern)) (field $val i32) (field $getM (ref $getM_t)))))
    (type $getM_t (func (param (ref null $Meta)) (result i32)))
    (type $Meta.meta-desc (sub (describes $Meta.desc) (struct (field $proto (ref extern)) (field $metaVal i32) (field $getVal (ref $getVal_t)))))
    (type $getVal_t (func (param (ref null $Meta.desc)) (result i32)))

    ;; Type with invalid prototype source (first field is i32, not externref)
    (type $NoProto (sub (descriptor $NoProto.desc) (struct (field $x i32))))
    (type $NoProto.desc (sub (describes $NoProto) (struct (field $val i32))))

    ;; Test struct.new_default_desc
    (type $Default (sub (descriptor $Default.desc) (struct (field i32))))
    (type $Default.desc (sub (describes $Default) (struct (field (ref extern)))))
  )

  (type $exact_f_t (func (param i32) (result i32)))
  (type $newB_t (func (param i32 i32) (result (ref $B))))
  (type $newC_t (func (param i32 i32 i32) (result (ref $C))))
  (type $newMeta_t (func (param i32) (result (ref $Meta))))

  ;; Types for configureAll
  (type $prototypes (array (mut externref)))
  (type $functions (array (mut funcref)))
  (type $data (array (mut i8)))
  (type $configureAll (func (param (ref null $prototypes))
                            (param (ref null $functions))
                            (param (ref null $data))
                            (param externref)))

  (import "wasm:js-prototypes" "configureAll" (func $configureAll (type $configureAll)))
  (import "env" "constructors" (global $constructors externref))
  (import "protos" "A.proto" (global $A.proto (ref extern)))
  (import "protos" "B.proto" (global $B.proto (ref extern)))
  (import "protos" "C.proto" (global $C.proto (ref extern)))
  (import "protos" "Meta.proto" (global $Meta.proto (ref extern)))
  (import "protos" "MetaDesc.proto" (global $MetaDesc.proto (ref extern)))

  ;; Exact function import test
  (import "env" "exact_func" (func $exact_func (exact (type $exact_f_t))))

  (elem $prototypes externref
    (global.get $A.proto)
    (global.get $B.proto)
    (global.get $C.proto)
    (global.get $Meta.proto)
    (global.get $MetaDesc.proto)
  )

  (elem $functions funcref
    (ref.func $A.getA)      ;; 0: method for A
    (ref.func $B.new)       ;; 1: constructor for B
    (ref.func $B.getB)      ;; 2: method for B
    (ref.func $C.new)       ;; 3: constructor for C
    (ref.func $static1)     ;; 4: static 1 for C
    (ref.func $static2)     ;; 5: static 2 for C
    (ref.func $C.getC)      ;; 6: method for C
    (ref.func $Meta.new)    ;; 7: constructor for Meta
    (ref.func $Meta.getM)   ;; 8: method for Meta
    (ref.func $MetaDesc.getVal) ;; 9: method for MetaDesc
  )

  ;; \05 (5 protoconfigs)
  ;; 1. A: \00 (0 constructors) \01 (1 method) \00\04getA \7f (parent -1)
  ;; 2. B: \01 (1 constructor) \01B \00 (0 static) \01 (1 method) \00\04getB \00 (parent 0)
  ;; 3. C: \01 (1 constructor) \01C \02 (2 static) \00\02s1 \00\02s2 \01 (1 method) \00\04getC \01 (parent 1)
  ;; 4. Meta: \01 (1 constructor) \04Meta \00 (0 static) \01 (1 method) \00\04getM \7f (parent -1)
  ;; 5. MetaDesc: \00 (0 constructors) \01 (1 method) \00\06getVal \7f (parent -1)
  (data $data "\05\00\01\00\04getA\7f\01\01B\00\01\00\04getB\00\01\01C\02\00\02s1\00\02s2\01\00\04getC\01\01\04Meta\00\01\00\04getM\7f\00\01\00\06getVal\7f")

  (global $A.vtable (ref (exact $A.desc))
    (struct.new $A.desc (global.get $A.proto) (ref.func $A.getA))
  )
  (global $B.vtable (ref (exact $B.desc))
    (struct.new $B.desc (global.get $B.proto) (ref.func $A.getA) (ref.func $B.getB))
  )
  (global $C.vtable (ref (exact $C.desc))
    (struct.new $C.desc (global.get $C.proto) (ref.func $A.getA) (ref.func $B.getB) (ref.func $C.getC))
  )

  (global $Meta.meta-vtable (ref (exact $Meta.meta-desc))
    (struct.new $Meta.meta-desc (global.get $MetaDesc.proto) (i32.const 42) (ref.func $MetaDesc.getVal))
  )
  (global $Meta.vtable (ref (exact $Meta.desc))
    (struct.new_desc $Meta.desc (global.get $Meta.proto) (i32.const 100) (ref.func $Meta.getM) (global.get $Meta.meta-vtable))
  )

  (global $NoProto.vtable (ref (exact $NoProto.desc))
    (struct.new $NoProto.desc (i32.const 123))
  )

  (func $A.getA (type $getA_t) (param $this (ref null $A)) (result i32) (struct.get $A $a (local.get $this)))
  (func $B.getB (type $getB_t) (param $this (ref null $B)) (result i32) (struct.get $B $b (local.get $this)))
  (func $C.getC (type $getC_t) (param $this (ref null $C)) (result i32) (struct.get $C $c (local.get $this)))
  (func $Meta.getM (type $getM_t) (param $this (ref null $Meta)) (result i32) (struct.get $Meta $m (local.get $this)))
  (func $MetaDesc.getVal (type $getVal_t) (param $this (ref null $Meta.desc)) (result i32) (struct.get $Meta.desc $val (local.get $this)))
  (func $static1 (result i32) (i32.const 1))
  (func $static2 (result i32) (i32.const 2))

  (func $A.new (export "newA") (param $a i32) (result (ref $A))
    (struct.new_desc $A (local.get $a) (global.get $A.vtable))
  )
  (func $B.new (type $newB_t) (param $a i32) (param $b i32) (result (ref $B))
    (struct.new_desc $B (local.get $a) (local.get $b) (global.get $B.vtable))
  )
  (func $C.new (type $newC_t) (param $a i32) (param $b i32) (param $c i32) (result (ref $C))
    (struct.new_desc $C (local.get $a) (local.get $b) (local.get $c) (global.get $C.vtable))
  )
  (func $Meta.new (type $newMeta_t) (param $m i32) (result (ref $Meta))
    (struct.new_desc $Meta (local.get $m) (global.get $Meta.vtable))
  )
  (func $NoProto.new (export "newNoProto") (param $x i32) (result (ref $NoProto))
    (struct.new_desc $NoProto (local.get $x) (global.get $NoProto.vtable))
  )

  (func $start
    (call $configureAll
      (array.new_elem $prototypes $prototypes (i32.const 0) (i32.const 5))
      (array.new_elem $functions $functions (i32.const 0) (i32.const 10))
      (array.new_data $data $data (i32.const 0) (i32.const 68))
      (global.get $constructors)
    )
  )
  (start $start)

  (func (export "get_meta_desc") (param $m (ref $Meta)) (result (ref $Meta.desc))
    (ref.get_desc $Meta (local.get $m))
  )

  (func (export "test_cast_desc_eq") (param $a (ref $A)) (param $desc (ref (exact $B.desc))) (result (ref null $B))
    (ref.cast_desc_eq (ref null $B) (local.get $a) (local.get $desc))
  )

  (func (export "test_br_on_cast_desc_eq_fail") (param $a (ref $A)) (param $desc (ref (exact $B.desc))) (result i32)
    (block $fail (result (ref $A))
      (br_on_cast_desc_eq_fail $fail (ref $A) (ref $B) (local.get $a) (local.get $desc))
      (return (i32.const 1))
    )
    (return (i32.const 0))
  )

  (func (export "get_B_vtable") (result (ref (exact $B.desc))) (global.get $B.vtable))

  (global $Default.vtable (ref (exact $Default.desc)) (struct.new $Default.desc (global.get $A.proto)))

  (func (export "newDefault") (result (ref $Default))
    (struct.new_default_desc $Default (global.get $Default.vtable))
  )

  (func (export "call_exact") (param i32) (result i32)
    (call $exact_func (local.get 0))
  )
)
