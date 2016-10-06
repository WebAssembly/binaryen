	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20010518-1.c"
	.section	.text.add,"ax",@progbits
	.hidden	add
	.globl	add
	.type	add,@function
add:                                    # @add
	.param  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.add 	$push0=, $1, $0
	i32.add 	$push1=, $pop0, $2
	i32.add 	$push2=, $pop1, $3
	i32.add 	$push3=, $pop2, $4
	i32.add 	$push4=, $pop3, $5
	i32.add 	$push5=, $pop4, $6
	i32.add 	$push6=, $pop5, $7
	i32.add 	$push7=, $pop6, $8
	i32.add 	$push8=, $pop7, $9
	i32.add 	$push9=, $pop8, $10
	i32.add 	$push10=, $pop9, $11
	i32.add 	$push11=, $pop10, $12
                                        # fallthrough-return: $pop11
	.endfunc
.Lfunc_end0:
	.size	add, .Lfunc_end0-add

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
