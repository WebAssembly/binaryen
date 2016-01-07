	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20030714-1.c"
	.globl	RenderBox_setStyle
	.type	RenderBox_setStyle,@function
RenderBox_setStyle:                     # @RenderBox_setStyle
	.param  	i32, i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.load16_u	$3=, 26($0)
	block   	.LBB0_9
	block   	.LBB0_8
	i32.const	$push1=, 2
	i32.add 	$push2=, $1, $pop1
	i32.load8_u	$push3=, 0($pop2)
	i32.const	$push4=, 4
	i32.and 	$push5=, $pop3, $pop4
	br_if   	$pop5, .LBB0_8
# BB#1:                                 # %sw.default
	i32.const	$2=, 16
	block   	.LBB0_3
	i32.and 	$push10=, $3, $2
	i32.const	$push31=, 0
	i32.eq  	$push32=, $pop10, $pop31
	br_if   	$pop32, .LBB0_3
# BB#2:                                 # %if.then
	i32.const	$push11=, 26
	i32.add 	$push12=, $0, $pop11
	i32.or  	$push0=, $3, $2
	i32.store16	$3=, 0($pop12), $pop0
.LBB0_3:                                  # %if.end
	i32.const	$push16=, 26
	i32.add 	$2=, $0, $pop16
	i32.const	$push14=, 65519
	i32.and 	$push15=, $3, $pop14
	i32.store16	$discard=, 0($2), $pop15
	i32.load	$3=, 0($1)
	block   	.LBB0_6
	i32.load	$push18=, 28($0)
	i32.call_indirect	$push19=, $pop18, $0
	br_if   	$pop19, .LBB0_6
# BB#4:                                 # %if.end
	i32.const	$push17=, 1572864
	i32.and 	$push13=, $3, $pop17
	i32.const	$push33=, 0
	i32.eq  	$push34=, $pop13, $pop33
	br_if   	$pop34, .LBB0_6
# BB#5:                                 # %if.then39
	i32.load16_u	$push20=, 0($2)
	i32.const	$push21=, 8
	i32.or  	$push22=, $pop20, $pop21
	i32.store16	$discard=, 0($2), $pop22
	br      	.LBB0_9
.LBB0_6:                                  # %if.else
	i32.load	$push23=, 0($1)
	i32.const	$push24=, 393216
	i32.and 	$push25=, $pop23, $pop24
	i32.const	$push26=, 131072
	i32.ne  	$push27=, $pop25, $pop26
	br_if   	$pop27, .LBB0_9
# BB#7:                                 # %if.then55
	i32.load16_u	$push28=, 0($2)
	i32.const	$push29=, 64
	i32.or  	$push30=, $pop28, $pop29
	i32.store16	$discard=, 0($2), $pop30
	br      	.LBB0_9
.LBB0_8:                                  # %sw.bb
	i32.const	$push8=, 26
	i32.add 	$push9=, $0, $pop8
	i32.const	$push6=, 16
	i32.or  	$push7=, $3, $pop6
	i32.store16	$discard=, 0($pop9), $pop7
.LBB0_9:                                  # %sw.epilog
	return
.Lfunc_end0:
	.size	RenderBox_setStyle, .Lfunc_end0-RenderBox_setStyle

	.globl	RenderObject_setStyle
	.type	RenderObject_setStyle,@function
RenderObject_setStyle:                  # @RenderObject_setStyle
	.param  	i32, i32
# BB#0:                                 # %entry
	return
.Lfunc_end1:
	.size	RenderObject_setStyle, .Lfunc_end1-RenderObject_setStyle

	.globl	removeFromSpecialObjects
	.type	removeFromSpecialObjects,@function
removeFromSpecialObjects:               # @removeFromSpecialObjects
	.param  	i32
# BB#0:                                 # %entry
	return
.Lfunc_end2:
	.size	removeFromSpecialObjects, .Lfunc_end2-removeFromSpecialObjects

	.globl	RenderBox_isTableCell
	.type	RenderBox_isTableCell,@function
RenderBox_isTableCell:                  # @RenderBox_isTableCell
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	return  	$pop0
.Lfunc_end3:
	.size	RenderBox_isTableCell, .Lfunc_end3-RenderBox_isTableCell

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %RenderBox_setStyle.exit
	i32.const	$0=, 0
	i32.load16_u	$1=, g_this+26($0)
	i32.load	$2=, g__style($0)
	i32.const	$push2=, RenderBox_isTableCell
	i32.store	$discard=, g_this+28($0), $pop2
	i32.const	$push3=, -1966081
	i32.and 	$push4=, $2, $pop3
	i32.const	$push5=, 393216
	i32.or  	$push6=, $pop4, $pop5
	i32.store	$discard=, g__style($0), $pop6
	i32.const	$push0=, 65447
	i32.and 	$push1=, $1, $pop0
	i32.const	$push7=, 16
	i32.or  	$push8=, $pop1, $pop7
	i32.store16	$discard=, g_this+26($0), $pop8
	call    	exit, $0
	unreachable
.Lfunc_end4:
	.size	main, .Lfunc_end4-main

	.type	false,@object           # @false
	.section	.rodata,"a",@progbits
	.globl	false
false:
	.int8	0                       # 0x0
	.size	false, 1

	.type	true,@object            # @true
	.globl	true
true:
	.int8	1                       # 0x1
	.size	true, 1

	.type	g_this,@object          # @g_this
	.bss
	.globl	g_this
	.align	2
g_this:
	.zero	32
	.size	g_this, 32

	.type	g__style,@object        # @g__style
	.globl	g__style
	.align	2
g__style:
	.zero	4
	.size	g__style, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
