	.text
	.file	"920810-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.call	$push0=, malloc@FUNCTION, $1
	i32.load	$push1=, 8($0)
	i32.call	$push4=, memcpy@FUNCTION, $pop0, $0, $pop1
	tee_local	$push3=, $2=, $pop4
	i32.const	$push2=, 0
	i32.store	4($pop3), $pop2
	i32.store	0($2), $0
	i32.store	8($2), $1
	copy_local	$push5=, $2
                                        # fallthrough-return: $pop5
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
	.functype	malloc, i32, i32
	.functype	exit, void, i32
