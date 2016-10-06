	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr45034.c"
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
	br_if   	0, $pop3        # 0: down to label0
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
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, 128
.LBB1_1:                                # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.const	$push14=, 0
	i32.const	$push13=, 255
	i32.and 	$push12=, $3, $pop13
	tee_local	$push11=, $1=, $pop12
	i32.sub 	$push10=, $pop14, $pop11
	tee_local	$push9=, $2=, $pop10
	i32.const	$push8=, 24
	i32.shl 	$0=, $pop9, $pop8
	block   	
	block   	
	i32.const	$push7=, 128
	i32.and 	$push0=, $2, $pop7
	i32.const	$push6=, 127
	i32.gt_u	$push1=, $pop0, $pop6
	br_if   	0, $pop1        # 0: down to label3
# BB#2:                                 # %cond.true.i
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push15=, 24
	i32.shr_s	$2=, $0, $pop15
	br      	1               # 1: down to label2
.LBB1_3:                                # %cond.false.i
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label3:
	i32.const	$push18=, -16777216
	i32.xor 	$push2=, $0, $pop18
	i32.const	$push17=, 24
	i32.shr_s	$push3=, $pop2, $pop17
	i32.const	$push16=, -1
	i32.xor 	$2=, $pop3, $pop16
.LBB1_4:                                # %fixnum_neg.exit
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label2:
	call    	foo@FUNCTION, $3, $2, $3
	i32.const	$push20=, 1
	i32.add 	$3=, $3, $pop20
	i32.const	$push19=, 127
	i32.ne  	$push4=, $1, $pop19
	br_if   	0, $pop4        # 0: up to label1
# BB#5:                                 # %for.end
	end_loop
	i32.const	$push5=, 0
                                        # fallthrough-return: $pop5
	.endfunc
.Lfunc_end1:
	.size	test_neg, .Lfunc_end1-test_neg

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, 128
.LBB2_1:                                # %for.cond.i
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label4:
	i32.const	$push14=, 0
	i32.const	$push13=, 255
	i32.and 	$push12=, $3, $pop13
	tee_local	$push11=, $1=, $pop12
	i32.sub 	$push10=, $pop14, $pop11
	tee_local	$push9=, $2=, $pop10
	i32.const	$push8=, 24
	i32.shl 	$0=, $pop9, $pop8
	block   	
	block   	
	i32.const	$push7=, 128
	i32.and 	$push0=, $2, $pop7
	i32.const	$push6=, 127
	i32.gt_u	$push1=, $pop0, $pop6
	br_if   	0, $pop1        # 0: down to label6
# BB#2:                                 # %cond.true.i.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push15=, 24
	i32.shr_s	$2=, $0, $pop15
	br      	1               # 1: down to label5
.LBB2_3:                                # %cond.false.i.i
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label6:
	i32.const	$push18=, -16777216
	i32.xor 	$push2=, $0, $pop18
	i32.const	$push17=, 24
	i32.shr_s	$push3=, $pop2, $pop17
	i32.const	$push16=, -1
	i32.xor 	$2=, $pop3, $pop16
.LBB2_4:                                # %fixnum_neg.exit.i
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label5:
	call    	foo@FUNCTION, $3, $2, $3
	i32.const	$push20=, 1
	i32.add 	$3=, $3, $pop20
	i32.const	$push19=, 127
	i32.ne  	$push4=, $1, $pop19
	br_if   	0, $pop4        # 0: up to label4
# BB#5:                                 # %if.end
	end_loop
	i32.const	$push5=, 0
                                        # fallthrough-return: $pop5
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
