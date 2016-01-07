	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr41239.c"
	.globl	test
	.type	test,@function
test:                                   # @test
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$8=, __stack_pointer
	i32.load	$8=, 0($8)
	i32.const	$9=, 16
	i32.sub 	$10=, $8, $9
	i32.const	$9=, __stack_pointer
	i32.store	$10=, 0($9), $10
	i32.load	$1=, 4($0)
	block   	.LBB0_3
	i32.const	$push0=, 8
	i32.add 	$push1=, $0, $pop0
	i32.load	$0=, 0($pop1)
	br_if   	$0, .LBB0_3
# BB#1:                                 # %if.then
	i32.const	$push6=, 20
	i32.const	$push3=, .str
	i32.const	$push5=, 924
	i32.const	$push2=, __func__.test
	i32.const	$push4=, 0
	i32.call	$2=, fn1, $pop6, $pop3, $pop5, $pop2, $pop4
	i32.const	$push7=, 255
	i32.and 	$push8=, $2, $pop7
	i32.const	$push12=, 0
	i32.eq  	$push13=, $pop8, $pop12
	br_if   	$pop13, .LBB0_3
# BB#2:                                 # %cond.true
	i32.const	$push9=, 33816706
	i32.call	$2=, fn3, $pop9
	i32.const	$push10=, .str.1
	i32.call	$3=, fn4, $pop10
	i32.const	$4=, __stack_pointer
	i32.load	$4=, 0($4)
	i32.const	$5=, 4
	i32.sub 	$10=, $4, $5
	i32.const	$5=, __stack_pointer
	i32.store	$10=, 0($5), $10
	i32.store	$discard=, 0($10), $3
	call    	fn2, $2
	i32.const	$6=, __stack_pointer
	i32.load	$6=, 0($6)
	i32.const	$7=, 4
	i32.add 	$10=, $6, $7
	i32.const	$7=, __stack_pointer
	i32.store	$10=, 0($7), $10
.LBB0_3:                                  # %if.end
	i32.div_s	$push11=, $1, $0
	i32.const	$10=, 16
	i32.add 	$10=, $10, $10
	i32.const	$10=, __stack_pointer
	i32.store	$10=, 0($10), $10
	return  	$pop11
.Lfunc_end0:
	.size	test, .Lfunc_end0-test

	.globl	fn1
	.type	fn1,@function
fn1:                                    # @fn1
	.param  	i32, i32, i32, i32, i32
	.result 	i32
# BB#0:                                 # %entry
	#APP
	#NO_APP
	#APP
	#NO_APP
	i32.const	$1=, 24
	i32.shl 	$push0=, $0, $1
	i32.shr_s	$push1=, $pop0, $1
	return  	$pop1
.Lfunc_end1:
	.size	fn1, .Lfunc_end1-fn1

	.globl	fn2
	.type	fn2,@function
fn2:                                    # @fn2
	.param  	i32
# BB#0:                                 # %entry
	#APP
	#NO_APP
	block   	.LBB2_2
	br_if   	$0, .LBB2_2
# BB#1:                                 # %if.end
	return
.LBB2_2:                                  # %if.then
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
.Lfunc_end2:
	.size	fn2, .Lfunc_end2-fn2

	.globl	fn3
	.type	fn3,@function
fn3:                                    # @fn3
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	#APP
	#NO_APP
	return  	$0
.Lfunc_end3:
	.size	fn3, .Lfunc_end3-fn3

	.globl	fn4
	.type	fn4,@function
fn4:                                    # @fn4
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	#APP
	#NO_APP
	i32.load8_s	$push0=, 0($0)
	return  	$pop0
.Lfunc_end4:
	.size	fn4, .Lfunc_end4-fn4

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %if.then.i
	i32.const	$6=, __stack_pointer
	i32.load	$6=, 0($6)
	i32.const	$7=, 16
	i32.sub 	$8=, $6, $7
	i32.const	$7=, __stack_pointer
	i32.store	$8=, 0($7), $8
	block   	.LBB5_2
	i32.const	$push4=, 20
	i32.const	$push1=, .str
	i32.const	$push3=, 924
	i32.const	$push0=, __func__.test
	i32.const	$push2=, 0
	i32.call	$0=, fn1, $pop4, $pop1, $pop3, $pop0, $pop2
	i32.const	$push5=, 255
	i32.and 	$push6=, $0, $pop5
	i32.const	$push9=, 0
	i32.eq  	$push10=, $pop6, $pop9
	br_if   	$pop10, .LBB5_2
# BB#1:                                 # %cond.true.i
	i32.const	$push7=, 33816706
	i32.call	$0=, fn3, $pop7
	i32.const	$push8=, .str.1
	i32.call	$1=, fn4, $pop8
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 4
	i32.sub 	$8=, $2, $3
	i32.const	$3=, __stack_pointer
	i32.store	$8=, 0($3), $8
	i32.store	$discard=, 0($8), $1
	call    	fn2, $0
	i32.const	$4=, __stack_pointer
	i32.load	$4=, 0($4)
	i32.const	$5=, 4
	i32.add 	$8=, $4, $5
	i32.const	$5=, __stack_pointer
	i32.store	$8=, 0($5), $8
.LBB5_2:                                  # %test.exit
	call    	abort
	unreachable
.Lfunc_end5:
	.size	main, .Lfunc_end5-main

	.type	.str,@object            # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.str:
	.asciz	"foo"
	.size	.str, 4

	.type	__func__.test,@object   # @__func__.test
__func__.test:
	.asciz	"test"
	.size	__func__.test, 5

	.type	.str.1,@object          # @.str.1
.str.1:
	.asciz	"division by zero"
	.size	.str.1, 17


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
