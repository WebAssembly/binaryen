	.text
	.file	"pr15262-2.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.load	$push9=, 0($0)
	tee_local	$push8=, $0=, $pop9
	i32.const	$push0=, 3
	i32.store	0($pop8), $pop0
	i32.const	$push1=, 2
	i32.store	0($1), $pop1
	i32.const	$push2=, 0
	f32.load	$push4=, 0($2)
	i32.const	$push7=, 0
	f32.load	$push3=, X($pop7)
	f32.add 	$push5=, $pop4, $pop3
	f32.store	X($pop2), $pop5
	i32.load	$push6=, 0($0)
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
	.local  	f32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	i32.const	$push5=, 0
	f32.load	$push4=, X($pop5)
	tee_local	$push3=, $0=, $pop4
	f32.add 	$push1=, $pop3, $0
	f32.store	X($pop0), $pop1
	i32.const	$push2=, 0
                                        # fallthrough-return: $pop2
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	X                       # @X
	.type	X,@object
	.section	.bss.X,"aw",@nobits
	.globl	X
	.p2align	2
X:
	.int32	0                       # float 0
	.size	X, 4


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
