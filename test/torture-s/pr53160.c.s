	.text
	.file	"pr53160.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.const	$push1=, 0
	i32.store	e($pop0), $pop1
                                        # fallthrough-return
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
	.local  	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push4=, 0
	i32.load	$push0=, g($pop4)
	i32.eqz 	$push15=, $pop0
	br_if   	0, $pop15       # 0: down to label0
# %bb.1:                                # %if.then
	i32.const	$push5=, 0
	i32.load	$drop=, b($pop5)
.LBB1_2:                                # %if.end
	end_block                       # label0:
	i32.const	$push14=, 0
	i32.const	$push1=, -1
	i32.store	d($pop14), $pop1
	i32.const	$push13=, 0
	i32.load8_s	$0=, f($pop13)
	i32.const	$push12=, 0
	i32.store16	i($pop12), $0
	i32.const	$push11=, 0
	i32.const	$push10=, 0
	i32.load	$push2=, c($pop10)
	i32.select	$0=, $0, $pop11, $pop2
	i32.const	$push9=, 0
	i32.store	h($pop9), $0
	i32.const	$push8=, 0
	i32.store	a($pop8), $0
	i32.const	$push7=, 0
	i32.const	$push6=, 0
	i32.store	e($pop7), $pop6
	block   	
	br_if   	0, $0           # 0: down to label1
# %bb.3:                                # %if.end16
	i32.const	$push3=, 0
	return  	$pop3
.LBB1_4:                                # %if.then15
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	c                       # @c
	.type	c,@object
	.section	.data.c,"aw",@progbits
	.globl	c
	.p2align	2
c:
	.int32	1                       # 0x1
	.size	c, 4

	.hidden	e                       # @e
	.type	e,@object
	.section	.bss.e,"aw",@nobits
	.globl	e
	.p2align	2
e:
	.int32	0                       # 0x0
	.size	e, 4

	.hidden	g                       # @g
	.type	g,@object
	.section	.bss.g,"aw",@nobits
	.globl	g
	.p2align	2
g:
	.int32	0                       # 0x0
	.size	g, 4

	.hidden	b                       # @b
	.type	b,@object
	.section	.bss.b,"aw",@nobits
	.globl	b
	.p2align	2
b:
	.int32	0                       # 0x0
	.size	b, 4

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
f:
	.int8	0                       # 0x0
	.size	f, 1

	.hidden	i                       # @i
	.type	i,@object
	.section	.bss.i,"aw",@nobits
	.globl	i
	.p2align	1
i:
	.int16	0                       # 0x0
	.size	i, 2

	.hidden	h                       # @h
	.type	h,@object
	.section	.bss.h,"aw",@nobits
	.globl	h
	.p2align	2
h:
	.int32	0                       # 0x0
	.size	h, 4

	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.p2align	2
a:
	.int32	0                       # 0x0
	.size	a, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
