	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr44942.c"
	.section	.text.test1,"ax",@progbits
	.hidden	test1
	.globl	test1
	.type	test1,@function
test1:                                  # @test1
	.param  	i32, i32, i32, i32, i32, i32, i32, i64, i64, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push7=, __stack_pointer
	i32.load	$push8=, 0($pop7)
	i32.const	$push9=, 16
	i32.sub 	$10=, $pop8, $pop9
	i32.const	$push10=, __stack_pointer
	i32.store	$discard=, 0($pop10), $10
	i32.store	$push6=, 12($10), $9
	tee_local	$push5=, $9=, $pop6
	i32.const	$push0=, 4
	i32.add 	$push1=, $pop5, $pop0
	i32.store	$discard=, 12($10), $pop1
	block
	i32.load	$push2=, 0($9)
	i32.const	$push3=, 1234
	i32.ne  	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push13=, __stack_pointer
	i32.const	$push11=, 16
	i32.add 	$push12=, $10, $pop11
	i32.store	$discard=, 0($pop13), $pop12
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
	i32.const	$push7=, __stack_pointer
	i32.load	$push8=, 0($pop7)
	i32.const	$push9=, 16
	i32.sub 	$19=, $pop8, $pop9
	i32.const	$push10=, __stack_pointer
	i32.store	$discard=, 0($pop10), $19
	i32.store	$push6=, 12($19), $18
	tee_local	$push5=, $18=, $pop6
	i32.const	$push0=, 4
	i32.add 	$push1=, $pop5, $pop0
	i32.store	$discard=, 12($19), $pop1
	block
	i32.load	$push2=, 0($18)
	i32.const	$push3=, 1234
	i32.ne  	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label1
# BB#1:                                 # %if.end
	i32.const	$push13=, __stack_pointer
	i32.const	$push11=, 16
	i32.add 	$push12=, $19, $pop11
	i32.store	$discard=, 0($pop13), $pop12
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
	.local  	f64, i32
# BB#0:                                 # %entry
	i32.const	$push10=, __stack_pointer
	i32.load	$push11=, 0($pop10)
	i32.const	$push12=, 16
	i32.sub 	$11=, $pop11, $pop12
	i32.const	$push13=, __stack_pointer
	i32.store	$discard=, 0($pop13), $11
	i32.store	$push0=, 12($11), $9
	i32.const	$push1=, 7
	i32.add 	$push2=, $pop0, $pop1
	i32.const	$push3=, -8
	i32.and 	$push9=, $pop2, $pop3
	tee_local	$push8=, $9=, $pop9
	f64.load	$10=, 0($pop8)
	i32.const	$push4=, 8
	i32.add 	$push5=, $9, $pop4
	i32.store	$discard=, 12($11), $pop5
	block
	f64.const	$push6=, 0x1.348p10
	f64.ne  	$push7=, $10, $pop6
	br_if   	0, $pop7        # 0: down to label2
# BB#1:                                 # %if.end
	i32.const	$push16=, __stack_pointer
	i32.const	$push14=, 16
	i32.add 	$push15=, $11, $pop14
	i32.store	$discard=, 0($pop16), $pop15
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
	.local  	f64, i32
# BB#0:                                 # %entry
	i32.const	$push10=, __stack_pointer
	i32.load	$push11=, 0($pop10)
	i32.const	$push12=, 16
	i32.sub 	$20=, $pop11, $pop12
	i32.const	$push13=, __stack_pointer
	i32.store	$discard=, 0($pop13), $20
	i32.store	$push0=, 12($20), $18
	i32.const	$push1=, 7
	i32.add 	$push2=, $pop0, $pop1
	i32.const	$push3=, -8
	i32.and 	$push9=, $pop2, $pop3
	tee_local	$push8=, $18=, $pop9
	f64.load	$19=, 0($pop8)
	i32.const	$push4=, 8
	i32.add 	$push5=, $18, $pop4
	i32.store	$discard=, 12($20), $pop5
	block
	f64.const	$push6=, 0x1.348p10
	f64.ne  	$push7=, $19, $pop6
	br_if   	0, $pop7        # 0: down to label3
# BB#1:                                 # %if.end
	i32.const	$push16=, __stack_pointer
	i32.const	$push14=, 16
	i32.add 	$push15=, $20, $pop14
	i32.store	$discard=, 0($pop16), $pop15
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
	.local  	i32, i64, f64, i32
# BB#0:                                 # %entry
	i32.const	$push7=, __stack_pointer
	i32.load	$push8=, 0($pop7)
	i32.const	$push9=, 128
	i32.sub 	$3=, $pop8, $pop9
	i32.const	$push10=, __stack_pointer
	i32.store	$discard=, 0($pop10), $3
	i32.const	$push0=, 1234
	i32.store	$0=, 120($3):p2align=3, $pop0
	i32.const	$push14=, 112
	i32.add 	$push15=, $3, $pop14
	call    	test1@FUNCTION, $0, $0, $0, $0, $0, $0, $0, $1, $pop15
	i32.const	$push16=, 64
	i32.add 	$push17=, $3, $pop16
	i32.const	$push1=, 32
	i32.add 	$push2=, $pop17, $pop1
	i32.store	$discard=, 0($pop2):p2align=4, $0
	i32.const	$push18=, 64
	i32.add 	$push19=, $3, $pop18
	call    	test2@FUNCTION, $0, $0, $0, $0, $0, $0, $0, $1, $1, $0, $1, $1, $0, $1, $pop19
	i64.const	$push3=, 4653142004841054208
	i64.store	$1=, 56($3), $pop3
	i32.const	$push20=, 48
	i32.add 	$push21=, $3, $pop20
	call    	test3@FUNCTION, $2, $2, $2, $2, $2, $2, $2, $1, $pop21
	i32.const	$push6=, 32
	i32.add 	$push4=, $3, $pop6
	i64.store	$discard=, 0($pop4):p2align=4, $1
	call    	test4@FUNCTION, $2, $2, $2, $2, $2, $2, $2, $1, $1, $2, $1, $1, $2, $1, $3
	i32.const	$push5=, 0
	i32.const	$push13=, __stack_pointer
	i32.const	$push11=, 128
	i32.add 	$push12=, $3, $pop11
	i32.store	$discard=, 0($pop13), $pop12
	return  	$pop5
	.endfunc
.Lfunc_end4:
	.size	main, .Lfunc_end4-main


	.ident	"clang version 3.9.0 "
