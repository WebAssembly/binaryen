	.text
	.file	"960317-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push8=, 0
	i32.const	$push7=, -1
	i32.shl 	$push6=, $pop7, $0
	tee_local	$push5=, $0=, $pop6
	i32.sub 	$push0=, $pop8, $pop5
	i32.and 	$push1=, $pop0, $1
	i32.eqz 	$push12=, $pop1
	br_if   	0, $pop12       # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push10=, -1
	i32.xor 	$push2=, $0, $pop10
	i32.and 	$push3=, $pop2, $1
	i32.const	$push9=, 0
	i32.ne  	$push4=, $pop3, $pop9
	return  	$pop4
.LBB0_2:                                # %cleanup
	end_block                       # label0:
	i32.const	$push11=, 0
                                        # fallthrough-return: $pop11
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
