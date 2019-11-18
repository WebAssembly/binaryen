;; OptimizeARC part of assemblyscript/tests/compiler/rc/optimize
;; with flattening applied manually
(module
 (import "rt" "retain" (func $~lib/rt/pure/__retain (param i32) (result i32)))
 (import "rt" "release" (func $~lib/rt/pure/__release (param i32)))
 (func $eliminates.linearArgument (param $0 i32)
  (local.set $0
   (call $~lib/rt/pure/__retain
    (local.get $0)
   )
  )
  (call $~lib/rt/pure/__release
   (local.get $0)
  )
 )
 (func $eliminates.linearLocal (param $0 i32)
  (local $1 i32)
  (local.set $1
   (call $~lib/rt/pure/__retain
    (local.get $0)
   )
  )
  (call $~lib/rt/pure/__release
   (local.get $1)
  )
 )
 (func $eliminates.linearChain (param $0 i32)
  (local $1 i32)
  (local $2 i32)
  (local $3 i32)
  (local.set $1
   (call $~lib/rt/pure/__retain
    (local.get $0)
   )
  )
  (local.set $2
   (call $~lib/rt/pure/__retain
    (local.get $1)
   )
  )
  (local.set $3
   (call $~lib/rt/pure/__retain
    (local.get $2)
   )
  )
  (call $~lib/rt/pure/__release
   (local.get $3)
  )
  (call $~lib/rt/pure/__release
   (local.get $2)
  )
  (call $~lib/rt/pure/__release
   (local.get $1)
  )
 )
  (func $eliminates.balancedReleases (param $0 i32) (param $cond i32)
  (local $2 i32)
  (local.set $2
   (call $~lib/rt/pure/__retain
    (local.get $0)
   )
  )
  (if
   (local.get $cond)
   (call $~lib/rt/pure/__release
    (local.get $2)
   )
   (call $~lib/rt/pure/__release
    (local.get $2)
   )
  )
 )
 (func $eliminates.partialReleases (param $0 i32) (param $cond i32)
  ;; technically invalid but assumed to be never emitted
  (local $2 i32)
  (local.set $2
   (call $~lib/rt/pure/__retain
    (local.get $0)
   )
  )
  (if
   (local.get $cond)
   (call $~lib/rt/pure/__release
    (local.get $2)
   )
  )
 )
 (func $eliminates.balancedRetains (param $0 i32) (param $cond1 i32) (param $cond2 i32)
  (local $3 i32)
  (if
   (local.get $cond1)
   (if
    (local.get $cond2)
    (local.set $3
     (call $~lib/rt/pure/__retain
      (local.get $0)
     )
    )
    (local.set $3
     (call $~lib/rt/pure/__retain
      (local.get $0)
     )
    )
   )
   (local.set $3
    (call $~lib/rt/pure/__retain
     (local.get $0)
    )
   )
  )
  (call $~lib/rt/pure/__release
   (local.get $3)
  )
 )
 (func $eliminates.balancedInsideLoop (param $0 i32) (param $cond i32)
  (local $flat i32)
  (block $break|0
   (loop $continue|0
    (local.set $flat
     (i32.eqz
      (local.get $cond)
     )
    )
    (br_if $break|0
     (local.get $flat)
    )
    (local.set $0
     (call $~lib/rt/pure/__retain
      (local.get $0)
     )
    )
    (call $~lib/rt/pure/__release
     (local.get $0)
    )
    (br $continue|0)
   )
   (unreachable)
  )
 )
 (func $eliminates.balancedOutsideLoop (param $0 i32) (param $cond i32)
  (local $flat i32)
  (local.set $0
   (call $~lib/rt/pure/__retain
    (local.get $0)
   )
  )
  (block $break|0
   (loop $continue|0
    (local.set $flat
     (i32.eqz
      (local.get $cond)
     )
    )
    (br_if $break|0
     (local.get $flat)
    )
    (br $continue|0)
   )
   (unreachable)
  )
  (call $~lib/rt/pure/__release
   (local.get $0)
  )
 )
 (func $eliminates.balancedInsideOutsideLoop (param $0 i32) (param $cond i32)
  (local $flat i32)
  (local.set $0
   (call $~lib/rt/pure/__retain
    (local.get $0)
   )
  )
  (block $break|0
   (loop $continue|0
    (local.set $flat
     (i32.eqz
      (local.get $cond)
     )
    )
    (br_if $break|0
     (local.get $flat)
    )
    (call $~lib/rt/pure/__release
     (local.get $0)
    )
    (local.set $0
     (call $~lib/rt/pure/__retain
      (local.get $0)
     )
    )
    (br $continue|0)
   )
   (unreachable)
  )
  (call $~lib/rt/pure/__release
   (local.get $0)
  )
 )
 (func $eliminates.balancedInsideOutsideLoopWithBranch (param $0 i32) (param $cond1 i32) (param $cond2 i32)
  (local $flat i32)
  (local.set $0
   (call $~lib/rt/pure/__retain
    (local.get $0)
   )
  )
  (block $break|0
   (loop $continue|0
    (local.set $flat
     (i32.eqz
      (local.get $cond1)
     )
    )
    (br_if $break|0
     (local.get $flat)
    )
    (if
     (local.get $cond2)
     (block
      (call $~lib/rt/pure/__release
       (local.get $0)
      )
      (return)
     )
    )
    (call $~lib/rt/pure/__release
     (local.get $0)
    )
    (local.set $0
     (call $~lib/rt/pure/__retain
      (local.get $0)
     )
    )
    (br $continue|0)
   )
   (unreachable)
  )
  (call $~lib/rt/pure/__release
   (local.get $0)
  )
 )
 (func $eliminates.replace (param $0 i32) (param $1 i32)
  (local $2 i32)
  (local $3 i32)
  (local.set $0
   (call $~lib/rt/pure/__retain
    (local.get $0)
   )
  )
  (local.set $1
   (call $~lib/rt/pure/__retain
    (local.get $1)
   )
  )
  ;; flat
  (local.set $2
   (local.get $1)
  )
  (local.set $3
   (local.get $0)
  )
  ;; /flat
  (if
   (i32.ne
    (local.get $2) ;; flat (local.tee $2 (local.get $1))
    (local.get $3) ;; flat (local.tee $3 (local.get $0))
   )
   (local.set $2
    (call $~lib/rt/pure/__retain
     (local.get $2)
    )
   )
   (call $~lib/rt/pure/__release
    (local.get $3)
   )
  )
  (local.set $0
   (local.get $2)
  )
  (call $~lib/rt/pure/__release
   (local.get $0)
  )
  (call $~lib/rt/pure/__release
   (local.get $1)
  )
 )
 (import "rc" "getRetainedRef" (func $getRetainedRef (result i32)))
 (func $eliminates.replaceAlreadyRetained (param $0 i32) (result i32)
  (local $1 i32)
  (block
   (local.set $0
    (call $~lib/rt/pure/__retain
     (local.get $0)
    )
   )
   (local.set $1
    (call $getRetainedRef)
   )
   (call $~lib/rt/pure/__release
    (local.get $0)
   )
   (local.set $0
    (local.get $1)
   )
   (return
    (local.get $0)
   )
  )
 )
 (func $keeps.partialRetains (param $0 i32) (param $cond i32)
  (if
   (local.get $cond)
   (local.set $0
    (call $~lib/rt/pure/__retain
     (local.get $0)
    )
   )
  )
  (call $~lib/rt/pure/__release
   (local.get $0)
  )
 )
 (func $keeps.reachesReturn (param $0 i32) (param $cond i32) (result i32)
  (block
   (local.set $0
    (call $~lib/rt/pure/__retain
     (local.get $0)
    )
   )
   (if
    (local.get $cond)
    (return
     (local.get $0)
    )
   )
   (call $~lib/rt/pure/__release
    (local.get $0)
   )
   (return
    (i32.const 0)
   )
  )
 )
)
