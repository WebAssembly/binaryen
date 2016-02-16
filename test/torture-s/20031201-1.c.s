	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20031201-1.c"
	.section	.text.f1,"ax",@progbits
	.hidden	f1
	.globl	f1
	.type	f1,@function
f1:                                     # @f1
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.store	$push1=, i($pop0), $0
	i64.const	$push2=, 137438953504
	i64.store	$discard=, 0($pop1):p2align=2, $pop2
	call    	f0@FUNCTION
	i32.const	$push5=, 0
	i32.load	$push3=, i($pop5)
	i64.const	$push4=, 34359738376
	i64.store	$discard=, 0($pop3):p2align=2, $pop4
	call    	test@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	f1, .Lfunc_end0-f1

	.section	.text.f0,"ax",@progbits
	.hidden	f0
	.globl	f0
	.type	f0,@function
f0:                                     # @f0
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$0=, i($pop0)
	i32.const	$push10=, 0
	i32.const	$push9=, 0
	i32.load	$push8=, f0.washere($pop9)
	tee_local	$push7=, $1=, $pop8
	i32.const	$push1=, 1
	i32.add 	$push2=, $pop7, $pop1
	i32.store	$discard=, f0.washere($pop10), $pop2
	block
	br_if   	0, $1           # 0: down to label0
# BB#1:                                 # %lor.lhs.false
	i32.load16_u	$push3=, 0($0):p2align=2
	i32.const	$push11=, 32
	i32.ne  	$push4=, $pop3, $pop11
	br_if   	0, $pop4        # 0: down to label0
# BB#2:                                 # %lor.lhs.false1
	i32.load16_u	$push5=, 4($0):p2align=2
	i32.const	$push12=, 32
	i32.ne  	$push6=, $pop5, $pop12
	br_if   	0, $pop6        # 0: down to label0
# BB#3:                                 # %if.end
	return
.LBB1_4:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	f0, .Lfunc_end1-f0

	.section	.text.test,"ax",@progbits
	.hidden	test
	.globl	test
	.type	test,@function
test:                                   # @test
	.local  	i32
# BB#0:                                 # %entry
	block
	i32.const	$push0=, 0
	i32.load	$push8=, i($pop0)
	tee_local	$push7=, $0=, $pop8
	i32.load16_u	$push1=, 0($pop7):p2align=2
	i32.const	$push6=, 8
	i32.ne  	$push2=, $pop1, $pop6
	br_if   	0, $pop2        # 0: down to label1
# BB#1:                                 # %lor.lhs.false
	i32.load16_u	$push3=, 4($0):p2align=2
	i32.const	$push9=, 8
	i32.ne  	$push4=, $pop3, $pop9
	br_if   	0, $pop4        # 0: down to label1
# BB#2:                                 # %if.end
	i32.const	$push5=, 0
	call    	exit@FUNCTION, $pop5
	unreachable
.LBB2_3:                                # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	test, .Lfunc_end2-test

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, __stack_pointer
	i32.load	$0=, 0($0)
	i32.const	$1=, 16
	i32.sub 	$3=, $0, $1
	i32.const	$1=, __stack_pointer
	i32.store	$3=, 0($1), $3
	i32.const	$2=, 8
	i32.add 	$2=, $3, $2
	i32.call	$discard=, f1@FUNCTION, $2
	unreachable
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main

	.type	i,@object               # @i
	.lcomm	i,4,2
	.type	f0.washere,@object      # @f0.washere
	.lcomm	f0.washere,4,2

	.ident	"clang version 3.9.0 "
