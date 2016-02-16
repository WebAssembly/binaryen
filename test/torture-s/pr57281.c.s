	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr57281.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push2=, g($pop0)
	i32.const	$push7=, 0
	i32.load	$push6=, b($pop7)
	tee_local	$push5=, $1=, $pop6
	i64.extend_s/i32	$push1=, $pop5
	i64.store	$discard=, 0($pop2), $pop1
	i32.const	$push4=, 0
	i32.select	$push3=, $pop4, $1, $0
	return  	$pop3
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	block
	i32.const	$push8=, 0
	i32.load	$push0=, b($pop8)
	i32.const	$push7=, -20
	i32.eq  	$push1=, $pop0, $pop7
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %for.body.lr.ph
	i32.const	$push11=, 0
	i32.load	$0=, a($pop11)
	i32.const	$push10=, 0
	i32.load	$1=, e($pop10)
	i32.const	$push9=, 0
	i32.load	$2=, g($pop9)
.LBB1_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.const	$push17=, 0
	i64.load	$discard=, f($pop17)
	i32.const	$push16=, 0
	i32.store	$3=, 0($1), $pop16
	i32.load	$push15=, b($3)
	tee_local	$push14=, $4=, $pop15
	i32.select	$push3=, $3, $pop14, $0
	i32.store	$discard=, 0($1), $pop3
	i32.load	$push4=, b($3)
	i32.const	$push13=, -1
	i32.add 	$push5=, $pop4, $pop13
	i32.store	$3=, b($3), $pop5
	i64.extend_s/i32	$push2=, $4
	i64.store	$discard=, 0($2), $pop2
	i32.const	$push12=, -20
	i32.ne  	$push6=, $3, $pop12
	br_if   	0, $pop6        # 0: up to label1
.LBB1_3:                                # %for.end
	end_loop                        # label2:
	end_block                       # label0:
	i32.const	$push18=, 0
	return  	$pop18
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	a                       # @a
	.type	a,@object
	.section	.data.a,"aw",@progbits
	.globl	a
	.p2align	2
a:
	.int32	1                       # 0x1
	.size	a, 4

	.hidden	d                       # @d
	.type	d,@object
	.section	.bss.d,"aw",@nobits
	.globl	d
	.p2align	2
d:
	.int32	0                       # 0x0
	.size	d, 4

	.hidden	e                       # @e
	.type	e,@object
	.section	.data.e,"aw",@progbits
	.globl	e
	.p2align	2
e:
	.int32	d
	.size	e, 4

	.hidden	c                       # @c
	.type	c,@object
	.section	.bss.c,"aw",@nobits
	.globl	c
	.p2align	3
c:
	.int64	0                       # 0x0
	.size	c, 8

	.hidden	g                       # @g
	.type	g,@object
	.section	.data.g,"aw",@progbits
	.globl	g
	.p2align	2
g:
	.int32	c
	.size	g, 4

	.hidden	b                       # @b
	.type	b,@object
	.section	.bss.b,"aw",@nobits
	.globl	b
	.p2align	2
b:
	.int32	0                       # 0x0
	.size	b, 4

	.hidden	f                       # @f
	.type	f,@object
	.section	.bss.f,"aw",@nobits
	.globl	f
	.p2align	3
f:
	.int64	0                       # 0x0
	.size	f, 8


	.ident	"clang version 3.9.0 "
