	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr21173.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push1=, 0
	i32.load	$1=, a+4($pop1)
	i32.const	$push9=, 0
	i32.const	$push8=, 0
	i32.load	$push2=, a($pop8)
	i32.const	$push0=, q
	i32.sub 	$push7=, $0, $pop0
	tee_local	$push6=, $0=, $pop7
	i32.add 	$push3=, $pop2, $pop6
	i32.store	$discard=, a($pop9), $pop3
	i32.const	$push5=, 0
	i32.add 	$push4=, $1, $0
	i32.store	$discard=, a+4($pop5), $pop4
	return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	block
	i32.const	$push4=, 0
	i32.load	$push0=, a($pop4)
	i32.const	$push3=, 0
	i32.load	$push1=, a+4($pop3)
	i32.or  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %for.cond.1
	i32.const	$push5=, 0
	return  	$pop5
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	q                       # @q
	.type	q,@object
	.section	.bss.q,"aw",@nobits
	.globl	q
q:
	.int8	0                       # 0x0
	.size	q, 1

	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.p2align	2
a:
	.skip	8
	.size	a, 8


	.ident	"clang version 3.9.0 "
