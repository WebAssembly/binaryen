	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/920520-1.c"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 8
	i32.store	$discard=, 0($0), $pop0
	return  	$0
func_end0:
	.size	foo, func_end0-foo

	.globl	bugger
	.type	bugger,@function
bugger:                                 # @bugger
	.result 	i32
# BB#0:                                 # %sw.epilog
	i32.const	$push0=, 0
	return  	$pop0
func_end1:
	.size	bugger, func_end1-bugger

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
func_end2:
	.size	main, func_end2-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
