	.text
	.file	"990117-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32, i32
	.result 	i32
# BB#0:                                 # %entry
	f64.convert_s/i32	$push4=, $0
	f64.convert_s/i32	$push3=, $1
	f64.div 	$push5=, $pop4, $pop3
	f64.convert_s/i32	$push1=, $2
	f64.convert_s/i32	$push0=, $3
	f64.div 	$push2=, $pop1, $pop0
	f64.lt  	$push6=, $pop5, $pop2
                                        # fallthrough-return: $pop6
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
