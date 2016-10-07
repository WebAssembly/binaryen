	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr58431.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %for.body
	i32.const	$3=, 1
	i32.const	$push23=, 0
	i32.const	$push22=, 0
	i32.load16_u	$push0=, i($pop22)
	i32.const	$push21=, 1
	i32.xor 	$push20=, $pop0, $pop21
	tee_local	$push19=, $1=, $pop20
	i32.store16	i($pop23), $pop19
	i32.const	$push18=, 0
	i32.const	$push17=, 0
	i32.store	b($pop18), $pop17
	i32.const	$push16=, 0
	i32.load8_s	$0=, a($pop16)
	i32.const	$push15=, 0
	i32.load	$2=, j($pop15)
	i32.const	$push14=, 0
	i32.const	$push13=, 0
	i32.load	$push1=, k($pop13)
	i32.store	g($pop14), $pop1
	i32.const	$push2=, 24
	i32.shl 	$push3=, $1, $pop2
	i32.const	$push12=, 24
	i32.shr_s	$1=, $pop3, $pop12
	block   	
	br_if   	0, $2           # 0: down to label0
# BB#1:                                 # %lor.rhs
	i32.const	$push25=, 0
	i32.load	$push4=, c($pop25)
	i32.const	$push24=, 0
	i32.ne  	$3=, $pop4, $pop24
.LBB0_2:                                # %lor.end
	end_block                       # label0:
	i32.const	$push26=, 0
	i32.store	j($pop26), $3
	block   	
	block   	
	block   	
	i32.ne  	$push5=, $0, $1
	br_if   	0, $pop5        # 0: down to label3
# BB#3:                                 # %if.else
	i32.const	$push29=, 0
	i32.const	$push28=, 1
	i32.store8	h($pop29), $pop28
	i32.const	$push27=, 0
	i32.load	$push9=, e($pop27)
	i32.eqz 	$push40=, $pop9
	br_if   	2, $pop40       # 2: down to label1
# BB#4:                                 # %for.inc17.preheader
	i32.const	$push31=, 0
	i32.const	$push30=, 0
	i32.store	e($pop31), $pop30
	br      	1               # 1: down to label2
.LBB0_5:                                # %for.cond10thread-pre-split
	end_block                       # label3:
	i32.const	$push33=, 0
	i32.load	$push6=, d($pop33)
	i32.const	$push32=, 0
	i32.gt_s	$push7=, $pop6, $pop32
	br_if   	0, $pop7        # 0: down to label2
# BB#6:                                 # %for.inc.preheader
	i32.const	$push34=, 0
	i32.const	$push8=, 1
	i32.store	d($pop34), $pop8
.LBB0_7:                                # %for.end22
	end_block                       # label2:
	i32.const	$push36=, 0
	i32.const	$push10=, 1
	i32.store	b($pop36), $pop10
	block   	
	i32.const	$push35=, 0
	i32.load8_u	$push11=, h($pop35)
	br_if   	0, $pop11       # 0: down to label4
# BB#8:                                 # %if.end27
	i32.const	$push37=, 0
	return  	$pop37
.LBB0_9:                                # %if.then26
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB0_10:                               # %for.end22.thread
	end_block                       # label1:
	i32.const	$push39=, 0
	i32.const	$push38=, 1
	i32.store	b($pop39), $pop38
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
