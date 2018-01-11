	.text
	.file	"pr57281.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.load	$1=, b($pop0)
	i32.const	$push5=, 0
	i32.load	$push1=, g($pop5)
	i64.extend_s/i32	$push2=, $1
	i64.store	0($pop1), $pop2
	i32.const	$push4=, 0
	i32.select	$push3=, $pop4, $1, $0
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push7=, 0
	i32.load	$push0=, b($pop7)
	i32.const	$push6=, -20
	i32.eq  	$push1=, $pop0, $pop6
	br_if   	0, $pop1        # 0: down to label0
# %bb.1:                                # %for.body.lr.ph
	i32.const	$push10=, 0
	i32.load	$2=, g($pop10)
	i32.const	$push9=, 0
	i32.load	$1=, e($pop9)
	i32.const	$push8=, 0
	i32.load	$0=, a($pop8)
.LBB1_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.const	$push18=, 0
	i32.store	0($1), $pop18
	i32.const	$push17=, 0
	i32.load	$3=, b($pop17)
	i32.const	$push16=, 0
	i32.select	$push2=, $pop16, $3, $0
	i32.store	0($1), $pop2
	i32.const	$push15=, 0
	i64.load	$drop=, f($pop15)
	i64.extend_s/i32	$push3=, $3
	i64.store	0($2), $pop3
	i32.const	$push14=, 0
	i32.load	$push4=, b($pop14)
	i32.const	$push13=, -1
	i32.add 	$3=, $pop4, $pop13
	i32.const	$push12=, 0
	i32.store	b($pop12), $3
	i32.const	$push11=, -20
	i32.ne  	$push5=, $3, $pop11
	br_if   	0, $pop5        # 0: up to label1
.LBB1_3:                                # %for.end
	end_loop
	end_block                       # label0:
	i32.const	$push19=, 0
                                        # fallthrough-return: $pop19
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	a                       # @a
	.type	a,@object
	.section	.data.a,"aw",@progbits
	.globl	a
	.p2align	2
a:
	.int32	1                       # 0x1
	.size	a, 4

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
	.section	.data.e,"aw",@progbits
	.globl	e
	.p2align	2
e:
	.int32	d
	.size	e, 4

	.hidden	c                       # @c
	.type	c,@object
	.section	.bss.c,"aw",@nobits
	.globl	c
	.p2align	3
c:
	.int64	0                       # 0x0
	.size	c, 8

	.hidden	g                       # @g
	.type	g,@object
	.section	.data.g,"aw",@progbits
	.globl	g
	.p2align	2
g:
	.int32	c
	.size	g, 4

	.hidden	b                       # @b
	.type	b,@object
	.section	.bss.b,"aw",@nobits
	.globl	b
	.p2align	2
b:
	.int32	0                       # 0x0
	.size	b, 4

	.hidden	f                       # @f
	.type	f,@object
	.section	.bss.f,"aw",@nobits
	.globl	f
	.p2align	3
f:
	.int64	0                       # 0x0
	.size	f, 8


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
