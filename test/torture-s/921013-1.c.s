	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/921013-1.c"
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32, i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	block   	BB0_2
	i32.const	$push4=, 0
	i32.eq  	$push5=, $3, $pop4
	br_if   	$pop5, BB0_2
BB0_1:                                  # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	BB0_2
	f32.load	$push1=, 0($1)
	f32.load	$push2=, 0($2)
	f32.eq  	$push3=, $pop1, $pop2
	i32.store	$discard=, 0($0), $pop3
	i32.const	$4=, 4
	i32.add 	$1=, $1, $4
	i32.add 	$2=, $2, $4
	i32.add 	$4=, $0, $4
	i32.const	$push0=, -1
	i32.add 	$3=, $3, $pop0
	copy_local	$0=, $4
	br_if   	$3, BB0_1
BB0_2:                                  # %while.end
	return  	$4
func_end0:
	.size	f, func_end0-f

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %for.cond.3
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
func_end1:
	.size	main, func_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
