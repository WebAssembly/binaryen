	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20020506-1.c"
	.section	.text.test1,"ax",@progbits
	.hidden	test1
	.globl	test1
	.type	test1,@function
test1:                                  # @test1
	.param  	i32, i32
# BB#0:                                 # %entry
	block   	
	block   	
	block   	
	i32.const	$push0=, 0
	i32.lt_s	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label2
# BB#1:                                 # %if.then
	i32.eqz 	$push2=, $1
	br_if   	1, $pop2        # 1: down to label1
# BB#2:                                 # %if.then2
	call    	abort@FUNCTION
	unreachable
.LBB0_3:                                # %if.else
	end_block                       # label2:
	i32.eqz 	$push3=, $1
	br_if   	1, $pop3        # 1: down to label0
.LBB0_4:                                # %if.end45
	end_block                       # label1:
	return
.LBB0_5:                                # %if.then4
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
	.param  	i32, i32
# BB#0:                                 # %entry
	block   	
	block   	
	block   	
	i32.const	$push0=, 24
	i32.shl 	$push1=, $0, $pop0
	i32.const	$push5=, 24
	i32.shr_s	$push2=, $pop1, $pop5
	i32.const	$push3=, 0
	i32.lt_s	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label5
# BB#1:                                 # %if.then
	i32.eqz 	$push6=, $1
	br_if   	1, $pop6        # 1: down to label4
# BB#2:                                 # %if.then2
	call    	abort@FUNCTION
	unreachable
.LBB1_3:                                # %if.else
	end_block                       # label5:
	i32.eqz 	$push7=, $1
	br_if   	1, $pop7        # 1: down to label3
.LBB1_4:                                # %if.end45
	end_block                       # label4:
	return
.LBB1_5:                                # %if.then4
	end_block                       # label3:
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
	.param  	i32, i32
# BB#0:                                 # %entry
	block   	
	block   	
	block   	
	i32.const	$push0=, 0
	i32.lt_s	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label8
# BB#1:                                 # %if.then
	i32.eqz 	$push2=, $1
	br_if   	1, $pop2        # 1: down to label7
# BB#2:                                 # %if.then2
	call    	abort@FUNCTION
	unreachable
.LBB2_3:                                # %if.else
	end_block                       # label8:
	i32.eqz 	$push3=, $1
	br_if   	1, $pop3        # 1: down to label6
.LBB2_4:                                # %if.end45
	end_block                       # label7:
	return
.LBB2_5:                                # %if.then4
	end_block                       # label6:
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
	.param  	i32, i32
# BB#0:                                 # %entry
	block   	
	block   	
	block   	
	i32.const	$push0=, 16
	i32.shl 	$push1=, $0, $pop0
	i32.const	$push5=, 16
	i32.shr_s	$push2=, $pop1, $pop5
	i32.const	$push3=, 0
	i32.lt_s	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label11
# BB#1:                                 # %if.then
	i32.eqz 	$push6=, $1
	br_if   	1, $pop6        # 1: down to label10
# BB#2:                                 # %if.then2
	call    	abort@FUNCTION
	unreachable
.LBB3_3:                                # %if.else
	end_block                       # label11:
	i32.eqz 	$push7=, $1
	br_if   	1, $pop7        # 1: down to label9
.LBB3_4:                                # %if.end45
	end_block                       # label10:
	return
.LBB3_5:                                # %if.then4
	end_block                       # label9:
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
	.param  	i32, i32
# BB#0:                                 # %entry
	block   	
	block   	
	block   	
	i32.const	$push0=, 0
	i32.lt_s	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label14
# BB#1:                                 # %if.then
	i32.eqz 	$push2=, $1
	br_if   	1, $pop2        # 1: down to label13
# BB#2:                                 # %if.then1
	call    	abort@FUNCTION
	unreachable
.LBB4_3:                                # %if.else
	end_block                       # label14:
	i32.eqz 	$push3=, $1
	br_if   	1, $pop3        # 1: down to label12
.LBB4_4:                                # %if.end38
	end_block                       # label13:
	return
.LBB4_5:                                # %if.then3
	end_block                       # label12:
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
	.param  	i32, i32
# BB#0:                                 # %entry
	block   	
	block   	
	block   	
	i32.const	$push0=, 0
	i32.lt_s	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label17
# BB#1:                                 # %if.then
	i32.eqz 	$push2=, $1
	br_if   	1, $pop2        # 1: down to label16
# BB#2:                                 # %if.then1
	call    	abort@FUNCTION
	unreachable
.LBB5_3:                                # %if.else
	end_block                       # label17:
	i32.eqz 	$push3=, $1
	br_if   	1, $pop3        # 1: down to label15
.LBB5_4:                                # %if.end38
	end_block                       # label16:
	return
.LBB5_5:                                # %if.then3
	end_block                       # label15:
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
	.param  	i64, i32
# BB#0:                                 # %entry
	block   	
	block   	
	block   	
	i64.const	$push0=, 0
	i64.lt_s	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label20
# BB#1:                                 # %if.then
	i32.eqz 	$push2=, $1
	br_if   	1, $pop2        # 1: down to label19
# BB#2:                                 # %if.then1
	call    	abort@FUNCTION
	unreachable
.LBB6_3:                                # %if.else
	end_block                       # label20:
	i32.eqz 	$push3=, $1
	br_if   	1, $pop3        # 1: down to label18
.LBB6_4:                                # %if.end38
	end_block                       # label19:
	return
.LBB6_5:                                # %if.then3
	end_block                       # label18:
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
	.param  	i64, i32
# BB#0:                                 # %entry
	block   	
	block   	
	block   	
	i64.const	$push0=, 0
	i64.lt_s	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label23
# BB#1:                                 # %if.then
	i32.eqz 	$push2=, $1
	br_if   	1, $pop2        # 1: down to label22
# BB#2:                                 # %if.then1
	call    	abort@FUNCTION
	unreachable
.LBB7_3:                                # %if.else
	end_block                       # label23:
	i32.eqz 	$push3=, $1
	br_if   	1, $pop3        # 1: down to label21
.LBB7_4:                                # %if.end38
	end_block                       # label22:
	return
.LBB7_5:                                # %if.then3
	end_block                       # label21:
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
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end8:
	.size	main, .Lfunc_end8-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
