	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/960302-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.load	$1=, a($0)
	i32.const	$push0=, 31
	i32.shr_u	$push1=, $1, $pop0
	i32.add 	$push2=, $1, $pop1
	i32.const	$push3=, -2
	i32.and 	$push4=, $pop2, $pop3
	i32.sub 	$1=, $1, $pop4
	i32.const	$2=, 1
	i32.eq  	$push5=, $1, $2
	i32.const	$push6=, -1
	i32.select	$push7=, $pop5, $2, $pop6
	i32.select	$push8=, $1, $pop7, $0
	return  	$pop8
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
	i32.load	$1=, a($0)
	block   	.LBB1_2
	i32.const	$push0=, 31
	i32.shr_u	$push1=, $1, $pop0
	i32.add 	$push2=, $1, $pop1
	i32.const	$push3=, -2
	i32.and 	$push4=, $pop2, $pop3
	i32.sub 	$push5=, $1, $pop4
	i32.const	$push6=, 1
	i32.ne  	$push7=, $pop5, $pop6
	br_if   	$pop7, .LBB1_2
# BB#1:                                 # %if.end
	call    	exit@FUNCTION, $0
	unreachable
.LBB1_2:                                # %if.then
	call    	abort@FUNCTION
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	a                       # @a
	.type	a,@object
	.section	.data.a,"aw",@progbits
	.globl	a
	.align	2
a:
	.int32	1                       # 0x1
	.size	a, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
