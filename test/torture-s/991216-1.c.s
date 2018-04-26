	.text
	.file	"991216-1.c"
	.section	.text.test1,"ax",@progbits
	.hidden	test1                   # -- Begin function test1
	.globl	test1
	.type	test1,@function
test1:                                  # @test1
	.param  	i32, i64, i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push0=, 1
	i32.ne  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label0
# %bb.1:                                # %entry
	i64.const	$push2=, 81985529216486895
	i64.ne  	$push3=, $1, $pop2
	br_if   	0, $pop3        # 0: down to label0
# %bb.2:                                # %entry
	i32.const	$push4=, 85
	i32.ne  	$push5=, $2, $pop4
	br_if   	0, $pop5        # 0: down to label0
# %bb.3:                                # %if.end
	return
.LBB0_4:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	test1, .Lfunc_end0-test1
                                        # -- End function
	.section	.text.test2,"ax",@progbits
	.hidden	test2                   # -- Begin function test2
	.globl	test2
	.type	test2,@function
test2:                                  # @test2
	.param  	i32, i32, i64, i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push0=, 1
	i32.ne  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label1
# %bb.1:                                # %entry
	i32.const	$push2=, 2
	i32.ne  	$push3=, $1, $pop2
	br_if   	0, $pop3        # 0: down to label1
# %bb.2:                                # %entry
	i64.const	$push4=, 81985529216486895
	i64.ne  	$push5=, $2, $pop4
	br_if   	0, $pop5        # 0: down to label1
# %bb.3:                                # %entry
	i32.const	$push6=, 85
	i32.ne  	$push7=, $3, $pop6
	br_if   	0, $pop7        # 0: down to label1
# %bb.4:                                # %if.end
	return
.LBB1_5:                                # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	test2, .Lfunc_end1-test2
                                        # -- End function
	.section	.text.test3,"ax",@progbits
	.hidden	test3                   # -- Begin function test3
	.globl	test3
	.type	test3,@function
test3:                                  # @test3
	.param  	i32, i32, i32, i64, i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push0=, 1
	i32.ne  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label2
# %bb.1:                                # %entry
	i32.const	$push2=, 2
	i32.ne  	$push3=, $1, $pop2
	br_if   	0, $pop3        # 0: down to label2
# %bb.2:                                # %entry
	i32.const	$push4=, 3
	i32.ne  	$push5=, $2, $pop4
	br_if   	0, $pop5        # 0: down to label2
# %bb.3:                                # %entry
	i64.const	$push6=, 81985529216486895
	i64.ne  	$push7=, $3, $pop6
	br_if   	0, $pop7        # 0: down to label2
# %bb.4:                                # %entry
	i32.const	$push8=, 85
	i32.ne  	$push9=, $4, $pop8
	br_if   	0, $pop9        # 0: down to label2
# %bb.5:                                # %if.end
	return
.LBB2_6:                                # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	test3, .Lfunc_end2-test3
                                        # -- End function
	.section	.text.test4,"ax",@progbits
	.hidden	test4                   # -- Begin function test4
	.globl	test4
	.type	test4,@function
test4:                                  # @test4
	.param  	i32, i32, i32, i32, i64, i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push0=, 1
	i32.ne  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label3
# %bb.1:                                # %entry
	i32.const	$push2=, 2
	i32.ne  	$push3=, $1, $pop2
	br_if   	0, $pop3        # 0: down to label3
# %bb.2:                                # %entry
	i32.const	$push4=, 3
	i32.ne  	$push5=, $2, $pop4
	br_if   	0, $pop5        # 0: down to label3
# %bb.3:                                # %entry
	i32.const	$push6=, 4
	i32.ne  	$push7=, $3, $pop6
	br_if   	0, $pop7        # 0: down to label3
# %bb.4:                                # %entry
	i64.const	$push8=, 81985529216486895
	i64.ne  	$push9=, $4, $pop8
	br_if   	0, $pop9        # 0: down to label3
