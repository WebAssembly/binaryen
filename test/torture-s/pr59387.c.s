	.text
	.file	"pr59387.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# %bb.0:                                # %entry
	i32.const	$1=, -19
	i32.const	$push6=, 0
	i32.const	$push5=, -19
	i32.store	a($pop6), $pop5
	i32.const	$push4=, 0
	i32.load8_u	$0=, c($pop4)
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label1:
	i32.const	$push10=, 0
	i32.load	$push0=, e($pop10)
	i32.const	$push9=, f
	i32.store	0($pop0), $pop9
	i32.const	$push8=, -24
	i32.add 	$0=, $0, $pop8
	i32.const	$push7=, 0
	i32.load	$push1=, d($pop7)
	i32.eqz 	$push15=, $pop1
	br_if   	1, $pop15       # 1: down to label0
# %bb.2:                                # %for.cond
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push12=, 1
	i32.add 	$1=, $1, $pop12
	i32.const	$push11=, 0
	i32.store	a($pop11), $1
	br_if   	0, $1           # 0: up to label1
.LBB0_3:                                # %return
	end_loop
	end_block                       # label0:
	i32.const	$push3=, 0
	i32.const	$push2=, 24
	i32.store	b($pop3), $pop2
	i32.const	$push14=, 0
	i32.store8	c($pop14), $0
	i32.const	$push13=, 0
                                        # fallthrough-return: $pop13
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
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


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
