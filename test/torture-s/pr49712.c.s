	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr49712.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
# BB#0:                                 # %entry
	return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	block
	i32.load	$push0=, d($0)
	i32.gt_s	$push1=, $pop0, $0
	br_if   	$pop1, 0        # 0: down to label0
# BB#1:                                 # %for.cond4.preheader.preheader
	i32.store	$push2=, e($0), $0
	i32.const	$push3=, 1
	i32.store	$discard=, d($pop2), $pop3
.LBB1_2:                                # %for.end9
	end_block                       # label0:
	return  	$0
	.endfunc
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, 0
	i32.store	$0=, b($2), $2
	block
	i32.load	$push0=, c($0)
	i32.const	$push4=, 0
	i32.eq  	$push5=, $pop0, $pop4
	br_if   	$pop5, 0        # 0: down to label1
# BB#1:                                 # %while.body.preheader
	i32.const	$1=, 1
	i32.load	$push1=, d($0)
	i32.lt_s	$2=, $pop1, $1
.LBB2_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	i32.and 	$push2=, $2, $1
	i32.const	$push6=, 0
	i32.eq  	$push7=, $pop2, $pop6
	br_if   	$pop7, 0        # 0: up to label2
# BB#3:                                 # %for.cond4.preheader.preheader.i
                                        #   in Loop: Header=BB2_2 Depth=1
	i32.store	$2=, a($0), $0
	i32.store	$discard=, e($2), $2
	i32.store	$discard=, d($2), $1
	br      	0               # 0: up to label2
.LBB2_4:                                # %for.inc.1
	end_loop                        # label3:
	end_block                       # label1:
	i32.const	$2=, 0
	i32.const	$push3=, 2
	i32.store	$discard=, b($2), $pop3
	return  	$2
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

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
	.section	.bss.e,"aw",@nobits
	.globl	e
	.align	2
e:
	.int32	0                       # 0x0
	.size	e, 4

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
	.section	.bss.c,"aw",@nobits
	.globl	c
	.align	2
c:
	.int32	0                       # 0x0
	.size	c, 4

	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.align	2
a:
	.skip	8
	.size	a, 8


	.ident	"clang version 3.9.0 "
