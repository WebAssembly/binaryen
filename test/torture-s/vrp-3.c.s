	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/vrp-3.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$1=, 1
	block   	.LBB0_2
	i32.const	$push0=, 14
	i32.add 	$push1=, $0, $pop0
	i32.const	$push2=, 25
	i32.gt_u	$push3=, $pop1, $pop2
	br_if   	$pop3, .LBB0_2
# BB#1:                                 # %if.then2
	i32.const	$push4=, 31
	i32.shr_s	$1=, $0, $pop4
	i32.add 	$push5=, $0, $1
	i32.xor 	$push6=, $pop5, $1
	i32.const	$push7=, 2
	i32.ne  	$1=, $pop6, $pop7
.LBB0_2:                                # %return
	return  	$1
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
