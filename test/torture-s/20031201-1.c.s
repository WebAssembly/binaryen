	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20031201-1.c"
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
	call    	f0
	i32.load	$1=, i($1)
	i32.const	$push2=, 8
	i32.store	$push3=, 0($1), $pop2
	i32.store	$discard=, 4($1), $pop3
	call    	test
	unreachable
func_end0:
	.size	f1, func_end0-f1

	.globl	f0
	.type	f0,@function
f0:                                     # @f0
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	i32.load	$2=, f0.washere($1)
	i32.load	$0=, i($1)
	block   	BB1_4
	i32.const	$push0=, 1
	i32.add 	$push1=, $2, $pop0
	i32.store	$discard=, f0.washere($1), $pop1
	br_if   	$2, BB1_4
# BB#1:                                 # %lor.lhs.false
	i32.const	$1=, 32
	i32.load16_u	$push2=, 0($0)
	i32.ne  	$push3=, $pop2, $1
	br_if   	$pop3, BB1_4
# BB#2:                                 # %lor.lhs.false1
	i32.load16_u	$push4=, 4($0)
	i32.ne  	$push5=, $pop4, $1
	br_if   	$pop5, BB1_4
# BB#3:                                 # %if.end
	return
BB1_4:                                  # %if.then
	call    	abort
	unreachable
func_end1:
	.size	f0, func_end1-f0

	.globl	test
	.type	test,@function
test:                                   # @test
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	i32.load	$0=, i($1)
	i32.const	$2=, 8
	block   	BB2_3
	i32.load16_u	$push0=, 0($0)
	i32.ne  	$push1=, $pop0, $2
	br_if   	$pop1, BB2_3
# BB#1:                                 # %lor.lhs.false
	i32.load16_u	$push2=, 4($0)
	i32.ne  	$push3=, $pop2, $2
	br_if   	$pop3, BB2_3
# BB#2:                                 # %if.end
	call    	exit, $1
	unreachable
BB2_3:                                  # %if.then
	call    	abort
	unreachable
func_end2:
	.size	test, func_end2-test

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
	i32.call	$discard=, f1, $2
	unreachable
func_end3:
	.size	main, func_end3-main

	.type	i,@object               # @i
	.lcomm	i,4,2
	.type	f0.washere,@object      # @f0.washere
	.lcomm	f0.washere,4,2

	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
