	.text
	.file	"20080117-1.c"
	.section	.text.gstate_path_memory,"ax",@progbits
	.hidden	gstate_path_memory      # -- Begin function gstate_path_memory
	.globl	gstate_path_memory
	.type	gstate_path_memory,@function
gstate_path_memory:                     # @gstate_path_memory
	.param  	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 8
	i32.add 	$push1=, $0, $pop0
	i32.const	$push2=, 0
	i32.load	$push3=, gstate_initial+8($pop2)
	i32.store	0($pop1), $pop3
	i32.const	$push5=, 0
	i64.load	$push4=, gstate_initial($pop5):p2align=2
	i64.store	0($0):p2align=2, $pop4
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	gstate_path_memory, .Lfunc_end0-gstate_path_memory
                                        # -- End function
	.section	.text.gs_state_update_overprint,"ax",@progbits
	.hidden	gs_state_update_overprint # -- Begin function gs_state_update_overprint
	.globl	gs_state_update_overprint
	.type	gs_state_update_overprint,@function
gs_state_update_overprint:              # @gs_state_update_overprint
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	gs_state_update_overprint, .Lfunc_end1-gs_state_update_overprint
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function
	.type	gstate_initial,@object  # @gstate_initial
	.section	.rodata.gstate_initial,"a",@progbits
	.p2align	2
gstate_initial:
	.int32	1                       # 0x1
	.int32	0                       # 0x0
	.int32	0                       # float 0
	.size	gstate_initial, 12


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
