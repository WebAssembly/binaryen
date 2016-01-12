	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/980618-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.section	.text.func,"ax",@progbits
	.hidden	func
	.globl	func
	.type	func,@function
func:                                   # @func
	.param  	i32, i32
# BB#0:                                 # %entry
	block   	.LBB1_2
	i32.ne  	$push0=, $0, $1
	br_if   	$pop0, .LBB1_2
# BB#1:                                 # %if.then
	return
.LBB1_2:                                # %if.else
	call    	abort@FUNCTION
	unreachable
.Lfunc_end1:
	.size	func, .Lfunc_end1-func


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
