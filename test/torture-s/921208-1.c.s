	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/921208-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	f64
	.result 	f64
# BB#0:                                 # %entry
	f64.mul 	$push0=, $0, $0
	return  	$pop0
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.Int,"ax",@progbits
	.hidden	Int
	.globl	Int
	.type	Int,@function
Int:                                    # @Int
	.param  	i32, f64
	.result 	f64
# BB#0:                                 # %entry
	f64.call_indirect	$push0=, $0, $1
	return  	$pop0
.Lfunc_end1:
	.size	Int, .Lfunc_end1-Int

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
