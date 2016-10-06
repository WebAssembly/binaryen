	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr44942.c"
	.section	.text.test1,"ax",@progbits
	.hidden	test1
	.globl	test1
	.type	test1,@function
test1:                                  # @test1
	.param  	i32, i32, i32, i32, i32, i32, i32, i64, i64, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push8=, 0
	i32.const	$push5=, 0
	i32.load	$push6=, __stack_pointer($pop5)
	i32.const	$push7=, 16
	i32.sub 	$push13=, $pop6, $pop7
	tee_local	$push12=, $10=, $pop13
	i32.store	__stack_pointer($pop8), $pop12
	i32.store	12($10), $9
	i32.const	$push0=, 4
	i32.add 	$push1=, $9, $pop0
	i32.store	12($10), $pop1
	block   	
	i32.load	$push2=, 0($9)
	i32.const	$push3=, 1234
	i32.ne  	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label0
# BB#1:                                 # %if.end
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

	.section	.text.test2,"ax",@progbits
	.hidden	test2
	.globl	test2
	.type	test2,@function
test2:                                  # @test2
	.param  	i32, i32, i32, i32, i32, i32, i32, i64, i64, i32, i64, i64, i32, i64, i64, i32, i64, i64, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push8=, 0
	i32.const	$push5=, 0
	i32.load	$push6=, __stack_pointer($pop5)
	i32.const	$push7=, 16
	i32.sub 	$push13=, $pop6, $pop7
	tee_local	$push12=, $19=, $pop13
	i32.store	__stack_pointer($pop8), $pop12
	i32.store	12($19), $18
	i32.const	$push0=, 4
	i32.add 	$push1=, $18, $pop0
	i32.store	12($19), $pop1
	block   	
	i32.load	$push2=, 0($18)
	i32.const	$push3=, 1234
	i32.ne  	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label1
# BB#1:                                 # %if.end
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

	.section	.text.test3,"ax",@progbits
	.hidden	test3
	.globl	test3
	.type	test3,@function
test3:                                  # @test3
	.param  	f64, f64, f64, f64, f64, f64, f64, i64, i64, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push11=, 0
	i32.const	$push8=, 0
	i32.load	$push9=, __stack_pointer($pop8)
	i32.const	$push10=, 16
	i32.sub 	$push18=, $pop9, $pop10
	tee_local	$push17=, $10=, $pop18
	i32.store	__stack_pointer($pop11), $pop17
	i32.store	12($10), $9
	i32.const	$push0=, 7
	i32.add 	$push1=, $9, $pop0
	i32.const	$push2=, -8
	i32.and 	$push16=, $pop1, $pop2
	tee_local	$push15=, $9=, $pop16
	i32.const	$push3=, 8
	i32.add 	$push4=, $pop15, $pop3
	i32.store	12($10), $pop4
	block   	
	f64.load	$push5=, 0($9)
	f64.const	$push6=, 0x1.348p10
	f64.ne  	$push7=, $pop5, $pop6
	br_if   	0, $pop7        # 0: down to label2
# BB#1:                                 # %if.end
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

	.section	.text.test4,"ax",@progbits
	.hidden	test4
	.globl	test4
	.type	test4,@function
test4:                                  # @test4
	.param  	f64, f64, f64, f64, f64, f64, f64, i64, i64, f64, i64, i64, f64, i64, i64, f64, i64, i64, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push11=, 0
	i32.const	$push8=, 0
	i32.load	$push9=, __stack_pointer($pop8)
	i32.const	$push10=, 16
	i32.sub 	$push18=, $pop9, $pop10
	tee_local	$push17=, $19=, $pop18
	i32.store	__stack_pointer($pop11), $pop17
	i32.store	12($19), $18
	i32.const	$push0=, 7
	i32.add 	$push1=, $18, $pop0
	i32.const	$push2=, -8
	i32.and 	$push16=, $pop1, $pop2
	tee_local	$push15=, $18=, $pop16
	i32.const	$push3=, 8
	i32.add 	$push4=, $pop15, $pop3
	i32.store	12($19), $pop4
	block   	
	f64.load	$push5=, 0($18)
	f64.const	$push6=, 0x1.348p10
	f64.ne  	$push7=, $pop5, $pop6
	br_if   	0, $pop7        # 0: down to label3
# BB#1:                                 # %if.end
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

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	f64, i64, i32
# BB#0:                                 # %entry
	i32.const	$push9=, 0
	i32.const	$push6=, 0
	i32.load	$push7=, __stack_pointer($pop6)
	i32.const	$push8=, 128
	i32.sub 	$push25=, $pop7, $pop8
	tee_local	$push24=, $2=, $pop25
	i32.store	__stack_pointer($pop9), $pop24
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
