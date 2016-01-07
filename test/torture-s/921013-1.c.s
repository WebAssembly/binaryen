	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/921013-1.c"
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32, i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	block   	.LBB0_2
	i32.const	$push4=, 0
	i32.eq  	$push5=, $3, $pop4
	br_if   	$pop5, .LBB0_2
.LBB0_1:                                  # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB0_2
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
	br_if   	$3, .LBB0_1
.LBB0_2:                                  # %while.end
	return  	$4
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %for.cond.3
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
