	.text
	.file	"pr38422.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push10=, 0
	i32.load	$push9=, s($pop10)
	tee_local	$push8=, $0=, $pop9
	i32.const	$push3=, 1
	i32.shl 	$push4=, $pop8, $pop3
	i32.const	$push5=, 1073741822
	i32.and 	$push6=, $pop4, $pop5
	i32.const	$push1=, -1073741824
	i32.and 	$push2=, $0, $pop1
	i32.or  	$push7=, $pop6, $pop2
	i32.store	s($pop0), $pop7
                                        # fallthrough-return
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
	i32.const	$push7=, 0
	i32.load	$push1=, s($pop7)
	i32.const	$push2=, -1073741824
	i32.and 	$push3=, $pop1, $pop2
	i32.const	$push4=, 48
	i32.or  	$push5=, $pop3, $pop4
	i32.store	s($pop0), $pop5
	i32.const	$push6=, 0
                                        # fallthrough-return: $pop6
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	s                       # @s
	.type	s,@object
	.section	.bss.s,"aw",@nobits
	.globl	s
	.p2align	2
s:
	.skip	4
	.size	s, 4


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
