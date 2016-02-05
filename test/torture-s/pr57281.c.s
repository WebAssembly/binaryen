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
	i32.load	$push3=, g($pop0)
	i32.const	$push7=, 0
	i32.load	$push1=, b($pop7)
	tee_local	$push6=, $1=, $pop1
	i64.extend_s/i32	$push2=, $pop6
	i64.store	$discard=, 0($pop3), $pop2
	i32.const	$push5=, 0
	i32.select	$push4=, $0, $pop5, $1
	return  	$pop4
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
	i32.const	$push9=, 0
	i32.load	$push0=, b($pop9)
	i32.const	$push8=, -20
	i32.eq  	$push1=, $pop0, $pop8
	br_if   	$pop1, 0        # 0: down to label0
# BB#1:                                 # %for.body.lr.ph
	i32.const	$push12=, 0
	i32.load	$0=, a($pop12)
	i32.const	$push11=, 0
	i32.load	$1=, e($pop11)
	i32.const	$push10=, 0
	i32.load	$2=, g($pop10)
.LBB1_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.const	$push17=, 0
	i64.load	$discard=, f($pop17)
	i32.const	$push16=, 0
	i32.store	$3=, 0($1), $pop16
	i32.load	$push2=, b($3)
	tee_local	$push15=, $4=, $pop2
	i32.select	$push4=, $0, $3, $pop15
	i32.store	$discard=, 0($1), $pop4
	i32.load	$push5=, b($3)
	i32.const	$push14=, -1
	i32.add 	$push6=, $pop5, $pop14
	i32.store	$3=, b($3), $pop6
	i64.extend_s/i32	$push3=, $4
	i64.store	$discard=, 0($2), $pop3
	i32.const	$push13=, -20
	i32.ne  	$push7=, $3, $pop13
	br_if   	$pop7, 0        # 0: up to label1
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
