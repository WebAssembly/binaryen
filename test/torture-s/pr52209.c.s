	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr52209.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push11=, 0
	i32.const	$push10=, 0
	i32.load8_u	$push0=, c($pop10):p2align=2
	tee_local	$push9=, $0=, $pop0
	i32.const	$push1=, 31
	i32.shl 	$push2=, $pop9, $pop1
	i32.const	$push8=, 31
	i32.shr_s	$push3=, $pop2, $pop8
	i32.const	$push4=, -1
	i32.xor 	$push5=, $pop3, $pop4
	i32.store	$discard=, b($pop11), $pop5
	block
	i32.const	$push6=, 1
	i32.and 	$push7=, $0, $pop6
	br_if   	0, $pop7        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push12=, 0
	return  	$pop12
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	c                       # @c
	.type	c,@object
	.section	.bss.c,"aw",@nobits
	.globl	c
	.p2align	2
c:
	.skip	4
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
