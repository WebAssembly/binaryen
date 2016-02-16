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
	i32.const	$push11=, 0
	i32.load	$push1=, a($pop11)
	i32.const	$push26=, 0
	i32.eq  	$push27=, $pop1, $pop26
	br_if   	0, $pop27       # 0: down to label0
# BB#1:                                 # %for.cond.preheader
	i32.const	$push13=, 0
	i32.const	$push12=, 0
	i32.store	$discard=, a($pop13), $pop12
.LBB0_2:                                # %while.end
	end_block                       # label0:
	i32.const	$0=, 255
	block
	i32.const	$push18=, 0
	i32.const	$push17=, 0
	i32.load8_s	$push2=, c($pop17):p2align=2
	i32.const	$push16=, 0
	i32.load	$push3=, h($pop16)
	i32.shr_s	$push0=, $pop2, $pop3
	i32.store	$push15=, g($pop18), $pop0
	tee_local	$push14=, $1=, $pop15
	i32.const	$push28=, 0
	i32.eq  	$push29=, $pop14, $pop28
	br_if   	0, $pop29       # 0: down to label1
# BB#3:                                 # %cond.false
	i32.const	$push4=, -1
	i32.rem_s	$0=, $pop4, $1
.LBB0_4:                                # %cond.end
	end_block                       # label1:
	i32.const	$push24=, 0
	i32.load	$push8=, d($pop24)
	i32.const	$push23=, 0
	i32.const	$push22=, 0
	i32.store8	$push5=, f($pop22), $0
	i32.store8	$push6=, e($pop23), $pop5
	i32.const	$push21=, 255
	i32.and 	$push7=, $pop6, $pop21
	i32.store	$discard=, 0($pop8), $pop7
	block
	i32.const	$push20=, 0
	i32.load	$push9=, b($pop20)
	i32.const	$push19=, 255
	i32.ne  	$push10=, $pop9, $pop19
	br_if   	0, $pop10       # 0: down to label2
# BB#5:                                 # %if.end23
	i32.const	$push25=, 0
	return  	$pop25
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
