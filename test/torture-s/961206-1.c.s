	.text
	.file	"961206-1.c"
	.section	.text.sub1,"ax",@progbits
	.hidden	sub1                    # -- Begin function sub1
	.globl	sub1
	.type	sub1,@function
sub1:                                   # @sub1
	.param  	i64
	.result 	i32
# BB#0:                                 # %entry
	i64.const	$push0=, 2147483648
	i64.lt_u	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end0:
	.size	sub1, .Lfunc_end0-sub1
                                        # -- End function
	.section	.text.sub2,"ax",@progbits
	.hidden	sub2                    # -- Begin function sub2
	.globl	sub2
	.type	sub2,@function
sub2:                                   # @sub2
	.param  	i64
	.result 	i32
# BB#0:                                 # %entry
	i64.const	$push0=, 2147483648
	i64.lt_u	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end1:
	.size	sub2, .Lfunc_end1-sub2
                                        # -- End function
	.section	.text.sub3,"ax",@progbits
	.hidden	sub3                    # -- Begin function sub3
	.globl	sub3
	.type	sub3,@function
sub3:                                   # @sub3
	.param  	i64
	.result 	i32
# BB#0:                                 # %entry
	i64.const	$push0=, 2147483648
	i64.lt_u	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end2:
	.size	sub3, .Lfunc_end2-sub3
                                        # -- End function
	.section	.text.sub4,"ax",@progbits
	.hidden	sub4                    # -- Begin function sub4
	.globl	sub4
	.type	sub4,@function
sub4:                                   # @sub4
	.param  	i64
	.result 	i32
# BB#0:                                 # %entry
	i64.const	$push0=, 2147483648
	i64.lt_u	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end3:
	.size	sub4, .Lfunc_end3-sub4
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end12
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end4:
	.size	main, .Lfunc_end4-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	exit, void, i32
