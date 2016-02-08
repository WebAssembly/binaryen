	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr57861.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push1=, 0
	i32.load16_u	$0=, a($pop1)
	copy_local	$2=, $0
	block
	i32.const	$push23=, 0
	i32.const	$push22=, 0
	i32.store	$push2=, c($pop23), $pop22
	tee_local	$push21=, $3=, $pop2
	i32.load	$push6=, e($pop21)
	i32.const	$push3=, 24
	i32.shl 	$push4=, $0, $pop3
	i32.const	$push20=, 24
	i32.shr_s	$push5=, $pop4, $pop20
	i32.ge_u	$push7=, $pop6, $pop5
	br_if   	0, $pop7        # 0: down to label0
# BB#1:                                 # %if.then.i.1
	i32.load	$push8=, d($3)
	i32.ne  	$push9=, $pop8, $3
	i32.load	$push10=, h($3)
	i32.ne  	$push11=, $pop10, $3
	i32.and 	$push0=, $pop9, $pop11
	i32.store16	$2=, a($3), $pop0
	i32.store16	$discard=, f($3), $3
.LBB0_2:                                # %for.inc.i.1
	end_block                       # label0:
	i32.store	$push15=, j($3), $3
	tee_local	$push24=, $4=, $pop15
	i32.load	$1=, g($pop24)
	i32.const	$push12=, 255
	i32.and 	$push13=, $0, $pop12
	i32.ne  	$push14=, $pop13, $3
	i32.store	$discard=, i($4), $pop14
	i32.const	$push16=, 2
	i32.store	$discard=, c($4), $pop16
	i32.store	$discard=, 0($1), $4
	block
	i32.const	$push17=, 65535
	i32.and 	$push18=, $2, $pop17
	br_if   	0, $pop18       # 0: down to label1
# BB#3:                                 # %if.end
	i32.const	$push19=, 0
	return  	$pop19
.LBB0_4:                                # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	a                       # @a
	.type	a,@object
	.section	.data.a,"aw",@progbits
	.globl	a
	.p2align	1
a:
	.int16	1                       # 0x1
	.size	a, 2

	.hidden	b                       # @b
	.type	b,@object
	.section	.bss.b,"aw",@nobits
	.globl	b
	.p2align	2
b:
	.int32	0                       # 0x0
	.size	b, 4

	.hidden	g                       # @g
	.type	g,@object
	.section	.data.g,"aw",@progbits
	.globl	g
	.p2align	2
g:
	.int32	b
	.size	g, 4

	.hidden	f                       # @f
	.type	f,@object
	.section	.bss.f,"aw",@nobits
	.globl	f
	.p2align	1
f:
	.int16	0                       # 0x0
	.size	f, 2

	.hidden	c                       # @c
	.type	c,@object
	.section	.bss.c,"aw",@nobits
	.globl	c
	.p2align	2
c:
	.int32	0                       # 0x0
	.size	c, 4

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
	.p2align	2
h:
	.int32	0                       # 0x0
	.size	h, 4

	.hidden	i                       # @i
	.type	i,@object
	.section	.bss.i,"aw",@nobits
	.globl	i
	.p2align	2
i:
	.int32	0                       # 0x0
	.size	i, 4

	.hidden	j                       # @j
	.type	j,@object
	.section	.bss.j,"aw",@nobits
	.globl	j
	.p2align	2
j:
	.int32	0                       # 0x0
	.size	j, 4

	.hidden	e                       # @e
	.type	e,@object
	.section	.bss.e,"aw",@nobits
	.globl	e
	.p2align	2
e:
	.int32	0                       # 0x0
	.size	e, 4


	.ident	"clang version 3.9.0 "
