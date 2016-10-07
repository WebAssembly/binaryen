	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/extzvsi.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push6=, 2
	i32.const	$push13=, 0
	i32.load	$push1=, x($pop13)
	i32.const	$push2=, 1
	i32.shr_u	$push3=, $pop1, $pop2
	i32.const	$push4=, 2047
	i32.and 	$push12=, $pop3, $pop4
	tee_local	$push11=, $0=, $pop12
	i32.const	$push10=, 1
	i32.eq  	$push5=, $pop11, $pop10
	i32.select	$push7=, $pop0, $pop6, $pop5
	i32.const	$push9=, 1
	i32.select	$push8=, $pop7, $pop9, $0
                                        # fallthrough-return: $pop8
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
	i32.const	$push7=, 0
	i64.load	$push1=, x($pop7)
	i64.const	$push2=, -4095
	i64.and 	$push3=, $pop1, $pop2
	i64.const	$push4=, 2
	i64.or  	$push5=, $pop3, $pop4
	i64.store	x($pop0), $pop5
	i32.const	$push6=, 0
                                        # fallthrough-return: $pop6
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	x                       # @x
	.type	x,@object
	.section	.bss.x,"aw",@nobits
	.globl	x
	.p2align	3
x:
	.skip	8
	.size	x, 8


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
