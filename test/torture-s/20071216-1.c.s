	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20071216-1.c"
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, x($pop0)
	return  	$pop1
func_end0:
	.size	bar, func_end0-bar

	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.call	$0=, bar
	i32.const	$push0=, -4095
	i32.lt_u	$push1=, $0, $pop0
	i32.const	$push2=, -38
	i32.eq  	$push3=, $0, $pop2
	i32.const	$push5=, -37
	i32.const	$push4=, -1
	i32.select	$push6=, $pop3, $pop5, $pop4
	i32.select	$push7=, $pop1, $0, $pop6
	return  	$pop7
func_end1:
	.size	foo, func_end1-foo

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.const	$push0=, 26
	i32.store	$1=, x($0), $pop0
	i32.call	$2=, bar
	i32.const	$4=, -38
	i32.const	$5=, -1
	i32.const	$6=, -37
	i32.const	$3=, -4095
	block   	BB2_6
	i32.lt_u	$push1=, $2, $3
	i32.eq  	$push2=, $2, $4
	i32.select	$push3=, $pop2, $6, $5
	i32.select	$push4=, $pop1, $2, $pop3
	i32.ne  	$push5=, $pop4, $1
	br_if   	$pop5, BB2_6
# BB#1:                                 # %if.end
	i32.const	$push6=, -39
	i32.store	$discard=, x($0), $pop6
	i32.call	$2=, bar
	block   	BB2_5
	i32.lt_u	$push7=, $2, $3
	i32.eq  	$push8=, $2, $4
	i32.select	$push9=, $pop8, $6, $5
	i32.select	$push10=, $pop7, $2, $pop9
	i32.ne  	$push11=, $pop10, $5
	br_if   	$pop11, BB2_5
# BB#2:                                 # %if.end4
	i32.store	$discard=, x($0), $4
	i32.call	$2=, bar
	block   	BB2_4
	i32.lt_u	$push12=, $2, $3
	i32.eq  	$push13=, $2, $4
	i32.select	$push14=, $pop13, $6, $5
	i32.select	$push15=, $pop12, $2, $pop14
	i32.ne  	$push16=, $pop15, $6
	br_if   	$pop16, BB2_4
# BB#3:                                 # %if.end8
	return  	$0
BB2_4:                                  # %if.then7
	call    	abort
	unreachable
BB2_5:                                  # %if.then3
	call    	abort
	unreachable
BB2_6:                                  # %if.then
	call    	abort
	unreachable
func_end2:
	.size	main, func_end2-main

	.type	x,@object               # @x
	.lcomm	x,4,2

	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
