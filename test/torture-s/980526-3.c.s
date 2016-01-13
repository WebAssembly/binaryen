	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/980526-3.c"
	.section	.text.compare,"ax",@progbits
	.hidden	compare
	.globl	compare
	.type	compare,@function
compare:                                # @compare
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.ne  	$push0=, $0, $1
	return  	$pop0
.Lfunc_end0:
	.size	compare, .Lfunc_end0-compare

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.else
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
