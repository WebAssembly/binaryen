(module
 (type $0 (func))
 (global $global$0 (mut i32) (i32.const 10))
 (export "func_59_invoker" (func $0))
 (func $0 (; 0 ;) (type $0)
  (if
   (block $label$1 (result i32)
    (global.set $global$0
     (i32.const 0)
    )
    (i32.const 127)
   )
   (unreachable)
  )
  (global.set $global$0
   (i32.const -1)
  )
  (if
   (global.get $global$0)
   (unreachable)
  )
  (unreachable)
 )
)
;; AssemblyScript n-body benchmark
(module
 (type $0 (func))
 (type $1 (func (param i32 i32) (result i32)))
 (type $2 (func (param i32 f64 f64 f64) (result i32)))
 (type $3 (func (param i32) (result i32)))
 (type $4 (func (result i32)))
 (type $5 (func (param i32 f64 f64 f64 f64 f64 f64 f64) (result i32)))
 (type $6 (func (param i32 i32 i32 i32)))
 (type $7 (func (param i32 i32 i32)))
 (type $8 (func (result f64)))
 (type $9 (func (param i32 f64)))
 (type $10 (func (param i32) (result f64)))
 (type $11 (func (param i32)))
 (import "env" "memory" (memory $1 1))
 (data (i32.const 8) "\0d\00\00\00~\00l\00i\00b\00/\00a\00r\00r\00a\00y\00.\00t\00s\00")
 (data (i32.const 40) "\1c\00\00\00~\00l\00i\00b\00/\00i\00n\00t\00e\00r\00n\00a\00l\00/\00a\00r\00r\00a\00y\00b\00u\00f\00f\00e\00r\00.\00t\00s\00")
 (import "env" "abort" (func $~lib/env/abort (param i32 i32 i32 i32)))
 (table $0 1 funcref)
 (elem (i32.const 0) $null)
 (global $global$0 (mut i32) (i32.const 0))
 (global $global$1 (mut i32) (i32.const 0))
 (global $global$2 f64 (f64.const 3.141592653589793))
 (global $global$3 f64 (f64.const 39.47841760435743))
 (global $global$4 f64 (f64.const 365.24))
 (global $global$5 (mut i32) (i32.const 0))
 (global $global$6 i32 (i32.const 100))
 (export "memory" (memory $0))
 (export "table" (table $0))
 (export "init" (func $assembly/index/init))
 (export "step" (func $assembly/index/step))
 (export "bench" (func $assembly/index/bench))
 (export "getBody" (func $assembly/index/getBody))
 (start $start)
 (func $start:~lib/allocator/arena (; 1 ;) (type $0)
  (global.set $global$0
   (i32.and
    (i32.add
     (global.get $global$6)
     (i32.const 7)
    )
    (i32.xor
     (i32.const 7)
     (i32.const -1)
    )
   )
  )
  (global.set $global$1
   (global.get $global$0)
  )
 )
 (func $start:assembly/index (; 2 ;) (type $0)
  (call $start:~lib/allocator/arena)
 )
 (func $~lib/array/Array<Body>#__unchecked_get (; 3 ;) (type $1) (param $0 i32) (param $1 i32) (result i32)
  (local $2 i32)
  (local $3 i32)
  (local $4 i32)
  (local.set $2
   (i32.load
    (local.get $0)
   )
  )
  (local.set $3
   (local.get $1)
  )
  (local.set $4
   (i32.const 0)
  )
  (i32.load offset=8
   (i32.add
    (i32.add
     (local.get $2)
     (i32.shl
      (local.get $3)
      (i32.const 2)
     )
    )
    (local.get $4)
   )
  )
 )
 (func $~lib/array/Array<Body>#__get (; 4 ;) (type $1) (param $0 i32) (param $1 i32) (result i32)
  (local $2 i32)
  (local $3 i32)
  (local $4 i32)
  (local $5 i32)
  (local.set $2
   (i32.load
    (local.get $0)
   )
  )
  (if (result i32)
   (i32.lt_u
    (local.get $1)
    (i32.shr_u
     (i32.load
      (local.get $2)
     )
     (i32.const 2)
    )
   )
   (block (result i32)
    (local.set $3
     (local.get $2)
    )
    (local.set $4
     (local.get $1)
    )
    (local.set $5
     (i32.const 0)
    )
    (i32.load offset=8
     (i32.add
      (i32.add
       (local.get $3)
       (i32.shl
        (local.get $4)
        (i32.const 2)
       )
      )
      (local.get $5)
     )
    )
   )
   (unreachable)
  )
 )
 (func $assembly/index/Body#offsetMomentum (; 5 ;) (type $2) (param $0 i32) (param $1 f64) (param $2 f64) (param $3 f64) (result i32)
  (f64.store offset=24
   (local.get $0)
   (f64.div
    (f64.neg
     (local.get $1)
    )
    (global.get $global$3)
   )
  )
  (f64.store offset=32
   (local.get $0)
   (f64.div
    (f64.neg
     (local.get $2)
    )
    (global.get $global$3)
   )
  )
  (f64.store offset=40
   (local.get $0)
   (f64.div
    (f64.neg
     (local.get $3)
    )
    (global.get $global$3)
   )
  )
  (local.get $0)
 )
 (func $~lib/allocator/arena/__memory_allocate (; 6 ;) (type $3) (param $0 i32) (result i32)
  (local $1 i32)
  (local $2 i32)
  (local $3 i32)
  (local $4 i32)
  (local $5 i32)
  (local $6 i32)
  (if
   (i32.gt_u
    (local.get $0)
    (i32.const 1073741824)
   )
   (unreachable)
  )
  (local.set $1
   (global.get $global$1)
  )
  (local.set $4
   (i32.and
    (i32.add
     (i32.add
      (local.get $1)
      (select
       (local.tee $2
        (local.get $0)
       )
       (local.tee $3
        (i32.const 1)
       )
       (i32.gt_u
        (local.get $2)
        (local.get $3)
       )
      )
     )
     (i32.const 7)
    )
    (i32.xor
     (i32.const 7)
     (i32.const -1)
    )
   )
  )
  (local.set $5
   (current_memory)
  )
  (if
   (i32.gt_u
    (local.get $4)
    (i32.shl
     (local.get $5)
     (i32.const 16)
    )
   )
   (block
    (local.set $2
     (i32.shr_u
      (i32.and
       (i32.add
        (i32.sub
         (local.get $4)
         (local.get $1)
        )
        (i32.const 65535)
       )
       (i32.xor
        (i32.const 65535)
        (i32.const -1)
       )
      )
      (i32.const 16)
     )
    )
    (local.set $3
     (select
      (local.tee $3
       (local.get $5)
      )
      (local.tee $6
       (local.get $2)
      )
      (i32.gt_s
       (local.get $3)
       (local.get $6)
      )
     )
    )
    (if
     (i32.lt_s
      (grow_memory
       (local.get $3)
      )
      (i32.const 0)
     )
     (if
      (i32.lt_s
       (grow_memory
        (local.get $2)
       )
       (i32.const 0)
      )
      (unreachable)
     )
    )
   )
  )
  (global.set $global$1
   (local.get $4)
  )
  (local.get $1)
 )
 (func $~lib/memory/memory.allocate (; 7 ;) (type $3) (param $0 i32) (result i32)
  (return
   (call $~lib/allocator/arena/__memory_allocate
    (local.get $0)
   )
  )
 )
 (func $assembly/index/NBodySystem#constructor (; 8 ;) (type $1) (param $0 i32) (param $1 i32) (result i32)
  (local $2 i32)
  (local $3 i32)
  (local $4 i32)
  (local $5 f64)
  (local $6 f64)
  (local $7 f64)
  (local $8 f64)
  (local.set $5
   (f64.const 0)
  )
  (local.set $6
   (f64.const 0)
  )
  (local.set $7
   (f64.const 0)
  )
  (local.set $3
   (block $label$1 (result i32)
    (local.set $2
     (local.get $1)
    )
    (i32.load offset=4
     (local.get $2)
    )
   )
  )
  (block $label$2
   (local.set $2
    (i32.const 0)
   )
   (loop $label$3
    (br_if $label$2
     (i32.eqz
      (i32.lt_s
       (local.get $2)
       (local.get $3)
      )
     )
    )
    (block $label$4
     (local.set $4
      (call $~lib/array/Array<Body>#__unchecked_get
       (local.get $1)
       (local.get $2)
      )
     )
     (local.set $8
      (f64.load offset=48
       (local.get $4)
      )
     )
     (local.set $5
      (f64.add
       (local.get $5)
       (f64.mul
        (f64.load offset=24
         (local.get $4)
        )
        (local.get $8)
       )
      )
     )
     (local.set $6
      (f64.add
       (local.get $6)
       (f64.mul
        (f64.load offset=32
         (local.get $4)
        )
        (local.get $8)
       )
      )
     )
     (local.set $7
      (f64.add
       (local.get $7)
       (f64.mul
        (f64.load offset=40
         (local.get $4)
        )
        (local.get $8)
       )
      )
     )
    )
    (local.set $2
     (i32.add
      (local.get $2)
      (i32.const 1)
     )
    )
    (br $label$3)
   )
  )
  (drop
   (call $assembly/index/Body#offsetMomentum
    (call $~lib/array/Array<Body>#__get
     (local.get $1)
     (i32.const 0)
    )
    (local.get $5)
    (local.get $6)
    (local.get $7)
   )
  )
  (if
   (i32.eqz
    (local.get $0)
   )
   (local.set $0
    (call $~lib/memory/memory.allocate
     (i32.const 4)
    )
   )
  )
  (i32.store
   (local.get $0)
   (local.get $1)
  )
  (local.get $0)
 )
 (func $assembly/index/Body#constructor (; 9 ;) (type $5) (param $0 i32) (param $1 f64) (param $2 f64) (param $3 f64) (param $4 f64) (param $5 f64) (param $6 f64) (param $7 f64) (result i32)
  (if
   (i32.eqz
    (local.get $0)
   )
   (local.set $0
    (call $~lib/memory/memory.allocate
     (i32.const 56)
    )
   )
  )
  (f64.store
   (local.get $0)
   (local.get $1)
  )
  (f64.store offset=8
   (local.get $0)
   (local.get $2)
  )
  (f64.store offset=16
   (local.get $0)
   (local.get $3)
  )
  (f64.store offset=24
   (local.get $0)
   (local.get $4)
  )
  (f64.store offset=32
   (local.get $0)
   (local.get $5)
  )
  (f64.store offset=40
   (local.get $0)
   (local.get $6)
  )
  (f64.store offset=48
   (local.get $0)
   (local.get $7)
  )
  (local.get $0)
 )
 (func $assembly/index/Sun (; 10 ;) (type $4) (result i32)
  (call $assembly/index/Body#constructor
   (i32.const 0)
   (f64.const 0)
   (f64.const 0)
   (f64.const 0)
   (f64.const 0)
   (f64.const 0)
   (f64.const 0)
   (global.get $global$3)
  )
 )
 (func $assembly/index/Jupiter (; 11 ;) (type $4) (result i32)
  (call $assembly/index/Body#constructor
   (i32.const 0)
   (f64.const 4.841431442464721)
   (f64.const -1.1603200440274284)
   (f64.const -0.10362204447112311)
   (f64.mul
    (f64.const 0.001660076642744037)
    (global.get $global$4)
   )
   (f64.mul
    (f64.const 0.007699011184197404)
    (global.get $global$4)
   )
   (f64.mul
    (f64.const -6.90460016972063e-05)
    (global.get $global$4)
   )
   (f64.mul
    (f64.const 9.547919384243266e-04)
    (global.get $global$3)
   )
  )
 )
 (func $assembly/index/Saturn (; 12 ;) (type $4) (result i32)
  (call $assembly/index/Body#constructor
   (i32.const 0)
   (f64.const 8.34336671824458)
   (f64.const 4.124798564124305)
   (f64.const -0.4035234171143214)
   (f64.mul
    (f64.const -0.002767425107268624)
    (global.get $global$4)
   )
   (f64.mul
    (f64.const 0.004998528012349172)
    (global.get $global$4)
   )
   (f64.mul
    (f64.const 2.3041729757376393e-05)
    (global.get $global$4)
   )
   (f64.mul
    (f64.const 2.858859806661308e-04)
    (global.get $global$3)
   )
  )
 )
 (func $assembly/index/Uranus (; 13 ;) (type $4) (result i32)
  (call $assembly/index/Body#constructor
   (i32.const 0)
   (f64.const 12.894369562139131)
   (f64.const -15.111151401698631)
   (f64.const -0.22330757889265573)
   (f64.mul
    (f64.const 0.002964601375647616)
    (global.get $global$4)
   )
   (f64.mul
    (f64.const 2.3784717395948095e-03)
    (global.get $global$4)
   )
   (f64.mul
    (f64.const -2.9658956854023756e-05)
    (global.get $global$4)
   )
   (f64.mul
    (f64.const 4.366244043351563e-05)
    (global.get $global$3)
   )
  )
 )
 (func $assembly/index/Neptune (; 14 ;) (type $4) (result i32)
  (call $assembly/index/Body#constructor
   (i32.const 0)
   (f64.const 15.379697114850917)
   (f64.const -25.919314609987964)
   (f64.const 0.17925877295037118)
   (f64.mul
    (f64.const 2.6806777249038932e-03)
    (global.get $global$4)
   )
   (f64.mul
    (f64.const 0.001628241700382423)
    (global.get $global$4)
   )
   (f64.mul
    (f64.const -9.515922545197159e-05)
    (global.get $global$4)
   )
   (f64.mul
    (f64.const 5.1513890204661145e-05)
    (global.get $global$3)
   )
  )
 )
 (func $~lib/internal/arraybuffer/computeSize (; 15 ;) (type $3) (param $0 i32) (result i32)
  (i32.shl
   (i32.const 1)
   (i32.sub
    (i32.const 32)
    (i32.clz
     (i32.sub
      (i32.add
       (local.get $0)
       (i32.const 8)
      )
      (i32.const 1)
     )
    )
   )
  )
 )
 (func $~lib/internal/arraybuffer/allocateUnsafe (; 16 ;) (type $3) (param $0 i32) (result i32)
  (local $1 i32)
  (local $2 i32)
  (if
   (i32.eqz
    (i32.le_u
     (local.get $0)
     (i32.const 1073741816)
    )
   )
   (block
    (call $~lib/env/abort
     (i32.const 0)
     (i32.const 40)
     (i32.const 26)
     (i32.const 2)
    )
    (unreachable)
   )
  )
  (local.set $1
   (block $label$2 (result i32)
    (local.set $2
     (call $~lib/internal/arraybuffer/computeSize
      (local.get $0)
     )
    )
    (br $label$2
     (call $~lib/allocator/arena/__memory_allocate
      (local.get $2)
     )
    )
   )
  )
  (i32.store
   (local.get $1)
   (local.get $0)
  )
  (local.get $1)
 )
 (func $~lib/internal/memory/memset (; 17 ;) (type $7) (param $0 i32) (param $1 i32) (param $2 i32)
  (local $3 i32)
  (local $4 i32)
  (local $5 i64)
  (if
   (i32.eqz
    (local.get $2)
   )
   (return)
  )
  (i32.store8
   (local.get $0)
   (local.get $1)
  )
  (i32.store8
   (i32.sub
    (i32.add
     (local.get $0)
     (local.get $2)
    )
    (i32.const 1)
   )
   (local.get $1)
  )
  (if
   (i32.le_u
    (local.get $2)
    (i32.const 2)
   )
   (return)
  )
  (i32.store8
   (i32.add
    (local.get $0)
    (i32.const 1)
   )
   (local.get $1)
  )
  (i32.store8
   (i32.add
    (local.get $0)
    (i32.const 2)
   )
   (local.get $1)
  )
  (i32.store8
   (i32.sub
    (i32.add
     (local.get $0)
     (local.get $2)
    )
    (i32.const 2)
   )
   (local.get $1)
  )
  (i32.store8
   (i32.sub
    (i32.add
     (local.get $0)
     (local.get $2)
    )
    (i32.const 3)
   )
   (local.get $1)
  )
  (if
   (i32.le_u
    (local.get $2)
    (i32.const 6)
   )
   (return)
  )
  (i32.store8
   (i32.add
    (local.get $0)
    (i32.const 3)
   )
   (local.get $1)
  )
  (i32.store8
   (i32.sub
    (i32.add
     (local.get $0)
     (local.get $2)
    )
    (i32.const 4)
   )
   (local.get $1)
  )
  (if
   (i32.le_u
    (local.get $2)
    (i32.const 8)
   )
   (return)
  )
  (local.set $3
   (i32.and
    (i32.sub
     (i32.const 0)
     (local.get $0)
    )
    (i32.const 3)
   )
  )
  (local.set $0
   (i32.add
    (local.get $0)
    (local.get $3)
   )
  )
  (local.set $2
   (i32.sub
    (local.get $2)
    (local.get $3)
   )
  )
  (local.set $2
   (i32.and
    (local.get $2)
    (i32.const -4)
   )
  )
  (local.set $4
   (i32.mul
    (i32.div_u
     (i32.const -1)
     (i32.const 255)
    )
    (i32.and
     (local.get $1)
     (i32.const 255)
    )
   )
  )
  (i32.store
   (local.get $0)
   (local.get $4)
  )
  (i32.store
   (i32.sub
    (i32.add
     (local.get $0)
     (local.get $2)
    )
    (i32.const 4)
   )
   (local.get $4)
  )
  (if
   (i32.le_u
    (local.get $2)
    (i32.const 8)
   )
   (return)
  )
  (i32.store
   (i32.add
    (local.get $0)
    (i32.const 4)
   )
   (local.get $4)
  )
  (i32.store
   (i32.add
    (local.get $0)
    (i32.const 8)
   )
   (local.get $4)
  )
  (i32.store
   (i32.sub
    (i32.add
     (local.get $0)
     (local.get $2)
    )
    (i32.const 12)
   )
   (local.get $4)
  )
  (i32.store
   (i32.sub
    (i32.add
     (local.get $0)
     (local.get $2)
    )
    (i32.const 8)
   )
   (local.get $4)
  )
  (if
   (i32.le_u
    (local.get $2)
    (i32.const 24)
   )
   (return)
  )
  (i32.store
   (i32.add
    (local.get $0)
    (i32.const 12)
   )
   (local.get $4)
  )
  (i32.store
   (i32.add
    (local.get $0)
    (i32.const 16)
   )
   (local.get $4)
  )
  (i32.store
   (i32.add
    (local.get $0)
    (i32.const 20)
   )
   (local.get $4)
  )
  (i32.store
   (i32.add
    (local.get $0)
    (i32.const 24)
   )
   (local.get $4)
  )
  (i32.store
   (i32.sub
    (i32.add
     (local.get $0)
     (local.get $2)
    )
    (i32.const 28)
   )
   (local.get $4)
  )
  (i32.store
   (i32.sub
    (i32.add
     (local.get $0)
     (local.get $2)
    )
    (i32.const 24)
   )
   (local.get $4)
  )
  (i32.store
   (i32.sub
    (i32.add
     (local.get $0)
     (local.get $2)
    )
    (i32.const 20)
   )
   (local.get $4)
  )
  (i32.store
   (i32.sub
    (i32.add
     (local.get $0)
     (local.get $2)
    )
    (i32.const 16)
   )
   (local.get $4)
  )
  (local.set $3
   (i32.add
    (i32.const 24)
    (i32.and
     (local.get $0)
     (i32.const 4)
    )
   )
  )
  (local.set $0
   (i32.add
    (local.get $0)
    (local.get $3)
   )
  )
  (local.set $2
   (i32.sub
    (local.get $2)
    (local.get $3)
   )
  )
  (local.set $5
   (i64.or
    (i64.extend_i32_u
     (local.get $4)
    )
    (i64.shl
     (i64.extend_i32_u
      (local.get $4)
     )
     (i64.const 32)
    )
   )
  )
  (block $label$7
   (loop $label$8
    (if
     (i32.ge_u
      (local.get $2)
      (i32.const 32)
     )
     (block
      (block $label$10
       (i64.store
        (local.get $0)
        (local.get $5)
       )
       (i64.store
        (i32.add
         (local.get $0)
         (i32.const 8)
        )
        (local.get $5)
       )
       (i64.store
        (i32.add
         (local.get $0)
         (i32.const 16)
        )
        (local.get $5)
       )
       (i64.store
        (i32.add
         (local.get $0)
         (i32.const 24)
        )
        (local.get $5)
       )
       (local.set $2
        (i32.sub
         (local.get $2)
         (i32.const 32)
        )
       )
       (local.set $0
        (i32.add
         (local.get $0)
         (i32.const 32)
        )
       )
      )
      (br $label$8)
     )
    )
   )
  )
 )
 (func $~lib/array/Array<Body>#constructor (; 18 ;) (type $1) (param $0 i32) (param $1 i32) (result i32)
  (local $2 i32)
  (local $3 i32)
  (local $4 i32)
  (local $5 i32)
  (local $6 i32)
  (if
   (i32.gt_u
    (local.get $1)
    (i32.const 268435454)
   )
   (block
    (call $~lib/env/abort
     (i32.const 0)
     (i32.const 8)
     (i32.const 45)
     (i32.const 39)
    )
    (unreachable)
   )
  )
  (local.set $2
   (i32.shl
    (local.get $1)
    (i32.const 2)
   )
  )
  (local.set $3
   (call $~lib/internal/arraybuffer/allocateUnsafe
    (local.get $2)
   )
  )
  (i32.store
   (block $label$2 (result i32)
    (if
     (i32.eqz
      (local.get $0)
     )
     (local.set $0
      (call $~lib/memory/memory.allocate
       (i32.const 8)
      )
     )
    )
    (i32.store
     (local.get $0)
     (i32.const 0)
    )
    (i32.store offset=4
     (local.get $0)
     (i32.const 0)
    )
    (local.get $0)
   )
   (local.get $3)
  )
  (i32.store offset=4
   (local.get $0)
   (local.get $1)
  )
  (block $label$4
   (local.set $4
    (i32.add
     (local.get $3)
     (i32.const 8)
    )
   )
   (local.set $5
    (i32.const 0)
   )
   (local.set $6
    (local.get $2)
   )
   (call $~lib/internal/memory/memset
    (local.get $4)
    (local.get $5)
    (local.get $6)
   )
  )
  (local.get $0)
 )
 (func $~lib/array/Array<Body>#__unchecked_set (; 19 ;) (type $7) (param $0 i32) (param $1 i32) (param $2 i32)
  (local $3 i32)
  (local $4 i32)
  (local $5 i32)
  (local $6 i32)
  (local.set $3
   (i32.load
    (local.get $0)
   )
  )
  (local.set $4
   (local.get $1)
  )
  (local.set $5
   (local.get $2)
  )
  (local.set $6
   (i32.const 0)
  )
  (i32.store offset=8
   (i32.add
    (i32.add
     (local.get $3)
     (i32.shl
      (local.get $4)
      (i32.const 2)
     )
    )
    (local.get $6)
   )
   (local.get $5)
  )
 )
 (func $assembly/index/init (; 20 ;) (type $0)
  (local $0 i32)
  (global.set $global$5
   (call $assembly/index/NBodySystem#constructor
    (i32.const 0)
    (block $label$1 (result i32)
     (local.set $0
      (call $~lib/array/Array<Body>#constructor
       (i32.const 0)
       (i32.const 5)
      )
     )
     (call $~lib/array/Array<Body>#__unchecked_set
      (local.get $0)
      (i32.const 0)
      (call $assembly/index/Sun)
     )
     (call $~lib/array/Array<Body>#__unchecked_set
      (local.get $0)
      (i32.const 1)
      (call $assembly/index/Jupiter)
     )
     (call $~lib/array/Array<Body>#__unchecked_set
      (local.get $0)
      (i32.const 2)
      (call $assembly/index/Saturn)
     )
     (call $~lib/array/Array<Body>#__unchecked_set
      (local.get $0)
      (i32.const 3)
      (call $assembly/index/Uranus)
     )
     (call $~lib/array/Array<Body>#__unchecked_set
      (local.get $0)
      (i32.const 4)
      (call $assembly/index/Neptune)
     )
     (local.get $0)
    )
   )
  )
 )
 (func $assembly/index/NBodySystem#advance (; 21 ;) (type $9) (param $0 i32) (param $1 f64)
  (local $2 i32)
  (local $3 i32)
  (local $4 i32)
  (local $5 i32)
  (local $6 i32)
  (local $7 i32)
  (local $8 f64)
  (local $9 f64)
  (local $10 f64)
  (local $11 f64)
  (local $12 f64)
  (local $13 f64)
  (local $14 f64)
  (local $15 f64)
  (local $16 f64)
  (local $17 f64)
  (local $18 f64)
  (local $19 f64)
  (local $20 f64)
  (local $21 f64)
  (local $22 f64)
  (local.set $2
   (i32.load
    (local.get $0)
   )
  )
  (local.set $4
   (block $label$1 (result i32)
    (local.set $3
     (local.get $2)
    )
    (i32.load offset=4
     (local.get $3)
    )
   )
  )
  (block $label$2
   (local.set $3
    (i32.const 0)
   )
   (loop $label$3
    (br_if $label$2
     (i32.eqz
      (i32.lt_u
       (local.get $3)
       (local.get $4)
      )
     )
    )
    (block $label$4
     (local.set $5
      (call $~lib/array/Array<Body>#__unchecked_get
       (local.get $2)
       (local.get $3)
      )
     )
     (local.set $8
      (f64.load
       (local.get $5)
      )
     )
     (local.set $9
      (f64.load offset=8
       (local.get $5)
      )
     )
     (local.set $10
      (f64.load offset=16
       (local.get $5)
      )
     )
     (local.set $11
      (f64.load offset=24
       (local.get $5)
      )
     )
     (local.set $12
      (f64.load offset=32
       (local.get $5)
      )
     )
     (local.set $13
      (f64.load offset=40
       (local.get $5)
      )
     )
     (local.set $14
      (f64.load offset=48
       (local.get $5)
      )
     )
     (block $label$5
      (local.set $6
       (i32.add
        (local.get $3)
        (i32.const 1)
       )
      )
      (loop $label$6
       (br_if $label$5
        (i32.eqz
         (i32.lt_u
          (local.get $6)
          (local.get $4)
         )
        )
       )
       (block $label$7
        (local.set $7
         (call $~lib/array/Array<Body>#__unchecked_get
          (local.get $2)
          (local.get $6)
         )
        )
        (local.set $15
         (f64.sub
          (local.get $8)
          (f64.load
           (local.get $7)
          )
         )
        )
        (local.set $16
         (f64.sub
          (local.get $9)
          (f64.load offset=8
           (local.get $7)
          )
         )
        )
        (local.set $17
         (f64.sub
          (local.get $10)
          (f64.load offset=16
           (local.get $7)
          )
         )
        )
        (local.set $18
         (f64.add
          (f64.add
           (f64.mul
            (local.get $15)
            (local.get $15)
           )
           (f64.mul
            (local.get $16)
            (local.get $16)
           )
          )
          (f64.mul
           (local.get $17)
           (local.get $17)
          )
         )
        )
        (local.set $19
         (block $label$8 (result f64)
          (local.set $19
           (local.get $18)
          )
          (f64.sqrt
           (local.get $19)
          )
         )
        )
        (local.set $20
         (f64.div
          (local.get $1)
          (f64.mul
           (local.get $18)
           (local.get $19)
          )
         )
        )
        (local.set $21
         (f64.mul
          (local.get $14)
          (local.get $20)
         )
        )
        (local.set $22
         (f64.mul
          (f64.load offset=48
           (local.get $7)
          )
          (local.get $20)
         )
        )
        (local.set $11
         (f64.sub
          (local.get $11)
          (f64.mul
           (local.get $15)
           (local.get $22)
          )
         )
        )
        (local.set $12
         (f64.sub
          (local.get $12)
          (f64.mul
           (local.get $16)
           (local.get $22)
          )
         )
        )
        (local.set $13
         (f64.sub
          (local.get $13)
          (f64.mul
           (local.get $17)
           (local.get $22)
          )
         )
        )
        (f64.store offset=24
         (local.get $7)
         (f64.add
          (f64.load offset=24
           (local.get $7)
          )
          (f64.mul
           (local.get $15)
           (local.get $21)
          )
         )
        )
        (f64.store offset=32
         (local.get $7)
         (f64.add
          (f64.load offset=32
           (local.get $7)
          )
          (f64.mul
           (local.get $16)
           (local.get $21)
          )
         )
        )
        (f64.store offset=40
         (local.get $7)
         (f64.add
          (f64.load offset=40
           (local.get $7)
          )
          (f64.mul
           (local.get $17)
           (local.get $21)
          )
         )
        )
       )
       (local.set $6
        (i32.add
         (local.get $6)
         (i32.const 1)
        )
       )
       (br $label$6)
      )
     )
     (f64.store offset=24
      (local.get $5)
      (local.get $11)
     )
     (f64.store offset=32
      (local.get $5)
      (local.get $12)
     )
     (f64.store offset=40
      (local.get $5)
      (local.get $13)
     )
     (f64.store
      (local.get $5)
      (f64.add
       (f64.load
        (local.get $5)
       )
       (f64.mul
        (local.get $1)
        (local.get $11)
       )
      )
     )
     (f64.store offset=8
      (local.get $5)
      (f64.add
       (f64.load offset=8
        (local.get $5)
       )
       (f64.mul
        (local.get $1)
        (local.get $12)
       )
      )
     )
     (f64.store offset=16
      (local.get $5)
      (f64.add
       (f64.load offset=16
        (local.get $5)
       )
       (f64.mul
        (local.get $1)
        (local.get $13)
       )
      )
     )
    )
    (local.set $3
     (i32.add
      (local.get $3)
      (i32.const 1)
     )
    )
    (br $label$3)
   )
  )
 )
 (func $assembly/index/NBodySystem#energy (; 22 ;) (type $10) (param $0 i32) (result f64)
  (local $1 i32)
  (local $2 i32)
  (local $3 i32)
  (local $4 i32)
  (local $5 i32)
  (local $6 i32)
  (local $7 f64)
  (local $8 f64)
  (local $9 f64)
  (local $10 f64)
  (local $11 f64)
  (local $12 f64)
  (local $13 f64)
  (local $14 f64)
  (local $15 f64)
  (local $16 f64)
  (local $17 f64)
  (local $18 f64)
  (local.set $7
   (f64.const 0)
  )
  (local.set $1
   (i32.load
    (local.get $0)
   )
  )
  (block $label$1
   (block $label$2
    (local.set $2
     (i32.const 0)
    )
    (local.set $3
     (block $label$3 (result i32)
      (local.set $3
       (local.get $1)
      )
      (i32.load offset=4
       (local.get $3)
      )
     )
    )
   )
   (loop $label$4
    (br_if $label$1
     (i32.eqz
      (i32.lt_u
       (local.get $2)
       (local.get $3)
      )
     )
    )
    (block $label$5
     (local.set $4
      (call $~lib/array/Array<Body>#__unchecked_get
       (local.get $1)
       (local.get $2)
      )
     )
     (local.set $8
      (f64.load
       (local.get $4)
      )
     )
     (local.set $9
      (f64.load offset=8
       (local.get $4)
      )
     )
     (local.set $10
      (f64.load offset=16
       (local.get $4)
      )
     )
     (local.set $11
      (f64.load offset=24
       (local.get $4)
      )
     )
     (local.set $12
      (f64.load offset=32
       (local.get $4)
      )
     )
     (local.set $13
      (f64.load offset=40
       (local.get $4)
      )
     )
     (local.set $14
      (f64.load offset=48
       (local.get $4)
      )
     )
     (local.set $7
      (f64.add
       (local.get $7)
       (f64.mul
        (f64.mul
         (f64.const 0.5)
         (local.get $14)
        )
        (f64.add
         (f64.add
          (f64.mul
           (local.get $11)
           (local.get $11)
          )
          (f64.mul
           (local.get $12)
           (local.get $12)
          )
         )
         (f64.mul
          (local.get $13)
          (local.get $13)
         )
        )
       )
      )
     )
     (block $label$6
      (local.set $5
       (i32.add
        (local.get $2)
        (i32.const 1)
       )
      )
      (loop $label$7
       (br_if $label$6
        (i32.eqz
         (i32.lt_u
          (local.get $5)
          (local.get $3)
         )
        )
       )
       (block $label$8
        (local.set $6
         (call $~lib/array/Array<Body>#__unchecked_get
          (local.get $1)
          (local.get $5)
         )
        )
        (local.set $15
         (f64.sub
          (local.get $8)
          (f64.load
           (local.get $6)
          )
         )
        )
        (local.set $16
         (f64.sub
          (local.get $9)
          (f64.load offset=8
           (local.get $6)
          )
         )
        )
        (local.set $17
         (f64.sub
          (local.get $10)
          (f64.load offset=16
           (local.get $6)
          )
         )
        )
        (local.set $18
         (block $label$9 (result f64)
          (local.set $18
           (f64.add
            (f64.add
             (f64.mul
              (local.get $15)
              (local.get $15)
             )
             (f64.mul
              (local.get $16)
              (local.get $16)
             )
            )
            (f64.mul
             (local.get $17)
             (local.get $17)
            )
           )
          )
          (f64.sqrt
           (local.get $18)
          )
         )
        )
        (local.set $7
         (f64.sub
          (local.get $7)
          (f64.div
           (f64.mul
            (local.get $14)
            (f64.load offset=48
             (local.get $6)
            )
           )
           (local.get $18)
          )
         )
        )
       )
       (local.set $5
        (i32.add
         (local.get $5)
         (i32.const 1)
        )
       )
       (br $label$7)
      )
     )
    )
    (local.set $2
     (i32.add
      (local.get $2)
      (i32.const 1)
     )
    )
    (br $label$4)
   )
  )
  (local.get $7)
 )
 (func $assembly/index/step (; 23 ;) (type $8) (result f64)
  (call $assembly/index/NBodySystem#advance
   (global.get $global$5)
   (f64.const 0.01)
  )
  (call $assembly/index/NBodySystem#energy
   (global.get $global$5)
  )
 )
 (func $assembly/index/bench (; 24 ;) (type $11) (param $0 i32)
  (local $1 i32)
  (block $label$1
   (local.set $1
    (i32.const 0)
   )
   (loop $label$2
    (br_if $label$1
     (i32.eqz
      (i32.lt_u
       (local.get $1)
       (local.get $0)
      )
     )
    )
    (call $assembly/index/NBodySystem#advance
     (global.get $global$5)
     (f64.const 0.01)
    )
    (local.set $1
     (i32.add
      (local.get $1)
      (i32.const 1)
     )
    )
    (br $label$2)
   )
  )
 )
 (func $assembly/index/getBody (; 25 ;) (type $3) (param $0 i32) (result i32)
  (local $1 i32)
  (local $2 i32)
  (local.set $1
   (i32.load
    (global.get $global$5)
   )
  )
  (if (result i32)
   (i32.lt_u
    (local.get $0)
    (block $label$1 (result i32)
     (local.set $2
      (local.get $1)
     )
     (i32.load offset=4
      (local.get $2)
     )
    )
   )
   (call $~lib/array/Array<Body>#__get
    (local.get $1)
    (local.get $0)
   )
   (i32.const 0)
  )
 )
 (func $start (; 26 ;) (type $0)
  (call $start:assembly/index)
 )
 (func $null (; 27 ;) (type $0)
 )
)

