	.text
	.file	"pr45262.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push5=, 1
	i32.const	$push0=, 0
	i32.sub 	$push2=, $pop0, $0
	i32.const	$push3=, 31
	i32.shr_u	$push4=, $pop2, $pop3
	i32.const	$push7=, 0
	i32.lt_s	$push1=, $0, $pop7
	i32.select	$push6=, $pop5, $pop4, $pop1
                                        # fallthrough-return: $pop6
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo
                                        # -- End function
	.section	.text.bar,"ax",@progbits
	.hidden	bar                     # -- Begin function bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push5=, 1
	i32.const	$push0=, 0
	i32.sub 	$push2=, $pop0, $0
	i32.const	$push3=, 31
	i32.shr_u	$push4=, $pop2, $pop3
	i32.const	$push7=, 0
	i32.lt_s	$push1=, $0, $pop7
	i32.select	$push6=, $pop5, $pop4, $pop1
                                        # fallthrough-return: $pop6
	.endfunc
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end20
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
