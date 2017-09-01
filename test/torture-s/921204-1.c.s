	.text
	.file	"921204-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32
# BB#0:                                 # %entry
	i32.load	$push8=, 0($1)
	tee_local	$push7=, $1=, $pop8
	i32.const	$push4=, 1310720
	i32.or  	$push5=, $pop7, $pop4
	i32.const	$push2=, -1310721
	i32.and 	$push3=, $1, $pop2
	i32.const	$push0=, 1
	i32.and 	$push1=, $1, $pop0
	i32.select	$push6=, $pop5, $pop3, $pop1
	i32.store	0($0), $pop6
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
