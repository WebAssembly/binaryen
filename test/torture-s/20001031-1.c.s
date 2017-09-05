	.text
	.file	"20001031-1.c"
	.section	.text.t1,"ax",@progbits
	.hidden	t1                      # -- Begin function t1
	.globl	t1
	.type	t1,@function
t1:                                     # @t1
	.param  	i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push0=, 4100
	i32.ne  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %if.end
	return
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	t1, .Lfunc_end0-t1
                                        # -- End function
	.section	.text.t2,"ax",@progbits
	.hidden	t2                      # -- Begin function t2
	.globl	t2
	.type	t2,@function
t2:                                     # @t2
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 4096
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	t2, .Lfunc_end1-t2
                                        # -- End function
	.section	.text.t3,"ax",@progbits
	.hidden	t3                      # -- Begin function t3
	.globl	t3
	.type	t3,@function
t3:                                     # @t3
	.param  	i64
# BB#0:                                 # %entry
	block   	
	i64.const	$push0=, 2147487743
	i64.ne  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label1
# BB#1:                                 # %if.end
	return
.LBB2_2:                                # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	t3, .Lfunc_end2-t3
                                        # -- End function
	.section	.text.t4,"ax",@progbits
	.hidden	t4                      # -- Begin function t4
	.globl	t4
	.type	t4,@function
t4:                                     # @t4
	.result 	i64
# BB#0:                                 # %entry
	i64.const	$push0=, 4096
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end3:
	.size	t4, .Lfunc_end3-t4
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
.Lfunc_end4:
	.size	main, .Lfunc_end4-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
	.functype	exit, void, i32