# %bb.5:                                # %entry
	i32.const	$push10=, 85
	i32.ne  	$push11=, $5, $pop10
	br_if   	0, $pop11       # 0: down to label3
# %bb.6:                                # %if.end
	return
.LBB3_7:                                # %if.then
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end3:
	.size	test4, .Lfunc_end3-test4
                                        # -- End function
	.section	.text.test5,"ax",@progbits
	.hidden	test5                   # -- Begin function test5
	.globl	test5
	.type	test5,@function
test5:                                  # @test5
	.param  	i32, i32, i32, i32, i32, i64, i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push0=, 1
	i32.ne  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label4
# %bb.1:                                # %entry
	i32.const	$push2=, 2
	i32.ne  	$push3=, $1, $pop2
	br_if   	0, $pop3        # 0: down to label4
# %bb.2:                                # %entry
	i32.const	$push4=, 3
	i32.ne  	$push5=, $2, $pop4
	br_if   	0, $pop5        # 0: down to label4
# %bb.3:                                # %entry
	i32.const	$push6=, 4
	i32.ne  	$push7=, $3, $pop6
	br_if   	0, $pop7        # 0: down to label4
# %bb.4:                                # %entry
	i32.const	$push8=, 5
	i32.ne  	$push9=, $4, $pop8
	br_if   	0, $pop9        # 0: down to label4
# %bb.5:                                # %entry
	i64.const	$push10=, 81985529216486895
	i64.ne  	$push11=, $5, $pop10
	br_if   	0, $pop11       # 0: down to label4
# %bb.6:                                # %entry
	i32.const	$push12=, 85
	i32.ne  	$push13=, $6, $pop12
	br_if   	0, $pop13       # 0: down to label4
# %bb.7:                                # %if.end
	return
.LBB4_8:                                # %if.then
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end4:
	.size	test5, .Lfunc_end4-test5
                                        # -- End function
	.section	.text.test6,"ax",@progbits
	.hidden	test6                   # -- Begin function test6
	.globl	test6
	.type	test6,@function
test6:                                  # @test6
	.param  	i32, i32, i32, i32, i32, i32, i64, i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push0=, 1
	i32.ne  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label5
# %bb.1:                                # %entry
	i32.const	$push2=, 2
	i32.ne  	$push3=, $1, $pop2
	br_if   	0, $pop3        # 0: down to label5
# %bb.2:                                # %entry
	i32.const	$push4=, 3
	i32.ne  	$push5=, $2, $pop4
	br_if   	0, $pop5        # 0: down to label5
# %bb.3:                                # %entry
	i32.const	$push6=, 4
	i32.ne  	$push7=, $3, $pop6
	br_if   	0, $pop7        # 0: down to label5
# %bb.4:                                # %entry
	i32.const	$push8=, 5
	i32.ne  	$push9=, $4, $pop8
	br_if   	0, $pop9        # 0: down to label5
# %bb.5:                                # %entry
	i32.const	$push10=, 6
	i32.ne  	$push11=, $5, $pop10
	br_if   	0, $pop11       # 0: down to label5
# %bb.6:                                # %entry
	i64.const	$push12=, 81985529216486895
	i64.ne  	$push13=, $6, $pop12
	br_if   	0, $pop13       # 0: down to label5
# %bb.7:                                # %entry
	i32.const	$push14=, 85
	i32.ne  	$push15=, $7, $pop14
	br_if   	0, $pop15       # 0: down to label5
# %bb.8:                                # %if.end
	return
.LBB5_9:                                # %if.then
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end5:
	.size	test6, .Lfunc_end5-test6
                                        # -- End function
	.section	.text.test7,"ax",@progbits
	.hidden	test7                   # -- Begin function test7
	.globl	test7
	.type	test7,@function
