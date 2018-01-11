	.text
	.file	"930622-2.c"
	.section	.text.ll_to_ld,"ax",@progbits
	.hidden	ll_to_ld                # -- Begin function ll_to_ld
	.globl	ll_to_ld
	.type	ll_to_ld,@function
ll_to_ld:                               # @ll_to_ld
	.param  	i32, i64
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push5=, 0
	i32.load	$push4=, __stack_pointer($pop5)
	i32.const	$push6=, 16
	i32.sub 	$2=, $pop4, $pop6
	i32.const	$push7=, 0
	i32.store	__stack_pointer($pop7), $2
	call    	__floatditf@FUNCTION, $2, $1
	i32.const	$push0=, 8
	i32.add 	$push1=, $2, $pop0
	i64.load	$push2=, 0($pop1)
	i64.store	8($0), $pop2
	i64.load	$push3=, 0($2)
	i64.store	0($0), $pop3
	i32.const	$push10=, 0
	i32.const	$push8=, 16
	i32.add 	$push9=, $2, $pop8
	i32.store	__stack_pointer($pop10), $pop9
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	ll_to_ld, .Lfunc_end0-ll_to_ld
                                        # -- End function
	.section	.text.ld_to_ll,"ax",@progbits
	.hidden	ld_to_ll                # -- Begin function ld_to_ll
	.globl	ld_to_ll
	.type	ld_to_ll,@function
ld_to_ll:                               # @ld_to_ll
	.param  	i64, i64
	.result 	i64
# %bb.0:                                # %entry
	i64.call	$push0=, __fixtfdi@FUNCTION, $0, $1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	ld_to_ll, .Lfunc_end1-ld_to_ll
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %if.end4
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	exit, void, i32
