	.text
	.file	"990127-2.c"
	.section	.text.fpEq,"ax",@progbits
	.hidden	fpEq                    # -- Begin function fpEq
	.globl	fpEq
	.type	fpEq,@function
fpEq:                                   # @fpEq
	.param  	f64, f64
# BB#0:                                 # %entry
	block   	
	f64.ne  	$push0=, $0, $1
	br_if   	0, $pop0        # 0: down to label0
# BB#1:                                 # %if.end
	return
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	fpEq, .Lfunc_end0-fpEq
                                        # -- End function
	.section	.text.fpTest,"ax",@progbits
	.hidden	fpTest                  # -- Begin function fpTest
	.globl	fpTest
	.type	fpTest,@function
fpTest:                                 # @fpTest
	.param  	f64, f64
# BB#0:                                 # %entry
	block   	
	f64.const	$push0=, 0x1.9p6
	f64.mul 	$push1=, $0, $pop0
	f64.div 	$push2=, $pop1, $1
	f64.const	$push3=, 0x1.3d55555555556p6
	f64.ne  	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label1
# BB#1:                                 # %fpEq.exit
	return
.LBB1_2:                                # %if.then.i
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	fpTest, .Lfunc_end1-fpTest
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
	.functype	exit, void, i32
