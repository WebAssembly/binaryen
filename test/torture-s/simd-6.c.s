	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/simd-6.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push1=, 7
	i32.add 	$push2=, $0, $pop1
	i32.mul 	$push0=, $16, $8
	i32.store8	0($pop2), $pop0
	i32.const	$push4=, 6
	i32.add 	$push5=, $0, $pop4
	i32.mul 	$push3=, $15, $7
	i32.store8	0($pop5), $pop3
	i32.const	$push7=, 5
	i32.add 	$push8=, $0, $pop7
	i32.mul 	$push6=, $14, $6
	i32.store8	0($pop8), $pop6
	i32.const	$push10=, 4
	i32.add 	$push11=, $0, $pop10
	i32.mul 	$push9=, $13, $5
	i32.store8	0($pop11), $pop9
	i32.const	$push13=, 3
	i32.add 	$push14=, $0, $pop13
	i32.mul 	$push12=, $12, $4
	i32.store8	0($pop14), $pop12
	i32.const	$push16=, 2
	i32.add 	$push17=, $0, $pop16
	i32.mul 	$push15=, $11, $3
	i32.store8	0($pop17), $pop15
	i32.const	$push19=, 1
	i32.add 	$push20=, $0, $pop19
	i32.mul 	$push18=, $10, $2
	i32.store8	0($pop20), $pop18
	i32.mul 	$push21=, $9, $1
	i32.store8	0($0), $pop21
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

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
