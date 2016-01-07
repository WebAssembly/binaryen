	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000412-2.c"
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 16
	i32.sub 	$4=, $2, $3
	i32.const	$3=, __stack_pointer
	i32.store	$4=, 0($3), $4
	i32.store	$discard=, 12($4), $0
	block   	.LBB0_3
	block   	.LBB0_2
	i32.const	$push2=, 0
	i32.eq  	$push3=, $0, $pop2
	br_if   	$pop3, .LBB0_2
# BB#1:                                 # %if.end
	i32.const	$push0=, -1
	i32.add 	$push1=, $0, $pop0
	i32.const	$5=, 12
	i32.add 	$5=, $4, $5
	i32.call	$0=, f, $pop1, $5
	br      	.LBB0_3
.LBB0_2:                                  # %if.then
	i32.load	$0=, 0($1)
.LBB0_3:                                  # %cleanup
	i32.const	$4=, 16
	i32.add 	$4=, $4, $4
	i32.const	$4=, __stack_pointer
	i32.store	$4=, 0($4), $4
	return  	$0
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.globl	main
	.type	main,@function
main:                                   # @main
	.param  	i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$2=, 0
	block   	.LBB1_2
	i32.const	$push0=, 100
	i32.call	$push1=, f, $pop0, $2
	i32.const	$push2=, 1
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	$pop3, .LBB1_2
# BB#1:                                 # %if.end
	call    	exit, $2
	unreachable
.LBB1_2:                                  # %if.then
	call    	abort
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
