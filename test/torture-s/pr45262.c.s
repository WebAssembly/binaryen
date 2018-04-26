	.text
	.file	"pr45262.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
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
# %bb.0:                                # %entry
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
# %bb.0:                                # %if.end20
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
