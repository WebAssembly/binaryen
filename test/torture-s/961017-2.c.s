	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/961017-2.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
.LBB0_1:                                # %do.cond
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB0_2
	i32.const	$push0=, 16384
	i32.add 	$0=, $0, $pop0
	br_if   	$0, .LBB0_1
.LBB0_2:                                # %do.end
	i32.const	$push1=, 0
	call    	exit@FUNCTION, $pop1
	unreachable
.Lfunc_end0:
	.size	main, .Lfunc_end0-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
