	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20071029-1.c"
	.section	.text.test,"ax",@progbits
	.hidden	test
	.globl	test
	.type	test,@function
test:                                   # @test
	.param  	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.load	$1=, 0($0)
	i32.const	$push1=, 0
	i32.const	$push19=, 0
	i32.load	$push2=, test.i($pop19)
	tee_local	$push18=, $3=, $pop2
	i32.const	$push3=, 1
	i32.add 	$push0=, $pop18, $pop3
	i32.store	$2=, test.i($pop1), $pop0
	block
	i32.ne  	$push4=, $1, $3
	br_if   	$pop4, 0        # 0: down to label0
# BB#1:                                 # %if.end
	block
	i32.load	$push5=, 4($0)
	br_if   	$pop5, 0        # 0: down to label1
# BB#2:                                 # %lor.lhs.false
	i32.load	$push6=, 8($0)
	br_if   	$pop6, 0        # 0: down to label1
# BB#3:                                 # %lor.lhs.false6
	i32.load	$push7=, 12($0)
	br_if   	$pop7, 0        # 0: down to label1
# BB#4:                                 # %lor.lhs.false10
	i32.load	$push8=, 16($0)
	br_if   	$pop8, 0        # 0: down to label1
# BB#5:                                 # %lor.lhs.false13
	i32.load	$push9=, 20($0)
	br_if   	$pop9, 0        # 0: down to label1
# BB#6:                                 # %lor.lhs.false16
	i32.load	$push10=, 24($0)
	br_if   	$pop10, 0       # 0: down to label1
# BB#7:                                 # %lor.lhs.false20
	i32.load	$push11=, 28($0)
	br_if   	$pop11, 0       # 0: down to label1
# BB#8:                                 # %lor.lhs.false23
	i32.load	$push12=, 32($0)
	br_if   	$pop12, 0       # 0: down to label1
# BB#9:                                 # %lor.lhs.false26
	i32.load	$push13=, 36($0)
	br_if   	$pop13, 0       # 0: down to label1
# BB#10:                                # %lor.lhs.false29
	i32.load	$push14=, 40($0)
	br_if   	$pop14, 0       # 0: down to label1
# BB#11:                                # %if.end34
	block
	i32.const	$push15=, 20
	i32.eq  	$push16=, $2, $pop15
	br_if   	$pop16, 0       # 0: down to label2
# BB#12:                                # %if.end37
	return
.LBB0_13:                               # %if.then36
	end_block                       # label2:
	i32.const	$push17=, 0
	call    	exit@FUNCTION, $pop17
	unreachable
.LBB0_14:                               # %if.then33
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_15:                               # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	test, .Lfunc_end0-test

	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 64
	i32.sub 	$6=, $2, $3
	i32.const	$3=, __stack_pointer
	i32.store	$6=, 0($3), $6
	i32.const	$push0=, 4
	i32.const	$4=, 8
	i32.add 	$4=, $6, $4
	i32.or  	$1=, $4, $pop0
	i32.const	$push1=, 1
	i32.add 	$0=, $0, $pop1
.LBB1_1:                                # %again
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label3:
	i32.store	$discard=, 8($6):p2align=3, $0
	i32.const	$push4=, 0
	i32.const	$push3=, 52
	i32.call	$discard=, memset@FUNCTION, $1, $pop4, $pop3
	i32.const	$5=, 8
	i32.add 	$5=, $6, $5
	call    	test@FUNCTION, $5
	i32.const	$push2=, 1
	i32.add 	$0=, $0, $pop2
	br      	0               # 0: up to label3
.LBB1_2:
	end_loop                        # label4:
	.endfunc
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end6
	i32.const	$push0=, 10
	call    	foo@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.type	test.i,@object          # @test.i
	.section	.data.test.i,"aw",@progbits
	.p2align	2
test.i:
	.int32	11                      # 0xb
	.size	test.i, 4


	.ident	"clang version 3.9.0 "
