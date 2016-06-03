	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000726-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.section	.text.adjust_xy,"ax",@progbits
	.hidden	adjust_xy
	.globl	adjust_xy
	.type	adjust_xy,@function
adjust_xy:                              # @adjust_xy
	.param  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 1
	i32.store16	$drop=, 0($0), $pop0
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	adjust_xy, .Lfunc_end1-adjust_xy


	.ident	"clang version 3.9.0 "
	.functype	exit, void, i32
