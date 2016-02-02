	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr59387.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push7=, 0
	i32.const	$push1=, -19
	i32.store	$0=, a($pop7), $pop1
	i32.const	$push6=, 0
	i32.load8_u	$1=, c($pop6)
.LBB0_1:                                # %for.body2
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	i32.const	$push11=, 0
	i32.load	$push2=, e($pop11)
	i32.const	$push10=, f
	i32.store	$discard=, 0($pop2), $pop10
	i32.const	$push9=, -24
	i32.add 	$1=, $1, $pop9
	i32.const	$push8=, 0
	i32.load	$push3=, d($pop8)
	i32.const	$push16=, 0
	i32.eq  	$push17=, $pop3, $pop16
	br_if   	$pop17, 1       # 1: down to label1
# BB#2:                                 # %for.inc4
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push13=, 0
	i32.const	$push12=, 1
	i32.add 	$push0=, $0, $pop12
	i32.store	$0=, a($pop13), $pop0
	br_if   	$0, 0           # 0: up to label0
.LBB0_3:                                # %return
	end_loop                        # label1:
	i32.const	$push4=, 0
	i32.store8	$discard=, c($pop4), $1
	i32.const	$push15=, 0
	i32.const	$push5=, 24
	i32.store	$discard=, b($pop15), $pop5
	i32.const	$push14=, 0
	return  	$pop14
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	d                       # @d
	.type	d,@object
	.section	.bss.d,"aw",@nobits
	.globl	d
	.p2align	2
d:
	.int32	0
	.size	d, 4

	.hidden	e                       # @e
	.type	e,@object
	.section	.data.e,"aw",@progbits
	.globl	e
	.p2align	2
e:
	.int32	d
	.size	e, 4

	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.p2align	2
a:
	.int32	0                       # 0x0
	.size	a, 4

	.hidden	b                       # @b
	.type	b,@object
	.section	.bss.b,"aw",@nobits
	.globl	b
	.p2align	2
b:
	.skip	4
	.size	b, 4

	.hidden	c                       # @c
	.type	c,@object
	.section	.bss.c,"aw",@nobits
	.globl	c
c:
	.int8	0                       # 0x0
	.size	c, 1

	.hidden	f                       # @f
	.type	f,@object
	.section	.bss.f,"aw",@nobits
	.globl	f
	.p2align	2
f:
	.int32	0                       # 0x0
	.size	f, 4


	.ident	"clang version 3.9.0 "
