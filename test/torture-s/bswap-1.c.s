	.text
	.file	"bswap-1.c"
	.section	.text.g,"ax",@progbits
	.hidden	g                       # -- Begin function g
	.globl	g
	.type	g,@function
g:                                      # @g
	.param  	i64
	.result 	i64
# %bb.0:                                # %entry
	i64.const	$push0=, 56
	i64.shl 	$push24=, $0, $pop0
	i64.const	$push2=, 40
	i64.shl 	$push25=, $0, $pop2
	i64.const	$push26=, 71776119061217280
	i64.and 	$push27=, $pop25, $pop26
	i64.or  	$push28=, $pop24, $pop27
	i64.const	$push7=, 24
	i64.shl 	$push20=, $0, $pop7
	i64.const	$push21=, 280375465082880
	i64.and 	$push22=, $pop20, $pop21
	i64.const	$push11=, 8
	i64.shl 	$push17=, $0, $pop11
	i64.const	$push18=, 1095216660480
	i64.and 	$push19=, $pop17, $pop18
	i64.or  	$push23=, $pop22, $pop19
	i64.or  	$push29=, $pop28, $pop23
	i64.const	$push34=, 8
	i64.shr_u	$push12=, $0, $pop34
	i64.const	$push13=, 4278190080
	i64.and 	$push14=, $pop12, $pop13
	i64.const	$push33=, 24
	i64.shr_u	$push8=, $0, $pop33
	i64.const	$push9=, 16711680
	i64.and 	$push10=, $pop8, $pop9
	i64.or  	$push15=, $pop14, $pop10
	i64.const	$push32=, 40
	i64.shr_u	$push3=, $0, $pop32
	i64.const	$push4=, 65280
	i64.and 	$push5=, $pop3, $pop4
	i64.const	$push31=, 56
	i64.shr_u	$push1=, $0, $pop31
	i64.or  	$push6=, $pop5, $pop1
	i64.or  	$push16=, $pop15, $pop6
	i64.or  	$push30=, $pop29, $pop16
                                        # fallthrough-return: $pop30
	.endfunc
.Lfunc_end0:
	.size	g, .Lfunc_end0-g
                                        # -- End function
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i64
	.result 	i64
# %bb.0:                                # %entry
	i64.const	$push0=, 56
	i64.shl 	$push24=, $0, $pop0
	i64.const	$push2=, 40
	i64.shl 	$push25=, $0, $pop2
	i64.const	$push26=, 71776119061217280
	i64.and 	$push27=, $pop25, $pop26
	i64.or  	$push28=, $pop24, $pop27
	i64.const	$push7=, 24
	i64.shl 	$push20=, $0, $pop7
	i64.const	$push21=, 280375465082880
	i64.and 	$push22=, $pop20, $pop21
	i64.const	$push11=, 8
	i64.shl 	$push17=, $0, $pop11
	i64.const	$push18=, 1095216660480
	i64.and 	$push19=, $pop17, $pop18
	i64.or  	$push23=, $pop22, $pop19
	i64.or  	$push29=, $pop28, $pop23
	i64.const	$push34=, 8
	i64.shr_u	$push12=, $0, $pop34
	i64.const	$push13=, 4278190080
	i64.and 	$push14=, $pop12, $pop13
	i64.const	$push33=, 24
	i64.shr_u	$push8=, $0, $pop33
	i64.const	$push9=, 16711680
	i64.and 	$push10=, $pop8, $pop9
	i64.or  	$push15=, $pop14, $pop10
	i64.const	$push32=, 40
	i64.shr_u	$push3=, $0, $pop32
	i64.const	$push4=, 65280
	i64.and 	$push5=, $pop3, $pop4
	i64.const	$push31=, 56
	i64.shr_u	$push1=, $0, $pop31
	i64.or  	$push6=, $pop5, $pop1
	i64.or  	$push16=, $pop15, $pop6
	i64.or  	$push30=, $pop29, $pop16
                                        # fallthrough-return: $pop30
	.endfunc
.Lfunc_end1:
	.size	f, .Lfunc_end1-f
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
	block   	
	i64.const	$push0=, 18
	i64.call	$push1=, g@FUNCTION, $pop0
	i64.const	$push2=, 1297036692682702848
	i64.ne  	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label0
# %bb.1:                                # %if.end
	i64.const	$push4=, 4660
	i64.call	$push5=, g@FUNCTION, $pop4
	i64.const	$push6=, 3752061439553044480
	i64.ne  	$push7=, $pop5, $pop6
	br_if   	0, $pop7        # 0: down to label0
# %bb.2:                                # %if.end6
	i64.const	$push8=, 1193046
	i64.call	$push9=, g@FUNCTION, $pop8
	i64.const	$push10=, 6211609577260056576
	i64.ne  	$push11=, $pop9, $pop10
	br_if   	0, $pop11       # 0: down to label0
# %bb.3:                                # %if.end11
	i64.const	$push12=, 305419896
	i64.call	$push13=, g@FUNCTION, $pop12
	i64.const	$push14=, 8671175384462524416
	i64.ne  	$push15=, $pop13, $pop14
	br_if   	0, $pop15       # 0: down to label0
# %bb.4:                                # %if.end16
	i64.const	$push16=, 78187493520
	i64.call	$push17=, g@FUNCTION, $pop16
	i64.const	$push18=, -8036578753402372096
	i64.ne  	$push19=, $pop17, $pop18
	br_if   	0, $pop19       # 0: down to label0
# %bb.5:                                # %if.end21
	i64.const	$push20=, 20015998341138
	i64.call	$push21=, g@FUNCTION, $pop20
	i64.const	$push22=, 1337701400965152768
	i64.ne  	$push23=, $pop21, $pop22
	br_if   	0, $pop23       # 0: down to label0
# %bb.6:                                # %if.end26
	i64.const	$push24=, 5124095575331380
	i64.call	$push25=, g@FUNCTION, $pop24
	i64.const	$push26=, 3752220286069772800
	i64.ne  	$push27=, $pop25, $pop26
	br_if   	0, $pop27       # 0: down to label0
# %bb.7:                                # %if.end31
	i64.const	$push28=, 1311768467284833366
	i64.call	$push29=, g@FUNCTION, $pop28
	i64.const	$push30=, 6211610197754262546
	i64.ne  	$push31=, $pop29, $pop30
	br_if   	0, $pop31       # 0: down to label0
# %bb.8:                                # %if.end36
	i32.const	$push32=, 0
	return  	$pop32
.LBB2_9:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
