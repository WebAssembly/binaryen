	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr49712.c"
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
# BB#1:                                 # %for.cond4.preheader
	i32.const	$push7=, 0
	i32.const	$push2=, 1
	i32.store	d($pop7), $pop2
	i32.const	$push6=, 0
	i32.const	$push5=, 0
	i32.store	e($pop6), $pop5
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
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push6=, 0
	i32.const	$push5=, 0
	i32.store	b($pop6), $pop5
	block   	
	i32.const	$push4=, 0
	i32.load	$push0=, c($pop4)
	i32.eqz 	$push18=, $pop0
	br_if   	0, $pop18       # 0: down to label1
# BB#1:                                 # %while.body.preheader
	i32.const	$push8=, 0
	i32.load	$push1=, d($pop8)
	i32.const	$push7=, 1
	i32.lt_s	$0=, $pop1, $pop7
.LBB2_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label2:
	i32.const	$push15=, 1
	i32.and 	$push2=, $0, $pop15
	i32.eqz 	$push19=, $pop2
	br_if   	0, $pop19       # 0: up to label2
# BB#3:                                 # %for.cond4.preheader.i
                                        #   in Loop: Header=BB2_2 Depth=1
	i32.const	$0=, 0
	i32.const	$push14=, 0
	i32.const	$push13=, 1
	i32.store	d($pop14), $pop13
	i32.const	$push12=, 0
	i32.const	$push11=, 0
	i32.store	e($pop12), $pop11
	i32.const	$push10=, 0
	i32.const	$push9=, 0
	i32.store	a($pop10), $pop9
	br      	0               # 0: up to label2
.LBB2_4:                                # %for.inc.1
	end_loop
	end_block                       # label1:
	i32.const	$push17=, 0
	i32.const	$push3=, 2
	i32.store	b($pop17), $pop3
	i32.const	$push16=, 0
                                        # fallthrough-return: $pop16
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
