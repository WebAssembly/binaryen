	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/961125-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, 1
	i32.const	$4=, .L.str
.LBB0_1:                                # %land.rhs.i
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_3 Depth 2
	loop    	.LBB0_6
	i32.const	$push13=, 0
	i32.eq  	$push14=, $3, $pop13
	br_if   	$pop14, .LBB0_6
# BB#2:                                 # %while.cond2.preheader.i
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$0=, -1
	i32.const	$1=, .L.str+3
	block   	.LBB0_5
	i32.ge_u	$push0=, $4, $1
	br_if   	$pop0, .LBB0_5
.LBB0_3:                                # %land.rhs4.i
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	.LBB0_5
	i32.load8_u	$2=, 0($4)
	i32.const	$push1=, 1
	i32.add 	$4=, $4, $pop1
	i32.const	$push2=, 58
	i32.eq  	$push3=, $2, $pop2
	br_if   	$pop3, .LBB0_5
# BB#4:                                 # %land.rhs4.i
                                        #   in Loop: Header=BB0_3 Depth=2
	i32.lt_u	$push4=, $4, $1
	br_if   	$pop4, .LBB0_3
.LBB0_5:                                # %while.end.thread.i
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.add 	$3=, $3, $0
	i32.lt_u	$push5=, $4, $1
	br_if   	$pop5, .LBB0_1
.LBB0_6:                                # %begfield.exit
	block   	.LBB0_8
	i32.const	$push6=, 1
	i32.add 	$2=, $4, $pop6
	i32.const	$push7=, .L.str+3
	i32.gt_u	$push8=, $2, $pop7
	i32.select	$push9=, $pop8, $4, $2
	i32.const	$push10=, .L.str+2
	i32.ne  	$push11=, $pop9, $pop10
	br_if   	$pop11, .LBB0_8
# BB#7:                                 # %if.end
	i32.const	$push12=, 0
	call    	exit, $pop12
	unreachable
.LBB0_8:                                # %if.then
	call    	abort
	unreachable
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	":ab"
	.size	.L.str, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
