	.text
	.file	"pr58831.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
	call    	fn2@FUNCTION
	i32.const	$push1=, 0
	i32.const	$push0=, r
	i32.store	i($pop1), $pop0
	i32.const	$push4=, 0
	i32.load	$push2=, b($pop4)
	call    	fn1@FUNCTION, $pop2
	i32.const	$push3=, 0
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.section	.text.fn2,"ax",@progbits
	.type	fn2,@function           # -- Begin function fn2
fn2:                                    # @fn2
# %bb.0:                                # %entry
	i32.const	$push1=, 0
	i32.const	$push0=, 42
	i32.store	f($pop1), $pop0
	i32.const	$push3=, 0
	i32.const	$push2=, 0
	i32.store16	o($pop3), $pop2
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	fn2, .Lfunc_end1-fn2
                                        # -- End function
	.section	.text.fn1,"ax",@progbits
	.type	fn1,@function           # -- Begin function fn1
fn1:                                    # @fn1
	.param  	i32
	.local  	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push3=, 0
	i32.load	$push0=, p($pop3)
	i32.eqz 	$push11=, $pop0
	br_if   	0, $pop11       # 0: down to label0
# %bb.1:                                # %for.body.preheader
.LBB2_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.const	$push7=, 1
	i32.store	0($0), $pop7
	i32.const	$push6=, 0
	i32.load	$push1=, p($pop6)
	i32.const	$push5=, 1
	i32.add 	$1=, $pop1, $pop5
	i32.const	$push4=, 0
	i32.store	p($pop4), $1
	br_if   	0, $1           # 0: up to label1
.LBB2_3:                                # %for.end
	end_loop
	end_block                       # label0:
	i32.const	$push10=, 0
	i32.const	$push2=, d
	i32.store	b($pop10), $pop2
	i32.const	$push9=, 0
	i32.const	$push8=, d
	i32.store	r($pop9), $pop8
                                        # fallthrough-return
	.endfunc
.Lfunc_end2:
	.size	fn1, .Lfunc_end2-fn1
                                        # -- End function
	.hidden	i                       # @i
	.type	i,@object
	.section	.bss.i,"aw",@nobits
	.globl	i
	.p2align	2
i:
	.int32	0
	.size	i, 4

	.hidden	b                       # @b
	.type	b,@object
	.section	.bss.b,"aw",@nobits
	.globl	b
	.p2align	2
b:
	.int32	0
	.size	b, 4

	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.p2align	2
a:
	.int32	0                       # 0x0
	.size	a, 4

	.hidden	c                       # @c
	.type	c,@object
	.section	.bss.c,"aw",@nobits
	.globl	c
	.p2align	2
c:
	.int32	0                       # 0x0
	.size	c, 4

	.hidden	d                       # @d
	.type	d,@object
	.section	.bss.d,"aw",@nobits
	.globl	d
	.p2align	2
d:
	.int32	0                       # 0x0
	.size	d, 4

	.hidden	f                       # @f
	.type	f,@object
	.section	.bss.f,"aw",@nobits
	.globl	f
	.p2align	2
f:
	.int32	0                       # 0x0
	.size	f, 4

	.hidden	p                       # @p
	.type	p,@object
	.section	.bss.p,"aw",@nobits
	.globl	p
	.p2align	2
p:
	.int32	0                       # 0x0
	.size	p, 4

	.hidden	q                       # @q
	.type	q,@object
	.section	.bss.q,"aw",@nobits
	.globl	q
	.p2align	2
q:
	.int32	0                       # 0x0
	.size	q, 4

	.hidden	r                       # @r
	.type	r,@object
	.section	.bss.r,"aw",@nobits
	.globl	r
	.p2align	2
r:
	.int32	0
	.size	r, 4

	.hidden	o                       # @o
	.type	o,@object
	.section	.bss.o,"aw",@nobits
	.globl	o
	.p2align	1
o:
	.int16	0                       # 0x0
	.size	o, 2

	.hidden	j                       # @j
	.type	j,@object
	.section	.bss.j,"aw",@nobits
	.globl	j
	.p2align	1
j:
	.int16	0                       # 0x0
	.size	j, 2


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
