	.text
	.file	"pr43560.c"
	.section	.text.test,"ax",@progbits
	.hidden	test                    # -- Begin function test
	.globl	test
	.type	test,@function
test:                                   # @test
	.param  	i32
	.local  	i32, i32, i32
# %bb.0:                                # %entry
	i32.load	$3=, 4($0)
	block   	
	i32.const	$push0=, 2
	i32.lt_s	$push1=, $3, $pop0
	br_if   	0, $pop1        # 0: down to label0
# %bb.1:                                # %land.rhs.preheader
	i32.const	$push5=, 4
	i32.add 	$2=, $0, $pop5
.LBB0_2:                                # %land.rhs
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.const	$push9=, -1
	i32.add 	$3=, $3, $pop9
	i32.add 	$push2=, $0, $3
	i32.const	$push8=, 8
	i32.add 	$1=, $pop2, $pop8
	i32.load8_u	$push3=, 0($1)
	i32.const	$push7=, 47
	i32.ne  	$push4=, $pop3, $pop7
	br_if   	1, $pop4        # 1: down to label0
# %bb.3:                                # %while.body
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.store	0($2), $3
	i32.const	$push11=, 0
	i32.store8	0($1), $pop11
	i32.load	$3=, 0($2)
	i32.const	$push10=, 1
	i32.gt_s	$push6=, $3, $pop10
	br_if   	0, $pop6        # 0: up to label1
.LBB0_4:                                # %while.end
	end_loop
	end_block                       # label0:
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	test, .Lfunc_end0-test
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$0=, s
	#APP
	#NO_APP
	call    	test@FUNCTION, $0
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	s                       # @s
	.type	s,@object
	.section	.rodata.s,"a",@progbits
	.globl	s
	.p2align	2
s:
	.skip	20
	.size	s, 20


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
