	.text
	.file	"20030714-1.c"
	.section	.text.RenderBox_setStyle,"ax",@progbits
	.hidden	RenderBox_setStyle      # -- Begin function RenderBox_setStyle
	.globl	RenderBox_setStyle
	.type	RenderBox_setStyle,@function
RenderBox_setStyle:                     # @RenderBox_setStyle
	.param  	i32, i32
	.local  	i32
# %bb.0:                                # %entry
	i32.load16_u	$2=, 26($0)
	block   	
	block   	
	block   	
	block   	
	i32.const	$push0=, 2
	i32.add 	$push1=, $1, $pop0
	i32.load8_u	$push2=, 0($pop1)
	i32.const	$push3=, 4
	i32.and 	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label3
# %bb.1:                                # %sw.default
	block   	
	i32.const	$push32=, 16
	i32.and 	$push6=, $2, $pop32
	i32.eqz 	$push34=, $pop6
	br_if   	0, $pop34       # 0: down to label4
# %bb.2:                                # %if.then
	i32.const	$push33=, 16
	i32.or  	$2=, $2, $pop33
	i32.const	$push7=, 26
	i32.add 	$push8=, $0, $pop7
	i32.store16	0($pop8), $2
.LBB0_3:                                # %if.end
	end_block                       # label4:
	i32.const	$push12=, 26
	i32.add 	$push13=, $0, $pop12
	i32.const	$push10=, 65519
	i32.and 	$push11=, $2, $pop10
	i32.store16	0($pop13), $pop11
	i32.load	$2=, 0($1)
	i32.load	$push15=, 28($0)
	i32.call_indirect	$push16=, $0, $pop15
	br_if   	1, $pop16       # 1: down to label2
# %bb.4:                                # %if.end
	i32.const	$push14=, 1572864
	i32.and 	$push9=, $2, $pop14
	i32.eqz 	$push35=, $pop9
	br_if   	1, $pop35       # 1: down to label2
# %bb.5:                                # %if.then33
	i32.const	$push17=, 26
	i32.add 	$push18=, $0, $pop17
	i32.load16_u	$push19=, 0($pop18)
	i32.const	$push20=, 8
	i32.or  	$2=, $pop19, $pop20
	br      	2               # 2: down to label1
.LBB0_6:                                # %sw.bb
	end_block                       # label3:
	i32.const	$push5=, 16
	i32.or  	$2=, $2, $pop5
	br      	1               # 1: down to label1
.LBB0_7:                                # %if.else
	end_block                       # label2:
	i32.load	$push21=, 0($1)
	i32.const	$push22=, 393216
	i32.and 	$push23=, $pop21, $pop22
	i32.const	$push24=, 131072
	i32.ne  	$push25=, $pop23, $pop24
	br_if   	1, $pop25       # 1: down to label0
# %bb.8:                                # %if.then48
	i32.const	$push26=, 26
	i32.add 	$push27=, $0, $pop26
	i32.load16_u	$push28=, 0($pop27)
	i32.const	$push29=, 64
	i32.or  	$2=, $pop28, $pop29
.LBB0_9:                                # %sw.epilog.sink.split
	end_block                       # label1:
	i32.const	$push30=, 26
	i32.add 	$push31=, $0, $pop30
	i32.store16	0($pop31), $2
.LBB0_10:                               # %sw.epilog
	end_block                       # label0:
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	RenderBox_setStyle, .Lfunc_end0-RenderBox_setStyle
                                        # -- End function
	.section	.text.RenderObject_setStyle,"ax",@progbits
	.hidden	RenderObject_setStyle   # -- Begin function RenderObject_setStyle
	.globl	RenderObject_setStyle
	.type	RenderObject_setStyle,@function
RenderObject_setStyle:                  # @RenderObject_setStyle
	.param  	i32, i32
# %bb.0:                                # %entry
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	RenderObject_setStyle, .Lfunc_end1-RenderObject_setStyle
                                        # -- End function
	.section	.text.removeFromSpecialObjects,"ax",@progbits
	.hidden	removeFromSpecialObjects # -- Begin function removeFromSpecialObjects
	.globl	removeFromSpecialObjects
	.type	removeFromSpecialObjects,@function
removeFromSpecialObjects:               # @removeFromSpecialObjects
	.param  	i32
# %bb.0:                                # %entry
                                        # fallthrough-return
	.endfunc
.Lfunc_end2:
	.size	removeFromSpecialObjects, .Lfunc_end2-removeFromSpecialObjects
                                        # -- End function
	.section	.text.RenderBox_isTableCell,"ax",@progbits
	.hidden	RenderBox_isTableCell   # -- Begin function RenderBox_isTableCell
	.globl	RenderBox_isTableCell
	.type	RenderBox_isTableCell,@function
RenderBox_isTableCell:                  # @RenderBox_isTableCell
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end3:
	.size	RenderBox_isTableCell, .Lfunc_end3-RenderBox_isTableCell
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %RenderBox_setStyle.exit
	i32.const	$push1=, 0
	i32.const	$push0=, RenderBox_isTableCell@FUNCTION
	i32.store	g_this+28($pop1), $pop0
	i32.const	$push16=, 0
	i32.const	$push15=, 0
	i32.load	$push2=, g__style($pop15)
	i32.const	$push3=, -1966081
	i32.and 	$push4=, $pop2, $pop3
	i32.const	$push5=, 393216
	i32.or  	$push6=, $pop4, $pop5
	i32.store	g__style($pop16), $pop6
	i32.const	$push14=, 0
	i32.const	$push13=, 0
	i32.load16_u	$push7=, g_this+26($pop13)
	i32.const	$push8=, 65447
	i32.and 	$push9=, $pop7, $pop8
	i32.const	$push10=, 16
	i32.or  	$push11=, $pop9, $pop10
	i32.store16	g_this+26($pop14), $pop11
	i32.const	$push12=, 0
	call    	exit@FUNCTION, $pop12
	unreachable
	.endfunc
.Lfunc_end4:
	.size	main, .Lfunc_end4-main
                                        # -- End function
	.hidden	false                   # @false
	.type	false,@object
	.section	.rodata.false,"a",@progbits
	.globl	false
false:
	.int8	0                       # 0x0
	.size	false, 1

	.hidden	true                    # @true
	.type	true,@object
	.section	.rodata.true,"a",@progbits
	.globl	true
true:
	.int8	1                       # 0x1
	.size	true, 1

	.hidden	g_this                  # @g_this
	.type	g_this,@object
	.section	.bss.g_this,"aw",@nobits
	.globl	g_this
	.p2align	2
g_this:
	.skip	32
	.size	g_this, 32

	.hidden	g__style                # @g__style
	.type	g__style,@object
	.section	.bss.g__style,"aw",@nobits
	.globl	g__style
	.p2align	2
g__style:
	.skip	4
	.size	g__style, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	exit, void, i32
