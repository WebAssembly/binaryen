	.text
	.file	"pr39228.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	block   	
	f64.const	$push0=, infinity
	i32.call	$push1=, __builtin_isinff@FUNCTION, $pop0
	i32.const	$push8=, 0
	i32.le_s	$push2=, $pop1, $pop8
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %if.end4
	i64.const	$push4=, 0
	i64.const	$push3=, 9223090561878065152
	i32.call	$push5=, __builtin_isinfl@FUNCTION, $pop4, $pop3
	i32.const	$push9=, 0
	i32.le_s	$push6=, $pop5, $pop9
	br_if   	0, $pop6        # 0: down to label0
# BB#2:                                 # %if.end8
	i32.const	$push7=, 0
	return  	$pop7
.LBB0_3:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
	.functype	__builtin_isinff, i32
	.functype	__builtin_isinfl, i32
