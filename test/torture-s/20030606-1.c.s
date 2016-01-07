	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20030606-1.c"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 55
	i32.store	$discard=, 0($0), $pop0
	i32.const	$2=, 4
	i32.add 	$3=, $0, $2
	block   	.LBB0_2
	i32.const	$push3=, 0
	i32.eq  	$push4=, $1, $pop3
	br_if   	$pop4, .LBB0_2
# BB#1:                                 # %if.then
	i32.add 	$push2=, $0, $2
	i32.store	$discard=, 0($pop2), $1
	i32.const	$push1=, 8
	i32.add 	$3=, $0, $pop1
.LBB0_2:                                  # %if.end
	return  	$3
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
