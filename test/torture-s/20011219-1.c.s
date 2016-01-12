	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20011219-1.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32, i32
# BB#0:                                 # %entry
	return
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar

	.section	.text.foo,"ax",@progbits
	.hidden	foo
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
	block   	.LBB1_7
	i32.const	$push1=, 4
	i32.gt_u	$push2=, $0, $pop1
	br_if   	$pop2, .LBB1_7
# BB#1:                                 # %entry
	block   	.LBB1_6
	block   	.LBB1_5
	block   	.LBB1_4
	block   	.LBB1_3
	block   	.LBB1_2
	tableswitch	$0, .LBB1_2, .LBB1_2, .LBB1_3, .LBB1_4, .LBB1_5, .LBB1_6
.LBB1_2:                                # %sw.bb
	i32.load	$2=, 0($1)
	br      	.LBB1_7
.LBB1_3:                                # %sw.bb1
	i32.load	$2=, 0($1)
	br      	.LBB1_7
.LBB1_4:                                # %sw.bb2
	i32.load	$2=, 0($1)
	br      	.LBB1_7
.LBB1_5:                                # %sw.bb3
	i32.load	$2=, 0($1)
	br      	.LBB1_7
.LBB1_6:                                # %sw.bb4
	i32.load	$2=, 0($1)
.LBB1_7:                                # %sw.epilog
	return  	$2
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
