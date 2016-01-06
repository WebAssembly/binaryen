	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr45034.c"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32
# BB#0:                                 # %entry
	block   	BB0_2
	i32.const	$push0=, 128
	i32.add 	$push1=, $1, $pop0
	i32.const	$push2=, 256
	i32.ge_u	$push3=, $pop1, $pop2
	br_if   	$pop3, BB0_2
# BB#1:                                 # %if.end
	return
BB0_2:                                  # %if.then
	call    	abort
	unreachable
func_end0:
	.size	foo, func_end0-foo

	.globl	test_neg
	.type	test_neg,@function
test_neg:                               # @test_neg
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 128
	copy_local	$7=, $1
BB1_1:                                  # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	loop    	BB1_5
	i32.const	$push0=, 255
	i32.and 	$2=, $7, $pop0
	i32.const	$3=, 0
	i32.sub 	$4=, $3, $2
	i32.const	$5=, 24
	i32.shl 	$0=, $4, $5
	i32.const	$6=, 127
	block   	BB1_4
	block   	BB1_3
	i32.and 	$push1=, $4, $1
	i32.gt_u	$push2=, $pop1, $6
	br_if   	$pop2, BB1_3
# BB#2:                                 # %cond.true.i
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.shr_s	$4=, $0, $5
	br      	BB1_4
BB1_3:                                  # %cond.false.i
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push3=, -16777216
	i32.xor 	$push4=, $0, $pop3
	i32.shr_s	$push5=, $pop4, $5
	i32.const	$push6=, -1
	i32.xor 	$4=, $pop5, $pop6
BB1_4:                                  # %fixnum_neg.exit
                                        #   in Loop: Header=BB1_1 Depth=1
	call    	foo, $7, $4, $7
	i32.const	$push7=, 1
	i32.add 	$7=, $7, $pop7
	i32.ne  	$push8=, $2, $6
	br_if   	$pop8, BB1_1
BB1_5:                                  # %for.end
	return  	$3
func_end1:
	.size	test_neg, func_end1-test_neg

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 128
	copy_local	$7=, $1
BB2_1:                                  # %for.cond.i
                                        # =>This Inner Loop Header: Depth=1
	loop    	BB2_5
	i32.const	$push0=, 255
	i32.and 	$2=, $7, $pop0
	i32.const	$3=, 0
	i32.sub 	$4=, $3, $2
	i32.const	$5=, 24
	i32.shl 	$0=, $4, $5
	i32.const	$6=, 127
	block   	BB2_4
	block   	BB2_3
	i32.and 	$push1=, $4, $1
	i32.gt_u	$push2=, $pop1, $6
	br_if   	$pop2, BB2_3
# BB#2:                                 # %cond.true.i.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.shr_s	$4=, $0, $5
	br      	BB2_4
BB2_3:                                  # %cond.false.i.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push3=, -16777216
	i32.xor 	$push4=, $0, $pop3
	i32.shr_s	$push5=, $pop4, $5
	i32.const	$push6=, -1
	i32.xor 	$4=, $pop5, $pop6
BB2_4:                                  # %fixnum_neg.exit.i
                                        #   in Loop: Header=BB2_1 Depth=1
	call    	foo, $7, $4, $7
	i32.const	$push7=, 1
	i32.add 	$7=, $7, $pop7
	i32.ne  	$push8=, $2, $6
	br_if   	$pop8, BB2_1
BB2_5:                                  # %if.end
	return  	$3
func_end2:
	.size	main, func_end2-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
