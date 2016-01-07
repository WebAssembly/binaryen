	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr44468.c"
	.globl	test1
	.type	test1,@function
test1:                                  # @test1
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	i32.store	$discard=, s+4($1), $1
	i32.const	$push0=, 3
	i32.store	$discard=, 4($0), $pop0
	i32.load	$push1=, s+4($1)
	return  	$pop1
.Lfunc_end0:
	.size	test1, .Lfunc_end0-test1

	.globl	test2
	.type	test2,@function
test2:                                  # @test2
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	i32.store	$discard=, s+4($1), $1
	i32.const	$push0=, 3
	i32.store	$discard=, 4($0), $pop0
	i32.load	$push1=, s+4($1)
	return  	$pop1
.Lfunc_end1:
	.size	test2, .Lfunc_end1-test2

	.globl	test3
	.type	test3,@function
test3:                                  # @test3
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	i32.store	$discard=, s+4($1), $1
	i32.const	$push0=, 3
	i32.store	$discard=, 4($0), $pop0
	i32.load	$push1=, s+4($1)
	return  	$pop1
.Lfunc_end2:
	.size	test3, .Lfunc_end2-test3

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.const	$push0=, 1
	i32.store	$1=, s+4($0), $pop0
	i32.const	$2=, s
	i32.const	$push1=, 2
	i32.store	$3=, s+8($0), $pop1
	i32.call	$4=, test1, $2
	i32.const	$5=, 3
	block   	.LBB3_6
	i32.ne  	$push2=, $4, $5
	br_if   	$pop2, .LBB3_6
# BB#1:                                 # %if.end
	i32.store	$4=, s+4($0), $1
	i32.store	$1=, s+8($0), $3
	block   	.LBB3_5
	i32.call	$push3=, test2, $2
	i32.ne  	$push4=, $pop3, $5
	br_if   	$pop4, .LBB3_5
# BB#2:                                 # %if.end4
	i32.store	$discard=, s+4($0), $4
	i32.store	$discard=, s+8($0), $1
	block   	.LBB3_4
	i32.call	$push5=, test3, $2
	i32.ne  	$push6=, $pop5, $5
	br_if   	$pop6, .LBB3_4
# BB#3:                                 # %if.end8
	return  	$0
.LBB3_4:                                  # %if.then7
	call    	abort
	unreachable
.LBB3_5:                                  # %if.then3
	call    	abort
	unreachable
.LBB3_6:                                  # %if.then
	call    	abort
	unreachable
.Lfunc_end3:
	.size	main, .Lfunc_end3-main

	.type	s,@object               # @s
	.bss
	.globl	s
	.align	2
s:
	.zero	12
	.size	s, 12


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
