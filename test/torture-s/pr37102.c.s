	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr37102.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
# BB#0:                                 # %entry
	block
	i32.const	$push0=, 5
	i32.ne  	$push1=, $0, $pop0
	br_if   	$pop1, 0        # 0: down to label0
# BB#1:                                 # %if.end
	return
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.load	$1=, b($0)
	block
	i32.load	$push0=, c($0)
	i32.const	$push8=, 0
	i32.eq  	$push9=, $pop0, $pop8
	br_if   	$pop9, 0        # 0: down to label1
# BB#1:                                 # %if.then.3
	i32.store	$discard=, a($0), $1
.LBB1_2:                                # %for.inc.3
	end_block                       # label1:
	i32.store	$discard=, a($0), $1
	i32.const	$push1=, 2147483647
	i32.and 	$push2=, $1, $pop1
	i32.const	$push3=, 2
	i32.shl 	$push4=, $1, $pop3
	i32.const	$push5=, 1
	i32.or  	$push6=, $pop4, $pop5
	i32.select	$push7=, $pop2, $pop6, $0
	call    	foo@FUNCTION, $pop7
	return  	$0
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	b                       # @b
	.type	b,@object
	.section	.data.b,"aw",@progbits
	.globl	b
	.align	2
b:
	.int32	1                       # 0x1
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
	.int32	0                       # 0x0
	.size	a, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
