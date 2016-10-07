	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr58570.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push25=, 0
	i32.load	$push0=, e($pop25)
	i32.eqz 	$push33=, $pop0
	br_if   	0, $pop33       # 0: down to label0
# BB#1:                                 # %if.then
	i32.const	$push30=, 0
	i32.load	$push1=, i($pop30)
	i32.const	$push2=, 6
	i32.mul 	$push3=, $pop1, $pop2
	i32.const	$push4=, d
	i32.add 	$push29=, $pop3, $pop4
	tee_local	$push28=, $0=, $pop29
	i64.const	$push5=, 32769
	i64.store32	0($pop28):p2align=1, $pop5
	i32.const	$push6=, 4
	i32.add 	$push27=, $0, $pop6
	tee_local	$push26=, $0=, $pop27
	i64.load16_u	$push7=, 0($0)
	i64.const	$push8=, 61440
	i64.and 	$push9=, $pop7, $pop8
	i64.store16	0($pop26), $pop9
.LBB0_2:                                # %if.end
	end_block                       # label0:
	block   	
	i32.const	$push32=, 0
	i64.load32_u	$push13=, d($pop32)
	i32.const	$push31=, 0
	i64.load16_u	$push10=, d+4($pop31)
	i64.const	$push11=, 32
	i64.shl 	$push12=, $pop10, $pop11
	i64.or  	$push14=, $pop13, $pop12
	i64.const	$push15=, 20
	i64.shl 	$push16=, $pop14, $pop15
	i64.const	$push17=, 16
	i64.shr_s	$push18=, $pop16, $pop17
	i64.const	$push19=, 19
	i64.shr_u	$push20=, $pop18, $pop19
	i32.wrap/i64	$push21=, $pop20
	i32.const	$push22=, 1
	i32.ne  	$push23=, $pop21, $pop22
	br_if   	0, $pop23       # 0: down to label1
# BB#3:                                 # %if.end7
	i32.const	$push24=, 0
	return  	$pop24
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

	.type	d,@object               # @d
	.section	.bss.d,"aw",@nobits
	.p2align	4
d:
	.skip	36
	.size	d, 36

	.hidden	i                       # @i
	.type	i,@object
	.section	.bss.i,"aw",@nobits
	.globl	i
	.p2align	2
i:
	.int32	0                       # 0x0
	.size	i, 4


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
