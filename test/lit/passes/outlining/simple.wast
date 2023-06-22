(module
  (tag $catch_a (param i32))
  (func $d
		;; Block, Const 20, Drop, Const 10, Drop
    (block $block_a
      	(i32.add (i32.const 20) (i32.const 4))
      	(drop (i32.const 10))
	)
	(block $block_b
		(drop (if (i32.const 0)
		  (then
			(i32.const 40))
		  (else
			(i32.const 5))
		))
	)
	(block $block_c
		(try $try_a
			(do
			  (nop)
			)
			(catch $catch_a
				(drop
				  (i32.const 8)
				)
			)
		)
  	)
  )
)
