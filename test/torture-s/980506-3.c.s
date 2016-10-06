	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/980506-3.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %if.else
	i32.const	$push2=, lookup_table
	i32.const	$push1=, 4
	i32.const	$push0=, 257
	i32.call	$drop=, memset@FUNCTION, $pop2, $pop1, $pop0
	i32.const	$push3=, 0
	call    	exit@FUNCTION, $pop3
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	lookup_table            # @lookup_table
	.type	lookup_table,@object
	.section	.bss.lookup_table,"aw",@nobits
	.globl	lookup_table
	.p2align	4
lookup_table:
	.skip	257
	.size	lookup_table, 257


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	exit, void, i32
