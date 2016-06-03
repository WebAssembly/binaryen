	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/complex-1.c"
	.section	.text.g0,"ax",@progbits
	.hidden	g0
	.globl	g0
	.type	g0,@function
g0:                                     # @g0
	.param  	f64
	.result 	f64
# BB#0:                                 # %entry
	f64.const	$push0=, 0x1p0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end0:
	.size	g0, .Lfunc_end0-g0

	.section	.text.g1,"ax",@progbits
	.hidden	g1
	.globl	g1
	.type	g1,@function
g1:                                     # @g1
	.param  	f64
	.result 	f64
# BB#0:                                 # %entry
	f64.const	$push0=, -0x1p0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	g1, .Lfunc_end1-g1

	.section	.text.g2,"ax",@progbits
	.hidden	g2
	.globl	g2
	.type	g2,@function
g2:                                     # @g2
	.param  	f64
	.result 	f64
# BB#0:                                 # %entry
	f64.const	$push0=, 0x0p0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end2:
	.size	g2, .Lfunc_end2-g2

	.section	.text.xcexp,"ax",@progbits
	.hidden	xcexp
	.globl	xcexp
	.type	xcexp,@function
xcexp:                                  # @xcexp
	.param  	i32, i32
# BB#0:                                 # %entry
	i64.const	$push0=, 0
	i64.store	$drop=, 8($0), $pop0
	i64.const	$push1=, -4616189618054758400
	i64.store	$drop=, 0($0), $pop1
                                        # fallthrough-return
	.endfunc
.Lfunc_end3:
	.size	xcexp, .Lfunc_end3-xcexp

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
.Lfunc_end4:
	.size	main, .Lfunc_end4-main


	.ident	"clang version 3.9.0 "
	.functype	exit, void, i32
