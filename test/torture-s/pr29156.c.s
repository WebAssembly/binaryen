	.text
	.file	"pr29156.c"
	.section	.text.bla,"ax",@progbits
	.hidden	bla                     # -- Begin function bla
	.globl	bla
	.type	bla,@function
bla:                                    # @bla
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 1
	i32.store	4($1), $pop0
	i32.const	$push1=, 0
	i32.const	$push4=, 1
	i32.store	global($pop1), $pop4
	i32.const	$push2=, 8
	i32.store	0($0), $pop2
	i32.load	$push3=, 4($1)
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end0:
	.size	bla, .Lfunc_end0-bla
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push1=, 0
	i32.const	$push0=, 1
	i32.store	global($pop1), $pop0
	i32.const	$push2=, 0
                                        # fallthrough-return: $pop2
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	global                  # @global
	.type	global,@object
	.section	.bss.global,"aw",@nobits
	.globl	global
	.p2align	2
global:
	.int32	0                       # 0x0
	.size	global, 4


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
