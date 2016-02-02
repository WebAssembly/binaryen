	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr44942.c"
	.section	.text.test1,"ax",@progbits
	.hidden	test1
	.globl	test1
	.type	test1,@function
test1:                                  # @test1
	.param  	i32, i32, i32, i32, i32, i32, i32, i64, i64
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$10=, __stack_pointer
	i32.load	$10=, 0($10)
	i32.const	$11=, 16
	i32.sub 	$13=, $10, $11
	copy_local	$14=, $13
	i32.const	$11=, __stack_pointer
	i32.store	$13=, 0($11), $13
	i32.store	$push0=, 12($13), $14
	i32.const	$push1=, 3
	i32.add 	$push2=, $pop0, $pop1
	i32.const	$push3=, -4
	i32.and 	$push4=, $pop2, $pop3
	tee_local	$push10=, $9=, $pop4
	i32.const	$push5=, 4
	i32.add 	$push6=, $pop10, $pop5
	i32.store	$discard=, 12($13), $pop6
	block
	i32.load	$push7=, 0($9)
	i32.const	$push8=, 1234
	i32.ne  	$push9=, $pop7, $pop8
	br_if   	$pop9, 0        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$12=, 16
	i32.add 	$13=, $14, $12
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
	.param  	i32, i32, i32, i32, i32, i32, i32, i64, i64, i32, i64, i64, i32, i64, i64, i32, i64, i64
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$19=, __stack_pointer
	i32.load	$19=, 0($19)
	i32.const	$20=, 16
	i32.sub 	$22=, $19, $20
	copy_local	$23=, $22
	i32.const	$20=, __stack_pointer
	i32.store	$22=, 0($20), $22
	i32.store	$push0=, 12($22), $23
	i32.const	$push1=, 3
	i32.add 	$push2=, $pop0, $pop1
	i32.const	$push3=, -4
	i32.and 	$push4=, $pop2, $pop3
	tee_local	$push10=, $18=, $pop4
	i32.const	$push5=, 4
	i32.add 	$push6=, $pop10, $pop5
	i32.store	$discard=, 12($22), $pop6
	block
	i32.load	$push7=, 0($18)
	i32.const	$push8=, 1234
	i32.ne  	$push9=, $pop7, $pop8
	br_if   	$pop9, 0        # 0: down to label1
# BB#1:                                 # %if.end
	i32.const	$21=, 16
	i32.add 	$22=, $23, $21
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
	.param  	f64, f64, f64, f64, f64, f64, f64, i64, i64
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$10=, __stack_pointer
	i32.load	$10=, 0($10)
	i32.const	$11=, 16
	i32.sub 	$13=, $10, $11
	copy_local	$14=, $13
	i32.const	$11=, __stack_pointer
	i32.store	$13=, 0($11), $13
	i32.store	$push0=, 12($13), $14
	i32.const	$push1=, 7
	i32.add 	$push2=, $pop0, $pop1
	i32.const	$push3=, -8
	i32.and 	$push4=, $pop2, $pop3
	tee_local	$push10=, $9=, $pop4
	i32.const	$push5=, 8
	i32.add 	$push6=, $pop10, $pop5
	i32.store	$discard=, 12($13), $pop6
	block
	f64.load	$push7=, 0($9)
	f64.const	$push8=, 0x1.348p10
	f64.ne  	$push9=, $pop7, $pop8
	br_if   	$pop9, 0        # 0: down to label2
# BB#1:                                 # %if.end
	i32.const	$12=, 16
	i32.add 	$13=, $14, $12
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
	.param  	f64, f64, f64, f64, f64, f64, f64, i64, i64, f64, i64, i64, f64, i64, i64, f64, i64, i64
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$19=, __stack_pointer
	i32.load	$19=, 0($19)
	i32.const	$20=, 16
	i32.sub 	$22=, $19, $20
	copy_local	$23=, $22
	i32.const	$20=, __stack_pointer
	i32.store	$22=, 0($20), $22
	i32.store	$push0=, 12($22), $23
	i32.const	$push1=, 7
	i32.add 	$push2=, $pop0, $pop1
	i32.const	$push3=, -8
	i32.and 	$push4=, $pop2, $pop3
	tee_local	$push10=, $18=, $pop4
	i32.const	$push5=, 8
	i32.add 	$push6=, $pop10, $pop5
	i32.store	$discard=, 12($22), $pop6
	block
	f64.load	$push7=, 0($18)
	f64.const	$push8=, 0x1.348p10
	f64.ne  	$push9=, $pop7, $pop8
	br_if   	$pop9, 0        # 0: down to label3
