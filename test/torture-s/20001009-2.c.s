	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20001009-2.c"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	block   	BB0_2
	i32.load	$push0=, b($0)
	i32.const	$push6=, 0
	i32.eq  	$push7=, $pop0, $pop6
	br_if   	$pop7, BB0_2
BB0_1:                                  # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	BB0_2
	i32.const	$1=, 1
	#APP
	#NO_APP
	i32.load	$push1=, b($0)
	i32.const	$push2=, -1
	i32.add 	$push3=, $pop1, $pop2
	i32.store	$push4=, b($0), $pop3
	br_if   	$pop4, BB0_1
BB0_2:                                  # %if.end
	i32.const	$push5=, -1
	return  	$pop5
func_end0:
	.size	foo, func_end0-foo

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	block   	BB1_2
	i32.load	$push0=, b($0)
	i32.const	$push5=, 0
	i32.eq  	$push6=, $pop0, $pop5
	br_if   	$pop6, BB1_2
BB1_1:                                  # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop    	BB1_2
	i32.const	$1=, 1
	#APP
	#NO_APP
	i32.load	$push1=, b($0)
	i32.const	$push2=, -1
	i32.add 	$push3=, $pop1, $pop2
	i32.store	$push4=, b($0), $pop3
	br_if   	$pop4, BB1_1
BB1_2:                                  # %foo.exit
	return  	$0
func_end1:
	.size	main, func_end1-main

	.type	b,@object               # @b
	.data
	.globl	b
	.align	2
b:
	.int32	1                       # 0x1
	.size	b, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
