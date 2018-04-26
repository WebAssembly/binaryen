	.text
	.file	"pr43236.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push19=, 0
	i32.load	$push18=, __stack_pointer($pop19)
	i32.const	$push20=, 96
	i32.sub 	$0=, $pop18, $pop20
	i32.const	$push21=, 0
	i32.store	__stack_pointer($pop21), $0
	i32.const	$push25=, 64
	i32.add 	$push26=, $0, $pop25
	i32.const	$push0=, 16
	i32.add 	$push1=, $pop26, $pop0
	i64.const	$push2=, 72340172838076673
	i64.store	0($pop1), $pop2
	i32.const	$push27=, 32
	i32.add 	$push28=, $0, $pop27
	i32.const	$push62=, 16
	i32.add 	$push3=, $pop28, $pop62
	i64.const	$push61=, 72340172838076673
	i64.store	0($pop3), $pop61
	i32.const	$push60=, 16
	i32.add 	$push4=, $0, $pop60
	i64.const	$push59=, 72340172838076673
	i64.store	0($pop4), $pop59
	i32.const	$push29=, 64
	i32.add 	$push30=, $0, $pop29
	i32.const	$push5=, 22
	i32.add 	$push6=, $pop30, $pop5
	i64.const	$push58=, 72340172838076673
	i64.store	0($pop6):p2align=1, $pop58
	i32.const	$push31=, 32
	i32.add 	$push32=, $0, $pop31
	i32.const	$push57=, 22
	i32.add 	$push7=, $pop32, $pop57
	i64.const	$push56=, 72340172838076673
	i64.store	0($pop7):p2align=1, $pop56
	i32.const	$push55=, 22
	i32.add 	$push8=, $0, $pop55
	i64.const	$push54=, 72340172838076673
	i64.store	0($pop8):p2align=1, $pop54
	i32.const	$push33=, 64
	i32.add 	$push34=, $0, $pop33
	i32.const	$push9=, 18
	i32.add 	$push10=, $pop34, $pop9
	i32.const	$push11=, 0
	i32.store16	0($pop10), $pop11
	i32.const	$push35=, 32
	i32.add 	$push36=, $0, $pop35
	i32.const	$push53=, 18
	i32.add 	$push12=, $pop36, $pop53
	i32.const	$push52=, 0
	i32.store16	0($pop12), $pop52
	i32.const	$push51=, 18
	i32.add 	$push13=, $0, $pop51
	i32.const	$push50=, 0
	i32.store16	0($pop13), $pop50
	i64.const	$push49=, 72340172838076673
	i64.store	72($0), $pop49
	i64.const	$push48=, 72340172838076673
	i64.store	40($0), $pop48
	i64.const	$push47=, 72340172838076673
	i64.store	8($0), $pop47
	i64.const	$push46=, 72340172838076673
	i64.store	64($0), $pop46
	i64.const	$push45=, 72340172838076673
	i64.store	32($0), $pop45
	i64.const	$push44=, 72340172838076673
	i64.store	0($0), $pop44
	i64.const	$push14=, 0
	i64.store	74($0):p2align=1, $pop14
	i64.const	$push43=, 0
	i64.store	42($0):p2align=1, $pop43
	i64.const	$push42=, 0
	i64.store	10($0):p2align=1, $pop42
	block   	
	i32.const	$push37=, 64
	i32.add 	$push38=, $0, $pop37
	i32.const	$push41=, 30
	i32.call	$push15=, memcmp@FUNCTION, $pop38, $0, $pop41
	br_if   	0, $pop15       # 0: down to label0
# %bb.1:                                # %lor.lhs.false
	i32.const	$push39=, 32
	i32.add 	$push40=, $0, $pop39
	i32.const	$push63=, 30
	i32.call	$push16=, memcmp@FUNCTION, $pop40, $0, $pop63
	br_if   	0, $pop16       # 0: down to label0
# %bb.2:                                # %if.end
	i32.const	$push24=, 0
	i32.const	$push22=, 96
	i32.add 	$push23=, $0, $pop22
	i32.store	__stack_pointer($pop24), $pop23
	i32.const	$push17=, 0
	return  	$pop17
.LBB0_3:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	memcmp, i32, i32, i32, i32
	.functype	abort, void
