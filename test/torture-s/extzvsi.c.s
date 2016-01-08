	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/extzvsi.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 1
	i32.const	$push0=, 0
	i32.load	$push1=, x($pop0)
	i32.shr_u	$push2=, $pop1, $0
	i32.const	$push3=, 2047
	i32.and 	$1=, $pop2, $pop3
	i32.gt_u	$push4=, $1, $0
	i32.shl 	$push5=, $pop4, $0
	i32.select	$push6=, $1, $pop5, $0
	return  	$pop6
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
	i64.load	$push0=, x($0)
	i64.const	$push1=, -4095
	i64.and 	$push2=, $pop0, $pop1
	i64.const	$push3=, 2
	i64.or  	$push4=, $pop2, $pop3
	i64.store	$discard=, x($0), $pop4
	return  	$0
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	x                       # @x
	.type	x,@object
	.section	.bss.x,"aw",@nobits
	.globl	x
	.align	3
x:
	.skip	8
	.size	x, 8


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
