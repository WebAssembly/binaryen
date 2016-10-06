	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/990106-2.c"
	.section	.text.calc_mp,"ax",@progbits
	.hidden	calc_mp
	.globl	calc_mp
	.type	calc_mp,@function
calc_mp:                                # @calc_mp
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, -1
	i32.rem_u	$push1=, $pop0, $0
	i32.const	$push2=, 1
	i32.add 	$push8=, $pop1, $pop2
	tee_local	$push7=, $1=, $pop8
	i32.const	$push4=, 0
	i32.gt_u	$push3=, $1, $0
	i32.select	$push5=, $0, $pop4, $pop3
	i32.sub 	$push6=, $pop7, $pop5
                                        # fallthrough-return: $pop6
	.endfunc
.Lfunc_end0:
	.size	calc_mp, .Lfunc_end0-calc_mp

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.param  	i32, i32
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
