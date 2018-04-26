	.text
	.file	"990222-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# %bb.0:                                # %entry
	i32.const	$push21=, 0
	i32.load8_u	$push0=, line+2($pop21)
	i32.const	$push20=, 1
	i32.add 	$1=, $pop0, $pop20
	i32.const	$push19=, 0
	i32.store8	line+2($pop19), $1
	block   	
	i32.const	$push18=, 24
	i32.shl 	$push1=, $1, $pop18
	i32.const	$push2=, 956301313
	i32.lt_s	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label0
# %bb.1:                                # %while.body.preheader
	i32.const	$1=, line+1
.LBB0_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.const	$push27=, 1
	i32.add 	$push4=, $1, $pop27
	i32.const	$push26=, 48
	i32.store8	0($pop4), $pop26
	i32.load8_u	$push5=, 0($1)
	i32.const	$push25=, 1
	i32.add 	$0=, $pop5, $pop25
	i32.store8	0($1), $0
	i32.const	$push24=, -1
	i32.add 	$1=, $1, $pop24
	i32.const	$push23=, 24
	i32.shl 	$push6=, $0, $pop23
	i32.const	$push22=, 956301312
	i32.gt_s	$push7=, $pop6, $pop22
	br_if   	0, $pop7        # 0: up to label1
# %bb.3:                                # %while.end.loopexit
	end_loop
	i32.const	$push8=, 0
	i32.load8_u	$1=, line+2($pop8)
.LBB0_4:                                # %while.end
	end_block                       # label0:
	block   	
	i32.const	$push28=, 0
	i32.load8_u	$push10=, line($pop28)
	i32.const	$push11=, 50
	i32.ne  	$push12=, $pop10, $pop11
	br_if   	0, $pop12       # 0: down to label2
# %bb.5:                                # %while.end
	i32.const	$push31=, 0
	i32.load8_u	$push9=, line+1($pop31)
	i32.const	$push30=, 255
	i32.and 	$push13=, $pop9, $pop30
	i32.const	$push29=, 48
	i32.ne  	$push14=, $pop13, $pop29
	br_if   	0, $pop14       # 0: down to label2
# %bb.6:                                # %while.end
	i32.const	$push33=, 255
	i32.and 	$push15=, $1, $pop33
	i32.const	$push32=, 48
	i32.ne  	$push16=, $pop15, $pop32
	br_if   	0, $pop16       # 0: down to label2
# %bb.7:                                # %if.end
	i32.const	$push17=, 0
	return  	$pop17
.LBB0_8:                                # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.hidden	line                    # @line
	.type	line,@object
	.section	.data.line,"aw",@progbits
	.globl	line
line:
	.asciz	"199"
	.size	line, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
