	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr57124.c"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block   	.LBB0_2
	i32.load16_u	$push0=, 0($0)
	i32.const	$push1=, 4095
	i32.gt_u	$push2=, $pop0, $pop1
	br_if   	$pop2, .LBB0_2
# BB#1:                                 # %if.then
	call    	abort
	unreachable
.LBB0_2:                                  # %if.end
	i32.const	$push3=, 0
	call    	exit, $pop3
	unreachable
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, __stack_pointer
	i32.load	$0=, 0($0)
	i32.const	$1=, 16
	i32.sub 	$4=, $0, $1
	i32.const	$1=, __stack_pointer
	i32.store	$4=, 0($1), $4
	i32.const	$push0=, 65531
	i32.store16	$discard=, 14($4), $pop0
	i32.const	$push1=, 65526
	i32.store16	$discard=, 12($4), $pop1
	i32.const	$2=, 14
	i32.add 	$2=, $4, $2
	i32.const	$3=, 12
	i32.add 	$3=, $4, $3
	i32.call	$discard=, foo, $2, $3
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
