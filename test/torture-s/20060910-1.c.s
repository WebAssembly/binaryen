	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20060910-1.c"
	.globl	input_getc_complicated
	.type	input_getc_complicated,@function
input_getc_complicated:                 # @input_getc_complicated
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	return  	$pop0
.Lfunc_end0:
	.size	input_getc_complicated, .Lfunc_end0-input_getc_complicated

	.globl	check_header
	.type	check_header,@function
check_header:                           # @check_header
	.param  	i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.load	$1=, 4($0)
	i32.load	$2=, 0($0)
	block   	.LBB1_2
	i32.ge_u	$push5=, $2, $1
	br_if   	$pop5, .LBB1_2
# BB#1:                                 # %cond.true
	i32.const	$push6=, 1
	i32.add 	$push0=, $2, $pop6
	i32.store	$2=, 0($0), $pop0
.LBB1_2:                                  # %for.inc
	block   	.LBB1_4
	i32.ge_u	$push7=, $2, $1
	br_if   	$pop7, .LBB1_4
# BB#3:                                 # %cond.true.1
	i32.const	$push8=, 1
	i32.add 	$push1=, $2, $pop8
	i32.store	$2=, 0($0), $pop1
.LBB1_4:                                  # %for.inc.1
	block   	.LBB1_6
	i32.ge_u	$push9=, $2, $1
	br_if   	$pop9, .LBB1_6
# BB#5:                                 # %cond.true.2
	i32.const	$push10=, 1
	i32.add 	$push2=, $2, $pop10
	i32.store	$2=, 0($0), $pop2
.LBB1_6:                                  # %for.inc.2
	block   	.LBB1_8
	i32.ge_u	$push11=, $2, $1
	br_if   	$pop11, .LBB1_8
# BB#7:                                 # %cond.true.3
	i32.const	$push12=, 1
	i32.add 	$push3=, $2, $pop12
	i32.store	$2=, 0($0), $pop3
.LBB1_8:                                  # %for.inc.3
	block   	.LBB1_10
	i32.ge_u	$push13=, $2, $1
	br_if   	$pop13, .LBB1_10
# BB#9:                                 # %cond.true.4
	i32.const	$push14=, 1
	i32.add 	$push4=, $2, $pop14
	i32.store	$2=, 0($0), $pop4
.LBB1_10:                                 # %for.inc.4
	block   	.LBB1_12
	i32.ge_u	$push15=, $2, $1
	br_if   	$pop15, .LBB1_12
# BB#11:                                # %cond.true.5
	i32.const	$push16=, 1
	i32.add 	$push17=, $2, $pop16
	i32.store	$discard=, 0($0), $pop17
.LBB1_12:                                 # %for.inc.5
	i32.const	$push18=, 1
	return  	$pop18
.Lfunc_end1:
	.size	check_header, .Lfunc_end1-check_header

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %if.end2
	i32.const	$0=, 0
	i32.const	$push0=, b+6
	i32.store	$push1=, s+4($0), $pop0
	i32.store	$discard=, s($0), $pop1
	return  	$0
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.type	b,@object               # @b
	.bss
	.globl	b
b:
	.zero	6
	.size	b, 6

	.type	s,@object               # @s
	.globl	s
	.align	2
s:
	.zero	8
	.size	s, 8


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
