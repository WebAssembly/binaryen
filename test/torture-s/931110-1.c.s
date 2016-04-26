	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/931110-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load16_u	$0=, x+6($pop0)
	i32.const	$push41=, 0
	i32.const	$push40=, 0
	i32.load16_u	$push1=, x+4($pop40)
	i32.const	$push2=, 65528
	i32.and 	$push3=, $pop1, $pop2
	i32.store16	$discard=, x+4($pop41), $pop3
	i32.const	$push39=, 0
	i32.load16_u	$1=, x+8($pop39)
	i32.const	$push38=, 0
	i32.const	$push37=, 65528
	i32.and 	$push4=, $0, $pop37
	i32.store16	$discard=, x+6($pop38), $pop4
	i32.const	$push36=, 0
	i32.load16_u	$0=, x+10($pop36)
	i32.const	$push35=, 0
	i32.const	$push34=, 65528
	i32.and 	$push5=, $1, $pop34
	i32.store16	$discard=, x+8($pop35), $pop5
	i32.const	$push33=, 0
	i32.load16_u	$1=, x+12($pop33)
	i32.const	$push32=, 0
	i32.const	$push31=, 65528
	i32.and 	$push6=, $0, $pop31
	i32.store16	$discard=, x+10($pop32), $pop6
	i32.const	$push30=, 0
	i32.load16_u	$0=, x+14($pop30)
	i32.const	$push29=, 0
	i32.const	$push28=, 65528
	i32.and 	$push7=, $1, $pop28
	i32.store16	$discard=, x+12($pop29), $pop7
	i32.const	$push27=, 0
	i32.load16_u	$1=, x+16($pop27)
	i32.const	$push26=, 0
	i32.const	$push25=, 65528
	i32.and 	$push8=, $0, $pop25
	i32.store16	$discard=, x+14($pop26), $pop8
	i32.const	$push24=, 0
	i32.load16_u	$0=, x+18($pop24)
	i32.const	$push23=, 0
	i32.const	$push22=, 65528
	i32.and 	$push9=, $1, $pop22
	i32.store16	$discard=, x+16($pop23), $pop9
	i32.const	$push21=, 0
	i32.load16_u	$1=, x+20($pop21)
	i32.const	$push20=, 0
	i32.load16_u	$2=, x+22($pop20)
	i32.const	$push19=, 0
	i32.const	$push18=, 65528
	i32.and 	$push10=, $0, $pop18
	i32.store16	$discard=, x+18($pop19), $pop10
	i32.const	$push17=, 0
	i32.const	$push16=, 65528
	i32.and 	$push11=, $1, $pop16
	i32.store16	$discard=, x+20($pop17), $pop11
	i32.const	$push15=, 0
	i32.const	$push14=, 65528
	i32.and 	$push12=, $2, $pop14
	i32.store16	$discard=, x+22($pop15), $pop12
	i32.const	$push13=, 0
	call    	exit@FUNCTION, $pop13
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	x                       # @x
	.type	x,@object
	.section	.bss.x,"aw",@nobits
	.globl	x
	.p2align	2
x:
	.skip	24
	.size	x, 24


	.ident	"clang version 3.9.0 "
