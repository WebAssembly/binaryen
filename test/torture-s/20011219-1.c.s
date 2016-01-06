	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20011219-1.c"
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32, i32
# BB#0:                                 # %entry
	return
func_end0:
	.size	bar, func_end0-bar

	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, -10
	i32.add 	$0=, $0, $pop0
                                        # implicit-def: %vreg13
	block   	BB1_7
	i32.const	$push1=, 4
	i32.gt_u	$push2=, $0, $pop1
	br_if   	$pop2, BB1_7
# BB#1:                                 # %entry
	block   	BB1_6
	block   	BB1_5
	block   	BB1_4
	block   	BB1_3
	block   	BB1_2
	tableswitch	$0, BB1_2, BB1_2, BB1_3, BB1_4, BB1_5, BB1_6
BB1_2:                                  # %sw.bb
	i32.load	$2=, 0($1)
	br      	BB1_7
BB1_3:                                  # %sw.bb1
	i32.load	$2=, 0($1)
	br      	BB1_7
BB1_4:                                  # %sw.bb2
	i32.load	$2=, 0($1)
	br      	BB1_7
BB1_5:                                  # %sw.bb3
	i32.load	$2=, 0($1)
	br      	BB1_7
BB1_6:                                  # %sw.bb4
	i32.load	$2=, 0($1)
BB1_7:                                  # %sw.epilog
	return  	$2
func_end1:
	.size	foo, func_end1-foo

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
func_end2:
	.size	main, func_end2-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
