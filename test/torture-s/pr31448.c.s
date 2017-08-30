	.text
	.file	"pr31448.c"
	.section	.text.g,"ax",@progbits
	.hidden	g                       # -- Begin function g
	.globl	g
	.type	g,@function
g:                                      # @g
# BB#0:                                 # %entry
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
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push15=, next($pop0)
	tee_local	$push14=, $0=, $pop15
	i32.load	$push1=, 0($0)
	i32.const	$push2=, -16777216
	i32.and 	$push3=, $pop1, $pop2
	i32.const	$push4=, 16711422
	i32.or  	$push5=, $pop3, $pop4
	i32.store	0($pop14), $pop5
	i32.const	$push13=, 0
	i32.load	$push12=, next($pop13)
	tee_local	$push11=, $0=, $pop12
	i32.load	$push6=, 4($0)
	i32.const	$push10=, -16777216
	i32.and 	$push7=, $pop6, $pop10
	i32.const	$push9=, 16711422
	i32.or  	$push8=, $pop7, $pop9
	i32.store	4($pop11), $pop8
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
# BB#0:                                 # %if.end6
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


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
