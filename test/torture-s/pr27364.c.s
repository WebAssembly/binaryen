	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr27364.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	block   	.LBB0_2
	i32.const	$push0=, 1294
	i32.gt_u	$push1=, $0, $pop0
	br_if   	$pop1, .LBB0_2
# BB#1:                                 # %if.end
	i32.const	$push2=, 3321928
	i32.mul 	$push3=, $0, $pop2
	i32.const	$push4=, 1000000
	i32.div_u	$push5=, $pop3, $pop4
	i32.const	$push6=, 1
	i32.add 	$push7=, $pop5, $pop6
	i32.const	$push8=, 4
	i32.shr_u	$1=, $pop7, $pop8
.LBB0_2:                                # %return
	return  	$1
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
