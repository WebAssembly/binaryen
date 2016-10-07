	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20050929-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push0=, 0
	i32.load	$push24=, e($pop0)
	tee_local	$push23=, $0=, $pop24
	i32.load	$push22=, 0($pop23)
	tee_local	$push21=, $1=, $pop22
	i32.load	$push1=, 0($pop21)
	i32.const	$push2=, 1
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label0
# BB#1:                                 # %lor.lhs.false
	i32.load	$push4=, 4($1)
	i32.const	$push5=, 2
	i32.ne  	$push6=, $pop4, $pop5
	br_if   	0, $pop6        # 0: down to label0
# BB#2:                                 # %if.end
	i32.load	$push26=, 4($0)
	tee_local	$push25=, $1=, $pop26
	i32.load	$push7=, 0($pop25)
	i32.const	$push8=, 3
	i32.ne  	$push9=, $pop7, $pop8
	br_if   	0, $pop9        # 0: down to label0
# BB#3:                                 # %lor.lhs.false5
	i32.load	$push10=, 4($1)
	i32.const	$push11=, 4
	i32.ne  	$push12=, $pop10, $pop11
	br_if   	0, $pop12       # 0: down to label0
# BB#4:                                 # %if.end10
	i32.const	$push13=, 0
	i32.load	$push28=, e+4($pop13)
	tee_local	$push27=, $1=, $pop28
	i32.load	$push14=, 0($pop27)
	i32.const	$push15=, 5
	i32.ne  	$push16=, $pop14, $pop15
	br_if   	0, $pop16       # 0: down to label0
# BB#5:                                 # %lor.lhs.false13
	i32.load	$push17=, 4($1)
	i32.const	$push18=, 6
	i32.ne  	$push19=, $pop17, $pop18
	br_if   	0, $pop19       # 0: down to label0
# BB#6:                                 # %if.end17
	i32.const	$push20=, 0
	return  	$pop20
.LBB0_7:                                # %if.then16
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
