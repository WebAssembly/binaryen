	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr57281.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	i32.load	$2=, b($1)
	i32.load	$push1=, g($1)
	i64.extend_s/i32	$push0=, $2
	i64.store	$discard=, 0($pop1), $pop0
	i32.select	$push2=, $0, $1, $2
	return  	$pop2
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, 0
	i32.const	$4=, -20
	block
	i32.load	$push0=, b($3)
	i32.eq  	$push1=, $pop0, $4
	br_if   	$pop1, 0        # 0: down to label0
# BB#1:                                 # %for.body.lr.ph
	i32.load	$0=, a($3)
	i32.load	$1=, e($3)
	i32.load	$2=, g($3)
.LBB1_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i64.load	$discard=, f($3)
	i32.store	$5=, 0($1), $3
	i32.load	$6=, b($5)
	i64.extend_s/i32	$push2=, $6
	i64.store	$discard=, 0($2), $pop2
	i32.select	$push3=, $0, $5, $6
	i32.store	$discard=, 0($1), $pop3
	i32.load	$push4=, b($5)
	i32.const	$push5=, -1
	i32.add 	$push6=, $pop4, $pop5
	i32.store	$push7=, b($5), $pop6
	i32.ne  	$push8=, $pop7, $4
	br_if   	$pop8, 0        # 0: up to label1
.LBB1_3:                                # %for.end
	end_loop                        # label2:
	end_block                       # label0:
	return  	$3
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	a                       # @a
	.type	a,@object
	.section	.data.a,"aw",@progbits
	.globl	a
	.align	2
a:
	.int32	1                       # 0x1
	.size	a, 4

	.hidden	d                       # @d
	.type	d,@object
	.section	.bss.d,"aw",@nobits
	.globl	d
	.align	2
d:
	.int32	0                       # 0x0
	.size	d, 4

	.hidden	e                       # @e
	.type	e,@object
	.section	.data.e,"aw",@progbits
	.globl	e
	.align	2
e:
	.int32	d
	.size	e, 4

	.hidden	c                       # @c
	.type	c,@object
	.section	.bss.c,"aw",@nobits
	.globl	c
	.align	3
c:
	.int64	0                       # 0x0
	.size	c, 8

	.hidden	g                       # @g
	.type	g,@object
	.section	.data.g,"aw",@progbits
	.globl	g
	.align	2
g:
	.int32	c
	.size	g, 4

	.hidden	b                       # @b
	.type	b,@object
	.section	.bss.b,"aw",@nobits
	.globl	b
	.align	2
b:
	.int32	0                       # 0x0
	.size	b, 4

	.hidden	f                       # @f
	.type	f,@object
	.section	.bss.f,"aw",@nobits
	.globl	f
	.align	3
f:
	.int64	0                       # 0x0
	.size	f, 8


	.ident	"clang version 3.9.0 "
	.section	".note.GNU-stack","",@progbits
