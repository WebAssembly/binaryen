	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr53160.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.store	$discard=, e($0), $0
	return
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	block
	i32.load	$push0=, g($0)
	i32.const	$push6=, 0
	i32.eq  	$push7=, $pop0, $pop6
	br_if   	$pop7, 0        # 0: down to label0
# BB#1:                                 # %if.then
	i32.load	$discard=, b($0)
.LBB1_2:                                # %if.end
	end_block                       # label0:
	i32.store	$discard=, e($0), $0
	i32.load8_s	$1=, f($0)
	i32.load	$2=, c($0)
	block
	i32.const	$push2=, -1
	i32.store	$discard=, d($0), $pop2
	i32.store16	$push1=, i($0), $1
	i32.select	$push3=, $2, $pop1, $0
	i32.store	$push4=, h($0), $pop3
	i32.store	$push5=, a($0), $pop4
	br_if   	$pop5, 0        # 0: down to label1
# BB#3:                                 # %if.end16
	return  	$0
.LBB1_4:                                # %if.then15
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	c                       # @c
	.type	c,@object
	.section	.data.c,"aw",@progbits
	.globl	c
	.align	2
c:
	.int32	1                       # 0x1
	.size	c, 4

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
	.section	.bss.d,"aw",@nobits
	.globl	d
	.align	2
d:
	.int32	0                       # 0x0
	.size	d, 4

	.hidden	f                       # @f
	.type	f,@object
	.section	.bss.f,"aw",@nobits
	.globl	f
f:
	.int8	0                       # 0x0
	.size	f, 1

	.hidden	i                       # @i
	.type	i,@object
	.section	.bss.i,"aw",@nobits
	.globl	i
	.align	1
i:
	.int16	0                       # 0x0
	.size	i, 2

	.hidden	h                       # @h
	.type	h,@object
	.section	.bss.h,"aw",@nobits
	.globl	h
	.align	2
h:
	.int32	0                       # 0x0
	.size	h, 4

	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.align	2
a:
	.int32	0                       # 0x0
	.size	a, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
