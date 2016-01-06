	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000726-1.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
func_end0:
	.size	main, func_end0-main

	.globl	adjust_xy
	.type	adjust_xy,@function
adjust_xy:                              # @adjust_xy
	.param  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 1
	i32.store16	$discard=, 0($0), $pop0
	return
func_end1:
	.size	adjust_xy, func_end1-adjust_xy


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
