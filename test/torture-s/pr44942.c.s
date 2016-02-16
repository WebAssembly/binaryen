	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr44942.c"
	.section	.text.test1,"ax",@progbits
	.hidden	test1
	.globl	test1
	.type	test1,@function
test1:                                  # @test1
	.param  	i32, i32, i32, i32, i32, i32, i32, i64, i64, i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$10=, __stack_pointer
	i32.load	$10=, 0($10)
	i32.const	$11=, 16
	i32.sub 	$13=, $10, $11
	i32.const	$11=, __stack_pointer
	i32.store	$13=, 0($11), $13
	i32.store	$push0=, 12($13), $9
	i32.const	$push1=, 3
	i32.add 	$push2=, $pop0, $pop1
	i32.const	$push3=, -4
	i32.and 	$push10=, $pop2, $pop3
	tee_local	$push9=, $9=, $pop10
	i32.const	$push4=, 4
	i32.add 	$push5=, $pop9, $pop4
	i32.store	$discard=, 12($13), $pop5
	block
	i32.load	$push6=, 0($9)
	i32.const	$push7=, 1234
	i32.ne  	$push8=, $pop6, $pop7
	br_if   	0, $pop8        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$12=, 16
	i32.add 	$13=, $13, $12
	i32.const	$12=, __stack_pointer
	i32.store	$13=, 0($12), $13
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
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$19=, __stack_pointer
	i32.load	$19=, 0($19)
	i32.const	$20=, 16
	i32.sub 	$22=, $19, $20
	i32.const	$20=, __stack_pointer
	i32.store	$22=, 0($20), $22
	i32.store	$push0=, 12($22), $18
	i32.const	$push1=, 3
	i32.add 	$push2=, $pop0, $pop1
	i32.const	$push3=, -4
	i32.and 	$push10=, $pop2, $pop3
	tee_local	$push9=, $18=, $pop10
	i32.const	$push4=, 4
	i32.add 	$push5=, $pop9, $pop4
	i32.store	$discard=, 12($22), $pop5
	block
	i32.load	$push6=, 0($18)
	i32.const	$push7=, 1234
	i32.ne  	$push8=, $pop6, $pop7
	br_if   	0, $pop8        # 0: down to label1
# BB#1:                                 # %if.end
	i32.const	$21=, 16
	i32.add 	$22=, $22, $21
	i32.const	$21=, __stack_pointer
	i32.store	$22=, 0($21), $22
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
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$10=, __stack_pointer
	i32.load	$10=, 0($10)
	i32.const	$11=, 16
	i32.sub 	$13=, $10, $11
	i32.const	$11=, __stack_pointer
	i32.store	$13=, 0($11), $13
	i32.store	$push0=, 12($13), $9
	i32.const	$push1=, 7
	i32.add 	$push2=, $pop0, $pop1
	i32.const	$push3=, -8
	i32.and 	$push10=, $pop2, $pop3
	tee_local	$push9=, $9=, $pop10
	i32.const	$push4=, 8
	i32.add 	$push5=, $pop9, $pop4
	i32.store	$discard=, 12($13), $pop5
	block
	f64.load	$push6=, 0($9)
	f64.const	$push7=, 0x1.348p10
	f64.ne  	$push8=, $pop6, $pop7
	br_if   	0, $pop8        # 0: down to label2
# BB#1:                                 # %if.end
	i32.const	$12=, 16
	i32.add 	$13=, $13, $12
	i32.const	$12=, __stack_pointer
	i32.store	$13=, 0($12), $13
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
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$19=, __stack_pointer
	i32.load	$19=, 0($19)
	i32.const	$20=, 16
	i32.sub 	$22=, $19, $20
	i32.const	$20=, __stack_pointer
	i32.store	$22=, 0($20), $22
	i32.store	$push0=, 12($22), $18
	i32.const	$push1=, 7
	i32.add 	$push2=, $pop0, $pop1
	i32.const	$push3=, -8
	i32.and 	$push10=, $pop2, $pop3
	tee_local	$push9=, $18=, $pop10
	i32.const	$push4=, 8
	i32.add 	$push5=, $pop9, $pop4
	i32.store	$discard=, 12($22), $pop5
	block
	f64.load	$push6=, 0($18)
	f64.const	$push7=, 0x1.348p10
	f64.ne  	$push8=, $pop6, $pop7
	br_if   	0, $pop8        # 0: down to label3
# BB#1:                                 # %if.end
	i32.const	$21=, 16
	i32.add 	$22=, $22, $21
	i32.const	$21=, __stack_pointer
	i32.store	$22=, 0($21), $22
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
	.local  	i32, i64, f64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, __stack_pointer
	i32.load	$3=, 0($3)
	i32.const	$4=, 128
	i32.sub 	$12=, $3, $4
	i32.const	$4=, __stack_pointer
	i32.store	$12=, 0($4), $12
	i32.const	$push0=, 8
	i32.const	$6=, 112
	i32.add 	$6=, $12, $6
	i32.or  	$push1=, $6, $pop0
	i32.const	$push2=, 1234
	i32.store	$0=, 0($pop1):p2align=3, $pop2
	i32.const	$7=, 112
	i32.add 	$7=, $12, $7
	call    	test1@FUNCTION, $0, $0, $0, $0, $0, $0, $0, $1, $7
	i32.const	$push3=, 32
	i32.const	$8=, 64
	i32.add 	$8=, $12, $8
	i32.add 	$push4=, $8, $pop3
	i32.store	$discard=, 0($pop4):p2align=4, $0
	i32.const	$9=, 64
	i32.add 	$9=, $12, $9
	call    	test2@FUNCTION, $0, $0, $0, $0, $0, $0, $0, $1, $1, $0, $1, $1, $0, $1, $9
	i32.const	$push10=, 8
	i32.const	$10=, 48
	i32.add 	$10=, $12, $10
	i32.or  	$push5=, $10, $pop10
	i64.const	$push6=, 4653142004841054208
	i64.store	$1=, 0($pop5), $pop6
	i32.const	$11=, 48
	i32.add 	$11=, $12, $11
	call    	test3@FUNCTION, $2, $2, $2, $2, $2, $2, $2, $1, $11
	i32.const	$push9=, 32
	i32.add 	$push7=, $12, $pop9
	i64.store	$discard=, 0($pop7):p2align=4, $1
	call    	test4@FUNCTION, $2, $2, $2, $2, $2, $2, $2, $1, $1, $2, $1, $1, $2, $1, $12
	i32.const	$push8=, 0
	i32.const	$5=, 128
	i32.add 	$12=, $12, $5
	i32.const	$5=, __stack_pointer
	i32.store	$12=, 0($5), $12
	return  	$pop8
	.endfunc
.Lfunc_end4:
	.size	main, .Lfunc_end4-main


	.ident	"clang version 3.9.0 "
