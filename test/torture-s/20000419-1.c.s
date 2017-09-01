	.text
	.file	"20000419-1.c"
	.section	.text.brother,"ax",@progbits
	.hidden	brother                 # -- Begin function brother
	.globl	brother
	.type	brother,@function
brother:                                # @brother
	.param  	i32, i32, i32
# BB#0:                                 # %entry
	block   	
	br_if   	0, $0           # 0: down to label0
# BB#1:                                 # %if.end
	return
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	brother, .Lfunc_end0-brother
                                        # -- End function
	.section	.text.sister,"ax",@progbits
	.hidden	sister                  # -- Begin function sister
	.globl	sister
	.type	sister,@function
sister:                                 # @sister
	.param  	i32, i32, i32
# BB#0:                                 # %entry
	block   	
	i32.load	$push0=, 4($0)
	i32.eq  	$push1=, $pop0, $1
	br_if   	0, $pop1        # 0: down to label1
# BB#1:                                 # %brother.exit
	return
.LBB1_2:                                # %if.then.i
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	sister, .Lfunc_end1-sister
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %sister.exit
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
