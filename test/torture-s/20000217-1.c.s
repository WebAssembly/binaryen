	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000217-1.c"
	.section	.text.showbug,"ax",@progbits
	.hidden	showbug
	.globl	showbug
	.type	showbug,@function
showbug:                                # @showbug
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.load16_u	$push2=, 0($1)
	i32.load16_u	$push1=, 0($0)
	i32.add 	$push3=, $pop2, $pop1
	i32.const	$push4=, 65528
	i32.add 	$push5=, $pop3, $pop4
	i32.store16	$push0=, 0($0), $pop5
	i32.const	$push9=, 65528
	i32.and 	$push6=, $pop0, $pop9
	i32.const	$push7=, 7
	i32.gt_u	$push8=, $pop6, $pop7
                                        # fallthrough-return: $pop8
	.endfunc
.Lfunc_end0:
	.size	showbug, .Lfunc_end0-showbug

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
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
	.functype	exit, void, i32
