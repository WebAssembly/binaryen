	.text
	.file	"20020506-1.c"
	.section	.text.test1,"ax",@progbits
	.hidden	test1                   # -- Begin function test1
	.globl	test1
	.type	test1,@function
test1:                                  # @test1
	.param  	i32, i32
# %bb.0:                                # %entry
	block   	
	block   	
	block   	
	i32.const	$push0=, 0
	i32.lt_s	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label2
# %bb.1:                                # %if.then
	br_if   	1, $1           # 1: down to label1
	br      	2               # 2: down to label0
.LBB0_2:                                # %if.else
	end_block                       # label2:
	br_if   	1, $1           # 1: down to label0
.LBB0_3:                                # %if.then2
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_4:                                # %if.end45
	end_block                       # label0:
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	test1, .Lfunc_end0-test1
                                        # -- End function
	.section	.text.test2,"ax",@progbits
	.hidden	test2                   # -- Begin function test2
	.globl	test2
	.type	test2,@function
test2:                                  # @test2
	.param  	i32, i32
# %bb.0:                                # %entry
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
# %bb.1:                                # %if.then
	br_if   	1, $1           # 1: down to label4
	br      	2               # 2: down to label3
.LBB1_2:                                # %if.else
	end_block                       # label5:
	br_if   	1, $1           # 1: down to label3
.LBB1_3:                                # %if.then2
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB1_4:                                # %if.end45
	end_block                       # label3:
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	test2, .Lfunc_end1-test2
                                        # -- End function
	.section	.text.test3,"ax",@progbits
	.hidden	test3                   # -- Begin function test3
	.globl	test3
	.type	test3,@function
test3:                                  # @test3
	.param  	i32, i32
# %bb.0:                                # %entry
	block   	
	block   	
	block   	
	i32.const	$push0=, 0
	i32.lt_s	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label8
# %bb.1:                                # %if.then
	br_if   	1, $1           # 1: down to label7
	br      	2               # 2: down to label6
.LBB2_2:                                # %if.else
	end_block                       # label8:
	br_if   	1, $1           # 1: down to label6
.LBB2_3:                                # %if.then2
	end_block                       # label7:
	call    	abort@FUNCTION
	unreachable
.LBB2_4:                                # %if.end45
	end_block                       # label6:
                                        # fallthrough-return
	.endfunc
.Lfunc_end2:
	.size	test3, .Lfunc_end2-test3
                                        # -- End function
	.section	.text.test4,"ax",@progbits
	.hidden	test4                   # -- Begin function test4
	.globl	test4
	.type	test4,@function
test4:                                  # @test4
	.param  	i32, i32
# %bb.0:                                # %entry
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
# %bb.1:                                # %if.then
	br_if   	1, $1           # 1: down to label10
	br      	2               # 2: down to label9
.LBB3_2:                                # %if.else
	end_block                       # label11:
	br_if   	1, $1           # 1: down to label9
.LBB3_3:                                # %if.then2
	end_block                       # label10:
	call    	abort@FUNCTION
	unreachable
.LBB3_4:                                # %if.end45
	end_block                       # label9:
                                        # fallthrough-return
	.endfunc
.Lfunc_end3:
	.size	test4, .Lfunc_end3-test4
                                        # -- End function
	.section	.text.test5,"ax",@progbits
	.hidden	test5                   # -- Begin function test5
	.globl	test5
	.type	test5,@function
test5:                                  # @test5
	.param  	i32, i32
# %bb.0:                                # %entry
	block   	
	block   	
	block   	
	i32.const	$push0=, 0
	i32.lt_s	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label14
# %bb.1:                                # %if.then
	br_if   	1, $1           # 1: down to label13
	br      	2               # 2: down to label12
.LBB4_2:                                # %if.else
	end_block                       # label14:
	br_if   	1, $1           # 1: down to label12
.LBB4_3:                                # %if.then1
	end_block                       # label13:
	call    	abort@FUNCTION
	unreachable
.LBB4_4:                                # %if.end38
	end_block                       # label12:
                                        # fallthrough-return
	.endfunc
.Lfunc_end4:
	.size	test5, .Lfunc_end4-test5
                                        # -- End function
	.section	.text.test6,"ax",@progbits
	.hidden	test6                   # -- Begin function test6
	.globl	test6
	.type	test6,@function
test6:                                  # @test6
	.param  	i32, i32
# %bb.0:                                # %entry
	block   	
	block   	
	block   	
	i32.const	$push0=, 0
	i32.lt_s	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label17
# %bb.1:                                # %if.then
	br_if   	1, $1           # 1: down to label16
	br      	2               # 2: down to label15
.LBB5_2:                                # %if.else
	end_block                       # label17:
	br_if   	1, $1           # 1: down to label15
.LBB5_3:                                # %if.then1
	end_block                       # label16:
	call    	abort@FUNCTION
	unreachable
.LBB5_4:                                # %if.end38
	end_block                       # label15:
                                        # fallthrough-return
	.endfunc
.Lfunc_end5:
	.size	test6, .Lfunc_end5-test6
                                        # -- End function
	.section	.text.test7,"ax",@progbits
	.hidden	test7                   # -- Begin function test7
	.globl	test7
	.type	test7,@function
test7:                                  # @test7
	.param  	i64, i32
# %bb.0:                                # %entry
	block   	
	block   	
	block   	
	i64.const	$push0=, 0
	i64.lt_s	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label20
# %bb.1:                                # %if.then
	br_if   	1, $1           # 1: down to label19
	br      	2               # 2: down to label18
.LBB6_2:                                # %if.else
	end_block                       # label20:
	br_if   	1, $1           # 1: down to label18
.LBB6_3:                                # %if.then1
	end_block                       # label19:
	call    	abort@FUNCTION
	unreachable
.LBB6_4:                                # %if.end38
	end_block                       # label18:
                                        # fallthrough-return
	.endfunc
.Lfunc_end6:
	.size	test7, .Lfunc_end6-test7
                                        # -- End function
	.section	.text.test8,"ax",@progbits
	.hidden	test8                   # -- Begin function test8
	.globl	test8
	.type	test8,@function
test8:                                  # @test8
	.param  	i64, i32
# %bb.0:                                # %entry
	block   	
	block   	
	block   	
	i64.const	$push0=, 0
	i64.lt_s	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label23
# %bb.1:                                # %if.then
	br_if   	1, $1           # 1: down to label22
	br      	2               # 2: down to label21
.LBB7_2:                                # %if.else
	end_block                       # label23:
	br_if   	1, $1           # 1: down to label21
.LBB7_3:                                # %if.then1
	end_block                       # label22:
	call    	abort@FUNCTION
	unreachable
.LBB7_4:                                # %if.end38
	end_block                       # label21:
                                        # fallthrough-return
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
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end8:
	.size	main, .Lfunc_end8-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
