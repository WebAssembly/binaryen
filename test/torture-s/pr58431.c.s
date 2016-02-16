	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr58431.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %for.body
	i32.const	$3=, 1
	i32.const	$push0=, 0
	i32.const	$push19=, 0
	i32.load16_u	$push1=, i($pop19)
	i32.const	$push18=, 1
	i32.xor 	$push2=, $pop1, $pop18
	i32.store16	$2=, i($pop0), $pop2
	i32.const	$push17=, 0
	i32.const	$push16=, 0
	i32.store	$push15=, b($pop17), $pop16
	tee_local	$push14=, $4=, $pop15
	i32.load	$0=, k($pop14)
	i32.load8_s	$1=, a($4)
	i32.const	$push3=, 24
	i32.shl 	$push4=, $2, $pop3
	i32.const	$push13=, 24
	i32.shr_s	$2=, $pop4, $pop13
	block
	i32.load	$push5=, j($4)
	br_if   	0, $pop5        # 0: down to label0
# BB#1:                                 # %lor.rhs
	i32.load	$push6=, c($4)
	i32.ne  	$3=, $pop6, $4
.LBB0_2:                                # %lor.end
	end_block                       # label0:
	block
	block
	block
	block
	i32.ne  	$push7=, $1, $2
	br_if   	0, $pop7        # 0: down to label4
# BB#3:                                 # %if.else
	i32.const	$push24=, 0
	i32.load	$4=, e($pop24)
	i32.const	$push23=, 0
	i32.const	$push11=, 1
	i32.store8	$2=, h($pop23), $pop11
	i32.const	$push35=, 0
	i32.eq  	$push36=, $4, $pop35
	br_if   	2, $pop36       # 2: down to label2
# BB#4:                                 # %for.inc17.preheader
	i32.const	$push29=, 0
	i32.const	$push28=, 0
	i32.store	$discard=, e($pop29), $pop28
	br      	1               # 1: down to label3
.LBB0_5:                                # %for.cond10thread-pre-split
	end_block                       # label4:
	i32.const	$push21=, 0
	i32.load	$push8=, d($pop21)
	i32.const	$push20=, 0
	i32.gt_s	$push9=, $pop8, $pop20
	br_if   	0, $pop9        # 0: down to label3
# BB#6:                                 # %for.inc.preheader
	i32.const	$push22=, 0
	i32.const	$push10=, 1
	i32.store	$discard=, d($pop22), $pop10
.LBB0_7:                                # %for.end22
	end_block                       # label3:
	i32.const	$push33=, 0
	i32.store	$discard=, g($pop33), $0
	i32.const	$push32=, 0
	i32.load8_u	$4=, h($pop32)
	i32.const	$push31=, 0
	i32.store	$discard=, j($pop31), $3
	i32.const	$push30=, 0
	i32.const	$push12=, 1
	i32.store	$discard=, b($pop30), $pop12
	br_if   	1, $4           # 1: down to label1
# BB#8:                                 # %if.end27
	i32.const	$push34=, 0
	return  	$pop34
.LBB0_9:                                # %for.end22.thread
	end_block                       # label2:
	i32.const	$push27=, 0
	i32.store	$discard=, g($pop27), $0
	i32.const	$push26=, 0
	i32.store	$discard=, j($pop26), $3
	i32.const	$push25=, 0
	i32.store	$discard=, b($pop25), $2
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
	.p2align	1
i:
	.int16	0                       # 0x0
	.size	i, 2

	.hidden	b                       # @b
	.type	b,@object
	.section	.bss.b,"aw",@nobits
	.globl	b
	.p2align	2
b:
	.int32	0                       # 0x0
	.size	b, 4

	.hidden	k                       # @k
	.type	k,@object
	.section	.bss.k,"aw",@nobits
	.globl	k
	.p2align	2
k:
	.int32	0                       # 0x0
	.size	k, 4

	.hidden	g                       # @g
	.type	g,@object
	.section	.bss.g,"aw",@nobits
	.globl	g
	.p2align	2
g:
	.int32	0                       # 0x0
	.size	g, 4

	.hidden	j                       # @j
	.type	j,@object
	.section	.bss.j,"aw",@nobits
	.globl	j
	.p2align	2
j:
	.int32	0                       # 0x0
	.size	j, 4

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
a:
	.int8	0                       # 0x0
	.size	a, 1

	.hidden	d                       # @d
	.type	d,@object
	.section	.bss.d,"aw",@nobits
	.globl	d
	.p2align	2
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
	.p2align	2
e:
	.int32	0                       # 0x0
	.size	e, 4


	.ident	"clang version 3.9.0 "
