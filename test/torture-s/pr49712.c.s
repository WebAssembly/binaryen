	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr49712.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
# BB#0:                                 # %entry
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.result 	i32
# BB#0:                                 # %entry
	block
	i32.const	$push4=, 0
	i32.load	$push0=, d($pop4)
	i32.const	$push3=, 0
	i32.gt_s	$push1=, $pop0, $pop3
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %for.cond4.preheader.preheader
	i32.const	$push7=, 0
	i32.const	$push2=, 1
	i32.store	$drop=, d($pop7), $pop2
	i32.const	$push6=, 0
	i32.const	$push5=, 0
	i32.store	$drop=, e($pop6), $pop5
.LBB1_2:                                # %for.end9
	end_block                       # label0:
	i32.const	$push8=, 0
                                        # fallthrough-return: $pop8
	.endfunc
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	block
	i32.const	$push0=, 0
	i32.const	$push7=, 0
	i32.store	$push6=, b($pop0), $pop7
	tee_local	$push5=, $1=, $pop6
	i32.load	$push1=, c($pop5)
	i32.eqz 	$push16=, $pop1
	br_if   	0, $pop16       # 0: down to label1
# BB#1:                                 # %while.body.preheader
	i32.load	$push2=, d($1)
	i32.const	$push8=, 1
	i32.lt_s	$1=, $pop2, $pop8
.LBB2_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	i32.const	$push15=, 1
	i32.and 	$push3=, $1, $pop15
	i32.eqz 	$push17=, $pop3
	br_if   	0, $pop17       # 0: up to label2
# BB#3:                                 # %for.cond4.preheader.preheader.i
                                        #   in Loop: Header=BB2_2 Depth=1
	i32.const	$1=, 0
	i32.const	$push14=, 0
	i32.const	$push13=, 1
	i32.store	$drop=, d($pop14), $pop13
	i32.const	$push12=, 0
	i32.const	$push11=, 0
	i32.store	$push10=, e($pop12), $pop11
	tee_local	$push9=, $0=, $pop10
	i32.store	$drop=, a($pop9), $0
	br      	0               # 0: up to label2
.LBB2_4:                                # %for.inc.1
	end_loop                        # label3:
	end_block                       # label1:
	i32.const	$push4=, 2
	i32.store	$drop=, b($1), $pop4
	copy_local	$push18=, $1
                                        # fallthrough-return: $pop18
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

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
	.section	.bss.e,"aw",@nobits
	.globl	e
	.p2align	2
e:
	.int32	0                       # 0x0
	.size	e, 4

	.hidden	b                       # @b
	.type	b,@object
	.section	.bss.b,"aw",@nobits
	.globl	b
	.p2align	2
b:
	.int32	0                       # 0x0
	.size	b, 4

	.hidden	c                       # @c
	.type	c,@object
	.section	.bss.c,"aw",@nobits
	.globl	c
	.p2align	2
c:
	.int32	0                       # 0x0
	.size	c, 4

	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.p2align	2
a:
	.skip	8
	.size	a, 8


	.ident	"clang version 3.9.0 "
