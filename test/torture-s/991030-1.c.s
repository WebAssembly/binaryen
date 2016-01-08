	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/991030-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	block   	.LBB0_2
	f64.load	$push0=, x($0)
	f64.const	$push1=, 0x1.fp1
	f64.eq  	$push2=, $pop0, $pop1
	br_if   	$pop2, .LBB0_2
# BB#1:                                 # %if.then
	call    	abort
	unreachable
.LBB0_2:                                # %if.end
	call    	exit, $0
	unreachable
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	x                       # @x
	.type	x,@object
	.section	.data.x,"aw",@progbits
	.globl	x
	.align	3
x:
	.int64	4615908143078047744     # double 3.875
	.size	x, 8


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
