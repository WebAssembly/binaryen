	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/941021-1.c"
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, f64
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, glob_dbl
	i32.select	$push1=, $0, $0, $pop0
	f64.store	$discard=, 0($pop1), $1
	return  	$0
func_end0:
	.size	f, func_end0-f

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %if.end
	i32.const	$0=, 0
	i64.const	$push0=, 4632951452917877965
	i64.store	$discard=, glob_dbl($0), $pop0
	call    	exit, $0
	unreachable
func_end1:
	.size	main, func_end1-main

	.type	glob_dbl,@object        # @glob_dbl
	.bss
	.globl	glob_dbl
	.align	3
glob_dbl:
	.int64	0                       # double 0
	.size	glob_dbl, 8


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
