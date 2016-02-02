	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr20187-1.c"
	.section	.text.test,"ax",@progbits
	.hidden	test
	.globl	test
	.type	test,@function
test:                                   # @test
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push4=, b($pop0)
	i32.const	$push12=, 0
	i32.load	$push1=, a($pop12)
	tee_local	$push11=, $0=, $pop1
	i32.mul 	$push5=, $pop4, $pop11
	i32.const	$push2=, 1
	i32.select	$push3=, $0, $0, $pop2
	i32.and 	$push6=, $pop5, $pop3
	i32.const	$push7=, 255
	i32.and 	$push8=, $pop6, $pop7
	i32.const	$push10=, 0
	i32.eq  	$push9=, $pop8, $pop10
	return  	$pop9
	.endfunc
.Lfunc_end0:
	.size	test, .Lfunc_end0-test

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push4=, b($pop0)
	i32.const	$push12=, 0
	i32.load	$push1=, a($pop12)
	tee_local	$push11=, $0=, $pop1
	i32.mul 	$push5=, $pop4, $pop11
	i32.const	$push2=, 1
	i32.select	$push3=, $0, $0, $pop2
	i32.and 	$push6=, $pop5, $pop3
	i32.const	$push7=, 255
	i32.and 	$push8=, $pop6, $pop7
	i32.const	$push10=, 0
	i32.ne  	$push9=, $pop8, $pop10
	return  	$pop9
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	a                       # @a
	.type	a,@object
	.section	.data.a,"aw",@progbits
	.globl	a
	.p2align	2
a:
	.int32	257                     # 0x101
	.size	a, 4

	.hidden	b                       # @b
	.type	b,@object
	.section	.data.b,"aw",@progbits
	.globl	b
	.p2align	2
b:
	.int32	256                     # 0x100
	.size	b, 4


	.ident	"clang version 3.9.0 "
