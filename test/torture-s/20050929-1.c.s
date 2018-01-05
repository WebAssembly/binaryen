	.text
	.file	"20050929-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.load	$0=, e($pop0)
	i32.load	$1=, 0($0)
	block   	
	i32.load	$push1=, 0($1)
	i32.const	$push2=, 1
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label0
# %bb.1:                                # %lor.lhs.false
	i32.load	$push4=, 4($1)
	i32.const	$push5=, 2
	i32.ne  	$push6=, $pop4, $pop5
	br_if   	0, $pop6        # 0: down to label0
# %bb.2:                                # %if.end
	i32.load	$0=, 4($0)
	i32.load	$push7=, 0($0)
	i32.const	$push8=, 3
	i32.ne  	$push9=, $pop7, $pop8
	br_if   	0, $pop9        # 0: down to label0
# %bb.3:                                # %lor.lhs.false5
	i32.load	$push10=, 4($0)
	i32.const	$push11=, 4
	i32.ne  	$push12=, $pop10, $pop11
	br_if   	0, $pop12       # 0: down to label0
# %bb.4:                                # %if.end10
	i32.const	$push13=, 0
	i32.load	$0=, e+4($pop13)
	i32.load	$push14=, 0($0)
	i32.const	$push15=, 5
	i32.ne  	$push16=, $pop14, $pop15
	br_if   	0, $pop16       # 0: down to label0
# %bb.5:                                # %lor.lhs.false13
	i32.load	$push17=, 4($0)
	i32.const	$push18=, 6
	i32.ne  	$push19=, $pop17, $pop18
	br_if   	0, $pop19       # 0: down to label0
# %bb.6:                                # %if.end17
	i32.const	$push20=, 0
	return  	$pop20
.LBB0_7:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
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


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
