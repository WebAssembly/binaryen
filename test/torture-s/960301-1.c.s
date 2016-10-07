	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/960301-1.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push14=, 0
	i32.load16_u	$push13=, foo($pop14)
	tee_local	$push12=, $1=, $pop13
	i32.const	$push1=, 12
	i32.shr_u	$push2=, $pop12, $pop1
	i32.store	oldfoo($pop0), $pop2
	i32.const	$push11=, 0
	i32.const	$push4=, 4095
	i32.and 	$push5=, $1, $pop4
	i32.const	$push10=, 12
	i32.shl 	$push3=, $0, $pop10
	i32.or  	$push6=, $pop5, $pop3
	i32.store16	foo($pop11), $pop6
	i32.const	$push8=, 1
	i32.const	$push7=, 2
	i32.select	$push9=, $pop8, $pop7, $0
                                        # fallthrough-return: $pop9
	.endfunc
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	i32.const	$push11=, 0
	i32.load16_u	$push10=, foo($pop11)
	tee_local	$push9=, $0=, $pop10
	i32.const	$push1=, 12
	i32.shr_u	$push2=, $pop9, $pop1
	i32.store	oldfoo($pop0), $pop2
	i32.const	$push8=, 0
	i32.const	$push3=, 4095
	i32.and 	$push4=, $0, $pop3
	i32.const	$push5=, 4096
	i32.or  	$push6=, $pop4, $pop5
	i32.store16	foo($pop8), $pop6
	i32.const	$push7=, 0
	call    	exit@FUNCTION, $pop7
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	foo                     # @foo
	.type	foo,@object
	.section	.bss.foo,"aw",@nobits
	.globl	foo
	.p2align	2
foo:
	.skip	4
	.size	foo, 4

	.hidden	oldfoo                  # @oldfoo
	.type	oldfoo,@object
	.section	.bss.oldfoo,"aw",@nobits
	.globl	oldfoo
	.p2align	2
oldfoo:
	.int32	0                       # 0x0
	.size	oldfoo, 4


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	exit, void, i32
