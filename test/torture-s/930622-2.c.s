	.text
	.file	"930622-2.c"
	.section	.text.ll_to_ld,"ax",@progbits
	.hidden	ll_to_ld                # -- Begin function ll_to_ld
	.globl	ll_to_ld
	.type	ll_to_ld,@function
ll_to_ld:                               # @ll_to_ld
	.param  	i32, i64
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push8=, 0
	i32.const	$push6=, 0
	i32.load	$push5=, __stack_pointer($pop6)
	i32.const	$push7=, 16
	i32.sub 	$push14=, $pop5, $pop7
	tee_local	$push13=, $2=, $pop14
	i32.store	__stack_pointer($pop8), $pop13
	call    	__floatditf@FUNCTION, $2, $1
	i32.const	$push0=, 8
	i32.add 	$push1=, $0, $pop0
	i32.const	$push12=, 8
	i32.add 	$push2=, $2, $pop12
	i64.load	$push3=, 0($pop2)
	i64.store	0($pop1), $pop3
	i64.load	$push4=, 0($2)
	i64.store	0($0), $pop4
	i32.const	$push11=, 0
	i32.const	$push9=, 16
	i32.add 	$push10=, $2, $pop9
	i32.store	__stack_pointer($pop11), $pop10
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
# BB#0:                                 # %entry
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
# BB#0:                                 # %if.end4
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	exit, void, i32
