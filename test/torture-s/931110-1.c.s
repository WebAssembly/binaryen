	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/931110-1.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.const	$1=, 65528
	i32.load16_u	$2=, x+6($0)
	i32.load16_u	$push0=, x+4($0)
	i32.and 	$push1=, $pop0, $1
	i32.store16	$discard=, x+4($0), $pop1
	i32.load16_u	$3=, x+8($0)
	i32.and 	$push2=, $2, $1
	i32.store16	$discard=, x+6($0), $pop2
	i32.load16_u	$2=, x+10($0)
	i32.and 	$push3=, $3, $1
	i32.store16	$discard=, x+8($0), $pop3
	i32.load16_u	$3=, x+12($0)
	i32.and 	$push4=, $2, $1
	i32.store16	$discard=, x+10($0), $pop4
	i32.load16_u	$2=, x+14($0)
	i32.and 	$push5=, $3, $1
	i32.store16	$discard=, x+12($0), $pop5
	i32.load16_u	$3=, x+16($0)
	i32.and 	$push6=, $2, $1
	i32.store16	$discard=, x+14($0), $pop6
	i32.load16_u	$2=, x+18($0)
	i32.and 	$push7=, $3, $1
	i32.store16	$discard=, x+16($0), $pop7
	i32.load16_u	$3=, x+20($0)
	i32.load16_u	$4=, x+22($0)
	i32.and 	$push8=, $2, $1
	i32.store16	$discard=, x+18($0), $pop8
	i32.and 	$push9=, $3, $1
	i32.store16	$discard=, x+20($0), $pop9
	i32.and 	$push10=, $4, $1
	i32.store16	$discard=, x+22($0), $pop10
	call    	exit, $0
	unreachable
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.type	x,@object               # @x
	.bss
	.globl	x
	.align	2
x:
	.zero	24
	.size	x, 24


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
