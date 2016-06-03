	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/cvt-1.c"
	.section	.text.g2,"ax",@progbits
	.hidden	g2
	.globl	g2
	.type	g2,@function
g2:                                     # @g2
	.param  	f64
	.result 	i32
# BB#0:                                 # %entry
	i32.trunc_s/f64	$push0=, $0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end0:
	.size	g2, .Lfunc_end0-g2

	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	f64
# BB#0:                                 # %if.end
	f64.convert_s/i32	$push0=, $0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	f, .Lfunc_end1-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end6
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 3.9.0 "
	.functype	exit, void, i32
