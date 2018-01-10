	.text
	.file	"931110-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.const	$push50=, 0
	i32.load16_u	$push1=, x+4($pop50)
	i32.const	$push2=, 65528
	i32.and 	$push3=, $pop1, $pop2
	i32.store16	x+4($pop0), $pop3
	i32.const	$push49=, 0
	i32.const	$push48=, 0
	i32.load16_u	$push4=, x+6($pop48)
	i32.const	$push47=, 65528
	i32.and 	$push5=, $pop4, $pop47
	i32.store16	x+6($pop49), $pop5
	i32.const	$push46=, 0
	i32.const	$push45=, 0
	i32.load16_u	$push6=, x+8($pop45)
	i32.const	$push44=, 65528
	i32.and 	$push7=, $pop6, $pop44
	i32.store16	x+8($pop46), $pop7
	i32.const	$push43=, 0
	i32.const	$push42=, 0
	i32.load16_u	$push8=, x+10($pop42)
	i32.const	$push41=, 65528
	i32.and 	$push9=, $pop8, $pop41
	i32.store16	x+10($pop43), $pop9
	i32.const	$push40=, 0
	i32.const	$push39=, 0
	i32.load16_u	$push10=, x+12($pop39)
	i32.const	$push38=, 65528
	i32.and 	$push11=, $pop10, $pop38
	i32.store16	x+12($pop40), $pop11
	i32.const	$push37=, 0
	i32.const	$push36=, 0
	i32.load16_u	$push12=, x+14($pop36)
	i32.const	$push35=, 65528
	i32.and 	$push13=, $pop12, $pop35
	i32.store16	x+14($pop37), $pop13
	i32.const	$push34=, 0
	i32.const	$push33=, 0
	i32.load16_u	$push14=, x+16($pop33)
	i32.const	$push32=, 65528
	i32.and 	$push15=, $pop14, $pop32
	i32.store16	x+16($pop34), $pop15
	i32.const	$push31=, 0
	i32.const	$push30=, 0
	i32.load16_u	$push16=, x+18($pop30)
	i32.const	$push29=, 65528
	i32.and 	$push17=, $pop16, $pop29
	i32.store16	x+18($pop31), $pop17
	i32.const	$push28=, 0
	i32.const	$push27=, 0
	i32.load16_u	$push18=, x+20($pop27)
	i32.const	$push26=, 65528
	i32.and 	$push19=, $pop18, $pop26
	i32.store16	x+20($pop28), $pop19
	i32.const	$push25=, 0
	i32.const	$push24=, 0
	i32.load16_u	$push20=, x+22($pop24)
	i32.const	$push23=, 65528
	i32.and 	$push21=, $pop20, $pop23
	i32.store16	x+22($pop25), $pop21
	i32.const	$push22=, 0
	call    	exit@FUNCTION, $pop22
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.hidden	x                       # @x
	.type	x,@object
	.section	.bss.x,"aw",@nobits
	.globl	x
	.p2align	2
x:
	.skip	24
	.size	x, 24


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	exit, void, i32
