	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20030714-1.c"
	.section	.text.RenderBox_setStyle,"ax",@progbits
	.hidden	RenderBox_setStyle
	.globl	RenderBox_setStyle
	.type	RenderBox_setStyle,@function
RenderBox_setStyle:                     # @RenderBox_setStyle
	.param  	i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.load16_u	$2=, 26($0)
	block
	block
	block
	i32.const	$push1=, 2
	i32.add 	$push2=, $1, $pop1
	i32.load8_u	$push3=, 0($pop2):p2align=1
	i32.const	$push4=, 4
	i32.and 	$push5=, $pop3, $pop4
	br_if   	0, $pop5        # 0: down to label2
# BB#1:                                 # %sw.default
	block
	i32.const	$push34=, 16
	i32.and 	$push10=, $2, $pop34
	i32.const	$push36=, 0
	i32.eq  	$push37=, $pop10, $pop36
	br_if   	0, $pop37       # 0: down to label3
# BB#2:                                 # %if.then
	i32.const	$push11=, 26
	i32.add 	$push12=, $0, $pop11
	i32.const	$push35=, 16
	i32.or  	$push0=, $2, $pop35
	i32.store16	$2=, 0($pop12), $pop0
.LBB0_3:                                # %if.end
	end_block                       # label3:
	i32.const	$push16=, 26
	i32.add 	$push17=, $0, $pop16
	i32.const	$push14=, 65519
	i32.and 	$push15=, $2, $pop14
	i32.store16	$discard=, 0($pop17), $pop15
	i32.load	$2=, 0($1)
	i32.load	$push19=, 28($0)
	i32.call_indirect	$push20=, $pop19, $0
	br_if   	1, $pop20       # 1: down to label1
# BB#4:                                 # %if.end
	i32.const	$push18=, 1572864
	i32.and 	$push13=, $2, $pop18
	i32.const	$push38=, 0
	i32.eq  	$push39=, $pop13, $pop38
	br_if   	1, $pop39       # 1: down to label1
# BB#5:                                 # %if.then39
	i32.const	$push21=, 26
	i32.add 	$0=, $0, $pop21
	i32.load16_u	$push22=, 0($0)
	i32.const	$push23=, 8
	i32.or  	$push24=, $pop22, $pop23
	i32.store16	$discard=, 0($0), $pop24
	br      	2               # 2: down to label0
.LBB0_6:                                # %sw.bb
	end_block                       # label2:
	i32.const	$push8=, 26
	i32.add 	$push9=, $0, $pop8
	i32.const	$push6=, 16
	i32.or  	$push7=, $2, $pop6
	i32.store16	$discard=, 0($pop9), $pop7
	br      	1               # 1: down to label0
.LBB0_7:                                # %if.else
	end_block                       # label1:
	i32.load	$push25=, 0($1)
	i32.const	$push26=, 393216
	i32.and 	$push27=, $pop25, $pop26
	i32.const	$push28=, 131072
	i32.ne  	$push29=, $pop27, $pop28
	br_if   	0, $pop29       # 0: down to label0
# BB#8:                                 # %if.then55
	i32.const	$push30=, 26
	i32.add 	$0=, $0, $pop30
	i32.load16_u	$push31=, 0($0)
	i32.const	$push32=, 64
	i32.or  	$push33=, $pop31, $pop32
	i32.store16	$discard=, 0($0), $pop33
.LBB0_9:                                # %sw.epilog
	end_block                       # label0:
	return
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
	return
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
	return
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
	return  	$pop0
	.endfunc
.Lfunc_end3:
	.size	RenderBox_isTableCell, .Lfunc_end3-RenderBox_isTableCell

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %RenderBox_setStyle.exit
	i32.const	$push0=, 0
	i32.load16_u	$0=, g_this+26($pop0)
	i32.const	$push14=, 0
	i32.load	$1=, g__style($pop14)
	i32.const	$push13=, 0
	i32.const	$push3=, RenderBox_isTableCell@FUNCTION
	i32.store	$discard=, g_this+28($pop13), $pop3
	i32.const	$push12=, 0
	i32.const	$push4=, -1966081
	i32.and 	$push5=, $1, $pop4
	i32.const	$push6=, 393216
	i32.or  	$push7=, $pop5, $pop6
	i32.store	$discard=, g__style($pop12), $pop7
	i32.const	$push11=, 0
	i32.const	$push1=, 65447
	i32.and 	$push2=, $0, $pop1
	i32.const	$push8=, 16
	i32.or  	$push9=, $pop2, $pop8
	i32.store16	$discard=, g_this+26($pop11), $pop9
	i32.const	$push10=, 0
	call    	exit@FUNCTION, $pop10
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


	.ident	"clang version 3.9.0 "
