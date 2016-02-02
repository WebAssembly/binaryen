	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20050929-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	block
	i32.const	$push4=, 0
	i32.load	$push0=, e($pop4)
	tee_local	$push26=, $1=, $pop0
	i32.load	$push1=, 0($pop26)
	tee_local	$push25=, $0=, $pop1
	i32.load	$push5=, 0($pop25)
	i32.const	$push6=, 1
	i32.ne  	$push7=, $pop5, $pop6
	br_if   	$pop7, 0        # 0: down to label0
# BB#1:                                 # %lor.lhs.false
	i32.load	$push8=, 4($0)
	i32.const	$push9=, 2
	i32.ne  	$push10=, $pop8, $pop9
	br_if   	$pop10, 0       # 0: down to label0
# BB#2:                                 # %if.end
	block
	i32.load	$push2=, 4($1)
	tee_local	$push27=, $0=, $pop2
	i32.load	$push11=, 0($pop27)
	i32.const	$push12=, 3
	i32.ne  	$push13=, $pop11, $pop12
	br_if   	$pop13, 0       # 0: down to label1
# BB#3:                                 # %lor.lhs.false5
	i32.load	$push14=, 4($0)
	i32.const	$push15=, 4
	i32.ne  	$push16=, $pop14, $pop15
	br_if   	$pop16, 0       # 0: down to label1
# BB#4:                                 # %if.end10
	block
	i32.const	$push17=, 0
	i32.load	$push3=, e+4($pop17)
	tee_local	$push28=, $0=, $pop3
	i32.load	$push18=, 0($pop28)
	i32.const	$push19=, 5
	i32.ne  	$push20=, $pop18, $pop19
	br_if   	$pop20, 0       # 0: down to label2
# BB#5:                                 # %lor.lhs.false13
	i32.load	$push21=, 4($0)
	i32.const	$push22=, 6
	i32.ne  	$push23=, $pop21, $pop22
	br_if   	$pop23, 0       # 0: down to label2
# BB#6:                                 # %if.end17
	i32.const	$push24=, 0
	return  	$pop24
.LBB0_7:                                # %if.then16
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB0_8:                                # %if.then9
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_9:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.type	.compoundliteral,@object # @.compoundliteral
	.section	.data..compoundliteral,"aw",@progbits
	.p2align	2
.compoundliteral:
	.int32	1                       # 0x1
	.int32	2                       # 0x2
	.size	.compoundliteral, 8

	.type	.compoundliteral.1,@object # @.compoundliteral.1
	.section	.data..compoundliteral.1,"aw",@progbits
	.p2align	2
.compoundliteral.1:
	.int32	3                       # 0x3
	.int32	4                       # 0x4
	.size	.compoundliteral.1, 8

	.type	.compoundliteral.2,@object # @.compoundliteral.2
	.section	.data..compoundliteral.2,"aw",@progbits
	.p2align	2
.compoundliteral.2:
	.int32	.compoundliteral
	.int32	.compoundliteral.1
	.size	.compoundliteral.2, 8

	.type	.compoundliteral.3,@object # @.compoundliteral.3
	.section	.data..compoundliteral.3,"aw",@progbits
	.p2align	2
.compoundliteral.3:
	.int32	5                       # 0x5
	.int32	6                       # 0x6
	.size	.compoundliteral.3, 8

	.hidden	e                       # @e
	.type	e,@object
	.section	.data.e,"aw",@progbits
	.globl	e
	.p2align	2
e:
	.int32	.compoundliteral.2
	.int32	.compoundliteral.3
	.size	e, 8


	.ident	"clang version 3.9.0 "
