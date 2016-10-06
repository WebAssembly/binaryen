	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/991216-1.c"
	.section	.text.test1,"ax",@progbits
	.hidden	test1
	.globl	test1
	.type	test1,@function
test1:                                  # @test1
	.param  	i32, i64, i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push0=, 1
	i32.ne  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %entry
	i64.const	$push2=, 81985529216486895
	i64.ne  	$push3=, $1, $pop2
	br_if   	0, $pop3        # 0: down to label0
# BB#2:                                 # %entry
	i32.const	$push4=, 85
	i32.ne  	$push5=, $2, $pop4
	br_if   	0, $pop5        # 0: down to label0
# BB#3:                                 # %if.end
	return
.LBB0_4:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	test1, .Lfunc_end0-test1

	.section	.text.test2,"ax",@progbits
	.hidden	test2
	.globl	test2
	.type	test2,@function
test2:                                  # @test2
	.param  	i32, i32, i64, i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push0=, 1
	i32.ne  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label1
# BB#1:                                 # %entry
	i32.const	$push2=, 2
	i32.ne  	$push3=, $1, $pop2
	br_if   	0, $pop3        # 0: down to label1
# BB#2:                                 # %entry
	i64.const	$push4=, 81985529216486895
	i64.ne  	$push5=, $2, $pop4
	br_if   	0, $pop5        # 0: down to label1
# BB#3:                                 # %entry
	i32.const	$push6=, 85
	i32.ne  	$push7=, $3, $pop6
	br_if   	0, $pop7        # 0: down to label1
# BB#4:                                 # %if.end
	return
.LBB1_5:                                # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	test2, .Lfunc_end1-test2

	.section	.text.test3,"ax",@progbits
	.hidden	test3
	.globl	test3
	.type	test3,@function
test3:                                  # @test3
	.param  	i32, i32, i32, i64, i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push0=, 1
	i32.ne  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label2
# BB#1:                                 # %entry
	i32.const	$push2=, 2
	i32.ne  	$push3=, $1, $pop2
	br_if   	0, $pop3        # 0: down to label2
# BB#2:                                 # %entry
	i32.const	$push4=, 3
	i32.ne  	$push5=, $2, $pop4
	br_if   	0, $pop5        # 0: down to label2
# BB#3:                                 # %entry
	i64.const	$push6=, 81985529216486895
	i64.ne  	$push7=, $3, $pop6
	br_if   	0, $pop7        # 0: down to label2
# BB#4:                                 # %entry
	i32.const	$push8=, 85
	i32.ne  	$push9=, $4, $pop8
	br_if   	0, $pop9        # 0: down to label2
# BB#5:                                 # %if.end
	return
.LBB2_6:                                # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	test3, .Lfunc_end2-test3

	.section	.text.test4,"ax",@progbits
	.hidden	test4
	.globl	test4
	.type	test4,@function
test4:                                  # @test4
	.param  	i32, i32, i32, i32, i64, i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push0=, 1
	i32.ne  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label3
# BB#1:                                 # %entry
	i32.const	$push2=, 2
	i32.ne  	$push3=, $1, $pop2
	br_if   	0, $pop3        # 0: down to label3
# BB#2:                                 # %entry
	i32.const	$push4=, 3
	i32.ne  	$push5=, $2, $pop4
	br_if   	0, $pop5        # 0: down to label3
# BB#3:                                 # %entry
	i32.const	$push6=, 4
	i32.ne  	$push7=, $3, $pop6
	br_if   	0, $pop7        # 0: down to label3
# BB#4:                                 # %entry
	i64.const	$push8=, 81985529216486895
	i64.ne  	$push9=, $4, $pop8
	br_if   	0, $pop9        # 0: down to label3
# BB#5:                                 # %entry
	i32.const	$push10=, 85
	i32.ne  	$push11=, $5, $pop10
	br_if   	0, $pop11       # 0: down to label3
# BB#6:                                 # %if.end
	return
.LBB3_7:                                # %if.then
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end3:
	.size	test4, .Lfunc_end3-test4

	.section	.text.test5,"ax",@progbits
	.hidden	test5
	.globl	test5
	.type	test5,@function
test5:                                  # @test5
	.param  	i32, i32, i32, i32, i32, i64, i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push0=, 1
	i32.ne  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label4
# BB#1:                                 # %entry
	i32.const	$push2=, 2
	i32.ne  	$push3=, $1, $pop2
	br_if   	0, $pop3        # 0: down to label4
# BB#2:                                 # %entry
	i32.const	$push4=, 3
	i32.ne  	$push5=, $2, $pop4
	br_if   	0, $pop5        # 0: down to label4
# BB#3:                                 # %entry
	i32.const	$push6=, 4
	i32.ne  	$push7=, $3, $pop6
	br_if   	0, $pop7        # 0: down to label4
# BB#4:                                 # %entry
	i32.const	$push8=, 5
	i32.ne  	$push9=, $4, $pop8
	br_if   	0, $pop9        # 0: down to label4
# BB#5:                                 # %entry
	i64.const	$push10=, 81985529216486895
	i64.ne  	$push11=, $5, $pop10
	br_if   	0, $pop11       # 0: down to label4
# BB#6:                                 # %entry
	i32.const	$push12=, 85
	i32.ne  	$push13=, $6, $pop12
	br_if   	0, $pop13       # 0: down to label4
# BB#7:                                 # %if.end
	return
.LBB4_8:                                # %if.then
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end4:
	.size	test5, .Lfunc_end4-test5

	.section	.text.test6,"ax",@progbits
	.hidden	test6
	.globl	test6
	.type	test6,@function
