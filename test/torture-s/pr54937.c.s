	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr54937.c"
	.globl	t
	.type	t,@function
t:                                      # @t
	.param  	i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, 0
	block   	.LBB0_4
	i32.const	$push0=, 1
	i32.lt_s	$push1=, $0, $pop0
	br_if   	$pop1, .LBB0_4
.LBB0_1:                                  # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB0_4
	block   	.LBB0_3
	i32.const	$push8=, 0
	i32.eq  	$push9=, $2, $pop8
	br_if   	$pop9, .LBB0_3
# BB#2:                                 # %if.then
                                        #   in Loop: Header=.LBB0_1 Depth=1
	i32.const	$1=, 0
	i32.load	$push2=, terminate_me($1)
	call_indirect	$pop2, $1
.LBB0_3:                                  # %if.end
                                        #   in Loop: Header=.LBB0_1 Depth=1
	i32.const	$push3=, a
	i32.add 	$push4=, $pop3, $2
	i32.const	$push5=, 0
	i32.store	$discard=, 0($pop4), $pop5
	i32.const	$push6=, 4
	i32.add 	$2=, $2, $pop6
	i32.const	$push7=, -1
	i32.add 	$0=, $0, $pop7
	br_if   	$0, .LBB0_1
.LBB0_4:                                  # %for.end
	return  	$2
.Lfunc_end0:
	.size	t, .Lfunc_end0-t

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push1=, 0
	i32.const	$push0=, exit
	i32.store	$discard=, terminate_me($pop1), $pop0
	i32.const	$push2=, 100
	i32.call	$discard=, t, $pop2
	call    	abort
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	terminate_me,@object    # @terminate_me
	.bss
	.globl	terminate_me
	.align	2
terminate_me:
	.int32	0
	.size	terminate_me, 4

	.type	a,@object               # @a
	.globl	a
	.align	2
a:
	.zero	4
	.size	a, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
