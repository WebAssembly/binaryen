	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000217-1.c"
	.section	.text.showbug,"ax",@progbits
	.hidden	showbug
	.globl	showbug
	.type	showbug,@function
showbug:                                # @showbug
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.load16_u	$push1=, 0($1)
	i32.load16_u	$push0=, 0($0)
	i32.add 	$push2=, $pop1, $pop0
	i32.const	$push3=, 65528
	i32.add 	$push9=, $pop2, $pop3
	tee_local	$push8=, $1=, $pop9
	i32.store16	0($0), $pop8
	i32.const	$push7=, 65528
	i32.and 	$push4=, $1, $pop7
	i32.const	$push5=, 7
	i32.gt_u	$push6=, $pop4, $pop5
                                        # fallthrough-return: $pop6
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	exit, void, i32
