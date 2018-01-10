	.text
	.file	"20020510-1.c"
	.section	.text.testc,"ax",@progbits
	.hidden	testc                   # -- Begin function testc
	.globl	testc
	.type	testc,@function
testc:                                  # @testc
	.param  	i32, i32
# %bb.0:                                # %entry
	block   	
	block   	
	block   	
	i32.const	$push0=, 24
	i32.shl 	$push1=, $0, $pop0
	i32.const	$push5=, 24
	i32.shr_s	$push2=, $pop1, $pop5
	i32.const	$push3=, 1
	i32.lt_s	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label2
# %bb.1:                                # %if.then
	i32.eqz 	$push6=, $1
	br_if   	1, $pop6        # 1: down to label1
	br      	2               # 2: down to label0
.LBB0_2:                                # %if.else
	end_block                       # label2:
	i32.eqz 	$push7=, $1
	br_if   	1, $pop7        # 1: down to label0
.LBB0_3:                                # %if.then5
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_4:                                # %if.end9
	end_block                       # label0:
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	testc, .Lfunc_end0-testc
                                        # -- End function
	.section	.text.tests,"ax",@progbits
	.hidden	tests                   # -- Begin function tests
	.globl	tests
	.type	tests,@function
tests:                                  # @tests
	.param  	i32, i32
# %bb.0:                                # %entry
	block   	
	block   	
	block   	
	i32.const	$push0=, 16
	i32.shl 	$push1=, $0, $pop0
	i32.const	$push5=, 16
	i32.shr_s	$push2=, $pop1, $pop5
	i32.const	$push3=, 1
	i32.lt_s	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label5
# %bb.1:                                # %if.then
	i32.eqz 	$push6=, $1
	br_if   	1, $pop6        # 1: down to label4
	br      	2               # 2: down to label3
.LBB1_2:                                # %if.else
	end_block                       # label5:
	i32.eqz 	$push7=, $1
	br_if   	1, $pop7        # 1: down to label3
.LBB1_3:                                # %if.then5
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB1_4:                                # %if.end9
	end_block                       # label3:
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	tests, .Lfunc_end1-tests
                                        # -- End function
	.section	.text.testi,"ax",@progbits
	.hidden	testi                   # -- Begin function testi
	.globl	testi
	.type	testi,@function
testi:                                  # @testi
	.param  	i32, i32
# %bb.0:                                # %entry
	block   	
	block   	
	block   	
	i32.const	$push0=, 1
	i32.lt_s	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label8
# %bb.1:                                # %if.then
	i32.eqz 	$push2=, $1
	br_if   	1, $pop2        # 1: down to label7
	br      	2               # 2: down to label6
.LBB2_2:                                # %if.else
	end_block                       # label8:
	i32.eqz 	$push3=, $1
	br_if   	1, $pop3        # 1: down to label6
.LBB2_3:                                # %if.then2
	end_block                       # label7:
	call    	abort@FUNCTION
	unreachable
.LBB2_4:                                # %if.end6
	end_block                       # label6:
                                        # fallthrough-return
	.endfunc
.Lfunc_end2:
	.size	testi, .Lfunc_end2-testi
                                        # -- End function
	.section	.text.testl,"ax",@progbits
	.hidden	testl                   # -- Begin function testl
	.globl	testl
	.type	testl,@function
testl:                                  # @testl
	.param  	i32, i32
# %bb.0:                                # %entry
	block   	
	block   	
	block   	
	i32.const	$push0=, 1
	i32.lt_s	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label11
# %bb.1:                                # %if.then
	i32.eqz 	$push2=, $1
	br_if   	1, $pop2        # 1: down to label10
	br      	2               # 2: down to label9
.LBB3_2:                                # %if.else
	end_block                       # label11:
	i32.eqz 	$push3=, $1
	br_if   	1, $pop3        # 1: down to label9
.LBB3_3:                                # %if.then2
	end_block                       # label10:
	call    	abort@FUNCTION
	unreachable
.LBB3_4:                                # %if.end6
	end_block                       # label9:
                                        # fallthrough-return
	.endfunc
.Lfunc_end3:
	.size	testl, .Lfunc_end3-testl
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
.Lfunc_end4:
	.size	main, .Lfunc_end4-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
