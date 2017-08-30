	.text
	.file	"pr43987.c"
	.section	.text.add_input_file,"ax",@progbits
	.hidden	add_input_file          # -- Begin function add_input_file
	.globl	add_input_file
	.type	add_input_file,@function
add_input_file:                         # @add_input_file
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, B+4($pop0)
	i32.store	0($pop1), $0
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	add_input_file, .Lfunc_end0-add_input_file
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push2=, 0
	i32.load	$push1=, __stack_pointer($pop2)
	i32.const	$push3=, 16
	i32.sub 	$push6=, $pop1, $pop3
	i32.const	$push4=, 12
	i32.add 	$push5=, $pop6, $pop4
	i32.store	B+4($pop0), $pop5
	i32.const	$push7=, 0
                                        # fallthrough-return: $pop7
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	B                       # @B
	.type	B,@object
	.section	.bss.B,"aw",@nobits
	.globl	B
	.p2align	4
B:
	.skip	1024
	.size	B, 1024


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
