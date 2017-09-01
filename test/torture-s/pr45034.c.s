	.text
	.file	"pr45034.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
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
                                        # -- End function
	.section	.text.test_neg,"ax",@progbits
	.hidden	test_neg                # -- Begin function test_neg
	.globl	test_neg
	.type	test_neg,@function
test_neg:                               # @test_neg
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, -128
	i32.const	$0=, -2147483648
.LBB1_1:                                # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	block   	
	i32.const	$push10=, 0
	i32.sub 	$push0=, $pop10, $1
	i32.const	$push9=, 24
	i32.shl 	$push1=, $pop0, $pop9
	i32.const	$push8=, 24
	i32.shr_s	$push7=, $pop1, $pop8
	tee_local	$push6=, $2=, $pop7
	i32.const	$push5=, 0
	i32.lt_s	$push2=, $pop6, $pop5
	br_if   	0, $pop2        # 0: down to label2
# BB#2:                                 # %cond.true.i
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push11=, 24
	i32.shr_s	$2=, $0, $pop11
.LBB1_3:                                # %fixnum_neg.exit
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label2:
	call    	foo@FUNCTION, $1, $2, $1
	i32.const	$push16=, -16777216
	i32.add 	$0=, $0, $pop16
	i32.const	$push15=, 1
	i32.add 	$push14=, $1, $pop15
	tee_local	$push13=, $1=, $pop14
	i32.const	$push12=, 128
	i32.ne  	$push3=, $pop13, $pop12
	br_if   	0, $pop3        # 0: up to label1
# BB#4:                                 # %for.end
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
# BB#0:                                 # %entry
	i32.const	$1=, -128
	i32.const	$0=, -2147483648
.LBB2_1:                                # %for.cond.i
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label3:
	block   	
	i32.const	$push10=, 0
	i32.sub 	$push0=, $pop10, $1
	i32.const	$push9=, 24
	i32.shl 	$push1=, $pop0, $pop9
	i32.const	$push8=, 24
	i32.shr_s	$push7=, $pop1, $pop8
	tee_local	$push6=, $2=, $pop7
	i32.const	$push5=, 0
	i32.lt_s	$push2=, $pop6, $pop5
	br_if   	0, $pop2        # 0: down to label4
# BB#2:                                 # %cond.true.i.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push11=, 24
	i32.shr_s	$2=, $0, $pop11
.LBB2_3:                                # %fixnum_neg.exit.i
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label4:
	call    	foo@FUNCTION, $1, $2, $1
	i32.const	$push16=, -16777216
	i32.add 	$0=, $0, $pop16
	i32.const	$push15=, 1
	i32.add 	$push14=, $1, $pop15
	tee_local	$push13=, $1=, $pop14
	i32.const	$push12=, 128
	i32.ne  	$push3=, $pop13, $pop12
	br_if   	0, $pop3        # 0: up to label3
# BB#4:                                 # %if.end
	end_loop
	i32.const	$push4=, 0
                                        # fallthrough-return: $pop4
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
