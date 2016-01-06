	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20071029-1.c"
	.globl	test
	.type	test,@function
test:                                   # @test
	.param  	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, 0
	i32.load	$3=, test.i($2)
	i32.load	$1=, 0($0)
	block   	BB0_15
	i32.const	$push1=, 1
	i32.add 	$push0=, $3, $pop1
	i32.store	$4=, test.i($2), $pop0
	i32.ne  	$push2=, $1, $3
	br_if   	$pop2, BB0_15
# BB#1:                                 # %if.end
	block   	BB0_14
	i32.load	$push3=, 4($0)
	br_if   	$pop3, BB0_14
# BB#2:                                 # %lor.lhs.false
	i32.load	$push4=, 8($0)
	br_if   	$pop4, BB0_14
# BB#3:                                 # %lor.lhs.false6
	i32.load	$push5=, 12($0)
	br_if   	$pop5, BB0_14
# BB#4:                                 # %lor.lhs.false10
	i32.load	$push6=, 16($0)
	br_if   	$pop6, BB0_14
# BB#5:                                 # %lor.lhs.false13
	i32.load	$push7=, 20($0)
	br_if   	$pop7, BB0_14
# BB#6:                                 # %lor.lhs.false16
	i32.load	$push8=, 24($0)
	br_if   	$pop8, BB0_14
# BB#7:                                 # %lor.lhs.false20
	i32.load	$push9=, 28($0)
	br_if   	$pop9, BB0_14
# BB#8:                                 # %lor.lhs.false23
	i32.load	$push10=, 32($0)
	br_if   	$pop10, BB0_14
# BB#9:                                 # %lor.lhs.false26
	i32.load	$push11=, 36($0)
	br_if   	$pop11, BB0_14
# BB#10:                                # %lor.lhs.false29
	i32.load	$push12=, 40($0)
	br_if   	$pop12, BB0_14
# BB#11:                                # %if.end34
	block   	BB0_13
	i32.const	$push13=, 20
	i32.eq  	$push14=, $4, $pop13
	br_if   	$pop14, BB0_13
# BB#12:                                # %if.end37
	return
BB0_13:                                 # %if.then36
	call    	exit, $2
	unreachable
BB0_14:                                 # %if.then33
	call    	abort
	unreachable
BB0_15:                                 # %if.then
	call    	abort
	unreachable
func_end0:
	.size	test, func_end0-test

	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i64, i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$16=, __stack_pointer
	i32.load	$16=, 0($16)
	i32.const	$17=, 112
	i32.sub 	$31=, $16, $17
	i32.const	$17=, __stack_pointer
	i32.store	$31=, 0($17), $31
	i32.const	$push0=, 40
	i32.const	$18=, 56
	i32.add 	$18=, $31, $18
	i32.add 	$1=, $18, $pop0
	i32.const	$3=, 1
	i32.add 	$15=, $0, $3
	i64.const	$8=, 0
	i32.const	$2=, 4
	i32.const	$19=, 56
	i32.add 	$19=, $31, $19
	i32.or  	$0=, $19, $2
BB1_1:                                  # %again
                                        # =>This Inner Loop Header: Depth=1
	loop    	BB1_2
	i32.const	$14=, 24
	i32.const	$20=, 24
	i32.add 	$20=, $31, $20
	i32.add 	$4=, $20, $14
	i32.const	$push1=, 0
	i32.store	$5=, 0($4), $pop1
	i32.const	$6=, 16
	i32.const	$21=, 24
	i32.add 	$21=, $31, $21
	i32.add 	$7=, $21, $6
	i64.store	$9=, 0($7), $8
	i32.const	$10=, 8
	i32.const	$22=, 24
	i32.add 	$22=, $31, $22
	i32.add 	$11=, $22, $10
	i64.store	$push2=, 0($11), $9
	i64.store	$9=, 24($31), $pop2
	i32.add 	$push5=, $0, $2
	i32.const	$23=, 24
	i32.add 	$23=, $31, $23
	i32.or  	$push6=, $23, $2
	i32.load	$push7=, 0($pop6)
	i32.store	$discard=, 0($pop5), $pop7
	i32.const	$12=, 20
	i32.const	$24=, 24
	i32.add 	$24=, $31, $24
	i32.add 	$push11=, $24, $12
	i32.load	$13=, 0($pop11)
	i32.add 	$push8=, $0, $14
	i32.load	$push9=, 0($4)
	i32.store	$discard=, 0($pop8), $pop9
	i32.add 	$push10=, $0, $12
	i32.store	$discard=, 0($pop10), $13
	i32.const	$14=, 12
	i32.const	$25=, 24
	i32.add 	$25=, $31, $25
	i32.add 	$push15=, $25, $14
	i32.load	$4=, 0($pop15)
	i32.add 	$push12=, $0, $6
	i32.load	$push13=, 0($7)
	i32.store	$discard=, 0($pop12), $pop13
	i32.load	$6=, 0($11)
	i32.add 	$push14=, $0, $14
	i32.store	$discard=, 0($pop14), $4
	i32.add 	$push16=, $0, $10
	i32.store	$discard=, 0($pop16), $6
	i32.const	$push17=, 32
	i32.const	$26=, 56
	i32.add 	$26=, $31, $26
	i32.add 	$push18=, $26, $pop17
	i32.store	$6=, 0($pop18), $5
	i32.const	$27=, 8
	i32.add 	$27=, $31, $27
	i32.add 	$4=, $27, $10
	i64.store	$push3=, 0($4), $9
	i64.store	$discard=, 8($31), $pop3
	i32.const	$28=, 8
	i32.add 	$28=, $31, $28
	i32.add 	$push22=, $28, $14
	i32.load	$7=, 0($pop22)
	i32.const	$push19=, 36
	i32.const	$29=, 56
	i32.add 	$29=, $31, $29
	i32.add 	$push20=, $29, $pop19
	i32.store	$discard=, 0($pop20), $6
	i32.load	$4=, 0($4)
	i32.add 	$push21=, $1, $14
	i32.store	$discard=, 0($pop21), $7
	i32.add 	$push23=, $1, $10
	i32.store	$discard=, 0($pop23), $4
	i32.load	$10=, 24($31)
	i32.load	$14=, 8($31)
	i32.add 	$push24=, $1, $2
	i32.const	$30=, 8
	i32.add 	$30=, $31, $30
	i32.or  	$push25=, $30, $2
	i32.load	$push26=, 0($pop25)
	i32.store	$discard=, 0($pop24), $pop26
	i32.store	$discard=, 0($0), $10
	i32.store	$discard=, 0($1), $14
	i32.const	$31=, 56
	i32.add 	$31=, $31, $31
	call    	test, $31
	i32.store	$push4=, 56($31), $15
	i32.add 	$15=, $pop4, $3
	br      	BB1_1
BB1_2:
func_end1:
	.size	foo, func_end1-foo

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end6
	i32.const	$push0=, 10
	call    	foo, $pop0
	unreachable
func_end2:
	.size	main, func_end2-main

	.type	test.i,@object          # @test.i
	.data
	.align	2
test.i:
	.int32	11                      # 0xb
	.size	test.i, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
