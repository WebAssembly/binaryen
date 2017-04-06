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
	i32.le_s	$push1=, $pop0, $pop3
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %for.end9
	i32.const	$push5=, 0
	return  	$pop5
.LBB1_2:                                # %for.cond4.preheader
	end_block                       # label0:
	i32.const	$push9=, 0
	i32.const	$push2=, 1
	i32.store	d($pop9), $pop2
	i32.const	$push8=, 0
	i32.const	$push7=, 0
	i32.store	e($pop8), $pop7
	i32.const	$push6=, 0
                                        # fallthrough-return: $pop6
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
	i32.eqz 	$push12=, $pop0
	br_if   	0, $pop12       # 0: down to label1
# BB#1:                                 # %while.body.preheader
	i32.const	$push8=, 0
	i32.load	$push1=, d($pop8)
	i32.const	$push7=, 1
	i32.lt_s	$0=, $pop1, $pop7
.LBB2_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label2:
	i32.const	$push9=, 1
	i32.and 	$push2=, $0, $pop9
	i32.eqz 	$push13=, $pop2
	br_if   	0, $pop13       # 0: up to label2
# BB#3:                                 #   in Loop: Header=BB2_2 Depth=1
	i32.const	$0=, 0
	br      	0               # 0: up to label2
.LBB2_4:                                # %for.inc.1
	end_loop
	end_block                       # label1:
	i32.const	$push11=, 0
	i32.const	$push3=, 2
	i32.store	b($pop11), $pop3
	i32.const	$push10=, 0
                                        # fallthrough-return: $pop10
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


	.ident	"clang version 5.0.0 (https://chromium.googlesource.com/external/github.com/llvm-mirror/clang e7bf9bd23e5ab5ae3f79d88d3e8956f0067fc683) (https://chromium.googlesource.com/external/github.com/llvm-mirror/llvm 7bfedca6fc415b0e5edea211f299142b03de1e97)"
