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
	i32.const	$0=, 0
	i32.store8	$discard=, n($0), $0
	block
	block
	i32.load	$push0=, g($0)
	i32.const	$push6=, 0
	i32.eq  	$push7=, $pop0, $pop6
	br_if   	$pop7, 0        # 0: down to label1
# BB#1:                                 # %fn2.exit.thread.i
	i32.load	$discard=, d($0)
	br      	1               # 1: down to label0
.LBB0_2:                                # %if.end.loopexit.i
	end_block                       # label1:
	i32.load	$push1=, h($0)
	i32.store	$push2=, 0($pop1), $0
	i32.const	$push3=, 1
	i32.store8	$discard=, n($pop2), $pop3
.LBB0_3:                                # %if.end
	end_block                       # label0:
	i32.load	$push4=, s($0)
	i32.store	$discard=, 0($pop4), $0
	i32.store8	$push5=, n($0), $0
	return  	$pop5
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
	.align	2
d:
	.int32	0                       # 0x0
	.size	d, 4

	.hidden	r                       # @r
	.type	r,@object
	.section	.bss.r,"aw",@nobits
	.globl	r
	.align	2
r:
	.int32	0
	.size	r, 4

	.hidden	f                       # @f
	.type	f,@object
	.section	.bss.f,"aw",@nobits
	.globl	f
	.align	2
f:
	.int32	0                       # 0x0
	.size	f, 4

	.hidden	g                       # @g
	.type	g,@object
	.section	.bss.g,"aw",@nobits
	.globl	g
	.align	2
g:
	.int32	0                       # 0x0
	.size	g, 4

	.hidden	o                       # @o
	.type	o,@object
	.section	.bss.o,"aw",@nobits
	.globl	o
	.align	2
o:
	.int32	0                       # 0x0
	.size	o, 4

	.hidden	x                       # @x
	.type	x,@object
	.section	.bss.x,"aw",@nobits
	.globl	x
	.align	2
x:
	.int32	0                       # 0x0
	.size	x, 4

	.type	h,@object               # @h
	.section	.data.h,"aw",@progbits
	.align	2
h:
	.int32	f
	.size	h, 4

	.type	s,@object               # @s
	.section	.data.s,"aw",@progbits
	.align	2
s:
	.int32	r
	.size	s, 4


	.ident	"clang version 3.9.0 "
	.section	".note.GNU-stack","",@progbits
