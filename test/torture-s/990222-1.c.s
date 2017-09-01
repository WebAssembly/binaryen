	.text
	.file	"990222-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push23=, 0
	i32.const	$push22=, 0
	i32.load8_u	$push0=, line+2($pop22)
	i32.const	$push21=, 1
	i32.add 	$push20=, $pop0, $pop21
	tee_local	$push19=, $1=, $pop20
	i32.store8	line+2($pop23), $pop19
	block   	
	i32.const	$push18=, 24
	i32.shl 	$push1=, $1, $pop18
	i32.const	$push2=, 956301313
	i32.lt_s	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label0
# BB#1:                                 # %while.body.preheader
	i32.const	$1=, line+1
.LBB0_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.const	$push31=, 1
	i32.add 	$push4=, $1, $pop31
	i32.const	$push30=, 48
	i32.store8	0($pop4), $pop30
	i32.load8_u	$push5=, 0($1)
	i32.const	$push29=, 1
	i32.add 	$push28=, $pop5, $pop29
	tee_local	$push27=, $0=, $pop28
	i32.store8	0($1), $pop27
	i32.const	$push26=, -1
	i32.add 	$1=, $1, $pop26
	i32.const	$push25=, 24
	i32.shl 	$push6=, $0, $pop25
	i32.const	$push24=, 956301312
	i32.gt_s	$push7=, $pop6, $pop24
	br_if   	0, $pop7        # 0: up to label1
# BB#3:                                 # %while.end.loopexit
	end_loop
	i32.const	$push8=, 0
	i32.load8_u	$1=, line+2($pop8)
.LBB0_4:                                # %while.end
	end_block                       # label0:
	block   	
	i32.const	$push32=, 0
	i32.load8_u	$push10=, line($pop32)
	i32.const	$push11=, 50
	i32.ne  	$push12=, $pop10, $pop11
	br_if   	0, $pop12       # 0: down to label2
# BB#5:                                 # %while.end
	i32.const	$push35=, 0
	i32.load8_u	$push9=, line+1($pop35)
	i32.const	$push34=, 255
	i32.and 	$push13=, $pop9, $pop34
	i32.const	$push33=, 48
	i32.ne  	$push14=, $pop13, $pop33
	br_if   	0, $pop14       # 0: down to label2
# BB#6:                                 # %while.end
	i32.const	$push37=, 255
	i32.and 	$push15=, $1, $pop37
	i32.const	$push36=, 48
	i32.ne  	$push16=, $pop15, $pop36
	br_if   	0, $pop16       # 0: down to label2
# BB#7:                                 # %if.end
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


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
