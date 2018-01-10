	.text
	.file	"pr58640.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
	call    	foo@FUNCTION
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.section	.text.foo,"ax",@progbits
	.type	foo,@function           # -- Begin function foo
foo:                                    # @foo
	.local  	i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push7=, 0
	i32.load	$2=, b($pop7)
	block   	
	i32.const	$push6=, 0
	i32.le_s	$push0=, $2, $pop6
	br_if   	0, $pop0        # 0: down to label0
# %bb.1:                                # %cleanup
	return
.LBB1_2:                                # %for.body3.lr.ph
	end_block                       # label0:
	block   	
	i32.const	$push8=, 0
	i32.load	$push1=, d($pop8)
	i32.eqz 	$push12=, $pop1
	br_if   	0, $pop12       # 0: down to label1
# %bb.3:                                # %if.then.split
	i32.const	$push3=, 0
	i32.const	$push2=, 4
	i32.store	c($pop3), $pop2
	i32.const	$push9=, 0
	i32.const	$push4=, 1
	i32.store	e($pop9), $pop4
	return
.LBB1_4:                                # %for.body3.preheader
	end_block                       # label1:
.LBB1_5:                                # %for.body3
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label2:
	i32.const	$push11=, 1
	i32.add 	$0=, $2, $pop11
	i32.const	$push10=, 0
	i32.lt_s	$1=, $2, $pop10
	copy_local	$2=, $0
	br_if   	0, $1           # 0: up to label2
# %bb.6:                                # %for.inc28
	end_loop
	i32.const	$push5=, 0
	i32.store	b($pop5), $0
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo
                                        # -- End function
	.hidden	d                       # @d
	.type	d,@object
	.section	.data.d,"aw",@progbits
	.globl	d
	.p2align	2
d:
	.int32	1                       # 0x1
	.size	d, 4

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

	.hidden	e                       # @e
	.type	e,@object
	.section	.bss.e,"aw",@nobits
	.globl	e
	.p2align	2
e:
	.int32	0                       # 0x0
	.size	e, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	exit, void, i32
