	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr57321.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push3=, 0
	i32.load	$push0=, a($pop3)
	br_if   	0, $pop0        # 0: down to label0
# BB#1:                                 # %if.then.i
	i32.const	$push4=, 0
	i32.load	$push1=, b($pop4)
	i32.const	$push2=, 1
	i32.store	0($pop1), $pop2
.LBB0_2:                                # %foo.exit
	end_block                       # label0:
	i32.const	$push5=, 0
                                        # fallthrough-return: $pop5
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	a                       # @a
	.type	a,@object
	.section	.data.a,"aw",@progbits
	.globl	a
	.p2align	2
a:
	.int32	1                       # 0x1
	.size	a, 4

	.hidden	b                       # @b
	.type	b,@object
	.section	.bss.b,"aw",@nobits
	.globl	b
	.p2align	2
b:
	.int32	0
	.size	b, 4

	.hidden	c                       # @c
	.type	c,@object
	.section	.bss.c,"aw",@nobits
	.globl	c
	.p2align	2
c:
	.int32	0
	.size	c, 4


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
