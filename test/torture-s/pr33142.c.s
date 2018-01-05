	.text
	.file	"pr33142.c"
	.section	.text.lisp_atan2,"ax",@progbits
	.hidden	lisp_atan2              # -- Begin function lisp_atan2
	.globl	lisp_atan2
	.type	lisp_atan2,@function
lisp_atan2:                             # @lisp_atan2
	.param  	i32, i32
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$2=, 0
	block   	
	i32.const	$push0=, 1
	i32.lt_s	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label0
# %bb.1:                                # %entry
	i32.const	$push2=, 0
	i32.gt_s	$push3=, $1, $pop2
	br_if   	0, $pop3        # 0: down to label0
# %bb.2:                                # %if.then2
	i32.const	$push4=, 31
	i32.shr_s	$2=, $1, $pop4
	i32.add 	$push5=, $1, $2
	i32.xor 	$push6=, $pop5, $2
	i32.le_s	$2=, $pop6, $0
.LBB0_3:                                # %return
	end_block                       # label0:
	copy_local	$push7=, $2
                                        # fallthrough-return: $pop7
	.endfunc
.Lfunc_end0:
	.size	lisp_atan2, .Lfunc_end0-lisp_atan2
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push7=, 0
	i32.load	$push6=, __stack_pointer($pop7)
	i32.const	$push8=, 16
	i32.sub 	$0=, $pop6, $pop8
	i32.const	$push9=, 0
	i32.store	__stack_pointer($pop9), $0
	i32.const	$push0=, 63
	i32.store	12($0), $pop0
	i32.const	$push1=, -77
	i32.store	8($0), $pop1
	block   	
	i32.load	$push2=, 12($0)
	i32.load	$push3=, 8($0)
	i32.call	$push4=, lisp_atan2@FUNCTION, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label1
# %bb.1:                                # %if.end
	i32.const	$push12=, 0
	i32.const	$push10=, 16
	i32.add 	$push11=, $0, $pop10
	i32.store	__stack_pointer($pop12), $pop11
	i32.const	$push5=, 0
	return  	$pop5
.LBB1_2:                                # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
