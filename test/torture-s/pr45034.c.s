	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr45034.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32
# BB#0:                                 # %entry
	block   	.LBB0_2
	i32.const	$push0=, 128
	i32.add 	$push1=, $1, $pop0
	i32.const	$push2=, 256
	i32.ge_u	$push3=, $pop1, $pop2
	br_if   	$pop3, .LBB0_2
# BB#1:                                 # %if.end
	return
.LBB0_2:                                # %if.then
	call    	abort
	unreachable
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.test_neg,"ax",@progbits
	.hidden	test_neg
	.globl	test_neg
	.type	test_neg,@function
test_neg:                               # @test_neg
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 128
	copy_local	$7=, $1
.LBB1_1:                                # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB1_5
	i32.const	$push0=, 255
	i32.and 	$2=, $7, $pop0
	i32.const	$3=, 0
	i32.sub 	$4=, $3, $2
	i32.const	$5=, 24
	i32.shl 	$0=, $4, $5
	i32.const	$6=, 127
	block   	.LBB1_4
	block   	.LBB1_3
	i32.and 	$push1=, $4, $1
	i32.gt_u	$push2=, $pop1, $6
	br_if   	$pop2, .LBB1_3
# BB#2:                                 # %cond.true.i
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.shr_s	$4=, $0, $5
	br      	.LBB1_4
.LBB1_3:                                # %cond.false.i
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push3=, -16777216
	i32.xor 	$push4=, $0, $pop3
	i32.shr_s	$push5=, $pop4, $5
	i32.const	$push6=, -1
	i32.xor 	$4=, $pop5, $pop6
.LBB1_4:                                # %fixnum_neg.exit
                                        #   in Loop: Header=BB1_1 Depth=1
	call    	foo, $7, $4, $7
	i32.const	$push7=, 1
	i32.add 	$7=, $7, $pop7
	i32.ne  	$push8=, $2, $6
	br_if   	$pop8, .LBB1_1
.LBB1_5:                                # %for.end
	return  	$3
.Lfunc_end1:
	.size	test_neg, .Lfunc_end1-test_neg

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 128
	copy_local	$7=, $1
.LBB2_1:                                # %for.cond.i
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB2_5
	i32.const	$push0=, 255
	i32.and 	$2=, $7, $pop0
	i32.const	$3=, 0
	i32.sub 	$4=, $3, $2
	i32.const	$5=, 24
	i32.shl 	$0=, $4, $5
	i32.const	$6=, 127
	block   	.LBB2_4
	block   	.LBB2_3
	i32.and 	$push1=, $4, $1
	i32.gt_u	$push2=, $pop1, $6
	br_if   	$pop2, .LBB2_3
# BB#2:                                 # %cond.true.i.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.shr_s	$4=, $0, $5
	br      	.LBB2_4
.LBB2_3:                                # %cond.false.i.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push3=, -16777216
	i32.xor 	$push4=, $0, $pop3
	i32.shr_s	$push5=, $pop4, $5
	i32.const	$push6=, -1
	i32.xor 	$4=, $pop5, $pop6
.LBB2_4:                                # %fixnum_neg.exit.i
                                        #   in Loop: Header=BB2_1 Depth=1
	call    	foo, $7, $4, $7
	i32.const	$push7=, 1
	i32.add 	$7=, $7, $pop7
	i32.ne  	$push8=, $2, $6
	br_if   	$pop8, .LBB2_1
.LBB2_5:                                # %if.end
	return  	$3
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
