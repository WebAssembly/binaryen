	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20050125-1.c"
	.globl	seterr
	.type	seterr,@function
seterr:                                 # @seterr
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.store	$discard=, 8($0), $1
	i32.const	$push0=, 0
	return  	$pop0
func_end0:
	.size	seterr, func_end0-seterr

	.globl	bracket_empty
	.type	bracket_empty,@function
bracket_empty:                          # @bracket_empty
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.load	$1=, 0($0)
	block   	BB1_3
	i32.load	$push0=, 4($0)
	i32.ge_u	$push1=, $1, $pop0
	br_if   	$pop1, BB1_3
# BB#1:                                 # %land.lhs.true
	i32.const	$push2=, 1
	i32.add 	$push3=, $1, $pop2
	i32.store	$discard=, 0($0), $pop3
	i32.load8_u	$push4=, 0($1)
	i32.const	$push5=, 93
	i32.ne  	$push6=, $pop4, $pop5
	br_if   	$pop6, BB1_3
# BB#2:                                 # %if.end
	return
BB1_3:                                  # %lor.lhs.false
	i32.const	$push7=, 7
	i32.store	$discard=, 8($0), $pop7
	return
func_end1:
	.size	bracket_empty, func_end1-bracket_empty

	.globl	main
	.type	main,@function
main:                                   # @main
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	return  	$pop0
func_end2:
	.size	main, func_end2-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
