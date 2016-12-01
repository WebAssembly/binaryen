	.text
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push1=, 0
	i32.load	$push0=, l($pop1)
	br_if   	0, $pop0        # 0: down to label0
# BB#1:                                 # %sw.bb
	i32.const	$push2=, 0
	call    	exit@FUNCTION, $pop2
	unreachable
.LBB0_2:                                # %sw.epilog
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	l                       # @l
	.type	l,@object
	.section	.data.l,"aw",@progbits
	.globl	l
	.p2align	2
l:
	.int32	0                       # 0x0
	.int32	1                       # 0x1
	.size	l, 8


	.functype	exit, void, i32
	.functype	abort, void
