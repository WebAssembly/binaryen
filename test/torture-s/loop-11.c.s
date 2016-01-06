	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/loop-11.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 199
	i32.const	$0=, a+792
BB0_1:                                  # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop    	BB0_2
	i32.const	$push1=, -1
	i32.add 	$push0=, $1, $pop1
	i32.store	$1=, 0($0), $pop0
	i32.const	$push2=, -4
	i32.add 	$0=, $0, $pop2
	i32.const	$3=, 0
	i32.const	$2=, a
	i32.gt_s	$push3=, $1, $3
	br_if   	$pop3, BB0_1
BB0_2:                                  # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block   	BB0_5
	loop    	BB0_4
	i32.load	$push4=, 0($2)
	i32.ne  	$push5=, $3, $pop4
	br_if   	$pop5, BB0_5
# BB#3:                                 # %for.cond
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push6=, 1
	i32.add 	$3=, $3, $pop6
	i32.const	$push7=, 4
	i32.add 	$2=, $2, $pop7
	i32.const	$push8=, 198
	i32.le_s	$push9=, $3, $pop8
	br_if   	$pop9, BB0_2
BB0_4:                                  # %for.end
	i32.const	$push10=, 0
	return  	$pop10
BB0_5:                                  # %if.then
	call    	abort
	unreachable
func_end0:
	.size	main, func_end0-main

	.type	a,@object               # @a
	.lcomm	a,796,4

	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
