	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr59387.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.load8_u	$2=, c($0)
	i32.const	$push1=, -19
	i32.store	$1=, a($0), $pop1
.LBB0_1:                                # %for.body2
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	i32.load	$push3=, e($0)
	i32.const	$push4=, f
	i32.store	$discard=, 0($pop3), $pop4
	i32.const	$push2=, -24
	i32.add 	$2=, $2, $pop2
	i32.load	$push5=, d($0)
	i32.const	$push8=, 0
	i32.eq  	$push9=, $pop5, $pop8
	br_if   	$pop9, 1        # 1: down to label1
# BB#2:                                 # %for.inc4
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push6=, 1
	i32.add 	$push0=, $1, $pop6
	i32.store	$1=, a($0), $pop0
	br_if   	$1, 0           # 0: up to label0
.LBB0_3:                                # %return
	end_loop                        # label1:
	i32.store8	$discard=, c($0), $2
	i32.const	$push7=, 24
	i32.store	$discard=, b($0), $pop7
	return  	$0
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	d                       # @d
	.type	d,@object
	.section	.bss.d,"aw",@nobits
	.globl	d
	.align	2
d:
	.int32	0
	.size	d, 4

	.hidden	e                       # @e
	.type	e,@object
	.section	.data.e,"aw",@progbits
	.globl	e
	.align	2
e:
	.int32	d
	.size	e, 4

	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.align	2
a:
	.int32	0                       # 0x0
	.size	a, 4

	.hidden	b                       # @b
	.type	b,@object
	.section	.bss.b,"aw",@nobits
	.globl	b
	.align	2
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
	.align	2
f:
	.int32	0                       # 0x0
	.size	f, 4


	.ident	"clang version 3.9.0 "
	.section	".note.GNU-stack","",@progbits
