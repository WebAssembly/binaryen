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
	i32.const	$push0=, 2
	i32.add 	$push1=, $1, $pop0
	i32.load8_u	$push2=, 0($pop1)
	i32.const	$push3=, 4
	i32.and 	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label1
# BB#1:                                 # %sw.default
	block
	i32.const	$push33=, 16
	i32.and 	$push9=, $2, $pop33
	i32.eqz 	$push41=, $pop9
	br_if   	0, $pop41       # 0: down to label2
# BB#2:                                 # %if.then
	i32.const	$push10=, 26
	i32.add 	$push11=, $0, $pop10
	i32.const	$push36=, 16
	i32.or  	$push35=, $2, $pop36
	tee_local	$push34=, $2=, $pop35
	i32.store16	$drop=, 0($pop11), $pop34
.LBB0_3:                                # %if.end
	end_block                       # label2:
	i32.const	$push15=, 26
	i32.add 	$push16=, $0, $pop15
	i32.const	$push13=, 65519
	i32.and 	$push14=, $2, $pop13
	i32.store16	$drop=, 0($pop16), $pop14
	i32.load	$2=, 0($1)
	i32.load	$push18=, 28($0)
	i32.call_indirect	$push19=, $pop18, $0
	br_if   	1, $pop19       # 1: down to label0
# BB#4:                                 # %if.end
	i32.const	$push17=, 1572864
	i32.and 	$push12=, $2, $pop17
	i32.eqz 	$push42=, $pop12
	br_if   	1, $pop42       # 1: down to label0
# BB#5:                                 # %if.then39
	i32.const	$push20=, 26
	i32.add 	$push38=, $0, $pop20
	tee_local	$push37=, $0=, $pop38
	i32.load16_u	$push21=, 0($0)
	i32.const	$push22=, 8
	i32.or  	$push23=, $pop21, $pop22
	i32.store16	$drop=, 0($pop37), $pop23
	return
.LBB0_6:                                # %sw.bb
	end_block                       # label1:
	i32.const	$push7=, 26
	i32.add 	$push8=, $0, $pop7
	i32.const	$push5=, 16
	i32.or  	$push6=, $2, $pop5
	i32.store16	$drop=, 0($pop8), $pop6
	return
.LBB0_7:                                # %if.else
	end_block                       # label0:
	block
	i32.load	$push24=, 0($1)
	i32.const	$push25=, 393216
	i32.and 	$push26=, $pop24, $pop25
	i32.const	$push27=, 131072
	i32.ne  	$push28=, $pop26, $pop27
	br_if   	0, $pop28       # 0: down to label3
# BB#8:                                 # %if.then55
	i32.const	$push29=, 26
	i32.add 	$push40=, $0, $pop29
	tee_local	$push39=, $0=, $pop40
	i32.load16_u	$push30=, 0($0)
	i32.const	$push31=, 64
	i32.or  	$push32=, $pop30, $pop31
	i32.store16	$drop=, 0($pop39), $pop32
.LBB0_9:                                # %sw.epilog
	end_block                       # label3:
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
	i32.store	$drop=, g_this+28($pop1), $pop0
	i32.const	$push16=, 0
	i32.const	$push15=, 0
	i32.load	$push2=, g__style($pop15)
	i32.const	$push3=, -1966081
	i32.and 	$push4=, $pop2, $pop3
	i32.const	$push5=, 393216
	i32.or  	$push6=, $pop4, $pop5
	i32.store	$drop=, g__style($pop16), $pop6
	i32.const	$push14=, 0
	i32.const	$push13=, 0
	i32.load16_u	$push7=, g_this+26($pop13)
	i32.const	$push8=, 65447
	i32.and 	$push9=, $pop7, $pop8
	i32.const	$push10=, 16
	i32.or  	$push11=, $pop9, $pop10
	i32.store16	$drop=, g_this+26($pop14), $pop11
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


	.ident	"clang version 3.9.0 "
	.functype	exit, void, i32
