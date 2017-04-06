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
	i32.const	$2=, -128
	i32.const	$1=, -2147483648
	i32.const	$0=, 2130706432
.LBB1_1:                                # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	block   	
	block   	
	i32.const	$push10=, 0
	i32.sub 	$push0=, $pop10, $2
	i32.const	$push9=, 24
	i32.shl 	$push1=, $pop0, $pop9
	i32.const	$push8=, 24
	i32.shr_s	$push2=, $pop1, $pop8
	i32.const	$push7=, 0
	i32.lt_s	$push3=, $pop2, $pop7
	br_if   	0, $pop3        # 0: down to label3
# BB#2:                                 # %cond.true.i
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push11=, 24
	i32.shr_s	$3=, $1, $pop11
	br      	1               # 1: down to label2
.LBB1_3:                                # %cond.false.i
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label3:
	i32.const	$push13=, 24
	i32.shr_s	$push4=, $0, $pop13
	i32.const	$push12=, -1
	i32.xor 	$3=, $pop4, $pop12
.LBB1_4:                                # %fixnum_neg.exit
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label2:
	call    	foo@FUNCTION, $2, $3, $2
	i32.const	$push19=, 16777216
	i32.add 	$0=, $0, $pop19
	i32.const	$push18=, -16777216
	i32.add 	$1=, $1, $pop18
	i32.const	$push17=, 1
	i32.add 	$push16=, $2, $pop17
	tee_local	$push15=, $2=, $pop16
	i32.const	$push14=, 128
	i32.ne  	$push5=, $pop15, $pop14
	br_if   	0, $pop5        # 0: up to label1
# BB#5:                                 # %for.end
	end_loop
	i32.const	$push6=, 0
                                        # fallthrough-return: $pop6
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
	i32.const	$2=, -128
	i32.const	$1=, 2130706432
	i32.const	$0=, -2147483648
.LBB2_1:                                # %for.cond.i
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label4:
	block   	
	block   	
	i32.const	$push10=, 0
	i32.sub 	$push0=, $pop10, $2
	i32.const	$push9=, 24
	i32.shl 	$push1=, $pop0, $pop9
	i32.const	$push8=, 24
	i32.shr_s	$push2=, $pop1, $pop8
	i32.const	$push7=, 0
	i32.lt_s	$push3=, $pop2, $pop7
	br_if   	0, $pop3        # 0: down to label6
# BB#2:                                 # %cond.true.i.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push11=, 24
	i32.shr_s	$3=, $0, $pop11
	br      	1               # 1: down to label5
.LBB2_3:                                # %cond.false.i.i
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label6:
	i32.const	$push13=, 24
	i32.shr_s	$push4=, $1, $pop13
	i32.const	$push12=, -1
	i32.xor 	$3=, $pop4, $pop12
.LBB2_4:                                # %fixnum_neg.exit.i
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label5:
	call    	foo@FUNCTION, $2, $3, $2
	i32.const	$push19=, -16777216
	i32.add 	$0=, $0, $pop19
	i32.const	$push18=, 16777216
	i32.add 	$1=, $1, $pop18
	i32.const	$push17=, 1
	i32.add 	$push16=, $2, $pop17
	tee_local	$push15=, $2=, $pop16
	i32.const	$push14=, 128
	i32.ne  	$push5=, $pop15, $pop14
	br_if   	0, $pop5        # 0: up to label4
# BB#5:                                 # %if.end
	end_loop
	i32.const	$push6=, 0
                                        # fallthrough-return: $pop6
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 5.0.0 (https://chromium.googlesource.com/external/github.com/llvm-mirror/clang e7bf9bd23e5ab5ae3f79d88d3e8956f0067fc683) (https://chromium.googlesource.com/external/github.com/llvm-mirror/llvm 7bfedca6fc415b0e5edea211f299142b03de1e97)"
	.functype	abort, void
