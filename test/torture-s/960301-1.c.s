	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/960301-1.c"
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
	i32.load16_u	$push1=, foo($pop14):p2align=2
	tee_local	$push13=, $1=, $pop1
	i32.const	$push2=, 12
	i32.shr_u	$push3=, $pop13, $pop2
	i32.store	$discard=, oldfoo($pop0), $pop3
	i32.const	$push12=, 0
	i32.const	$push5=, 4095
	i32.and 	$push6=, $1, $pop5
	i32.const	$push11=, 12
	i32.shl 	$push4=, $0, $pop11
	i32.or  	$push7=, $pop6, $pop4
	i32.store16	$discard=, foo($pop12):p2align=2, $pop7
	i32.const	$push9=, 1
	i32.const	$push8=, 2
	i32.select	$push10=, $0, $pop9, $pop8
	return  	$pop10
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
	i32.load16_u	$push1=, foo($pop11):p2align=2
	tee_local	$push10=, $0=, $pop1
	i32.const	$push2=, 12
	i32.shr_u	$push3=, $pop10, $pop2
	i32.store	$discard=, oldfoo($pop0), $pop3
	i32.const	$push9=, 0
	i32.const	$push4=, 4095
	i32.and 	$push5=, $0, $pop4
	i32.const	$push6=, 4096
	i32.or  	$push7=, $pop5, $pop6
	i32.store16	$discard=, foo($pop9):p2align=2, $pop7
	i32.const	$push8=, 0
	call    	exit@FUNCTION, $pop8
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


	.ident	"clang version 3.9.0 "
