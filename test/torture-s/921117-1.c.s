	.text
	.file	"921117-1.c"
	.section	.text.check,"ax",@progbits
	.hidden	check                   # -- Begin function check
	.globl	check
	.type	check,@function
check:                                  # @check
	.param  	i32
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$1=, 1
	block   	
	i32.load	$push0=, 12($0)
	i32.const	$push1=, 99
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$push3=, .L.str
	i32.call	$1=, strcmp@FUNCTION, $0, $pop3
.LBB0_2:                                # %return
	end_block                       # label0:
	copy_local	$push4=, $1
                                        # fallthrough-return: $pop4
	.endfunc
.Lfunc_end0:
	.size	check, .Lfunc_end0-check
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %check.exit
	i32.const	$push13=, 0
	i32.const	$push0=, 99
	i32.store	cell+12($pop13), $pop0
	i32.const	$push12=, 0
	i32.const	$push11=, 0
	i64.load	$push1=, .L.str($pop11):p2align=0
	i64.store	cell($pop12):p2align=2, $pop1
	i32.const	$push10=, 0
	i32.const	$push9=, 0
	i32.load16_u	$push2=, .L.str+8($pop9):p2align=0
	i32.store16	cell+8($pop10), $pop2
	i32.const	$push8=, 0
	i32.const	$push7=, 0
	i32.load8_u	$push3=, .L.str+10($pop7)
	i32.store8	cell+10($pop8), $pop3
	block   	
	i32.const	$push5=, cell
	i32.const	$push4=, .L.str
	i32.call	$push6=, strcmp@FUNCTION, $pop5, $pop4
	br_if   	0, $pop6        # 0: down to label1
# %bb.1:                                # %if.end
	i32.const	$push14=, 0
	call    	exit@FUNCTION, $pop14
	unreachable
.LBB1_2:                                # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"0123456789"
	.size	.L.str, 11

	.hidden	cell                    # @cell
	.type	cell,@object
	.section	.bss.cell,"aw",@nobits
	.globl	cell
	.p2align	2
cell:
	.skip	16
	.size	cell, 16


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	strcmp, i32, i32, i32
	.functype	abort, void
	.functype	exit, void, i32
