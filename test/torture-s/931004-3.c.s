	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/931004-3.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32, i32, i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$5=, 65535
	block   	.LBB0_8
	i32.and 	$push0=, $1, $5
	i32.const	$push1=, 10
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	$pop2, .LBB0_8
# BB#1:                                 # %if.end
	block   	.LBB0_7
	i32.and 	$push3=, $2, $5
	i32.const	$push4=, 11
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	$pop5, .LBB0_7
# BB#2:                                 # %if.end9
	block   	.LBB0_6
	i32.and 	$push6=, $3, $5
	i32.const	$push7=, 12
	i32.ne  	$push8=, $pop6, $pop7
	br_if   	$pop8, .LBB0_6
# BB#3:                                 # %if.end15
	block   	.LBB0_5
	i32.const	$push9=, 123
	i32.ne  	$push10=, $4, $pop9
	br_if   	$pop10, .LBB0_5
# BB#4:                                 # %if.end19
	return  	$5
.LBB0_5:                                # %if.then18
	call    	abort
	unreachable
.LBB0_6:                                # %if.then14
	call    	abort
	unreachable
.LBB0_7:                                # %if.then8
	call    	abort
	unreachable
.LBB0_8:                                # %if.then
	call    	abort
	unreachable
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
