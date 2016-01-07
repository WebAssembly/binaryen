	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20060110-2.c"
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i64, i64
	.result 	i64
	.local  	i64
# BB#0:                                 # %entry
	i64.const	$2=, 32
	i64.add 	$push0=, $1, $0
	i64.shl 	$push1=, $pop0, $2
	i64.shr_s	$push2=, $pop1, $2
	return  	$pop2
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i64
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i64.const	$1=, 32
	block   	.LBB1_2
	i64.load	$push1=, b($0)
	i64.load	$push0=, a($0)
	i64.add 	$push2=, $pop1, $pop0
	i64.shl 	$push3=, $pop2, $1
	i64.shr_s	$push4=, $pop3, $1
	i64.load	$push5=, c($0)
	i64.ne  	$push6=, $pop4, $pop5
	br_if   	$pop6, .LBB1_2
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
	.int64	2541551395937657089     # 0x2345678765432101
	.size	b, 8

	.type	c,@object               # @c
	.globl	c
	.align	3
c:
	.int64	-610839791              # 0xffffffffdb975311
	.size	c, 8


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
