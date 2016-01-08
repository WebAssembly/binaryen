	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr58570.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i64
# BB#0:                                 # %entry
	i32.const	$0=, 0
	block   	.LBB0_2
	i32.load	$push0=, e($0)
	i32.const	$push29=, 0
	i32.eq  	$push30=, $pop0, $pop29
	br_if   	$pop30, .LBB0_2
# BB#1:                                 # %if.then
	i32.const	$push4=, d
	i32.load	$push1=, i($0)
	i32.const	$push2=, 6
	i32.mul 	$push3=, $pop1, $pop2
	i32.add 	$1=, $pop4, $pop3
	i32.const	$push5=, 4
	i32.add 	$2=, $1, $pop5
	i64.load16_u	$3=, 0($2)
	i32.const	$push6=, 2
	i32.add 	$push7=, $1, $pop6
	i64.const	$push8=, 0
	i64.store16	$discard=, 0($pop7), $pop8
	i64.const	$push9=, 32769
	i64.store16	$discard=, 0($1), $pop9
	i64.const	$push10=, 61440
	i64.and 	$push11=, $3, $pop10
	i64.store16	$discard=, 0($2), $pop11
.LBB0_2:                                # %if.end
	block   	.LBB0_4
	i64.load32_u	$push18=, d($0)
	i32.const	$push12=, d
	i32.const	$push13=, 4
	i32.add 	$push14=, $pop12, $pop13
	i64.load16_u	$push15=, 0($pop14)
	i64.const	$push16=, 32
	i64.shl 	$push17=, $pop15, $pop16
	i64.or  	$push19=, $pop18, $pop17
	i64.const	$push20=, 20
	i64.shl 	$push21=, $pop19, $pop20
	i64.const	$push22=, 16
	i64.shr_s	$push23=, $pop21, $pop22
	i64.const	$push24=, 19
	i64.shr_u	$push25=, $pop23, $pop24
	i32.wrap/i64	$push26=, $pop25
	i32.const	$push27=, 1
	i32.ne  	$push28=, $pop26, $pop27
	br_if   	$pop28, .LBB0_4
# BB#3:                                 # %if.end7
	return  	$0
.LBB0_4:                                # %if.then6
	call    	abort
	unreachable
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	e                       # @e
	.type	e,@object
	.section	.data.e,"aw",@progbits
	.globl	e
	.align	2
e:
	.int32	1                       # 0x1
	.size	e, 4

	.hidden	i                       # @i
	.type	i,@object
	.section	.bss.i,"aw",@nobits
	.globl	i
	.align	2
i:
	.int32	0                       # 0x0
	.size	i, 4

	.type	d,@object               # @d
	.lcomm	d,36,4

	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
