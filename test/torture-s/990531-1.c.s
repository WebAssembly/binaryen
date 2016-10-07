	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/990531-1.c"
	.section	.text.bad,"ax",@progbits
	.hidden	bad
	.globl	bad
	.type	bad,@function
bad:                                    # @bad
	.param  	i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push3=, 0
	i32.load	$push4=, __stack_pointer($pop3)
	i32.const	$push5=, 16
	i32.sub 	$push9=, $pop4, $pop5
	tee_local	$push8=, $2=, $pop9
	i32.store	8($pop8), $1
	i32.const	$push6=, 8
	i32.add 	$push7=, $2, $pop6
	i32.add 	$push0=, $pop7, $0
	i32.const	$push1=, 0
	i32.store8	0($pop0), $pop1
	i32.load	$push2=, 8($2)
                                        # fallthrough-return: $pop2
	.endfunc
.Lfunc_end0:
	.size	bad, .Lfunc_end0-bad

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
