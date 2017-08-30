	.text
	.file	"950710-1.c"
	.section	.text.g,"ax",@progbits
	.hidden	g                       # -- Begin function g
	.globl	g
	.type	g,@function
g:                                      # @g
	.param  	i32
# BB#0:                                 # %entry
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	g, .Lfunc_end0-g
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	call    	f@FUNCTION
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.section	.text.f,"ax",@progbits
	.type	f,@function             # -- Begin function f
f:                                      # @f
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push8=, 0
	i32.const	$push6=, 0
	i32.load	$push5=, __stack_pointer($pop6)
	i32.const	$push7=, 32
	i32.sub 	$push19=, $pop5, $pop7
	tee_local	$push18=, $1=, $pop19
	i32.store	__stack_pointer($pop8), $pop18
	block   	
	i32.const	$push12=, 16
	i32.add 	$push13=, $1, $pop12
	i32.sub 	$push17=, $1, $pop13
	tee_local	$push16=, $0=, $pop17
	i32.const	$push0=, 31
	i32.shr_s	$push15=, $0, $pop0
	tee_local	$push14=, $0=, $pop15
	i32.add 	$push1=, $pop16, $pop14
	i32.xor 	$push2=, $pop1, $0
	i32.const	$push3=, 11
	i32.le_u	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push11=, 0
	i32.const	$push9=, 32
	i32.add 	$push10=, $1, $pop9
	i32.store	__stack_pointer($pop11), $pop10
	return
.LBB2_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	f, .Lfunc_end2-f
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	exit, void, i32
	.functype	abort, void
