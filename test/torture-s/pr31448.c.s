	.text
	.file	"pr31448.c"
	.section	.text.g,"ax",@progbits
	.hidden	g                       # -- Begin function g
	.globl	g
	.type	g,@function
g:                                      # @g
# %bb.0:                                # %entry
	unreachable
	unreachable
	.endfunc
.Lfunc_end0:
	.size	g, .Lfunc_end0-g
                                        # -- End function
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.load	$0=, next($pop0)
	i32.load	$push1=, 0($0)
	i32.const	$push2=, -16777216
	i32.and 	$push3=, $pop1, $pop2
	i32.const	$push4=, 16711422
	i32.or  	$push5=, $pop3, $pop4
	i32.store	0($0), $pop5
	i32.const	$push11=, 0
	i32.load	$0=, next($pop11)
	i32.load	$push6=, 4($0)
	i32.const	$push10=, -16777216
	i32.and 	$push7=, $pop6, $pop10
	i32.const	$push9=, 16711422
	i32.or  	$push8=, $pop7, $pop9
	i32.store	4($0), $pop8
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	f, .Lfunc_end1-f
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %if.end6
	i32.const	$push0=, 0
	i32.const	$push2=, 0
	i32.load	$push1=, __stack_pointer($pop2)
	i32.const	$push3=, 16
	i32.sub 	$push6=, $pop1, $pop3
	i32.const	$push4=, 8
	i32.add 	$push5=, $pop6, $pop4
	i32.store	next($pop0), $pop5
	i32.const	$push7=, 0
                                        # fallthrough-return: $pop7
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function
	.hidden	next                    # @next
	.type	next,@object
	.section	.bss.next,"aw",@nobits
	.globl	next
	.p2align	2
next:
	.int32	0
	.size	next, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
