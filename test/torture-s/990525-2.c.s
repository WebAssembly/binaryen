	.text
	.file	"990525-2.c"
	.section	.text.func1,"ax",@progbits
	.hidden	func1                   # -- Begin function func1
	.globl	func1
	.type	func1,@function
func1:                                  # @func1
	.result 	i32
	.local  	i32
# BB#0:                                 # %if.end15
	copy_local	$push0=, $0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end0:
	.size	func1, .Lfunc_end0-func1
                                        # -- End function
	.section	.text.func2,"ax",@progbits
	.hidden	func2                   # -- Begin function func2
	.globl	func2
	.type	func2,@function
func2:                                  # @func2
	.param  	i32
# BB#0:                                 # %entry
	i64.const	$push0=, 85899345930
	i64.store	0($0):p2align=2, $pop0
	i64.const	$push1=, 171798691870
	i64.store	8($0):p2align=2, $pop1
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	func2, .Lfunc_end1-func2
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	exit, void, i32
