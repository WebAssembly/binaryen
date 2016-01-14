	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr57568.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	block
	i32.load	$push0=, b($0)
	i32.const	$push3=, 0
	i32.eq  	$push4=, $pop0, $pop3
	br_if   	$pop4, 0        # 0: down to label0
# BB#1:                                 # %land.lhs.true
	i32.load	$1=, c($0)
	i32.load	$2=, 0($1)
	i32.const	$push1=, 1
	i32.shl 	$push2=, $2, $pop1
	i32.store	$discard=, 0($1), $pop2
	i32.const	$push5=, 0
	i32.eq  	$push6=, $2, $pop5
	br_if   	$pop6, 0        # 0: down to label0
# BB#2:                                 # %if.then
	call    	abort@FUNCTION
	unreachable
.LBB0_3:                                # %if.end
	end_block                       # label0:
	return  	$0
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.align	4
a:
	.skip	216
	.size	a, 216

	.hidden	b                       # @b
	.type	b,@object
	.section	.data.b,"aw",@progbits
	.globl	b
	.align	2
b:
	.int32	1                       # 0x1
	.size	b, 4

	.hidden	c                       # @c
	.type	c,@object
	.section	.data.c,"aw",@progbits
	.globl	c
	.align	2
c:
	.int32	a+128
	.size	c, 4


	.ident	"clang version 3.9.0 "
	.section	".note.GNU-stack","",@progbits
