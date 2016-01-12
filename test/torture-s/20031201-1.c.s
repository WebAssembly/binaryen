	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20031201-1.c"
	.section	.text.f1,"ax",@progbits
	.hidden	f1
	.globl	f1
	.type	f1,@function
f1:                                     # @f1
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	i32.store	$discard=, i($1), $0
	i32.const	$push0=, 32
	i32.store	$push1=, 0($0), $pop0
	i32.store	$discard=, 4($0), $pop1
	call    	f0@FUNCTION
	i32.load	$1=, i($1)
	i32.const	$push2=, 8
	i32.store	$push3=, 0($1), $pop2
	i32.store	$discard=, 4($1), $pop3
	call    	test@FUNCTION
	unreachable
.Lfunc_end0:
	.size	f1, .Lfunc_end0-f1

	.section	.text.f0,"ax",@progbits
	.hidden	f0
	.globl	f0
	.type	f0,@function
f0:                                     # @f0
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	i32.load	$2=, f0.washere($1)
	i32.load	$0=, i($1)
	block   	.LBB1_4
	i32.const	$push0=, 1
	i32.add 	$push1=, $2, $pop0
	i32.store	$discard=, f0.washere($1), $pop1
	br_if   	$2, .LBB1_4
# BB#1:                                 # %lor.lhs.false
	i32.const	$1=, 32
	i32.load16_u	$push2=, 0($0)
	i32.ne  	$push3=, $pop2, $1
	br_if   	$pop3, .LBB1_4
# BB#2:                                 # %lor.lhs.false1
	i32.load16_u	$push4=, 4($0)
	i32.ne  	$push5=, $pop4, $1
	br_if   	$pop5, .LBB1_4
# BB#3:                                 # %if.end
	return
.LBB1_4:                                # %if.then
	call    	abort@FUNCTION
	unreachable
.Lfunc_end1:
	.size	f0, .Lfunc_end1-f0

	.section	.text.test,"ax",@progbits
	.hidden	test
	.globl	test
	.type	test,@function
test:                                   # @test
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	i32.load	$0=, i($1)
	i32.const	$2=, 8
	block   	.LBB2_3
	i32.load16_u	$push0=, 0($0)
	i32.ne  	$push1=, $pop0, $2
	br_if   	$pop1, .LBB2_3
# BB#1:                                 # %lor.lhs.false
	i32.load16_u	$push2=, 4($0)
	i32.ne  	$push3=, $pop2, $2
	br_if   	$pop3, .LBB2_3
# BB#2:                                 # %if.end
	call    	exit@FUNCTION, $1
	unreachable
.LBB2_3:                                # %if.then
	call    	abort@FUNCTION
	unreachable
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
.Lfunc_end3:
	.size	main, .Lfunc_end3-main

	.type	i,@object               # @i
	.lcomm	i,4,2
	.type	f0.washere,@object      # @f0.washere
	.lcomm	f0.washere,4,2

	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
