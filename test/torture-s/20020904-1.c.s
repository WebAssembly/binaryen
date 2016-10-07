	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20020904-1.c"
	.section	.text.fun,"ax",@progbits
	.hidden	fun
	.globl	fun
	.type	fun,@function
fun:                                    # @fun
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 255
	i32.div_u	$push1=, $pop0, $0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end0:
	.size	fun, .Lfunc_end0-fun

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
