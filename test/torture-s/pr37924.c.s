	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr37924.c"
	.globl	test1
	.type	test1,@function
test1:                                  # @test1
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load8_s	$push1=, a($pop0)
	i32.const	$push2=, 9
	i32.shr_u	$push3=, $pop1, $pop2
	i32.const	$push4=, 8388607
	i32.xor 	$push5=, $pop3, $pop4
	return  	$pop5
.Lfunc_end0:
	.size	test1, .Lfunc_end0-test1

	.globl	test2
	.type	test2,@function
test2:                                  # @test2
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 8388607
	return  	$pop0
.Lfunc_end1:
	.size	test2, .Lfunc_end1-test2

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %if.end21
	i32.const	$0=, 0
	i32.const	$push0=, 255
	i32.store8	$push1=, a($0), $pop0
	i32.store8	$discard=, b($0), $pop1
	return  	$0
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.type	a,@object               # @a
	.bss
	.globl	a
a:
	.int8	0                       # 0x0
	.size	a, 1

	.type	b,@object               # @b
	.globl	b
b:
	.int8	0                       # 0x0
	.size	b, 1


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
