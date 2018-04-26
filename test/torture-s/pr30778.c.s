	.text
	.file	"pr30778.c"
	.section	.text.init_reg_last,"ax",@progbits
	.hidden	init_reg_last           # -- Begin function init_reg_last
	.globl	init_reg_last
	.type	init_reg_last,@function
init_reg_last:                          # @init_reg_last
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.load	$0=, reg_stat($pop0)
	i64.const	$push1=, 0
	i64.store	0($0):p2align=0, $pop1
	i32.const	$push2=, 18
	i32.add 	$push3=, $0, $pop2
	i32.const	$push10=, 0
	i32.store8	0($pop3), $pop10
	i32.const	$push4=, 16
	i32.add 	$push5=, $0, $pop4
	i32.const	$push9=, 0
	i32.store16	0($pop5):p2align=0, $pop9
	i32.const	$push6=, 8
	i32.add 	$push7=, $0, $pop6
	i64.const	$push8=, 0
	i64.store	0($pop7):p2align=0, $pop8
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	init_reg_last, .Lfunc_end0-init_reg_last
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push4=, 0
	i32.load	$push3=, __stack_pointer($pop4)
	i32.const	$push5=, 32
	i32.sub 	$0=, $pop3, $pop5
	i32.const	$push6=, 0
	i32.store	__stack_pointer($pop6), $0
	i32.const	$push13=, 0
	i32.const	$push10=, 8
	i32.add 	$push11=, $0, $pop10
	i32.store	reg_stat($pop13), $pop11
	i32.const	$push0=, -1
	i32.store	28($0), $pop0
	call    	init_reg_last@FUNCTION
	block   	
	i32.load	$push1=, 28($0)
	i32.const	$push12=, -1
	i32.ne  	$push2=, $pop1, $pop12
	br_if   	0, $pop2        # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$push9=, 0
	i32.const	$push7=, 32
	i32.add 	$push8=, $0, $pop7
	i32.store	__stack_pointer($pop9), $pop8
	i32.const	$push14=, 0
	return  	$pop14
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.type	reg_stat,@object        # @reg_stat
	.section	.bss.reg_stat,"aw",@nobits
	.p2align	2
reg_stat:
	.int32	0
	.size	reg_stat, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
