	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/920604-1.c"
	.globl	mod
	.type	mod,@function
mod:                                    # @mod
	.param  	i64, i64
	.result 	i64
# BB#0:                                 # %entry
	i64.rem_s	$push0=, $0, $1
	return  	$pop0
.Lfunc_end0:
	.size	mod, .Lfunc_end0-mod

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
