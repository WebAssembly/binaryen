	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/961125-1.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, 1
	i32.const	$5=, .str
BB0_1:                                  # %land.rhs.i
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_3 Depth 2
	loop    	BB0_6
	i32.const	$push16=, 0
	i32.eq  	$push17=, $3, $pop16
	br_if   	$pop17, BB0_6
# BB#2:                                 # %while.cond2.preheader.i
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$0=, -1
	i32.const	$1=, 0
	i32.const	$2=, .str+3
	copy_local	$4=, $1
	block   	BB0_5
	i32.ge_u	$push0=, $5, $2
	br_if   	$pop0, BB0_5
BB0_3:                                  # %land.rhs4.i
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	BB0_5
	i32.const	$4=, 1
	i32.load8_u	$push1=, 0($5)
	i32.const	$push2=, 58
	i32.eq  	$push3=, $pop1, $pop2
	br_if   	$pop3, BB0_5
# BB#4:                                 # %while.body8.i
                                        #   in Loop: Header=BB0_3 Depth=2
	i32.const	$push4=, 1
	i32.add 	$5=, $5, $pop4
	copy_local	$4=, $1
	i32.lt_u	$push5=, $5, $2
	br_if   	$pop5, BB0_3
BB0_5:                                  # %while.end.i
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push6=, 1
	i32.add 	$push7=, $5, $pop6
	i32.select	$5=, $4, $pop7, $5
	i32.add 	$3=, $3, $0
	i32.lt_u	$push8=, $5, $2
	br_if   	$pop8, BB0_1
BB0_6:                                  # %begfield.exit
	block   	BB0_8
	i32.const	$push9=, 1
	i32.add 	$4=, $5, $pop9
	i32.const	$push10=, .str+3
	i32.gt_u	$push11=, $4, $pop10
	i32.select	$push12=, $pop11, $5, $4
	i32.const	$push13=, .str+2
	i32.ne  	$push14=, $pop12, $pop13
	br_if   	$pop14, BB0_8
# BB#7:                                 # %if.end
	i32.const	$push15=, 0
	call    	exit, $pop15
	unreachable
BB0_8:                                  # %if.then
	call    	abort
	unreachable
func_end0:
	.size	main, func_end0-main

	.type	.str,@object            # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.str:
	.asciz	":ab"
	.size	.str, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
