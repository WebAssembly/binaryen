	.text
	.file	"20071029-1.c"
	.section	.text.test,"ax",@progbits
	.hidden	test                    # -- Begin function test
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
.LBB0_13:                               # %if.then
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
                                        # -- End function
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push10=, 0
	i32.const	$push8=, 0
	i32.load	$push7=, __stack_pointer($pop8)
	i32.const	$push9=, 64
	i32.sub 	$push19=, $pop7, $pop9
	tee_local	$push18=, $8=, $pop19
	i32.store	__stack_pointer($pop10), $pop18
	i32.const	$push17=, 1
	i32.add 	$0=, $0, $pop17
	i32.const	$push11=, 8
	i32.add 	$push12=, $8, $pop11
	i32.const	$push0=, 4
	i32.or  	$push16=, $pop12, $pop0
	tee_local	$push15=, $1=, $pop16
	i32.const	$push1=, 48
	i32.add 	$2=, $pop15, $pop1
	i32.const	$push2=, 40
	i32.add 	$3=, $1, $pop2
	i32.const	$push3=, 32
	i32.add 	$4=, $1, $pop3
	i32.const	$push4=, 24
	i32.add 	$5=, $1, $pop4
	i32.const	$push5=, 16
	i32.add 	$6=, $1, $pop5
	i32.const	$push6=, 8
	i32.add 	$7=, $1, $pop6
.LBB1_1:                                # %again
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label2:
	i64.const	$push27=, 0
	i64.store	0($1):p2align=2, $pop27
	i32.const	$push26=, 0
	i32.store	0($2), $pop26
	i64.const	$push25=, 0
	i64.store	0($3):p2align=2, $pop25
	i64.const	$push24=, 0
	i64.store	0($4):p2align=2, $pop24
	i64.const	$push23=, 0
	i64.store	0($5):p2align=2, $pop23
	i64.const	$push22=, 0
	i64.store	0($6):p2align=2, $pop22
	i64.const	$push21=, 0
	i64.store	0($7):p2align=2, $pop21
	i32.store	8($8), $0
	i32.const	$push20=, 1
	i32.add 	$0=, $0, $pop20
	i32.const	$push13=, 8
	i32.add 	$push14=, $8, $pop13
	call    	test@FUNCTION, $pop14
	br      	0               # 0: up to label2
.LBB1_2:
	end_loop
	.endfunc
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
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
                                        # -- End function
	.type	test.i,@object          # @test.i
	.section	.data.test.i,"aw",@progbits
	.p2align	2
test.i:
	.int32	11                      # 0xb
	.size	test.i, 4


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
	.functype	exit, void, i32
