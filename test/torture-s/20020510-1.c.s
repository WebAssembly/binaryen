	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20020510-1.c"
	.globl	testc
	.type	testc,@function
testc:                                  # @testc
	.param  	i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$2=, 24
	block   	.LBB0_5
	block   	.LBB0_4
	block   	.LBB0_3
	i32.shl 	$push0=, $0, $2
	i32.shr_s	$push1=, $pop0, $2
	i32.const	$push2=, 1
	i32.lt_s	$push3=, $pop1, $pop2
	br_if   	$pop3, .LBB0_3
# BB#1:                                 # %if.then
	br_if   	$1, .LBB0_4
# BB#2:                                 # %if.then5
	call    	abort
	unreachable
.LBB0_3:                                  # %if.else
	br_if   	$1, .LBB0_5
.LBB0_4:                                  # %if.end9
	return
.LBB0_5:                                  # %if.then7
	call    	abort
	unreachable
.Lfunc_end0:
	.size	testc, .Lfunc_end0-testc

	.globl	tests
	.type	tests,@function
tests:                                  # @tests
	.param  	i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$2=, 16
	block   	.LBB1_5
	block   	.LBB1_4
	block   	.LBB1_3
	i32.shl 	$push0=, $0, $2
	i32.shr_s	$push1=, $pop0, $2
	i32.const	$push2=, 1
	i32.lt_s	$push3=, $pop1, $pop2
	br_if   	$pop3, .LBB1_3
# BB#1:                                 # %if.then
	br_if   	$1, .LBB1_4
# BB#2:                                 # %if.then5
	call    	abort
	unreachable
.LBB1_3:                                  # %if.else
	br_if   	$1, .LBB1_5
.LBB1_4:                                  # %if.end9
	return
.LBB1_5:                                  # %if.then7
	call    	abort
	unreachable
.Lfunc_end1:
	.size	tests, .Lfunc_end1-tests

	.globl	testi
	.type	testi,@function
testi:                                  # @testi
	.param  	i32, i32
# BB#0:                                 # %entry
	block   	.LBB2_5
	block   	.LBB2_4
	block   	.LBB2_3
	i32.const	$push0=, 1
	i32.lt_s	$push1=, $0, $pop0
	br_if   	$pop1, .LBB2_3
# BB#1:                                 # %if.then
	br_if   	$1, .LBB2_4
# BB#2:                                 # %if.then2
	call    	abort
	unreachable
.LBB2_3:                                  # %if.else
	br_if   	$1, .LBB2_5
.LBB2_4:                                  # %if.end6
	return
.LBB2_5:                                  # %if.then4
	call    	abort
	unreachable
.Lfunc_end2:
	.size	testi, .Lfunc_end2-testi

	.globl	testl
	.type	testl,@function
testl:                                  # @testl
	.param  	i32, i32
# BB#0:                                 # %entry
	block   	.LBB3_5
	block   	.LBB3_4
	block   	.LBB3_3
	i32.const	$push0=, 1
	i32.lt_s	$push1=, $0, $pop0
	br_if   	$pop1, .LBB3_3
# BB#1:                                 # %if.then
	br_if   	$1, .LBB3_4
# BB#2:                                 # %if.then2
	call    	abort
	unreachable
.LBB3_3:                                  # %if.else
	br_if   	$1, .LBB3_5
.LBB3_4:                                  # %if.end6
	return
.LBB3_5:                                  # %if.then4
	call    	abort
	unreachable
.Lfunc_end3:
	.size	testl, .Lfunc_end3-testl

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	return  	$pop0
.Lfunc_end4:
	.size	main, .Lfunc_end4-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
