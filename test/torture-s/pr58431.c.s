	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr58431.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %for.body
	i32.const	$3=, 0
	i32.const	$5=, 1
	i32.load16_u	$push0=, i($3)
	i32.xor 	$push1=, $pop0, $5
	i32.store16	$2=, i($3), $pop1
	i32.store	$discard=, b($3), $3
	i32.load	$0=, k($3)
	i32.load8_s	$1=, a($3)
	i32.const	$4=, 24
	block
	i32.shl 	$push2=, $2, $4
	i32.shr_s	$4=, $pop2, $4
	i32.load	$push3=, j($3)
	br_if   	$pop3, 0        # 0: down to label0
# BB#1:                                 # %lor.rhs
	i32.load	$push4=, c($3)
	i32.ne  	$5=, $pop4, $3
.LBB0_2:                                # %lor.end
	end_block                       # label0:
	block
	block
	block
	i32.ne  	$push5=, $1, $4
	br_if   	$pop5, 0        # 0: down to label3
# BB#3:                                 # %if.else
	i32.load	$4=, e($3)
	block
	i32.const	$push9=, 1
	i32.store8	$2=, h($3), $pop9
	i32.const	$push11=, 0
	i32.eq  	$push12=, $4, $pop11
	br_if   	$pop12, 0       # 0: down to label4
# BB#4:                                 # %for.inc17.preheader
	i32.store	$discard=, e($3), $3
	br      	2               # 2: down to label2
.LBB0_5:                                # %for.end22.thread
	end_block                       # label4:
	i32.store	$discard=, g($3), $0
	i32.store	$discard=, j($3), $5
	i32.store	$discard=, b($3), $2
	br      	2               # 2: down to label1
.LBB0_6:                                # %for.cond10thread-pre-split
	end_block                       # label3:
	i32.load	$push6=, d($3)
	i32.gt_s	$push7=, $pop6, $3
	br_if   	$pop7, 0        # 0: down to label2
# BB#7:                                 # %for.inc.preheader
	i32.const	$push8=, 1
	i32.store	$discard=, d($3), $pop8
.LBB0_8:                                # %for.end22
	end_block                       # label2:
	i32.store	$discard=, g($3), $0
	i32.load8_u	$4=, h($3)
	i32.store	$discard=, j($3), $5
	i32.const	$push10=, 1
	i32.store	$discard=, b($3), $pop10
	br_if   	$4, 0           # 0: down to label1
# BB#9:                                 # %if.end27
	return  	$3
.LBB0_10:                               # %if.then26
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	i                       # @i
	.type	i,@object
	.section	.bss.i,"aw",@nobits
	.globl	i
	.align	1
i:
	.int16	0                       # 0x0
	.size	i, 2

	.hidden	b                       # @b
	.type	b,@object
	.section	.bss.b,"aw",@nobits
	.globl	b
	.align	2
b:
	.int32	0                       # 0x0
	.size	b, 4

	.hidden	k                       # @k
	.type	k,@object
	.section	.bss.k,"aw",@nobits
	.globl	k
	.align	2
k:
	.int32	0                       # 0x0
	.size	k, 4

	.hidden	g                       # @g
	.type	g,@object
	.section	.bss.g,"aw",@nobits
	.globl	g
	.align	2
g:
	.int32	0                       # 0x0
	.size	g, 4

	.hidden	j                       # @j
	.type	j,@object
	.section	.bss.j,"aw",@nobits
	.globl	j
	.align	2
j:
	.int32	0                       # 0x0
	.size	j, 4

	.hidden	c                       # @c
	.type	c,@object
	.section	.bss.c,"aw",@nobits
	.globl	c
	.align	2
c:
	.int32	0                       # 0x0
	.size	c, 4

	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
a:
	.int8	0                       # 0x0
	.size	a, 1

	.hidden	d                       # @d
	.type	d,@object
	.section	.bss.d,"aw",@nobits
	.globl	d
	.align	2
d:
	.int32	0                       # 0x0
	.size	d, 4

	.hidden	h                       # @h
	.type	h,@object
	.section	.bss.h,"aw",@nobits
	.globl	h
h:
	.int8	0                       # 0x0
	.size	h, 1

	.hidden	e                       # @e
	.type	e,@object
	.section	.bss.e,"aw",@nobits
	.globl	e
	.align	2
e:
	.int32	0                       # 0x0
	.size	e, 4


	.ident	"clang version 3.9.0 "
	.section	".note.GNU-stack","",@progbits
