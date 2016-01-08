	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20031216-1.c"
	.section	.text.DisplayNumber,"ax",@progbits
	.hidden	DisplayNumber
	.globl	DisplayNumber
	.type	DisplayNumber,@function
DisplayNumber:                          # @DisplayNumber
	.param  	i32
# BB#0:                                 # %entry
	block   	.LBB0_2
	i32.const	$push0=, 154
	i32.ne  	$push1=, $0, $pop0
	br_if   	$pop1, .LBB0_2
# BB#1:                                 # %if.end
	return
.LBB0_2:                                # %if.then
	call    	abort
	unreachable
.Lfunc_end0:
	.size	DisplayNumber, .Lfunc_end0-DisplayNumber

	.section	.text.ReadNumber,"ax",@progbits
	.hidden	ReadNumber
	.globl	ReadNumber
	.type	ReadNumber,@function
ReadNumber:                             # @ReadNumber
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 10092544
	return  	$pop0
.Lfunc_end1:
	.size	ReadNumber, .Lfunc_end1-ReadNumber

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	return  	$pop0
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
