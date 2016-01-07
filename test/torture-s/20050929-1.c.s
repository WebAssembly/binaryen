	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20050929-1.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, 0
	i32.load	$0=, e($2)
	i32.load	$1=, 0($0)
	block   	.LBB0_9
	i32.load	$push0=, 0($1)
	i32.const	$push1=, 1
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	$pop2, .LBB0_9
# BB#1:                                 # %lor.lhs.false
	i32.load	$push3=, 4($1)
	i32.const	$push4=, 2
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	$pop5, .LBB0_9
# BB#2:                                 # %if.end
	i32.load	$1=, 4($0)
	block   	.LBB0_8
	i32.load	$push6=, 0($1)
	i32.const	$push7=, 3
	i32.ne  	$push8=, $pop6, $pop7
	br_if   	$pop8, .LBB0_8
# BB#3:                                 # %lor.lhs.false5
	i32.load	$push9=, 4($1)
	i32.const	$push10=, 4
	i32.ne  	$push11=, $pop9, $pop10
	br_if   	$pop11, .LBB0_8
# BB#4:                                 # %if.end10
	i32.load	$1=, e+4($2)
	block   	.LBB0_7
	i32.load	$push12=, 0($1)
	i32.const	$push13=, 5
	i32.ne  	$push14=, $pop12, $pop13
	br_if   	$pop14, .LBB0_7
# BB#5:                                 # %lor.lhs.false13
	i32.load	$push15=, 4($1)
	i32.const	$push16=, 6
	i32.ne  	$push17=, $pop15, $pop16
	br_if   	$pop17, .LBB0_7
# BB#6:                                 # %if.end17
	return  	$2
.LBB0_7:                                  # %if.then16
	call    	abort
	unreachable
.LBB0_8:                                  # %if.then9
	call    	abort
	unreachable
.LBB0_9:                                  # %if.then
	call    	abort
	unreachable
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.type	.compoundliteral,@object # @.compoundliteral
	.data
	.align	2
.compoundliteral:
	.int32	1                       # 0x1
	.int32	2                       # 0x2
	.size	.compoundliteral, 8

	.type	.compoundliteral.1,@object # @.compoundliteral.1
	.align	2
.compoundliteral.1:
	.int32	3                       # 0x3
	.int32	4                       # 0x4
	.size	.compoundliteral.1, 8

	.type	.compoundliteral.2,@object # @.compoundliteral.2
	.align	2
.compoundliteral.2:
	.int32	.compoundliteral
	.int32	.compoundliteral.1
	.size	.compoundliteral.2, 8

	.type	.compoundliteral.3,@object # @.compoundliteral.3
	.align	2
.compoundliteral.3:
	.int32	5                       # 0x5
	.int32	6                       # 0x6
	.size	.compoundliteral.3, 8

	.type	e,@object               # @e
	.globl	e
	.align	2
e:
	.int32	.compoundliteral.2
	.int32	.compoundliteral.3
	.size	e, 8


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
