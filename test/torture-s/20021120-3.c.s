	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20021120-3.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push9=, 0
	i32.const	$push6=, 0
	i32.load	$push7=, __stack_pointer($pop6)
	i32.const	$push8=, 16
	i32.sub 	$push15=, $pop7, $pop8
	tee_local	$push14=, $3=, $pop15
	i32.store	__stack_pointer($pop9), $pop14
	i32.div_u	$push0=, $1, $2
	i32.store	0($3), $pop0
	i32.const	$push1=, .L.str
	i32.call	$drop=, sprintf@FUNCTION, $0, $pop1, $3
	i32.const	$push12=, 0
	i32.const	$push10=, 16
	i32.add 	$push11=, $3, $pop10
	i32.store	__stack_pointer($pop12), $pop11
	i32.const	$push2=, 1
	i32.add 	$push4=, $1, $pop2
	i32.const	$push13=, 1
	i32.add 	$push3=, $2, $pop13
	i32.div_u	$push5=, $pop4, $pop3
                                        # fallthrough-return: $pop5
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
	i32.const	$push6=, 0
	i32.const	$push3=, 0
	i32.load	$push4=, __stack_pointer($pop3)
	i32.const	$push5=, 32
	i32.sub 	$push10=, $pop4, $pop5
	tee_local	$push9=, $0=, $pop10
	i32.store	__stack_pointer($pop6), $pop9
	i32.const	$push0=, 1073741823
	i32.store	0($0), $pop0
	i32.const	$push7=, 16
	i32.add 	$push8=, $0, $pop7
	i32.const	$push1=, .L.str
	i32.call	$drop=, sprintf@FUNCTION, $pop8, $pop1, $0
	i32.const	$push2=, 0
	call    	exit@FUNCTION, $pop2
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"%d"
	.size	.L.str, 3


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	sprintf, i32, i32, i32
	.functype	exit, void, i32
