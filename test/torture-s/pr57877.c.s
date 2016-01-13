	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr57877.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i64, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, 0
	i32.load	$7=, g($3)
	i32.const	$4=, 1
	block
	block
	i32.lt_s	$push2=, $7, $4
	br_if   	$pop2, 0        # 0: down to label1
# BB#1:                                 # %entry.foo.exit_crit_edge
	i32.load	$6=, e($3)
	br      	1               # 1: down to label0
.LBB0_2:                                # %for.body.lr.ph.i
	end_block                       # label1:
	i64.load32_s	$0=, f($3)
	i32.load	$1=, c($3)
	i32.load	$2=, a($3)
	i32.const	$push3=, -1
	i32.add 	$7=, $7, $pop3
.LBB0_3:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	i32.load	$push0=, 0($1)
	i32.store	$5=, h($3), $pop0
	i32.const	$6=, 16
	i32.const	$push8=, 2
	i32.add 	$push9=, $7, $pop8
	i32.store	$discard=, g($3), $pop9
	i32.shl 	$push4=, $5, $6
	i32.shr_s	$push5=, $pop4, $6
	i32.eq  	$push6=, $pop5, $2
	i64.extend_u/i32	$push7=, $pop6
	i64.lt_u	$push1=, $pop7, $0
	i32.store	$6=, e($3), $pop1
	i32.add 	$7=, $7, $4
	i32.lt_s	$push10=, $7, $3
	br_if   	$pop10, 0       # 0: up to label2
# BB#4:                                 # %for.cond.for.end_crit_edge.i
	end_loop                        # label3:
	i32.store16	$discard=, d($3), $5
.LBB0_5:                                # %foo.exit
	end_block                       # label0:
	block
	i32.ne  	$push11=, $6, $4
	br_if   	$pop11, 0       # 0: down to label4
# BB#6:                                 # %if.end
	return  	$3
.LBB0_7:                                # %if.then
	end_block                       # label4:
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

	.hidden	c                       # @c
	.type	c,@object
	.section	.data.c,"aw",@progbits
	.globl	c
	.align	2
c:
	.int32	b
	.size	c, 4

	.hidden	f                       # @f
	.type	f,@object
	.section	.data.f,"aw",@progbits
	.globl	f
	.align	2
f:
	.int32	6                       # 0x6
	.size	f, 4

	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.align	2
a:
	.int32	0                       # 0x0
	.size	a, 4

	.hidden	e                       # @e
	.type	e,@object
	.section	.bss.e,"aw",@nobits
	.globl	e
	.align	2
e:
	.int32	0                       # 0x0
	.size	e, 4

	.hidden	g                       # @g
	.type	g,@object
	.section	.bss.g,"aw",@nobits
	.globl	g
	.align	2
g:
	.int32	0                       # 0x0
	.size	g, 4

	.hidden	h                       # @h
	.type	h,@object
	.section	.bss.h,"aw",@nobits
	.globl	h
	.align	2
h:
	.int32	0                       # 0x0
	.size	h, 4

	.hidden	d                       # @d
	.type	d,@object
	.section	.bss.d,"aw",@nobits
	.globl	d
	.align	1
d:
	.int16	0                       # 0x0
	.size	d, 2


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
