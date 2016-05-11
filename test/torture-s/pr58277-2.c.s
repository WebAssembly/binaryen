	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr58277-2.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push2=, 0
	i32.load	$1=, g($pop2)
	i32.const	$push8=, 0
	i32.const	$push7=, 0
	i32.store8	$0=, n($pop8), $pop7
	block
	block
	i32.const	$push12=, 0
	i32.eq  	$push13=, $1, $pop12
	br_if   	0, $pop13       # 0: down to label1
# BB#1:                                 # %fn2.exit.thread.i
	i32.load	$discard=, d($0)
	br      	1               # 1: down to label0
.LBB0_2:                                # %if.end.loopexit.i
	end_block                       # label1:
	i32.load	$push3=, h($0)
	i32.store	$push0=, 0($pop3), $0
	i32.const	$push4=, 1
	i32.store8	$discard=, n($pop0), $pop4
.LBB0_3:                                # %if.end
	end_block                       # label0:
	i32.const	$push5=, 0
	i32.load	$push6=, s($pop5)
	i32.const	$push11=, 0
	i32.store	$push10=, 0($pop6), $pop11
	tee_local	$push9=, $0=, $pop10
	i32.store8	$push1=, n($pop9), $0
	return  	$pop1
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
