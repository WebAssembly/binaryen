	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr44164.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.load	$1=, 0($0)
	i32.const	$push0=, 0
	i32.const	$push3=, 0
	i32.store	$drop=, a($pop0), $pop3
	i32.load	$push1=, 0($0)
	i32.add 	$push2=, $1, $pop1
                                        # fallthrough-return: $pop2
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
	i32.const	$push5=, 0
	i32.const	$push1=, 1
	i32.store	$push0=, a($pop5), $pop1
	i32.const	$push2=, a
	i32.call	$push3=, foo@FUNCTION, $pop2
	i32.ne  	$push4=, $pop0, $pop3
	br_if   	0, $pop4        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push6=, 0
	return  	$pop6
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.p2align	2
a:
	.skip	4
	.size	a, 4


	.ident	"clang version 3.9.0 "
