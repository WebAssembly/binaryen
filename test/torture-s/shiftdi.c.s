	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/shiftdi.c"
	.section	.text.g,"ax",@progbits
	.hidden	g
	.globl	g
	.type	g,@function
g:                                      # @g
	.param  	i64, i32, i32, i32
# BB#0:                                 # %entry
	i64.load	$push11=, 0($3)
	i64.extend_u/i32	$push0=, $1
	i64.shr_u	$push1=, $0, $pop0
	i64.const	$push2=, 4294967295
	i64.and 	$push3=, $pop1, $pop2
	i32.const	$push4=, 31
	i32.and 	$push5=, $2, $pop4
	i64.extend_u/i32	$push6=, $pop5
	i64.shl 	$push7=, $pop3, $pop6
	i64.const	$push13=, 4294967295
	i64.and 	$push8=, $pop7, $pop13
	i64.extend_u/i32	$push9=, $2
	i64.shl 	$push10=, $pop8, $pop9
	i64.or  	$push12=, $pop11, $pop10
	i64.store	0($3), $pop12
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	g, .Lfunc_end0-g

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
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
