	.text
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	one                     # @one
	.type	one,@object
	.section	.rodata.one,"a",@progbits
	.globl	one
	.p2align	3
one:
	.int64	4607182418800017408     # double 1
	.size	one, 8


