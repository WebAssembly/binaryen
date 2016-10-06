	.text
	.file	"/tmp/tmpG0LbqO/a.out.bc"
	.type	_Z6reporti,@function
_Z6reporti:                             # @_Z6reporti
	.param  	i32
# BB#0:
	i32.const	$push0=, 8
	i32.store	0($pop0), $0
	i32.const	$push1=, .str
	call    	emscripten_asm_const@FUNCTION, $pop1
	return
	.endfunc
.Lfunc_end0:
	.size	_Z6reporti, .Lfunc_end0-_Z6reporti

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32 # XXX this was 1 short in the backend output, an extra one was added manually
# BB#0:
	i32.const	$7=, 0
	i32.load	$7=, 0($7)
	i32.const	$8=, 1048576
	i32.sub 	$12=, $7, $8
	i32.const	$8=, 0
	i32.store	0($8), $12
	i32.const	$1=, 0
	copy_local	$0=, $1
	copy_local	$6=, $1
.LBB1_1:                                  # %.preheader1
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop .LBB1_2 Depth 2
                                        #     Child Loop .LBB1_3 Depth 2
        block
	loop    	.LBB1_5
	copy_local	$4=, $1
.LBB1_2:                                  #   Parent Loop .LBB1_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
        block
	loop
	i32.const	$10=, 0
	i32.add 	$10=, $12, $10
	i32.add 	$push1=, $10, $4
	i32.add 	$push0=, $6, $4
	i32.store8	0($pop1), $pop0
	i32.const	$2=, 1
	i32.add 	$4=, $4, $2
	i32.const	$3=, 1048576
	i32.ne  	$push2=, $4, $3
	copy_local	$5=, $1
	br_if   	0, $pop2
	end_loop
        end_block
        block
	loop
	i32.const	$11=, 0
	i32.add 	$11=, $12, $11
	i32.add 	$push3=, $11, $5
	i32.load8_u	$push4=, 0($pop3)
	i32.and 	$push5=, $pop4, $2
	i32.add 	$6=, $pop5, $6
	i32.add 	$5=, $5, $2
	i32.ne  	$push6=, $5, $3
	br_if   	0, $pop6
	end_loop
        end_block
	i32.const	$push7=, 3
	i32.mul 	$push8=, $6, $pop7
	i32.const	$push9=, 5
	i32.div_s	$push10=, $6, $pop9
	i32.add 	$push11=, $pop8, $pop10
	i32.const	$push12=, 17
	i32.add 	$push13=, $pop11, $pop12
	i32.const	$push14=, 65535
	i32.and 	$6=, $pop13, $pop14
	i32.add 	$0=, $0, $2
	i32.const	$push15=, 100
	i32.ne  	$push16=, $0, $pop15
	br_if   	0, $pop16
	end_loop
        end_block
	call    	_Z6reporti@FUNCTION, $6
	i32.const	$push17=, 0
	i32.const	$9=, 1048576
	i32.add 	$12=, $12, $9
	i32.const	$9=, 0
	i32.store	0($9), $12
	return  	$pop17
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	.str,@object            # @.str
	.data
.str:
	.asciz	"{ Module.print(\"hello, world! \" + HEAP32[8>>2]); }"
	.size	.str, 51


