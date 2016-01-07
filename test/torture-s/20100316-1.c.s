	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20100316-1.c"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.load16_u	$push0=, 4($0)
	i32.const	$push1=, 1023
	i32.and 	$push2=, $pop0, $pop1
	return  	$pop2
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.load16_u	$1=, f+4($0)
	block   	.LBB1_2
	i32.const	$push0=, -1
	i32.store	$discard=, f($0), $pop0
	i32.const	$push2=, 57344
	i32.and 	$push3=, $1, $pop2
	i32.const	$push4=, 7168
	i32.or  	$push5=, $pop3, $pop4
	i32.store16	$discard=, f+4($0), $pop5
	i32.const	$push1=, f
	i32.call	$push6=, foo, $pop1
	br_if   	$pop6, .LBB1_2
# BB#1:                                 # %if.end
	return  	$0
.LBB1_2:                                  # %if.then
	call    	abort
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	f,@object               # @f
	.bss
	.globl	f
	.align	2
f:
	.zero	8
	.size	f, 8


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
