	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr58570.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i64, i32, i32
# BB#0:                                 # %entry
	block
	i32.const	$push26=, 0
	i32.load	$push0=, e($pop26)
	i32.const	$push32=, 0
	i32.eq  	$push33=, $pop0, $pop32
	br_if   	$pop33, 0       # 0: down to label0
# BB#1:                                 # %if.then
	i32.const	$push29=, 0
	i32.load	$push1=, i($pop29)
	i32.const	$push2=, 6
	i32.mul 	$push3=, $pop1, $pop2
	tee_local	$push28=, $2=, $pop3
	i32.const	$push4=, d
	i32.add 	$push5=, $pop28, $pop4
	i32.const	$push6=, 4
	i32.add 	$push7=, $pop5, $pop6
	tee_local	$push27=, $1=, $pop7
	i64.load16_u	$0=, 0($pop27)
	i64.const	$push8=, 32769
	i64.store32	$discard=, d($2):p2align=1, $pop8
	i64.const	$push9=, 61440
	i64.and 	$push10=, $0, $pop9
	i64.store16	$discard=, 0($1), $pop10
.LBB0_2:                                # %if.end
	end_block                       # label0:
	block
	i32.const	$push31=, 0
	i64.load32_u	$push14=, d($pop31):p2align=4
	i32.const	$push30=, 0
	i64.load16_u	$push11=, d+4($pop30):p2align=2
	i64.const	$push12=, 32
	i64.shl 	$push13=, $pop11, $pop12
	i64.or  	$push15=, $pop14, $pop13
	i64.const	$push16=, 20
	i64.shl 	$push17=, $pop15, $pop16
	i64.const	$push18=, 16
	i64.shr_s	$push19=, $pop17, $pop18
	i64.const	$push20=, 19
	i64.shr_u	$push21=, $pop19, $pop20
	i32.wrap/i64	$push22=, $pop21
	i32.const	$push23=, 1
	i32.ne  	$push24=, $pop22, $pop23
	br_if   	$pop24, 0       # 0: down to label1
# BB#3:                                 # %if.end7
	i32.const	$push25=, 0
	return  	$pop25
.LBB0_4:                                # %if.then6
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	e                       # @e
	.type	e,@object
	.section	.data.e,"aw",@progbits
	.globl	e
	.p2align	2
e:
	.int32	1                       # 0x1
	.size	e, 4

	.hidden	i                       # @i
	.type	i,@object
	.section	.bss.i,"aw",@nobits
	.globl	i
	.p2align	2
i:
	.int32	0                       # 0x0
	.size	i, 4

	.type	d,@object               # @d
	.lcomm	d,36,4

	.ident	"clang version 3.9.0 "
