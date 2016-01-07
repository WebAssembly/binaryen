	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr48571-1.c"
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, -2492
.LBB0_1:                                  # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB0_2
	i32.const	$push0=, c
	i32.add 	$0=, $pop0, $1
	i32.const	$push6=, 2496
	i32.add 	$push7=, $0, $pop6
	i32.const	$push1=, 2492
	i32.add 	$push2=, $0, $pop1
	i32.load	$push3=, 0($pop2)
	i32.const	$push4=, 1
	i32.shl 	$push5=, $pop3, $pop4
	i32.store	$discard=, 0($pop7), $pop5
	i32.const	$push8=, 4
	i32.add 	$1=, $1, $pop8
	br_if   	$1, .LBB0_1
.LBB0_2:                                  # %for.end
	return
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, -2496
.LBB1_1:                                  # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB1_2
	i32.const	$3=, c
	i32.add 	$push0=, $3, $2
	i32.const	$push1=, 2496
	i32.add 	$push2=, $pop0, $pop1
	i32.const	$push3=, 1
	i32.store	$4=, 0($pop2), $pop3
	i32.const	$0=, 4
	i32.add 	$2=, $2, $0
	br_if   	$2, .LBB1_1
.LBB1_2:                                  # %for.end
	call    	bar
	i32.const	$2=, 0
.LBB1_3:                                  # %for.body3
                                        # =>This Inner Loop Header: Depth=1
	block   	.LBB1_6
	loop    	.LBB1_5
	i32.load	$push4=, 0($3)
	i32.ne  	$push5=, $pop4, $4
	br_if   	$pop5, .LBB1_6
# BB#4:                                 # %if.end
                                        #   in Loop: Header=.LBB1_3 Depth=1
	i32.const	$1=, 1
	i32.shl 	$4=, $4, $1
	i32.add 	$2=, $2, $1
	i32.add 	$3=, $3, $0
	i32.const	$push6=, 624
	i32.lt_u	$push7=, $2, $pop6
	br_if   	$pop7, .LBB1_3
.LBB1_5:                                  # %for.end8
	i32.const	$push8=, 0
	return  	$pop8
.LBB1_6:                                  # %if.then
	call    	abort
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	c,@object               # @c
	.bss
	.globl	c
	.align	4
c:
	.zero	2496
	.size	c, 2496


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
