	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20031216-1.c"
	.globl	DisplayNumber
	.type	DisplayNumber,@function
DisplayNumber:                          # @DisplayNumber
	.param  	i32
# BB#0:                                 # %entry
	block   	BB0_2
	i32.const	$push0=, 154
	i32.ne  	$push1=, $0, $pop0
	br_if   	$pop1, BB0_2
# BB#1:                                 # %if.end
	return
BB0_2:                                  # %if.then
	call    	abort
	unreachable
func_end0:
	.size	DisplayNumber, func_end0-DisplayNumber

	.globl	ReadNumber
	.type	ReadNumber,@function
ReadNumber:                             # @ReadNumber
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 10092544
	return  	$pop0
func_end1:
	.size	ReadNumber, func_end1-ReadNumber

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	return  	$pop0
func_end2:
	.size	main, func_end2-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
