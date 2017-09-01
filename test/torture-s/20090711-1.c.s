	.text
	.file	"20090711-1.c"
	.section	.text.div,"ax",@progbits
	.hidden	div                     # -- Begin function div
	.globl	div
	.type	div,@function
div:                                    # @div
	.param  	i64
	.result 	i64
# BB#0:                                 # %entry
	i64.const	$push0=, 32768
	i64.div_s	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end0:
	.size	div, .Lfunc_end0-div
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	block   	
	i64.const	$push0=, -990000000
	i64.call	$push1=, div@FUNCTION, $pop0
	i64.const	$push2=, -30212
	i64.ne  	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push4=, 0
	return  	$pop4
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
