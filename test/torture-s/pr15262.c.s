	.text
	.file	"pr15262.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar                     # -- Begin function bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 1084647014
	i32.store	0($0), $pop0
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar
                                        # -- End function
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push3=, 0
	i32.load	$3=, __stack_pointer($pop3)
	i32.const	$push0=, 1
	i32.store	4($0), $pop0
	i32.const	$push4=, 16
	i32.sub 	$push11=, $3, $pop4
	tee_local	$push10=, $0=, $pop11
	i32.const	$push5=, 8
	i32.add 	$push6=, $pop10, $pop5
	i32.const	$push7=, 12
	i32.add 	$push8=, $0, $pop7
	i32.select	$push1=, $pop6, $pop8, $1
	i32.const	$push2=, 1084647014
	i32.store	0($pop1), $pop2
	i32.const	$push9=, 1
                                        # fallthrough-return: $pop9
	.endfunc
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo
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
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
