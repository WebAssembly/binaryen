	.text
	.file	"20120111-1.c"
	.section	.text.f0a,"ax",@progbits
	.hidden	f0a                     # -- Begin function f0a
	.globl	f0a
	.type	f0a,@function
f0a:                                    # @f0a
	.param  	i64
	.result 	i32
# BB#0:                                 # %entry
	i64.const	$push0=, -3
	i64.gt_u	$push1=, $0, $pop0
	i32.const	$push2=, -1
	i32.xor 	$push3=, $pop1, $pop2
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end0:
	.size	f0a, .Lfunc_end0-f0a
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	block   	
	i64.const	$push0=, -6352373499721454287
	i32.call	$push1=, f0a@FUNCTION, $pop0
	i32.const	$push2=, -1
	i32.ne  	$push3=, $pop1, $pop2
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
