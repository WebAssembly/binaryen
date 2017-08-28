	.text
	.file	"anon-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push1=, 0
	i64.const	$push0=, 25769803781
	i64.store	foo+4($pop1):p2align=2, $pop0
	i32.const	$push2=, 0
                                        # fallthrough-return: $pop2
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.hidden	foo                     # @foo
	.type	foo,@object
	.section	.bss.foo,"aw",@nobits
	.globl	foo
	.p2align	2
foo:
	.skip	12
	.size	foo, 12


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
