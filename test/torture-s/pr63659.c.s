	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr63659.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	block
	i32.const	$push9=, 0
	i32.load	$push2=, a($pop9)
	i32.const	$push24=, 0
	i32.eq  	$push25=, $pop2, $pop24
	br_if   	0, $pop25       # 0: down to label0
# BB#1:                                 # %for.cond.preheader
	i32.const	$push11=, 0
	i32.const	$push10=, 0
	i32.store	$discard=, a($pop11), $pop10
.LBB0_2:                                # %while.end
	end_block                       # label0:
	i32.const	$1=, 255
	block
	i32.const	$push16=, 0
	i32.const	$push15=, 0
	i32.load8_s	$push3=, c($pop15)
	i32.const	$push14=, 0
	i32.load	$push4=, h($pop14)
	i32.shr_s	$push1=, $pop3, $pop4
	i32.store	$push13=, g($pop16), $pop1
	tee_local	$push12=, $0=, $pop13
	i32.const	$push26=, 0
	i32.eq  	$push27=, $pop12, $pop26
	br_if   	0, $pop27       # 0: down to label1
# BB#3:                                 # %cond.false
	i32.const	$push5=, -1
	i32.rem_s	$1=, $pop5, $0
.LBB0_4:                                # %cond.end
	end_block                       # label1:
	i32.const	$push22=, 0
	i32.load	$push7=, d($pop22)
	i32.const	$push21=, 255
	i32.and 	$push6=, $1, $pop21
	i32.store	$discard=, 0($pop7), $pop6
	i32.const	$push20=, 0
	i32.load	$0=, b($pop20)
	i32.const	$push19=, 0
	i32.const	$push18=, 0
	i32.store8	$push0=, f($pop18), $1
	i32.store8	$discard=, e($pop19), $pop0
	block
	i32.const	$push17=, 255
	i32.ne  	$push8=, $0, $pop17
	br_if   	0, $pop8        # 0: down to label2
# BB#5:                                 # %if.end23
	i32.const	$push23=, 0
	return  	$pop23
.LBB0_6:                                # %if.then22
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

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
	.section	.data.d,"aw",@progbits
	.globl	d
	.p2align	2
d:
	.int32	b
	.size	d, 4

	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.p2align	2
a:
	.int32	0                       # 0x0
	.size	a, 4

	.hidden	c                       # @c
	.type	c,@object
	.section	.bss.c,"aw",@nobits
	.globl	c
	.p2align	2
c:
	.int32	0                       # 0x0
	.size	c, 4

	.hidden	i                       # @i
	.type	i,@object
	.section	.bss.i,"aw",@nobits
	.globl	i
	.p2align	2
i:
	.int32	0                       # 0x0
	.size	i, 4

	.hidden	h                       # @h
	.type	h,@object
	.section	.bss.h,"aw",@nobits
	.globl	h
	.p2align	2
h:
	.int32	0                       # 0x0
	.size	h, 4

	.hidden	g                       # @g
	.type	g,@object
	.section	.bss.g,"aw",@nobits
	.globl	g
	.p2align	2
g:
	.int32	0                       # 0x0
	.size	g, 4

	.hidden	f                       # @f
	.type	f,@object
	.section	.bss.f,"aw",@nobits
	.globl	f
f:
	.int8	0                       # 0x0
	.size	f, 1

	.hidden	e                       # @e
	.type	e,@object
	.section	.bss.e,"aw",@nobits
	.globl	e
e:
	.int8	0                       # 0x0
	.size	e, 1


	.ident	"clang version 3.9.0 "
