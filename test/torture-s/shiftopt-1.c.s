	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/shiftopt-1.c"
	.section	.text.utest,"ax",@progbits
	.hidden	utest
	.globl	utest
	.type	utest,@function
utest:                                  # @utest
	.param  	i32
# BB#0:                                 # %entry
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	utest, .Lfunc_end0-utest

	.section	.text.stest,"ax",@progbits
	.hidden	stest
	.globl	stest
	.type	stest,@function
stest:                                  # @stest
	.param  	i32
# BB#0:                                 # %entry
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	stest, .Lfunc_end1-stest

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
