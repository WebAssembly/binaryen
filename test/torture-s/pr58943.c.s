	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr58943.c"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.load	$push0=, x($0)
	i32.const	$push1=, 128
	i32.or  	$push2=, $pop0, $pop1
	i32.store	$discard=, x($0), $pop2
	i32.const	$push3=, 1
	return  	$pop3
func_end0:
	.size	foo, func_end0-foo

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	block   	BB1_2
	i32.load	$push0=, x($0)
	i32.const	$push1=, 129
	i32.or  	$push2=, $pop0, $pop1
	i32.store	$push3=, x($0), $pop2
	i32.const	$push4=, 131
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	$pop5, BB1_2
# BB#1:                                 # %if.end
	return  	$0
BB1_2:                                  # %if.then
	call    	abort
	unreachable
func_end1:
	.size	main, func_end1-main

	.type	x,@object               # @x
	.data
	.globl	x
	.align	2
x:
	.int32	2                       # 0x2
	.size	x, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
