	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20020510-1.c"
	.globl	testc
	.type	testc,@function
testc:                                  # @testc
	.param  	i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$2=, 24
	block   	BB0_5
	block   	BB0_4
	block   	BB0_3
	i32.shl 	$push0=, $0, $2
	i32.shr_s	$push1=, $pop0, $2
	i32.const	$push2=, 1
	i32.lt_s	$push3=, $pop1, $pop2
	br_if   	$pop3, BB0_3
# BB#1:                                 # %if.then
	br_if   	$1, BB0_4
# BB#2:                                 # %if.then5
	call    	abort
	unreachable
BB0_3:                                  # %if.else
	br_if   	$1, BB0_5
BB0_4:                                  # %if.end9
	return
BB0_5:                                  # %if.then7
	call    	abort
	unreachable
func_end0:
	.size	testc, func_end0-testc

	.globl	tests
	.type	tests,@function
tests:                                  # @tests
	.param  	i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$2=, 16
	block   	BB1_5
	block   	BB1_4
	block   	BB1_3
	i32.shl 	$push0=, $0, $2
	i32.shr_s	$push1=, $pop0, $2
	i32.const	$push2=, 1
	i32.lt_s	$push3=, $pop1, $pop2
	br_if   	$pop3, BB1_3
# BB#1:                                 # %if.then
	br_if   	$1, BB1_4
# BB#2:                                 # %if.then5
	call    	abort
	unreachable
BB1_3:                                  # %if.else
	br_if   	$1, BB1_5
BB1_4:                                  # %if.end9
	return
BB1_5:                                  # %if.then7
	call    	abort
	unreachable
func_end1:
	.size	tests, func_end1-tests

	.globl	testi
	.type	testi,@function
testi:                                  # @testi
	.param  	i32, i32
# BB#0:                                 # %entry
	block   	BB2_5
	block   	BB2_4
	block   	BB2_3
	i32.const	$push0=, 1
	i32.lt_s	$push1=, $0, $pop0
	br_if   	$pop1, BB2_3
# BB#1:                                 # %if.then
	br_if   	$1, BB2_4
# BB#2:                                 # %if.then2
	call    	abort
	unreachable
BB2_3:                                  # %if.else
	br_if   	$1, BB2_5
BB2_4:                                  # %if.end6
	return
BB2_5:                                  # %if.then4
	call    	abort
	unreachable
func_end2:
	.size	testi, func_end2-testi

	.globl	testl
	.type	testl,@function
testl:                                  # @testl
	.param  	i32, i32
# BB#0:                                 # %entry
	block   	BB3_5
	block   	BB3_4
	block   	BB3_3
	i32.const	$push0=, 1
	i32.lt_s	$push1=, $0, $pop0
	br_if   	$pop1, BB3_3
# BB#1:                                 # %if.then
	br_if   	$1, BB3_4
# BB#2:                                 # %if.then2
	call    	abort
	unreachable
BB3_3:                                  # %if.else
	br_if   	$1, BB3_5
BB3_4:                                  # %if.end6
	return
BB3_5:                                  # %if.then4
	call    	abort
	unreachable
func_end3:
	.size	testl, func_end3-testl

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	return  	$pop0
func_end4:
	.size	main, func_end4-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
