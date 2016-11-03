	.text
	.file	"/usr/local/google/home/jgravelle/code/wasm/waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20030714-1.c"
	.section	.text.RenderBox_setStyle,"ax",@progbits
	.hidden	RenderBox_setStyle
	.globl	RenderBox_setStyle
	.type	RenderBox_setStyle,@function
RenderBox_setStyle:                     # @RenderBox_setStyle
	.param  	i32, i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, 16
	block   	
	block   	
	i32.const	$push0=, 2
	i32.add 	$push1=, $1, $pop0
	i32.load8_u	$push2=, 0($pop1)
	i32.const	$push3=, 4
	i32.and 	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label1
# BB#1:                                 # %sw.default
	block   	
	i32.load16_u	$push26=, 26($0)
	tee_local	$push25=, $3=, $pop26
	i32.const	$push24=, 16
	i32.and 	$push5=, $pop25, $pop24
	i32.eqz 	$push32=, $pop5
	br_if   	0, $pop32       # 0: down to label2
# BB#2:                                 # %if.then
	i32.const	$push6=, 26
	i32.add 	$push7=, $0, $pop6
	i32.const	$push29=, 16
	i32.or  	$push28=, $3, $pop29
	tee_local	$push27=, $3=, $pop28
	i32.store16	0($pop7), $pop27
.LBB0_3:                                # %if.end
	end_block                       # label2:
	i32.const	$push11=, 26
	i32.add 	$push12=, $0, $pop11
	i32.const	$push9=, 65519
	i32.and 	$push10=, $3, $pop9
	i32.store16	0($pop12), $pop10
	i32.load	$2=, 0($1)
	block   	
	i32.load	$push14=, 28($0)
	i32.call_indirect	$push15=, $0, $pop14
	br_if   	0, $pop15       # 0: down to label3
# BB#4:                                 # %if.end
	i32.const	$3=, 8
	i32.const	$push13=, 1572864
	i32.and 	$push8=, $2, $pop13
	br_if   	1, $pop8        # 1: down to label1
.LBB0_5:                                # %if.else
	end_block                       # label3:
	i32.const	$3=, 64
	i32.load	$push16=, 0($1)
	i32.const	$push17=, 393216
	i32.and 	$push18=, $pop16, $pop17
	i32.const	$push19=, 131072
	i32.ne  	$push20=, $pop18, $pop19
	br_if   	1, $pop20       # 1: down to label0
.LBB0_6:                                # %sw.epilog.sink.split
	end_block                       # label1:
	i32.const	$push21=, 26
	i32.add 	$push31=, $0, $pop21
	tee_local	$push30=, $0=, $pop31
	i32.load16_u	$push22=, 0($0)
	i32.or  	$push23=, $pop22, $3
	i32.store16	0($pop30), $pop23
.LBB0_7:                                # %sw.epilog
	end_block                       # label0:
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	RenderBox_setStyle, .Lfunc_end0-RenderBox_setStyle

	.section	.text.RenderObject_setStyle,"ax",@progbits
	.hidden	RenderObject_setStyle
	.globl	RenderObject_setStyle
	.type	RenderObject_setStyle,@function
RenderObject_setStyle:                  # @RenderObject_setStyle
	.param  	i32, i32
# BB#0:                                 # %entry
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	RenderObject_setStyle, .Lfunc_end1-RenderObject_setStyle

	.section	.text.removeFromSpecialObjects,"ax",@progbits
	.hidden	removeFromSpecialObjects
	.globl	removeFromSpecialObjects
	.type	removeFromSpecialObjects,@function
removeFromSpecialObjects:               # @removeFromSpecialObjects
	.param  	i32
# BB#0:                                 # %entry
                                        # fallthrough-return
	.endfunc
.Lfunc_end2:
	.size	removeFromSpecialObjects, .Lfunc_end2-removeFromSpecialObjects

	.section	.text.RenderBox_isTableCell,"ax",@progbits
	.hidden	RenderBox_isTableCell
	.globl	RenderBox_isTableCell
	.type	RenderBox_isTableCell,@function
RenderBox_isTableCell:                  # @RenderBox_isTableCell
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end3:
	.size	RenderBox_isTableCell, .Lfunc_end3-RenderBox_isTableCell

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %RenderBox_setStyle.exit
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


	.ident	"clang version 4.0.0 "
	.functype	exit, void, i32
