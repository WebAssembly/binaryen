	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr58277-2.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	block
	block
	i32.const	$push1=, 0
	i32.const	$push9=, 0
	i32.store8	$push8=, n($pop1), $pop9
	tee_local	$push7=, $0=, $pop8
	i32.load	$push2=, g($pop7)
	i32.eqz 	$push13=, $pop2
	br_if   	0, $pop13       # 0: down to label1
# BB#1:                                 # %fn2.exit.thread.i
	i32.load	$drop=, d($0)
	br      	1               # 1: down to label0
.LBB0_2:                                # %if.end.loopexit.i
	end_block                       # label1:
	i32.const	$push3=, 1
	i32.store8	$drop=, n($0), $pop3
	i32.load	$push4=, h($0)
	i32.store	$drop=, 0($pop4), $0
.LBB0_3:                                # %if.end
	end_block                       # label0:
	i32.const	$push5=, 0
	i32.load	$push6=, s($pop5)
	i32.const	$push12=, 0
	i32.store	$push11=, 0($pop6), $pop12
	tee_local	$push10=, $0=, $pop11
	i32.store8	$push0=, n($pop10), $0
                                        # fallthrough-return: $pop0
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


	.ident	"clang version 3.9.0 "
