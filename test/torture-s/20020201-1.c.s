	.text
	.file	"20020201-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i64
# BB#0:                                 # %entry
	block   	
	i32.const	$push0=, 0
	i32.load8_u	$push38=, cx($pop0)
	tee_local	$push37=, $0=, $pop38
	i32.const	$push1=, -6
	i32.add 	$push2=, $pop37, $pop1
	i32.const	$push36=, 6
	i32.ge_u	$push3=, $pop2, $pop36
	br_if   	0, $pop3        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push39=, 6
	i32.rem_u	$push4=, $0, $pop39
	i32.const	$push5=, 1
	i32.ne  	$push6=, $pop4, $pop5
	br_if   	0, $pop6        # 0: down to label0
# BB#2:                                 # %if.end10
	i32.const	$push7=, 0
	i32.load16_u	$push42=, sx($pop7)
	tee_local	$push41=, $0=, $pop42
	i32.const	$push8=, -12
	i32.add 	$push9=, $pop41, $pop8
	i32.const	$push40=, 6
	i32.ge_u	$push10=, $pop9, $pop40
	br_if   	0, $pop10       # 0: down to label0
# BB#3:                                 # %if.end18
	i32.const	$push43=, 6
	i32.rem_u	$push11=, $0, $pop43
	i32.const	$push12=, 2
	i32.ne  	$push13=, $pop11, $pop12
	br_if   	0, $pop13       # 0: down to label0
# BB#4:                                 # %if.end26
	i32.const	$push14=, 0
	i32.load	$push46=, ix($pop14)
	tee_local	$push45=, $0=, $pop46
	i32.const	$push15=, -18
	i32.add 	$push16=, $pop45, $pop15
	i32.const	$push44=, 6
	i32.ge_u	$push17=, $pop16, $pop44
	br_if   	0, $pop17       # 0: down to label0
# BB#5:                                 # %if.end31
	i32.const	$push47=, 6
	i32.rem_u	$push18=, $0, $pop47
	i32.const	$push19=, 3
	i32.ne  	$push20=, $pop18, $pop19
	br_if   	0, $pop20       # 0: down to label0
# BB#6:                                 # %if.end36
	i32.const	$push21=, 0
	i32.load	$push50=, lx($pop21)
	tee_local	$push49=, $0=, $pop50
	i32.const	$push22=, -24
	i32.add 	$push23=, $pop49, $pop22
	i32.const	$push48=, 6
	i32.ge_u	$push24=, $pop23, $pop48
	br_if   	0, $pop24       # 0: down to label0
# BB#7:                                 # %if.end41
	i32.const	$push51=, 6
	i32.rem_u	$push25=, $0, $pop51
	i32.const	$push26=, 4
	i32.ne  	$push27=, $pop25, $pop26
	br_if   	0, $pop27       # 0: down to label0
# BB#8:                                 # %if.end46
	i32.const	$push28=, 0
	i64.load	$push54=, Lx($pop28)
	tee_local	$push53=, $1=, $pop54
	i64.const	$push29=, -30
	i64.add 	$push30=, $pop53, $pop29
	i64.const	$push52=, 6
	i64.ge_u	$push31=, $pop30, $pop52
	br_if   	0, $pop31       # 0: down to label0
# BB#9:                                 # %if.end51
	i64.const	$push55=, 6
	i64.rem_u	$push32=, $1, $pop55
	i64.const	$push33=, 5
	i64.ne  	$push34=, $pop32, $pop33
	br_if   	0, $pop34       # 0: down to label0
# BB#10:                                # %if.end56
	i32.const	$push35=, 0
	call    	exit@FUNCTION, $pop35
	unreachable
.LBB0_11:                               # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.hidden	cx                      # @cx
	.type	cx,@object
	.section	.data.cx,"aw",@progbits
	.globl	cx
cx:
	.int8	7                       # 0x7
	.size	cx, 1

	.hidden	sx                      # @sx
	.type	sx,@object
	.section	.data.sx,"aw",@progbits
	.globl	sx
	.p2align	1
sx:
	.int16	14                      # 0xe
	.size	sx, 2

	.hidden	ix                      # @ix
	.type	ix,@object
	.section	.data.ix,"aw",@progbits
	.globl	ix
	.p2align	2
ix:
	.int32	21                      # 0x15
	.size	ix, 4

	.hidden	lx                      # @lx
	.type	lx,@object
	.section	.data.lx,"aw",@progbits
	.globl	lx
	.p2align	2
lx:
	.int32	28                      # 0x1c
	.size	lx, 4

	.hidden	Lx                      # @Lx
	.type	Lx,@object
	.section	.data.Lx,"aw",@progbits
	.globl	Lx
	.p2align	3
Lx:
	.int64	35                      # 0x23
	.size	Lx, 8


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
	.functype	exit, void, i32
