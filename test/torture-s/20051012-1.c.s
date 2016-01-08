	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20051012-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load16_u	$push1=, t+6($pop0)
	i32.const	$push2=, 511
	i32.and 	$push3=, $pop1, $pop2
	return  	$pop3
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %if.end
	i32.const	$0=, 0
	i32.load	$push0=, t+4($0)
	i32.const	$push1=, -33488897
	i32.and 	$push2=, $pop0, $pop1
	i32.const	$push3=, 524288
	i32.or  	$push4=, $pop2, $pop3
	i32.store	$discard=, t+4($0), $pop4
	return  	$0
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	t                       # @t
	.type	t,@object
	.section	.bss.t,"aw",@nobits
	.globl	t
	.align	2
t:
	.skip	8
	.size	t, 8


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