test6:                                  # @test6
	.param  	i32, i32, i32, i32, i32, i32, i64, i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push0=, 1
	i32.ne  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label5
# BB#1:                                 # %entry
	i32.const	$push2=, 2
	i32.ne  	$push3=, $1, $pop2
	br_if   	0, $pop3        # 0: down to label5
# BB#2:                                 # %entry
	i32.const	$push4=, 3
	i32.ne  	$push5=, $2, $pop4
	br_if   	0, $pop5        # 0: down to label5
# BB#3:                                 # %entry
	i32.const	$push6=, 4
	i32.ne  	$push7=, $3, $pop6
	br_if   	0, $pop7        # 0: down to label5
# BB#4:                                 # %entry
	i32.const	$push8=, 5
	i32.ne  	$push9=, $4, $pop8
	br_if   	0, $pop9        # 0: down to label5
# BB#5:                                 # %entry
	i32.const	$push10=, 6
	i32.ne  	$push11=, $5, $pop10
	br_if   	0, $pop11       # 0: down to label5
# BB#6:                                 # %entry
	i64.const	$push12=, 81985529216486895
	i64.ne  	$push13=, $6, $pop12
	br_if   	0, $pop13       # 0: down to label5
# BB#7:                                 # %entry
	i32.const	$push14=, 85
	i32.ne  	$push15=, $7, $pop14
	br_if   	0, $pop15       # 0: down to label5
# BB#8:                                 # %if.end
	return
.LBB5_9:                                # %if.then
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end5:
	.size	test6, .Lfunc_end5-test6

	.section	.text.test7,"ax",@progbits
	.hidden	test7
	.globl	test7
	.type	test7,@function
test7:                                  # @test7
	.param  	i32, i32, i32, i32, i32, i32, i32, i64, i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push0=, 1
	i32.ne  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label6
# BB#1:                                 # %entry
	i32.const	$push2=, 2
	i32.ne  	$push3=, $1, $pop2
	br_if   	0, $pop3        # 0: down to label6
# BB#2:                                 # %entry
	i32.const	$push4=, 3
	i32.ne  	$push5=, $2, $pop4
	br_if   	0, $pop5        # 0: down to label6
# BB#3:                                 # %entry
	i32.const	$push6=, 4
	i32.ne  	$push7=, $3, $pop6
	br_if   	0, $pop7        # 0: down to label6
# BB#4:                                 # %entry
	i32.const	$push8=, 5
	i32.ne  	$push9=, $4, $pop8
	br_if   	0, $pop9        # 0: down to label6
# BB#5:                                 # %entry
	i32.const	$push10=, 6
	i32.ne  	$push11=, $5, $pop10
	br_if   	0, $pop11       # 0: down to label6
# BB#6:                                 # %entry
	i32.const	$push12=, 7
	i32.ne  	$push13=, $6, $pop12
	br_if   	0, $pop13       # 0: down to label6
# BB#7:                                 # %entry
	i64.const	$push14=, 81985529216486895
	i64.ne  	$push15=, $7, $pop14
	br_if   	0, $pop15       # 0: down to label6
# BB#8:                                 # %entry
	i32.const	$push16=, 85
	i32.ne  	$push17=, $8, $pop16
	br_if   	0, $pop17       # 0: down to label6
# BB#9:                                 # %if.end
	return
.LBB6_10:                               # %if.then
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end6:
	.size	test7, .Lfunc_end6-test7

	.section	.text.test8,"ax",@progbits
	.hidden	test8
	.globl	test8
	.type	test8,@function
test8:                                  # @test8
	.param  	i32, i32, i32, i32, i32, i32, i32, i32, i64, i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push0=, 1
	i32.ne  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label7
# BB#1:                                 # %entry
	i32.const	$push2=, 2
	i32.ne  	$push3=, $1, $pop2
	br_if   	0, $pop3        # 0: down to label7
# BB#2:                                 # %entry
	i32.const	$push4=, 3
	i32.ne  	$push5=, $2, $pop4
	br_if   	0, $pop5        # 0: down to label7
# BB#3:                                 # %entry
	i32.const	$push6=, 4
	i32.ne  	$push7=, $3, $pop6
	br_if   	0, $pop7        # 0: down to label7
# BB#4:                                 # %entry
	i32.const	$push8=, 5
	i32.ne  	$push9=, $4, $pop8
	br_if   	0, $pop9        # 0: down to label7
# BB#5:                                 # %entry
	i32.const	$push10=, 6
	i32.ne  	$push11=, $5, $pop10
	br_if   	0, $pop11       # 0: down to label7
# BB#6:                                 # %entry
	i32.const	$push12=, 7
	i32.ne  	$push13=, $6, $pop12
	br_if   	0, $pop13       # 0: down to label7
# BB#7:                                 # %entry
	i32.const	$push14=, 8
	i32.ne  	$push15=, $7, $pop14
	br_if   	0, $pop15       # 0: down to label7
# BB#8:                                 # %entry
	i64.const	$push16=, 81985529216486895
	i64.ne  	$push17=, $8, $pop16
	br_if   	0, $pop17       # 0: down to label7
# BB#9:                                 # %entry
	i32.const	$push18=, 85
	i32.ne  	$push19=, $9, $pop18
	br_if   	0, $pop19       # 0: down to label7
# BB#10:                                # %if.end
	return
.LBB7_11:                               # %if.then
	end_block                       # label7:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end7:
	.size	test8, .Lfunc_end7-test8

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end8:
	.size	main, .Lfunc_end8-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
