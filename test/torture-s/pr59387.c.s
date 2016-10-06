	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr59387.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, -19
	i32.const	$push6=, 0
	i32.const	$push5=, -19
	i32.store	a($pop6), $pop5
	i32.const	$push4=, 0
	i32.load8_u	$1=, c($pop4)
.LBB0_1:                                # %for.cond1.preheader
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label1:
	i32.const	$push10=, 0
	i32.load	$push0=, e($pop10)
	i32.const	$push9=, f
	i32.store	0($pop0), $pop9
	i32.const	$push8=, -24
	i32.add 	$1=, $1, $pop8
	i32.const	$push7=, 0
	i32.load	$push1=, d($pop7)
	i32.eqz 	$push17=, $pop1
	br_if   	1, $pop17       # 1: down to label0
# BB#2:                                 # %for.inc4
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push14=, 0
	i32.const	$push13=, 1
	i32.add 	$push12=, $0, $pop13
	tee_local	$push11=, $0=, $pop12
	i32.store	a($pop14), $pop11
	br_if   	0, $0           # 0: up to label1
.LBB0_3:                                # %return
	end_loop
	end_block                       # label0:
	i32.const	$push3=, 0
	i32.const	$push2=, 24
	i32.store	b($pop3), $pop2
	i32.const	$push16=, 0
	i32.store8	c($pop16), $1
	i32.const	$push15=, 0
                                        # fallthrough-return: $pop15
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	d                       # @d
	.type	d,@object
	.section	.bss.d,"aw",@nobits
	.globl	d
	.p2align	2
d:
	.int32	0
	.size	d, 4

	.hidden	e                       # @e
	.type	e,@object
	.section	.data.e,"aw",@progbits
	.globl	e
	.p2align	2
e:
	.int32	d
	.size	e, 4

	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.p2align	2
a:
	.int32	0                       # 0x0
	.size	a, 4

	.hidden	b                       # @b
	.type	b,@object
	.section	.bss.b,"aw",@nobits
	.globl	b
	.p2align	2
b:
	.skip	4
	.size	b, 4

	.hidden	c                       # @c
	.type	c,@object
	.section	.bss.c,"aw",@nobits
	.globl	c
c:
	.int8	0                       # 0x0
	.size	c, 1

	.hidden	f                       # @f
	.type	f,@object
	.section	.bss.f,"aw",@nobits
	.globl	f
	.p2align	2
f:
	.int32	0                       # 0x0
	.size	f, 4


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
