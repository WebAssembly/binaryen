	.text
	.file	"strct-pack-3.c"
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push3=, 6
	i32.add 	$push4=, $0, $pop3
	i32.load	$push14=, 0($pop4):p2align=1
	tee_local	$push13=, $1=, $pop14
	i32.const	$push1=, 16
	i32.shl 	$push8=, $pop13, $pop1
	i32.load	$push0=, 2($0):p2align=1
	i32.const	$push12=, 16
	i32.shl 	$push2=, $pop0, $pop12
	i32.const	$push5=, 17
	i32.shl 	$push6=, $1, $pop5
	i32.add 	$push7=, $pop2, $pop6
	i32.add 	$push9=, $pop8, $pop7
	i32.const	$push11=, 16
	i32.shr_s	$push10=, $pop9, $pop11
                                        # fallthrough-return: $pop10
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
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	exit, void, i32
