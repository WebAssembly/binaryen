	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr63659.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	block
	i32.load	$push1=, a($0)
	i32.const	$push10=, 0
	i32.eq  	$push11=, $pop1, $pop10
	br_if   	$pop11, 0       # 0: down to label0
# BB#1:                                 # %for.cond.preheader
	i32.store	$discard=, a($0), $0
.LBB0_2:                                # %while.end
	end_block                       # label0:
	i32.const	$1=, 255
	i32.load8_s	$push2=, c($0)
	i32.load	$push3=, h($0)
	i32.shr_s	$push0=, $pop2, $pop3
	i32.store	$2=, g($0), $pop0
	copy_local	$3=, $1
	block
	i32.const	$push12=, 0
	i32.eq  	$push13=, $2, $pop12
	br_if   	$pop13, 0       # 0: down to label1
# BB#3:                                 # %cond.false
	i32.const	$push4=, -1
	i32.rem_s	$3=, $pop4, $2
.LBB0_4:                                # %cond.end
	end_block                       # label1:
	i32.load	$2=, d($0)
	block
	i32.store8	$push5=, f($0), $3
	i32.store8	$push6=, e($0), $pop5
	i32.and 	$push7=, $pop6, $1
	i32.store	$discard=, 0($2), $pop7
	i32.load	$push8=, b($0)
	i32.ne  	$push9=, $pop8, $1
	br_if   	$pop9, 0        # 0: down to label2
# BB#5:                                 # %if.end23
	return  	$0
.LBB0_6:                                # %if.then22
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	b                       # @b
	.type	b,@object
	.section	.bss.b,"aw",@nobits
	.globl	b
	.align	2
b:
	.int32	0                       # 0x0
	.size	b, 4

	.hidden	d                       # @d
	.type	d,@object
	.section	.data.d,"aw",@progbits
	.globl	d
	.align	2
d:
	.int32	b
	.size	d, 4

	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.align	2
a:
	.int32	0                       # 0x0
	.size	a, 4

	.hidden	c                       # @c
	.type	c,@object
	.section	.bss.c,"aw",@nobits
	.globl	c
	.align	2
c:
	.int32	0                       # 0x0
	.size	c, 4

	.hidden	i                       # @i
	.type	i,@object
	.section	.bss.i,"aw",@nobits
	.globl	i
	.align	2
i:
	.int32	0                       # 0x0
	.size	i, 4

	.hidden	h                       # @h
	.type	h,@object
	.section	.bss.h,"aw",@nobits
	.globl	h
	.align	2
h:
	.int32	0                       # 0x0
	.size	h, 4

	.hidden	g                       # @g
	.type	g,@object
	.section	.bss.g,"aw",@nobits
	.globl	g
	.align	2
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


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
