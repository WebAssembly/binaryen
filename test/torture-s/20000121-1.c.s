	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000121-1.c"
	.section	.text.big,"ax",@progbits
	.hidden	big
	.globl	big
	.type	big,@function
big:                                    # @big
	.param  	i64
# BB#0:                                 # %entry
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	big, .Lfunc_end0-big

	.section	.text.doit,"ax",@progbits
	.hidden	doit
	.globl	doit
	.type	doit,@function
doit:                                   # @doit
	.param  	i32, i32, i32
# BB#0:                                 # %entry
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	doit, .Lfunc_end1-doit

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
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 3.9.0 "
