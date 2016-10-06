	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20071029-1.c"
	.section	.text.test,"ax",@progbits
	.hidden	test
	.globl	test
	.type	test,@function
test:                                   # @test
	.param  	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.load	$3=, 0($0)
	i32.const	$push0=, 0
	i32.const	$push20=, 0
	i32.load	$push19=, test.i($pop20)
	tee_local	$push18=, $2=, $pop19
	i32.const	$push1=, 1
	i32.add 	$push17=, $pop18, $pop1
	tee_local	$push16=, $1=, $pop17
	i32.store	test.i($pop0), $pop16
	block   	
	block   	
	i32.ne  	$push2=, $3, $2
	br_if   	0, $pop2        # 0: down to label1
# BB#1:                                 # %if.end
	i32.load	$push3=, 4($0)
	br_if   	0, $pop3        # 0: down to label1
# BB#2:                                 # %lor.lhs.false
	i32.load	$push4=, 8($0)
	br_if   	0, $pop4        # 0: down to label1
# BB#3:                                 # %lor.lhs.false6
	i32.load	$push5=, 12($0)
	br_if   	0, $pop5        # 0: down to label1
# BB#4:                                 # %lor.lhs.false10
	i32.load	$push6=, 16($0)
	br_if   	0, $pop6        # 0: down to label1
# BB#5:                                 # %lor.lhs.false13
	i32.load	$push7=, 20($0)
	br_if   	0, $pop7        # 0: down to label1
# BB#6:                                 # %lor.lhs.false16
	i32.load	$push8=, 24($0)
	br_if   	0, $pop8        # 0: down to label1
# BB#7:                                 # %lor.lhs.false20
	i32.load	$push9=, 28($0)
	br_if   	0, $pop9        # 0: down to label1
# BB#8:                                 # %lor.lhs.false23
	i32.load	$push10=, 32($0)
	br_if   	0, $pop10       # 0: down to label1
# BB#9:                                 # %lor.lhs.false26
	i32.load	$push11=, 36($0)
	br_if   	0, $pop11       # 0: down to label1
# BB#10:                                # %lor.lhs.false29
	i32.load	$push12=, 40($0)
	br_if   	0, $pop12       # 0: down to label1
# BB#11:                                # %if.end34
	i32.const	$push13=, 20
	i32.eq  	$push14=, $1, $pop13
	br_if   	1, $pop14       # 1: down to label0
# BB#12:                                # %if.end37
	return
.LBB0_13:                               # %if.then33
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_14:                               # %if.then36
	end_block                       # label0:
	i32.const	$push15=, 0
	call    	exit@FUNCTION, $pop15
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
	i32.const	$push4=, 0
	i32.const	$push1=, 0
	i32.load	$push2=, __stack_pointer($pop1)
	i32.const	$push3=, 64
	i32.sub 	$push11=, $pop2, $pop3
	tee_local	$push10=, $2=, $pop11
	i32.store	__stack_pointer($pop4), $pop10
	i32.const	$push9=, 1
	i32.add 	$0=, $0, $pop9
	i32.const	$push5=, 8
	i32.add 	$push6=, $2, $pop5
	i32.const	$push0=, 4
	i32.or  	$1=, $pop6, $pop0
.LBB1_1:                                # %again
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label2:
	i32.store	8($2), $0
	i32.const	$push14=, 0
	i32.const	$push13=, 52
	i32.call	$drop=, memset@FUNCTION, $1, $pop14, $pop13
	i32.const	$push12=, 1
	i32.add 	$0=, $0, $pop12
	i32.const	$push7=, 8
	i32.add 	$push8=, $2, $pop7
	call    	test@FUNCTION, $pop8
	br      	0               # 0: up to label2
.LBB1_2:
	end_loop
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
