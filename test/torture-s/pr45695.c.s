	.text
	.file	"pr45695.c"
	.section	.text.g,"ax",@progbits
	.hidden	g                       # -- Begin function g
	.globl	g
	.type	g,@function
g:                                      # @g
	.param  	i32
# BB#0:                                 # %entry
	#APP
	#NO_APP
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	g, .Lfunc_end0-g
                                        # -- End function
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.add 	$push0=, $2, $1
	call    	g@FUNCTION, $pop0
	i32.const	$push2=, -1
	i32.eq  	$push1=, $2, $0
	i32.select	$push3=, $1, $pop2, $pop1
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end1:
	.size	f, .Lfunc_end1-f
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, 0
	#APP
	#NO_APP
	block   	
	i32.const	$push11=, 1
	i32.add 	$push10=, $2, $pop11
	tee_local	$push9=, $0=, $pop10
	i32.const	$push0=, 4
	i32.add 	$push8=, $2, $pop0
	tee_local	$push7=, $1=, $pop8
	i32.call	$push1=, f@FUNCTION, $2, $pop9, $pop7
	i32.const	$push2=, -1
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label0
# BB#1:                                 # %if.end
	i32.call	$push4=, f@FUNCTION, $1, $0, $1
	i32.const	$push12=, 1
	i32.ne  	$push5=, $pop4, $pop12
	br_if   	0, $pop5        # 0: down to label0
# BB#2:                                 # %if.end9
	i32.const	$push6=, 0
	return  	$pop6
.LBB2_3:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
