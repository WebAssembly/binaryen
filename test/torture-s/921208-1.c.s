	.text
	.file	"921208-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	f64
	.result 	f64
# BB#0:                                 # %entry
	f64.mul 	$push0=, $0, $0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f
                                        # -- End function
	.section	.text.Int,"ax",@progbits
	.hidden	Int                     # -- Begin function Int
	.globl	Int
	.type	Int,@function
Int:                                    # @Int
	.param  	i32, f64
	.result 	f64
# BB#0:                                 # %entry
	f64.call_indirect	$push0=, $1, $0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	Int, .Lfunc_end1-Int
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
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	exit, void, i32
