	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr57861.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push23=, 0
	i32.store	$push22=, c($pop0), $pop23
	tee_local	$push21=, $0=, $pop22
	i32.load16_u	$push20=, a($pop21)
	tee_local	$push19=, $1=, $pop20
	copy_local	$2=, $pop19
	block
	i32.load	$push8=, e($0)
	i32.const	$push5=, 24
	i32.shl 	$push6=, $1, $pop5
	i32.const	$push18=, 24
	i32.shr_s	$push7=, $pop6, $pop18
	i32.ge_u	$push9=, $pop8, $pop7
	br_if   	0, $pop9        # 0: down to label0
# BB#1:                                 # %if.then.i.1
	i32.load	$push3=, d($0)
	i32.ne  	$push4=, $pop3, $0
	i32.load	$push1=, h($0)
	i32.ne  	$push2=, $pop1, $0
	i32.and 	$push25=, $pop4, $pop2
	tee_local	$push24=, $2=, $pop25
	i32.store16	$drop=, a($0), $pop24
	i32.store16	$drop=, f($0), $0
.LBB0_2:                                # %for.inc.i.1
	end_block                       # label0:
	i32.const	$push10=, 2
	i32.store	$drop=, c($0), $pop10
	i32.const	$push11=, 255
	i32.and 	$push12=, $1, $pop11
	i32.ne  	$push13=, $pop12, $0
	i32.store	$drop=, i($0), $pop13
	i32.store	$push27=, j($0), $0
	tee_local	$push26=, $0=, $pop27
	i32.load	$push14=, g($pop26)
	i32.store	$drop=, 0($pop14), $0
	block
	i32.const	$push15=, 65535
	i32.and 	$push16=, $2, $pop15
	br_if   	0, $pop16       # 0: down to label1
# BB#3:                                 # %if.end
	i32.const	$push17=, 0
	return  	$pop17
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
	.functype	abort, void
