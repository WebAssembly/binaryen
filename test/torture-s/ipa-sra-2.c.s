	.text
	.file	"ipa-sra-2.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.param  	i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push2=, 2000
	i32.gt_s	$push3=, $0, $pop2
	i32.const	$push1=, 1
	i32.const	$push0=, 40
	i32.call	$push5=, calloc@FUNCTION, $pop1, $pop0
	tee_local	$push4=, $0=, $pop5
	i32.call	$2=, foo@FUNCTION, $pop3, $pop4
	call    	free@FUNCTION, $0
	copy_local	$push6=, $2
                                        # fallthrough-return: $pop6
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.section	.text.foo,"ax",@progbits
	.type	foo,@function           # -- Begin function foo
foo:                                    # @foo
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 3999996
	i32.add 	$push1=, $1, $pop0
	i32.select	$push2=, $pop1, $1, $0
	i32.load	$push3=, 0($pop2)
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	calloc, i32, i32, i32
	.functype	free, void, i32
