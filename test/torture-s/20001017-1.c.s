	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20001017-1.c"
	.globl	bug
	.type	bug,@function
bug:                                    # @bug
	.param  	i32, i32, i32, i32, i32, f64, i32, i32, i32, i32, f64, i32, i32
# BB#0:                                 # %entry
	block   	BB0_2
	i32.ne  	$push0=, $11, $0
	br_if   	$pop0, BB0_2
# BB#1:                                 # %if.end
	return
BB0_2:                                  # %if.then
	call    	abort
	unreachable
func_end0:
	.size	bug, func_end0-bug

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	return  	$pop0
func_end1:
	.size	main, func_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
