	.text
	.file	"pr37125.c"
	.section	.text.func_44,"ax",@progbits
	.hidden	func_44                 # -- Begin function func_44
	.globl	func_44
	.type	func_44,@function
func_44:                                # @func_44
	.param  	i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push0=, -9
	i32.mul 	$push7=, $0, $pop0
	tee_local	$push6=, $0=, $pop7
	i32.const	$push2=, 9
	i32.add 	$push3=, $0, $pop2
	i32.const	$push5=, -9
	i32.lt_u	$push1=, $0, $pop5
	i32.select	$push4=, $pop6, $pop3, $pop1
	i32.eqz 	$push8=, $pop4
	br_if   	0, $pop8        # 0: down to label0
# BB#1:                                 # %if.end
	return
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	func_44, .Lfunc_end0-func_44
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
