	.text
	.file	"pr49712.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
# %bb.0:                                # %entry
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo
                                        # -- End function
	.section	.text.bar,"ax",@progbits
	.hidden	bar                     # -- Begin function bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.result 	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push4=, 0
	i32.load	$push0=, d($pop4)
	i32.const	$push3=, 0
	i32.le_s	$push1=, $pop0, $pop3
	br_if   	0, $pop1        # 0: down to label0
# %bb.1:                                # %for.end9
	i32.const	$push5=, 0
	return  	$pop5
.LBB1_2:                                # %for.body
	end_block                       # label0:
	i32.const	$push9=, 0
	i32.const	$push2=, 1
	i32.store	d($pop9), $pop2
	i32.const	$push8=, 0
	i32.const	$push7=, 0
	i32.store	e($pop8), $pop7
	i32.const	$push6=, 0
                                        # fallthrough-return: $pop6
	.endfunc
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push5=, 0
	i32.const	$push4=, 0
	i32.store	b($pop5), $pop4
	block   	
	i32.const	$push3=, 0
	i32.load	$push0=, c($pop3)
	i32.eqz 	$push11=, $pop0
	br_if   	0, $pop11       # 0: down to label1
# %bb.1:                                # %while.body.lr.ph
	i32.const	$push6=, 0
	i32.load	$0=, d($pop6)
.LBB2_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label2:
	i32.const	$push8=, 1
	i32.const	$push7=, 1
	i32.gt_s	$push1=, $0, $pop7
	i32.select	$0=, $0, $pop8, $pop1
	br      	0               # 0: up to label2
.LBB2_3:                                # %for.inc.1
	end_loop
	end_block                       # label1:
	i32.const	$push10=, 0
	i32.const	$push2=, 2
	i32.store	b($pop10), $pop2
	i32.const	$push9=, 0
                                        # fallthrough-return: $pop9
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function
	.hidden	d                       # @d
	.type	d,@object
	.section	.bss.d,"aw",@nobits
	.globl	d
	.p2align	2
d:
	.int32	0                       # 0x0
	.size	d, 4

	.hidden	e                       # @e
	.type	e,@object
	.section	.bss.e,"aw",@nobits
	.globl	e
	.p2align	2
e:
	.int32	0                       # 0x0
	.size	e, 4

	.hidden	b                       # @b
	.type	b,@object
	.section	.bss.b,"aw",@nobits
	.globl	b
	.p2align	2
b:
	.int32	0                       # 0x0
	.size	b, 4

	.hidden	c                       # @c
	.type	c,@object
	.section	.bss.c,"aw",@nobits
	.globl	c
	.p2align	2
c:
	.int32	0                       # 0x0
	.size	c, 4

	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.p2align	2
a:
	.skip	8
	.size	a, 8


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
