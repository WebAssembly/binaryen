	.text
	.file	"pr44942.c"
	.section	.text.test1,"ax",@progbits
	.hidden	test1                   # -- Begin function test1
	.globl	test1
	.type	test1,@function
test1:                                  # @test1
	.param  	i32, i32, i32, i32, i32, i32, i32, i64, i64, i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push6=, 0
	i32.load	$push5=, __stack_pointer($pop6)
	i32.const	$push7=, 16
	i32.sub 	$10=, $pop5, $pop7
	i32.const	$push8=, 0
	i32.store	__stack_pointer($pop8), $10
	i32.const	$push0=, 4
	i32.add 	$push1=, $9, $pop0
	i32.store	12($10), $pop1
	block   	
	i32.load	$push2=, 0($9)
	i32.const	$push3=, 1234
	i32.ne  	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$push11=, 0
	i32.const	$push9=, 16
	i32.add 	$push10=, $10, $pop9
	i32.store	__stack_pointer($pop11), $pop10
	return
.LBB0_2:                                # %if.then
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
	.param  	i32, i32, i32, i32, i32, i32, i32, i64, i64, i32, i64, i64, i32, i64, i64, i32, i64, i64, i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push6=, 0
	i32.load	$push5=, __stack_pointer($pop6)
	i32.const	$push7=, 16
	i32.sub 	$19=, $pop5, $pop7
	i32.const	$push8=, 0
	i32.store	__stack_pointer($pop8), $19
	i32.const	$push0=, 4
	i32.add 	$push1=, $18, $pop0
	i32.store	12($19), $pop1
	block   	
	i32.load	$push2=, 0($18)
	i32.const	$push3=, 1234
	i32.ne  	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label1
# %bb.1:                                # %if.end
	i32.const	$push11=, 0
	i32.const	$push9=, 16
	i32.add 	$push10=, $19, $pop9
	i32.store	__stack_pointer($pop11), $pop10
	return
.LBB1_2:                                # %if.then
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
	.param  	f64, f64, f64, f64, f64, f64, f64, i64, i64, i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push9=, 0
	i32.load	$push8=, __stack_pointer($pop9)
	i32.const	$push10=, 16
	i32.sub 	$10=, $pop8, $pop10
	i32.const	$push11=, 0
	i32.store	__stack_pointer($pop11), $10
	i32.const	$push0=, 7
	i32.add 	$push1=, $9, $pop0
	i32.const	$push2=, -8
	i32.and 	$9=, $pop1, $pop2
	i32.const	$push3=, 8
	i32.add 	$push4=, $9, $pop3
	i32.store	12($10), $pop4
	block   	
	f64.load	$push5=, 0($9)
	f64.const	$push6=, 0x1.348p10
	f64.ne  	$push7=, $pop5, $pop6
	br_if   	0, $pop7        # 0: down to label2
# %bb.1:                                # %if.end
	i32.const	$push14=, 0
	i32.const	$push12=, 16
	i32.add 	$push13=, $10, $pop12
	i32.store	__stack_pointer($pop14), $pop13
	return
.LBB2_2:                                # %if.then
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
	.param  	f64, f64, f64, f64, f64, f64, f64, i64, i64, f64, i64, i64, f64, i64, i64, f64, i64, i64, i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push9=, 0
	i32.load	$push8=, __stack_pointer($pop9)
	i32.const	$push10=, 16
	i32.sub 	$19=, $pop8, $pop10
	i32.const	$push11=, 0
	i32.store	__stack_pointer($pop11), $19
	i32.const	$push0=, 7
	i32.add 	$push1=, $18, $pop0
	i32.const	$push2=, -8
	i32.and 	$18=, $pop1, $pop2
	i32.const	$push3=, 8
	i32.add 	$push4=, $18, $pop3
	i32.store	12($19), $pop4
	block   	
	f64.load	$push5=, 0($18)
	f64.const	$push6=, 0x1.348p10
	f64.ne  	$push7=, $pop5, $pop6
	br_if   	0, $pop7        # 0: down to label3
# %bb.1:                                # %if.end
	i32.const	$push14=, 0
	i32.const	$push12=, 16
	i32.add 	$push13=, $19, $pop12
	i32.store	__stack_pointer($pop14), $pop13
	return
.LBB3_2:                                # %if.then
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end3:
	.size	test4, .Lfunc_end3-test4
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	f64, i64, i32
# %bb.0:                                # %entry
	i32.const	$push7=, 0
	i32.load	$push6=, __stack_pointer($pop7)
	i32.const	$push8=, 128
	i32.sub 	$2=, $pop6, $pop8
	i32.const	$push9=, 0
	i32.store	__stack_pointer($pop9), $2
	i32.const	$push0=, 1234
	i32.store	120($2), $pop0
	i32.const	$push13=, 112
	i32.add 	$push14=, $2, $pop13
	call    	test1@FUNCTION, $2, $2, $2, $2, $2, $2, $2, $1, $pop14
	i32.const	$push15=, 64
	i32.add 	$push16=, $2, $pop15
	i32.const	$push1=, 32
	i32.add 	$push2=, $pop16, $pop1
	i32.const	$push23=, 1234
	i32.store	0($pop2), $pop23
	i32.const	$push17=, 64
	i32.add 	$push18=, $2, $pop17
	call    	test2@FUNCTION, $2, $2, $2, $2, $2, $2, $2, $1, $1, $2, $1, $1, $2, $1, $pop18
	i64.const	$push3=, 4653142004841054208
	i64.store	56($2), $pop3
	i32.const	$push19=, 48
	i32.add 	$push20=, $2, $pop19
	call    	test3@FUNCTION, $0, $0, $0, $0, $0, $0, $0, $1, $pop20
	i32.const	$push22=, 32
	i32.add 	$push4=, $2, $pop22
	i64.const	$push21=, 4653142004841054208
	i64.store	0($pop4), $pop21
	call    	test4@FUNCTION, $0, $0, $0, $0, $0, $0, $0, $1, $1, $0, $1, $1, $0, $1, $2
	i32.const	$push12=, 0
	i32.const	$push10=, 128
	i32.add 	$push11=, $2, $pop10
	i32.store	__stack_pointer($pop12), $pop11
	i32.const	$push5=, 0
                                        # fallthrough-return: $pop5
	.endfunc
.Lfunc_end4:
	.size	main, .Lfunc_end4-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
