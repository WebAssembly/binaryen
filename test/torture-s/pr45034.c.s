	.text
	.file	"pr45034.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push0=, 128
	i32.add 	$push1=, $1, $pop0
	i32.const	$push2=, 256
	i32.ge_u	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label0
# %bb.1:                                # %if.end
	return
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo
                                        # -- End function
	.section	.text.test_neg,"ax",@progbits
	.hidden	test_neg                # -- Begin function test_neg
	.globl	test_neg
	.type	test_neg,@function
test_neg:                               # @test_neg
	.result 	i32
	.local  	i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$1=, -128
	i32.const	$0=, -2147483648
.LBB1_1:                                # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.const	$push8=, 0
	i32.sub 	$push0=, $pop8, $1
	i32.const	$push7=, 24
	i32.shl 	$push1=, $pop0, $pop7
	i32.const	$push6=, 24
	i32.shr_s	$2=, $pop1, $pop6
	block   	
	i32.const	$push5=, 0
	i32.lt_s	$push2=, $2, $pop5
	br_if   	0, $pop2        # 0: down to label2
# %bb.2:                                # %cond.true.i
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push9=, 24
	i32.shr_s	$2=, $0, $pop9
.LBB1_3:                                # %fixnum_neg.exit
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label2:
	call    	foo@FUNCTION, $1, $2, $1
	i32.const	$push12=, -16777216
	i32.add 	$0=, $0, $pop12
	i32.const	$push11=, 1
	i32.add 	$1=, $1, $pop11
	i32.const	$push10=, 128
	i32.ne  	$push3=, $1, $pop10
	br_if   	0, $pop3        # 0: up to label1
# %bb.4:                                # %for.end
	end_loop
	i32.const	$push4=, 0
                                        # fallthrough-return: $pop4
	.endfunc
.Lfunc_end1:
	.size	test_neg, .Lfunc_end1-test_neg
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$1=, -128
	i32.const	$0=, -2147483648
.LBB2_1:                                # %for.cond.i
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label3:
	i32.const	$push8=, 0
	i32.sub 	$push0=, $pop8, $1
	i32.const	$push7=, 24
	i32.shl 	$push1=, $pop0, $pop7
	i32.const	$push6=, 24
	i32.shr_s	$2=, $pop1, $pop6
	block   	
	i32.const	$push5=, 0
	i32.lt_s	$push2=, $2, $pop5
	br_if   	0, $pop2        # 0: down to label4
# %bb.2:                                # %cond.true.i.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push9=, 24
	i32.shr_s	$2=, $0, $pop9
.LBB2_3:                                # %fixnum_neg.exit.i
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label4:
	call    	foo@FUNCTION, $1, $2, $1
	i32.const	$push12=, -16777216
	i32.add 	$0=, $0, $pop12
	i32.const	$push11=, 1
	i32.add 	$1=, $1, $pop11
	i32.const	$push10=, 128
	i32.ne  	$push3=, $1, $pop10
	br_if   	0, $pop3        # 0: up to label3
# %bb.4:                                # %if.end
	end_loop
	i32.const	$push4=, 0
                                        # fallthrough-return: $pop4
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
