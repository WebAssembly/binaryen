	.text
	.file	"vrp-2.c"
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$1=, 1
	block   	
	i32.const	$push4=, 2
	i32.eq  	$push0=, $0, $pop4
	br_if   	0, $pop0        # 0: down to label0
# BB#1:                                 # %if.then
	i32.const	$push1=, 31
	i32.shr_s	$push7=, $0, $pop1
	tee_local	$push6=, $1=, $pop7
	i32.add 	$push2=, $0, $pop6
	i32.xor 	$push3=, $pop2, $1
	i32.const	$push5=, 2
	i32.ne  	$1=, $pop3, $pop5
.LBB0_2:                                # %return
	end_block                       # label0:
	copy_local	$push8=, $1
                                        # fallthrough-return: $pop8
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.param  	i32, i32
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
