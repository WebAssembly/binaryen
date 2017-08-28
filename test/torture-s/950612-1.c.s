	.text
	.file	"950612-1.c"
	.section	.text.f1,"ax",@progbits
	.hidden	f1                      # -- Begin function f1
	.globl	f1
	.type	f1,@function
f1:                                     # @f1
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 31
	i32.shr_s	$push4=, $0, $pop0
	tee_local	$push3=, $1=, $pop4
	i32.add 	$push1=, $0, $pop3
	i32.xor 	$push2=, $pop1, $1
                                        # fallthrough-return: $pop2
	.endfunc
.Lfunc_end0:
	.size	f1, .Lfunc_end0-f1
                                        # -- End function
	.section	.text.f2,"ax",@progbits
	.hidden	f2                      # -- Begin function f2
	.globl	f2
	.type	f2,@function
f2:                                     # @f2
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 31
	i32.shr_s	$push4=, $0, $pop0
	tee_local	$push3=, $1=, $pop4
	i32.add 	$push1=, $0, $pop3
	i32.xor 	$push2=, $pop1, $1
                                        # fallthrough-return: $pop2
	.endfunc
.Lfunc_end1:
	.size	f2, .Lfunc_end1-f2
                                        # -- End function
	.section	.text.f3,"ax",@progbits
	.hidden	f3                      # -- Begin function f3
	.globl	f3
	.type	f3,@function
f3:                                     # @f3
	.param  	i64
	.result 	i64
	.local  	i64
# BB#0:                                 # %entry
	i64.const	$push0=, 63
	i64.shr_s	$push4=, $0, $pop0
	tee_local	$push3=, $1=, $pop4
	i64.add 	$push1=, $0, $pop3
	i64.xor 	$push2=, $pop1, $1
                                        # fallthrough-return: $pop2
	.endfunc
.Lfunc_end2:
	.size	f3, .Lfunc_end2-f3
                                        # -- End function
	.section	.text.f4,"ax",@progbits
	.hidden	f4                      # -- Begin function f4
	.globl	f4
	.type	f4,@function
f4:                                     # @f4
	.param  	i64
	.result 	i64
	.local  	i64
# BB#0:                                 # %entry
	i64.const	$push0=, 63
	i64.shr_s	$push4=, $0, $pop0
	tee_local	$push3=, $1=, $pop4
	i64.add 	$push1=, $0, $pop3
	i64.xor 	$push2=, $pop1, $1
                                        # fallthrough-return: $pop2
	.endfunc
.Lfunc_end3:
	.size	f4, .Lfunc_end3-f4
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
	.functype	exit, void, i32
