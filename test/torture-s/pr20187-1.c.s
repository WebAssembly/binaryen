	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr20187-1.c"
	.section	.text.test,"ax",@progbits
	.hidden	test
	.globl	test
	.type	test,@function
test:                                   # @test
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.load	$1=, a($0)
	i32.load	$push2=, b($0)
	i32.mul 	$push3=, $pop2, $1
	i32.const	$push0=, 1
	i32.select	$push1=, $1, $1, $pop0
	i32.and 	$push4=, $pop3, $pop1
	i32.const	$push5=, 255
	i32.and 	$push6=, $pop4, $pop5
	i32.eq  	$push7=, $pop6, $0
	return  	$pop7
.Lfunc_end0:
	.size	test, .Lfunc_end0-test

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.load	$1=, a($0)
	i32.load	$push2=, b($0)
	i32.mul 	$push3=, $pop2, $1
	i32.const	$push0=, 1
	i32.select	$push1=, $1, $1, $pop0
	i32.and 	$push4=, $pop3, $pop1
	i32.const	$push5=, 255
	i32.and 	$push6=, $pop4, $pop5
	i32.ne  	$push7=, $pop6, $0
	return  	$pop7
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	a                       # @a
	.type	a,@object
	.section	.data.a,"aw",@progbits
	.globl	a
	.align	2
a:
	.int32	257                     # 0x101
	.size	a, 4

	.hidden	b                       # @b
	.type	b,@object
	.section	.data.b,"aw",@progbits
	.globl	b
	.align	2
b:
	.int32	256                     # 0x100
	.size	b, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
