	.text
	.file	"20020201-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i64
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.load8_u	$0=, cx($pop0)
	block   	
	i32.const	$push1=, -6
	i32.add 	$push2=, $0, $pop1
	i32.const	$push36=, 6
	i32.ge_u	$push3=, $pop2, $pop36
	br_if   	0, $pop3        # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$push37=, 6
	i32.rem_u	$push4=, $0, $pop37
	i32.const	$push5=, 1
	i32.ne  	$push6=, $pop4, $pop5
	br_if   	0, $pop6        # 0: down to label0
# %bb.2:                                # %if.end10
	i32.const	$push7=, 0
	i32.load16_u	$0=, sx($pop7)
	i32.const	$push8=, -12
	i32.add 	$push9=, $0, $pop8
	i32.const	$push38=, 6
	i32.ge_u	$push10=, $pop9, $pop38
	br_if   	0, $pop10       # 0: down to label0
# %bb.3:                                # %if.end18
	i32.const	$push39=, 6
	i32.rem_u	$push11=, $0, $pop39
	i32.const	$push12=, 2
	i32.ne  	$push13=, $pop11, $pop12
	br_if   	0, $pop13       # 0: down to label0
# %bb.4:                                # %if.end26
	i32.const	$push14=, 0
	i32.load	$0=, ix($pop14)
	i32.const	$push15=, -18
	i32.add 	$push16=, $0, $pop15
	i32.const	$push40=, 6
	i32.ge_u	$push17=, $pop16, $pop40
	br_if   	0, $pop17       # 0: down to label0
# %bb.5:                                # %if.end31
	i32.const	$push41=, 6
	i32.rem_u	$push18=, $0, $pop41
	i32.const	$push19=, 3
	i32.ne  	$push20=, $pop18, $pop19
	br_if   	0, $pop20       # 0: down to label0
# %bb.6:                                # %if.end36
	i32.const	$push21=, 0
	i32.load	$0=, lx($pop21)
	i32.const	$push22=, -24
	i32.add 	$push23=, $0, $pop22
	i32.const	$push42=, 6
	i32.ge_u	$push24=, $pop23, $pop42
	br_if   	0, $pop24       # 0: down to label0
# %bb.7:                                # %if.end41
	i32.const	$push43=, 6
	i32.rem_u	$push25=, $0, $pop43
	i32.const	$push26=, 4
	i32.ne  	$push27=, $pop25, $pop26
	br_if   	0, $pop27       # 0: down to label0
# %bb.8:                                # %if.end46
	i32.const	$push28=, 0
	i64.load	$1=, Lx($pop28)
	i64.const	$push29=, -30
	i64.add 	$push30=, $1, $pop29
	i64.const	$push44=, 6
	i64.ge_u	$push31=, $pop30, $pop44
	br_if   	0, $pop31       # 0: down to label0
# %bb.9:                                # %if.end51
	i64.const	$push45=, 6
	i64.rem_u	$push32=, $1, $pop45
	i64.const	$push33=, 5
	i64.ne  	$push34=, $pop32, $pop33
	br_if   	0, $pop34       # 0: down to label0
# %bb.10:                               # %if.end56
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


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
