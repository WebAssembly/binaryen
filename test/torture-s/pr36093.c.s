	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr36093.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push2=, foo
	i32.const	$push1=, 97
	i32.const	$push0=, 129
	i32.call	$drop=, memset@FUNCTION, $pop2, $pop1, $pop0
	i32.const	$push4=, foo+129
	i32.const	$push3=, 98
	i32.const	$push12=, 129
	i32.call	$drop=, memset@FUNCTION, $pop4, $pop3, $pop12
	i32.const	$push6=, foo+258
	i32.const	$push5=, 99
	i32.const	$push11=, 129
	i32.call	$drop=, memset@FUNCTION, $pop6, $pop5, $pop11
	i32.const	$push8=, foo+387
	i32.const	$push7=, 100
	i32.const	$push10=, 129
	i32.call	$drop=, memset@FUNCTION, $pop8, $pop7, $pop10
	i32.const	$push9=, 0
                                        # fallthrough-return: $pop9
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	foo                     # @foo
	.type	foo,@object
	.section	.bss.foo,"aw",@nobits
	.globl	foo
	.p2align	7
foo:
	.skip	2560
	.size	foo, 2560


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
