	.text
	.file	"20100708-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 8
	i32.add 	$push1=, $0, $pop0
	i32.const	$push3=, 0
	i32.const	$push2=, 192
	i32.call	$drop=, memset@FUNCTION, $pop1, $pop3, $pop2
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push4=, 0
	i32.const	$push2=, 0
	i32.load	$push1=, __stack_pointer($pop2)
	i32.const	$push3=, 208
	i32.sub 	$push11=, $pop1, $pop3
	tee_local	$push10=, $0=, $pop11
	i32.store	__stack_pointer($pop4), $pop10
	i32.const	$push8=, 8
	i32.add 	$push9=, $0, $pop8
	call    	f@FUNCTION, $pop9
	i32.const	$push7=, 0
	i32.const	$push5=, 208
	i32.add 	$push6=, $0, $pop5
	i32.store	__stack_pointer($pop7), $pop6
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
