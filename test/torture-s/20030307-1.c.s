	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20030307-1.c"
	.globl	vfswrap_lock
	.type	vfswrap_lock,@function
vfswrap_lock:                           # @vfswrap_lock
	.param  	i32, i32, i32, i64, i64, i32
	.result 	i32
# BB#0:                                 # %entry
	return  	$5
func_end0:
	.size	vfswrap_lock, func_end0-vfswrap_lock

	.globl	fcntl_lock
	.type	fcntl_lock,@function
fcntl_lock:                             # @fcntl_lock
	.param  	i32, i32, i64, i64, i32
	.result 	i32
# BB#0:                                 # %entry
	return  	$4
func_end1:
	.size	fcntl_lock, func_end1-fcntl_lock

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	return  	$pop0
func_end2:
	.size	main, func_end2-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
