	.text
	.file	"pr42614.c"
	.section	.text.init,"ax",@progbits
	.hidden	init                    # -- Begin function init
	.globl	init
	.type	init,@function
init:                                   # @init
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 2
	i32.call	$push1=, malloc@FUNCTION, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end0:
	.size	init, .Lfunc_end0-init
                                        # -- End function
	.section	.text.expect_func,"ax",@progbits
	.hidden	expect_func             # -- Begin function expect_func
	.globl	expect_func
	.type	expect_func,@function
expect_func:                            # @expect_func
	.param  	i32, i32
# %bb.0:                                # %entry
	block   	
	i32.eqz 	$push0=, $0
	br_if   	0, $pop0        # 0: down to label0
# %bb.1:                                # %if.end
	i32.eqz 	$push1=, $1
	br_if   	0, $pop1        # 0: down to label0
# %bb.2:                                # %if.end6
	return
.LBB1_3:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	expect_func, .Lfunc_end1-expect_func
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push3=, 0
	i32.load	$push2=, __stack_pointer($pop3)
	i32.const	$push4=, 16
	i32.sub 	$0=, $pop2, $pop4
	i32.const	$push5=, 0
	i32.store	__stack_pointer($pop5), $0
	i32.const	$push0=, 0
	i32.store8	15($0), $pop0
	i32.const	$push1=, 1
	i32.const	$push9=, 15
	i32.add 	$push10=, $0, $pop9
	call    	expect_func@FUNCTION, $pop1, $pop10
	i32.const	$push8=, 0
	i32.const	$push6=, 16
	i32.add 	$push7=, $0, $pop6
	i32.store	__stack_pointer($pop8), $pop7
	i32.const	$push11=, 0
                                        # fallthrough-return: $pop11
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	malloc, i32, i32
	.functype	abort, void
