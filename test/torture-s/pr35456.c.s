	.text
	.file	"pr35456.c"
	.section	.text.not_fabs,"ax",@progbits
	.hidden	not_fabs                # -- Begin function not_fabs
	.globl	not_fabs
	.type	not_fabs,@function
not_fabs:                               # @not_fabs
	.param  	f64
	.result 	f64
# BB#0:                                 # %entry
	f64.neg 	$push2=, $0
	f64.const	$push0=, 0x0p0
	f64.ge  	$push1=, $0, $pop0
	f64.select	$push3=, $0, $pop2, $pop1
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end0:
	.size	not_fabs, .Lfunc_end0-not_fabs
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	block   	
	f64.const	$push0=, -0x0p0
	f64.call	$push1=, not_fabs@FUNCTION, $pop0
	i64.reinterpret/f64	$push2=, $pop1
	i64.const	$push3=, 0
	i64.ge_s	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push5=, 0
	return  	$pop5
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
