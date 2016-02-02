	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr58662.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push19=, 0
	i32.const	$push18=, 0
	i32.load	$push8=, c($pop18)
	i32.const	$push17=, 0
	i32.ne  	$push9=, $pop8, $pop17
	i32.const	$push16=, 0
	i32.const	$push15=, 0
	i32.load	$push0=, a($pop15)
	i32.const	$push14=, 0
	i32.eq  	$push1=, $pop0, $pop14
	i32.const	$push2=, -30000
	i32.div_s	$push3=, $pop1, $pop2
	i32.store	$push4=, d($pop16), $pop3
	i32.const	$push5=, 14
	i32.rem_s	$push6=, $pop4, $pop5
	i32.const	$push13=, 0
	i32.ne  	$push7=, $pop6, $pop13
	i32.and 	$push10=, $pop9, $pop7
	i32.store	$discard=, b($pop19), $pop10
	block
	i32.const	$push12=, 0
	i32.load	$push11=, b($pop12)
	br_if   	$pop11, 0       # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push20=, 0
	return  	$pop20
.LBB0_2:                                # %if.then
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
	.p2align	2
a:
	.int32	0                       # 0x0
	.size	a, 4

	.hidden	d                       # @d
	.type	d,@object
	.section	.bss.d,"aw",@nobits
	.globl	d
	.p2align	2
d:
	.int32	0                       # 0x0
	.size	d, 4

	.hidden	c                       # @c
	.type	c,@object
	.section	.bss.c,"aw",@nobits
	.globl	c
	.p2align	2
c:
	.int32	0                       # 0x0
	.size	c, 4

	.hidden	b                       # @b
	.type	b,@object
	.section	.bss.b,"aw",@nobits
	.globl	b
	.p2align	2
b:
	.int32	0                       # 0x0
	.size	b, 4


	.ident	"clang version 3.9.0 "
