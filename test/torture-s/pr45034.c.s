	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr45034.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32
# BB#0:                                 # %entry
	block
	i32.const	$push0=, 128
	i32.add 	$push1=, $1, $pop0
	i32.const	$push2=, 256
	i32.ge_u	$push3=, $pop1, $pop2
	br_if   	$pop3, 0        # 0: down to label0
# BB#1:                                 # %if.end
	return
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
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
	loop                            # label1:
	i32.const	$push0=, 255
	i32.and 	$2=, $7, $pop0
	i32.const	$3=, 0
	i32.sub 	$4=, $3, $2
	i32.const	$5=, 24
	i32.shl 	$0=, $4, $5
	i32.const	$6=, 127
	block
	block
	i32.and 	$push1=, $4, $1
	i32.gt_u	$push2=, $pop1, $6
	br_if   	$pop2, 0        # 0: down to label4
# BB#2:                                 # %cond.true.i
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.shr_s	$4=, $0, $5
	br      	1               # 1: down to label3
.LBB1_3:                                # %cond.false.i
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label4:
	i32.const	$push3=, -16777216
	i32.xor 	$push4=, $0, $pop3
	i32.shr_s	$push5=, $pop4, $5
	i32.const	$push6=, -1
	i32.xor 	$4=, $pop5, $pop6
.LBB1_4:                                # %fixnum_neg.exit
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label3:
	call    	foo@FUNCTION, $7, $4, $7
	i32.const	$push7=, 1
	i32.add 	$7=, $7, $pop7
	i32.ne  	$push8=, $2, $6
	br_if   	$pop8, 0        # 0: up to label1
# BB#5:                                 # %for.end
	end_loop                        # label2:
	return  	$3
	.endfunc
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
	loop                            # label5:
	i32.const	$push0=, 255
	i32.and 	$2=, $7, $pop0
	i32.const	$3=, 0
	i32.sub 	$4=, $3, $2
	i32.const	$5=, 24
	i32.shl 	$0=, $4, $5
	i32.const	$6=, 127
	block
	block
	i32.and 	$push1=, $4, $1
	i32.gt_u	$push2=, $pop1, $6
	br_if   	$pop2, 0        # 0: down to label8
# BB#2:                                 # %cond.true.i.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.shr_s	$4=, $0, $5
	br      	1               # 1: down to label7
.LBB2_3:                                # %cond.false.i.i
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label8:
	i32.const	$push3=, -16777216
	i32.xor 	$push4=, $0, $pop3
	i32.shr_s	$push5=, $pop4, $5
	i32.const	$push6=, -1
	i32.xor 	$4=, $pop5, $pop6
.LBB2_4:                                # %fixnum_neg.exit.i
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label7:
	call    	foo@FUNCTION, $7, $4, $7
	i32.const	$push7=, 1
	i32.add 	$7=, $7, $pop7
	i32.ne  	$push8=, $2, $6
	br_if   	$pop8, 0        # 0: up to label5
# BB#5:                                 # %if.end
	end_loop                        # label6:
	return  	$3
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 3.9.0 "
	.section	".note.GNU-stack","",@progbits