# BB#1:                                 # %if.end
	i32.const	$21=, 16
	i32.add 	$22=, $23, $21
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
	.local  	i32, i32, i64, f64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$20=, __stack_pointer
	i32.load	$20=, 0($20)
	i32.const	$21=, 48
	i32.sub 	$23=, $20, $21
	i32.const	$21=, __stack_pointer
	i32.store	$23=, 0($21), $23
	i32.const	$4=, __stack_pointer
	i32.load	$4=, 0($4)
	i32.const	$5=, 16
	i32.sub 	$23=, $4, $5
	i32.const	$5=, __stack_pointer
	i32.store	$23=, 0($5), $23
	i32.const	$push0=, 8
	i32.add 	$0=, $23, $pop0
	i32.const	$push1=, 1234
	i32.store	$0=, 0($0), $pop1
	call    	test1@FUNCTION, $0, $0, $0, $0, $0, $0, $0, $2
	i32.const	$6=, __stack_pointer
	i32.load	$6=, 0($6)
	i32.const	$7=, 16
	i32.add 	$23=, $6, $7
	i32.const	$7=, __stack_pointer
	i32.store	$23=, 0($7), $23
	i32.const	$8=, __stack_pointer
	i32.load	$8=, 0($8)
	i32.const	$9=, 40
	i32.sub 	$23=, $8, $9
	i32.const	$9=, __stack_pointer
	i32.store	$23=, 0($9), $23
	i32.const	$push2=, 32
	i32.add 	$1=, $23, $pop2
	i32.store	$discard=, 0($1), $0
	call    	test2@FUNCTION, $0, $0, $0, $0, $0, $0, $0, $2, $2, $0, $2, $2, $0, $2
	i32.const	$10=, __stack_pointer
	i32.load	$10=, 0($10)
	i32.const	$11=, 40
	i32.add 	$23=, $10, $11
	i32.const	$11=, __stack_pointer
	i32.store	$23=, 0($11), $23
	i32.const	$12=, __stack_pointer
	i32.load	$12=, 0($12)
	i32.const	$13=, 16
	i32.sub 	$23=, $12, $13
	i32.const	$13=, __stack_pointer
	i32.store	$23=, 0($13), $23
	i32.const	$push6=, 8
	i32.add 	$0=, $23, $pop6
	i64.const	$push3=, 4653142004841054208
	i64.store	$2=, 0($0), $pop3
	call    	test3@FUNCTION, $3, $3, $3, $3, $3, $3, $3, $2
	i32.const	$14=, __stack_pointer
	i32.load	$14=, 0($14)
	i32.const	$15=, 16
	i32.add 	$23=, $14, $15
	i32.const	$15=, __stack_pointer
	i32.store	$23=, 0($15), $23
	i32.const	$16=, __stack_pointer
	i32.load	$16=, 0($16)
	i32.const	$17=, 40
	i32.sub 	$23=, $16, $17
	i32.const	$17=, __stack_pointer
	i32.store	$23=, 0($17), $23
	i32.const	$push5=, 32
	i32.add 	$0=, $23, $pop5
	i64.store	$discard=, 0($0), $2
	call    	test4@FUNCTION, $3, $3, $3, $3, $3, $3, $3, $2, $2, $3, $2, $2, $3, $2
	i32.const	$18=, __stack_pointer
	i32.load	$18=, 0($18)
	i32.const	$19=, 40
	i32.add 	$23=, $18, $19
	i32.const	$19=, __stack_pointer
	i32.store	$23=, 0($19), $23
	i32.const	$push4=, 0
	i32.const	$22=, 48
	i32.add 	$23=, $23, $22
	i32.const	$22=, __stack_pointer
	i32.store	$23=, 0($22), $23
	return  	$pop4
	.endfunc
.Lfunc_end4:
	.size	main, .Lfunc_end4-main


	.ident	"clang version 3.9.0 "
