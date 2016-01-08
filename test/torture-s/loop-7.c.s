	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/loop-7.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, 0
	i32.const	$2=, -1
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB0_3
	i32.const	$1=, 1
	i32.shl 	$push0=, $1, $3
	i32.eq  	$push1=, $pop0, $0
	i32.select	$2=, $pop1, $3, $2
	i32.add 	$3=, $3, $1
	i32.const	$push2=, 9
	i32.gt_s	$push3=, $3, $pop2
	br_if   	$pop3, .LBB0_3
# BB#2:                                 # %for.body
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push4=, 0
	i32.lt_s	$push5=, $2, $pop4
	br_if   	$pop5, .LBB0_1
.LBB0_3:                                # %for.end
	block   	.LBB0_5
	i32.const	$push6=, -1
	i32.le_s	$push7=, $2, $pop6
	br_if   	$pop7, .LBB0_5
# BB#4:                                 # %if.end5
	return
.LBB0_5:                                # %if.then4
	call    	abort
	unreachable
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 1
	i32.const	$2=, -1
	copy_local	$1=, $0
.LBB1_1:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB1_3
	i32.const	$push0=, 7
	i32.eq  	$push1=, $1, $pop0
	i32.const	$push2=, 6
	i32.select	$2=, $pop1, $pop2, $2
	i32.const	$push3=, 9
	i32.gt_s	$push4=, $1, $pop3
	br_if   	$pop4, .LBB1_3
# BB#2:                                 # %for.body.i
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.add 	$1=, $1, $0
	i32.const	$push5=, 0
	i32.lt_s	$push6=, $2, $pop5
	br_if   	$pop6, .LBB1_1
.LBB1_3:                                # %for.end.i
	block   	.LBB1_5
	i32.const	$push7=, -1
	i32.gt_s	$push8=, $2, $pop7
	br_if   	$pop8, .LBB1_5
# BB#4:                                 # %if.then4.i
	call    	abort
	unreachable
.LBB1_5:                                # %foo.exit
	i32.const	$push9=, 0
	call    	exit, $pop9
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
