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
	i32.const	$4=, 1
	i32.const	$push1=, 0
	i32.const	$push22=, 0
	i32.load16_u	$push2=, i($pop22)
	i32.const	$push21=, 1
	i32.xor 	$push3=, $pop2, $pop21
	i32.store16	$push0=, i($pop1), $pop3
	i32.const	$push4=, 24
	i32.shl 	$push5=, $pop0, $pop4
	i32.const	$push20=, 24
	i32.shr_s	$3=, $pop5, $pop20
	i32.const	$push19=, 0
	i32.const	$push18=, 0
	i32.store	$push17=, b($pop19), $pop18
	tee_local	$push16=, $0=, $pop17
	i32.load8_s	$2=, a($pop16)
	i32.load	$1=, k($0)
	block
	i32.load	$push6=, j($0)
	br_if   	0, $pop6        # 0: down to label0
# BB#1:                                 # %lor.rhs
	i32.load	$push7=, c($0)
	i32.ne  	$4=, $pop7, $0
.LBB0_2:                                # %lor.end
	end_block                       # label0:
	block
	block
	block
	i32.ne  	$push8=, $2, $3
	br_if   	0, $pop8        # 0: down to label3
# BB#3:                                 # %if.else
	i32.const	$push24=, 0
	i32.const	$push12=, 1
	i32.store8	$0=, h($pop24), $pop12
	i32.const	$push23=, 0
	i32.load	$push13=, e($pop23)
	i32.eqz 	$push38=, $pop13
	br_if   	2, $pop38       # 2: down to label1
# BB#4:                                 # %for.inc17.preheader
	i32.const	$push26=, 0
	i32.const	$push25=, 0
	i32.store	$drop=, e($pop26), $pop25
	br      	1               # 1: down to label2
.LBB0_5:                                # %for.cond10thread-pre-split
	end_block                       # label3:
	i32.const	$push28=, 0
	i32.load	$push9=, d($pop28)
	i32.const	$push27=, 0
	i32.gt_s	$push10=, $pop9, $pop27
	br_if   	0, $pop10       # 0: down to label2
# BB#6:                                 # %for.inc.preheader
	i32.const	$push29=, 0
	i32.const	$push11=, 1
	i32.store	$drop=, d($pop29), $pop11
.LBB0_7:                                # %for.end22
	end_block                       # label2:
	i32.const	$push33=, 0
	i32.store	$drop=, g($pop33), $1
	i32.const	$push32=, 0
	i32.store	$drop=, j($pop32), $4
	i32.const	$push31=, 0
	i32.const	$push14=, 1
	i32.store	$drop=, b($pop31), $pop14
	block
	i32.const	$push30=, 0
	i32.load8_u	$push15=, h($pop30)
	br_if   	0, $pop15       # 0: down to label4
# BB#8:                                 # %if.end27
	i32.const	$push34=, 0
	return  	$pop34
.LBB0_9:                                # %if.then26
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB0_10:                               # %for.end22.thread
	end_block                       # label1:
	i32.const	$push37=, 0
	i32.store	$drop=, j($pop37), $4
	i32.const	$push36=, 0
	i32.store	$drop=, g($pop36), $1
	i32.const	$push35=, 0
	i32.store	$drop=, b($pop35), $0
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
	.functype	abort, void
