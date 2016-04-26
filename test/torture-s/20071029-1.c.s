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
	i32.load	$push18=, test.i($pop19)
	tee_local	$push17=, $3=, $pop18
	i32.const	$push2=, 1
	i32.add 	$push0=, $pop17, $pop2
	i32.store	$2=, test.i($pop1), $pop0
	block
	block
	i32.ne  	$push3=, $1, $3
	br_if   	0, $pop3        # 0: down to label1
# BB#1:                                 # %if.end
	i32.load	$push4=, 4($0)
	br_if   	0, $pop4        # 0: down to label1
# BB#2:                                 # %lor.lhs.false
	i32.load	$push5=, 8($0)
	br_if   	0, $pop5        # 0: down to label1
# BB#3:                                 # %lor.lhs.false6
	i32.load	$push6=, 12($0)
	br_if   	0, $pop6        # 0: down to label1
# BB#4:                                 # %lor.lhs.false10
	i32.load	$push7=, 16($0)
	br_if   	0, $pop7        # 0: down to label1
# BB#5:                                 # %lor.lhs.false13
	i32.load	$push8=, 20($0)
	br_if   	0, $pop8        # 0: down to label1
# BB#6:                                 # %lor.lhs.false16
	i32.load	$push9=, 24($0)
	br_if   	0, $pop9        # 0: down to label1
# BB#7:                                 # %lor.lhs.false20
	i32.load	$push10=, 28($0)
	br_if   	0, $pop10       # 0: down to label1
# BB#8:                                 # %lor.lhs.false23
	i32.load	$push11=, 32($0)
	br_if   	0, $pop11       # 0: down to label1
# BB#9:                                 # %lor.lhs.false26
	i32.load	$push12=, 36($0)
	br_if   	0, $pop12       # 0: down to label1
# BB#10:                                # %lor.lhs.false29
	i32.load	$push13=, 40($0)
	br_if   	0, $pop13       # 0: down to label1
# BB#11:                                # %if.end34
	i32.const	$push14=, 20
	i32.eq  	$push15=, $2, $pop14
	br_if   	1, $pop15       # 1: down to label0
# BB#12:                                # %if.end37
	return
.LBB0_13:                               # %if.then33
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_14:                               # %if.then36
	end_block                       # label0:
	i32.const	$push16=, 0
	call    	exit@FUNCTION, $pop16
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
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push5=, __stack_pointer
	i32.load	$push6=, 0($pop5)
	i32.const	$push7=, 64
	i32.sub 	$2=, $pop6, $pop7
	i32.const	$push8=, __stack_pointer
	i32.store	$discard=, 0($pop8), $2
	i32.const	$push9=, 8
	i32.add 	$push10=, $2, $pop9
	i32.const	$push0=, 4
	i32.or  	$1=, $pop10, $pop0
	i32.const	$push1=, 1
	i32.add 	$0=, $0, $pop1
.LBB1_1:                                # %again
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	i32.store	$discard=, 8($2), $0
	i32.const	$push4=, 0
	i32.const	$push3=, 52
	i32.call	$discard=, memset@FUNCTION, $1, $pop4, $pop3
	i32.const	$push11=, 8
	i32.add 	$push12=, $2, $pop11
	call    	test@FUNCTION, $pop12
	i32.const	$push2=, 1
	i32.add 	$0=, $0, $pop2
	br      	0               # 0: up to label2
.LBB1_2:
	end_loop                        # label3:
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
