	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20060110-1.c"
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i64
	.result 	i64
	.local  	i64
# BB#0:                                 # %entry
	i64.const	$1=, 32
	i64.shl 	$push0=, $0, $1
	i64.shr_s	$push1=, $pop0, $1
	return  	$pop1
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	block   	.LBB1_2
	i64.load32_s	$push0=, a($0)
	i64.load	$push1=, b($0)
	i64.ne  	$push2=, $pop0, $pop1
	br_if   	$pop2, .LBB1_2
# BB#1:                                 # %if.end
	return  	$0
.LBB1_2:                                  # %if.then
	call    	abort
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	a,@object               # @a
	.data
	.globl	a
	.align	3
a:
	.int64	1311768466852950544     # 0x1234567876543210
	.size	a, 8

	.type	b,@object               # @b
	.globl	b
	.align	3
b:
	.int64	1985229328              # 0x76543210
	.size	b, 8


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
