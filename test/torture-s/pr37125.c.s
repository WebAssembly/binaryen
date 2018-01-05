	.text
	.file	"pr37125.c"
	.section	.text.func_44,"ax",@progbits
	.hidden	func_44                 # -- Begin function func_44
	.globl	func_44
	.type	func_44,@function
func_44:                                # @func_44
	.param  	i32
# %bb.0:                                # %entry
	i32.const	$push0=, -9
	i32.mul 	$0=, $0, $pop0
	block   	
	i32.const	$push2=, 9
	i32.add 	$push3=, $0, $pop2
	i32.const	$push5=, -9
	i32.lt_u	$push1=, $0, $pop5
	i32.select	$push4=, $0, $pop3, $pop1
	i32.eqz 	$push6=, $pop4
	br_if   	0, $pop6        # 0: down to label0
# %bb.1:                                # %if.end
	return
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	func_44, .Lfunc_end0-func_44
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
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
