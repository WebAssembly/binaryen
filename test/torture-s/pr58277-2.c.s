	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr58277-2.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push7=, 0
	i32.const	$push6=, 0
	i32.store8	n($pop7), $pop6
	block   	
	block   	
	i32.const	$push5=, 0
	i32.load	$push0=, g($pop5)
	i32.eqz 	$push16=, $pop0
	br_if   	0, $pop16       # 0: down to label1
# BB#1:                                 # %fn2.exit.thread.i
	i32.const	$push8=, 0
	i32.load	$drop=, d($pop8)
	br      	1               # 1: down to label0
.LBB0_2:                                # %for.body4.preheader.i
	end_block                       # label1:
	i32.const	$push11=, 0
	i32.const	$push1=, 1
	i32.store8	n($pop11), $pop1
	i32.const	$push10=, 0
	i32.load	$push2=, h($pop10)
	i32.const	$push9=, 0
	i32.store	0($pop2), $pop9
.LBB0_3:                                # %if.end
	end_block                       # label0:
	i32.const	$push3=, 0
	i32.load	$push4=, s($pop3)
	i32.const	$push15=, 0
	i32.store	0($pop4), $pop15
	i32.const	$push14=, 0
	i32.const	$push13=, 0
	i32.store8	n($pop14), $pop13
	i32.const	$push12=, 0
                                        # fallthrough-return: $pop12
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	n                       # @n
	.type	n,@object
	.section	.bss.n,"aw",@nobits
	.globl	n
n:
	.int8	0                       # 0x0
	.size	n, 1

	.hidden	d                       # @d
	.type	d,@object
	.section	.bss.d,"aw",@nobits
	.globl	d
	.p2align	2
d:
	.int32	0                       # 0x0
	.size	d, 4

	.hidden	r                       # @r
	.type	r,@object
	.section	.bss.r,"aw",@nobits
	.globl	r
	.p2align	2
r:
	.int32	0
	.size	r, 4

	.hidden	f                       # @f
	.type	f,@object
	.section	.bss.f,"aw",@nobits
	.globl	f
	.p2align	2
f:
	.int32	0                       # 0x0
	.size	f, 4

	.hidden	g                       # @g
	.type	g,@object
	.section	.bss.g,"aw",@nobits
	.globl	g
	.p2align	2
g:
	.int32	0                       # 0x0
	.size	g, 4

	.hidden	o                       # @o
	.type	o,@object
	.section	.bss.o,"aw",@nobits
	.globl	o
	.p2align	2
o:
	.int32	0                       # 0x0
	.size	o, 4

	.hidden	x                       # @x
	.type	x,@object
	.section	.bss.x,"aw",@nobits
	.globl	x
	.p2align	2
x:
	.int32	0                       # 0x0
	.size	x, 4

	.type	h,@object               # @h
	.section	.data.h,"aw",@progbits
	.p2align	2
h:
	.int32	f
	.size	h, 4

	.type	s,@object               # @s
	.section	.data.s,"aw",@progbits
	.p2align	2
s:
	.int32	r
	.size	s, 4


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