test7:                                  # @test7
	.param  	i32, i32, i32, i32, i32, i32, i32, i64, i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push0=, 1
	i32.ne  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label6
# %bb.1:                                # %entry
	i32.const	$push2=, 2
	i32.ne  	$push3=, $1, $pop2
	br_if   	0, $pop3        # 0: down to label6
# %bb.2:                                # %entry
	i32.const	$push4=, 3
	i32.ne  	$push5=, $2, $pop4
	br_if   	0, $pop5        # 0: down to label6
# %bb.3:                                # %entry
	i32.const	$push6=, 4
	i32.ne  	$push7=, $3, $pop6
	br_if   	0, $pop7        # 0: down to label6
# %bb.4:                                # %entry
	i32.const	$push8=, 5
	i32.ne  	$push9=, $4, $pop8
	br_if   	0, $pop9        # 0: down to label6
# %bb.5:                                # %entry
	i32.const	$push10=, 6
	i32.ne  	$push11=, $5, $pop10
	br_if   	0, $pop11       # 0: down to label6
# %bb.6:                                # %entry
	i32.const	$push12=, 7
	i32.ne  	$push13=, $6, $pop12
	br_if   	0, $pop13       # 0: down to label6
# %bb.7:                                # %entry
	i64.const	$push14=, 81985529216486895
	i64.ne  	$push15=, $7, $pop14
	br_if   	0, $pop15       # 0: down to label6
# %bb.8:                                # %entry
	i32.const	$push16=, 85
	i32.ne  	$push17=, $8, $pop16
	br_if   	0, $pop17       # 0: down to label6
# %bb.9:                                # %if.end
	return
.LBB6_10:                               # %if.then
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end6:
	.size	test7, .Lfunc_end6-test7
                                        # -- End function
	.section	.text.test8,"ax",@progbits
	.hidden	test8                   # -- Begin function test8
	.globl	test8
	.type	test8,@function
test8:                                  # @test8
	.param  	i32, i32, i32, i32, i32, i32, i32, i32, i64, i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push0=, 1
	i32.ne  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label7
# %bb.1:                                # %entry
	i32.const	$push2=, 2
	i32.ne  	$push3=, $1, $pop2
	br_if   	0, $pop3        # 0: down to label7
# %bb.2:                                # %entry
	i32.const	$push4=, 3
	i32.ne  	$push5=, $2, $pop4
	br_if   	0, $pop5        # 0: down to label7
# %bb.3:                                # %entry
	i32.const	$push6=, 4
	i32.ne  	$push7=, $3, $pop6
	br_if   	0, $pop7        # 0: down to label7
# %bb.4:                                # %entry
	i32.const	$push8=, 5
	i32.ne  	$push9=, $4, $pop8
	br_if   	0, $pop9        # 0: down to label7
# %bb.5:                                # %entry
	i32.const	$push10=, 6
	i32.ne  	$push11=, $5, $pop10
	br_if   	0, $pop11       # 0: down to label7
# %bb.6:                                # %entry
	i32.const	$push12=, 7
	i32.ne  	$push13=, $6, $pop12
	br_if   	0, $pop13       # 0: down to label7
# %bb.7:                                # %entry
	i32.const	$push14=, 8
	i32.ne  	$push15=, $7, $pop14
	br_if   	0, $pop15       # 0: down to label7
# %bb.8:                                # %entry
	i64.const	$push16=, 81985529216486895
	i64.ne  	$push17=, $8, $pop16
	br_if   	0, $pop17       # 0: down to label7
# %bb.9:                                # %entry
	i32.const	$push18=, 85
	i32.ne  	$push19=, $9, $pop18
	br_if   	0, $pop19       # 0: down to label7
# %bb.10:                               # %if.end
	return
.LBB7_11:                               # %if.then
	end_block                       # label7:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end7:
	.size	test8, .Lfunc_end7-test8
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end8:
	.size	main, .Lfunc_end8-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
