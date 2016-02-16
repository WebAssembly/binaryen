	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr57568.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	block
	block
	i32.const	$push3=, 0
	i32.load	$push0=, b($pop3)
	i32.const	$push8=, 0
	i32.eq  	$push9=, $pop0, $pop8
	br_if   	0, $pop9        # 0: down to label1
# BB#1:                                 # %land.lhs.true
	i32.const	$push6=, 0
	i32.load	$0=, c($pop6)
	i32.load	$push5=, 0($0)
	tee_local	$push4=, $1=, $pop5
	i32.const	$push1=, 1
	i32.shl 	$push2=, $pop4, $pop1
	i32.store	$discard=, 0($0), $pop2
	br_if   	1, $1           # 1: down to label0
.LBB0_2:                                # %if.end
	end_block                       # label1:
	i32.const	$push7=, 0
	return  	$pop7
.LBB0_3:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.p2align	4
a:
	.skip	216
	.size	a, 216

	.hidden	b                       # @b
	.type	b,@object
	.section	.data.b,"aw",@progbits
	.globl	b
	.p2align	2
b:
	.int32	1                       # 0x1
	.size	b, 4

	.hidden	c                       # @c
	.type	c,@object
	.section	.data.c,"aw",@progbits
	.globl	c
	.p2align	2
c:
	.int32	a+128
	.size	c, 4


	.ident	"clang version 3.9.0 "
