	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/980617-1.c"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
# BB#0:                                 # %entry
	block   	BB0_2
	i32.load8_s	$push0=, 0($0)
	i32.const	$push1=, -17
	i32.add 	$push2=, $pop0, $pop1
	i32.const	$push3=, 1
	i32.gt_u	$push4=, $pop2, $pop3
	br_if   	$pop4, BB0_2
# BB#1:                                 # %if.then
	return
BB0_2:                                  # %if.else
	call    	abort
	unreachable
func_end0:
	.size	foo, func_end0-foo

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %foo.exit
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
func_end1:
	.size	main, func_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
