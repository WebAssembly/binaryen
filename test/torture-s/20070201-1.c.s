	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20070201-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push6=, 0
	i32.const	$push3=, 0
	i32.load	$push4=, __stack_pointer($pop3)
	i32.const	$push5=, 16
	i32.sub 	$push11=, $pop4, $pop5
	tee_local	$push10=, $2=, $pop11
	i32.store	__stack_pointer($pop6), $pop10
	i32.store	0($2), $1
	i32.const	$push0=, .L.str
	i32.call	$drop=, sprintf@FUNCTION, $0, $pop0, $2
	i32.const	$push9=, 0
	i32.const	$push7=, 16
	i32.add 	$push8=, $2, $pop7
	i32.store	__stack_pointer($pop9), $pop8
	i32.const	$push1=, 1
	i32.add 	$push2=, $1, $pop1
                                        # fallthrough-return: $pop2
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %if.end
	i32.const	$push7=, 0
	i32.const	$push4=, 0
	i32.load	$push5=, __stack_pointer($pop4)
	i32.const	$push6=, 16
	i32.sub 	$push14=, $pop5, $pop6
	tee_local	$push13=, $0=, $pop14
	i32.store	__stack_pointer($pop7), $pop13
	i32.const	$push0=, 12
	i32.add 	$push1=, $0, $pop0
	i32.store	0($0), $pop1
	i32.const	$push11=, 10
	i32.add 	$push12=, $0, $pop11
	i32.const	$push2=, .L.str
	i32.call	$drop=, sprintf@FUNCTION, $pop12, $pop2, $0
	i32.const	$push10=, 0
	i32.const	$push8=, 16
	i32.add 	$push9=, $0, $pop8
	i32.store	__stack_pointer($pop10), $pop9
	i32.const	$push3=, 0
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"abcde"
	.size	.L.str, 6


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	sprintf, i32, i32, i32
