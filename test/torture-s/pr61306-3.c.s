	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr61306-3.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	block
	i32.const	$push13=, 0
	i32.const	$push12=, 0
	i32.const	$push11=, 0
	i32.load16_s	$push1=, a($pop11)
	i32.store8	$push10=, c($pop12), $pop1
	tee_local	$push9=, $0=, $pop10
	i32.const	$push2=, 24
	i32.shl 	$push3=, $pop9, $pop2
	i32.const	$push8=, 24
	i32.shr_s	$push4=, $pop3, $pop8
	i32.or  	$push5=, $pop4, $0
	i32.store	$push0=, b($pop13), $pop5
	i32.const	$push6=, -1
	i32.ne  	$push7=, $pop0, $pop6
	br_if   	0, $pop7        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push14=, 0
	return  	$pop14
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	a                       # @a
	.type	a,@object
	.section	.data.a,"aw",@progbits
	.globl	a
	.p2align	1
a:
	.int16	65535                   # 0xffff
	.size	a, 2

	.hidden	c                       # @c
	.type	c,@object
	.section	.bss.c,"aw",@nobits
	.globl	c
c:
	.int8	0                       # 0x0
	.size	c, 1

	.hidden	b                       # @b
	.type	b,@object
	.section	.bss.b,"aw",@nobits
	.globl	b
	.p2align	2
b:
	.int32	0                       # 0x0
	.size	b, 4


	.ident	"clang version 3.9.0 "
	.functype	abort, void
