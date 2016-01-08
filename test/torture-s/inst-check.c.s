	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/inst-check.c"
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
	i32.const	$push0=, 1
	i32.lt_s	$push1=, $0, $pop0
	br_if   	$pop1, .LBB0_2
# BB#1:                                 # %for.body.preheader
	i32.const	$1=, -1
	i32.add 	$push2=, $0, $1
	i64.extend_u/i32	$push3=, $pop2
	i32.const	$push4=, -2
	i32.add 	$push5=, $0, $pop4
	i64.extend_u/i32	$push6=, $pop5
	i64.mul 	$push7=, $pop3, $pop6
	i64.const	$push8=, 1
	i64.shr_u	$push9=, $pop7, $pop8
	i32.wrap/i64	$push10=, $pop9
	i32.add 	$push11=, $pop10, $0
	i32.add 	$1=, $pop11, $1
.LBB0_2:                                # %for.end
	return  	$1
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
