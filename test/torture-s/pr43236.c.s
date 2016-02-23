	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr43236.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push44=, __stack_pointer
	i32.load	$push45=, 0($pop44)
	i32.const	$push46=, 96
	i32.sub 	$13=, $pop45, $pop46
	i32.const	$push47=, __stack_pointer
	i32.store	$discard=, 0($pop47), $13
	i32.const	$push0=, 16
	i32.const	$3=, 64
	i32.add 	$3=, $13, $3
	i32.add 	$push1=, $3, $pop0
	i64.const	$push2=, 72340172838076673
	i64.store	$0=, 0($pop1):p2align=4, $pop2
	i32.const	$push3=, 28
	i32.const	$4=, 64
	i32.add 	$4=, $13, $4
	i32.add 	$push4=, $4, $pop3
	i32.const	$push5=, 257
	i32.store16	$1=, 0($pop4):p2align=2, $pop5
	i32.const	$push6=, 24
	i32.const	$5=, 64
	i32.add 	$5=, $13, $5
	i32.add 	$push7=, $5, $pop6
	i32.const	$push8=, 16843009
	i32.store	$2=, 0($pop7):p2align=3, $pop8
	i32.const	$push42=, 16
	i32.const	$6=, 32
	i32.add 	$6=, $13, $6
	i32.add 	$push11=, $6, $pop42
	i64.store	$push9=, 72($13), $0
	i64.store	$push10=, 64($13):p2align=4, $pop9
	i64.store	$0=, 0($pop11):p2align=4, $pop10
	i32.const	$push41=, 28
	i32.add 	$push26=, $13, $pop41
	i32.const	$push40=, 28
	i32.const	$7=, 32
	i32.add 	$7=, $13, $7
	i32.add 	$push12=, $7, $pop40
	i32.store16	$push13=, 0($pop12):p2align=2, $1
	i32.store16	$discard=, 0($pop26):p2align=2, $pop13
	i32.const	$push39=, 24
	i32.add 	$push27=, $13, $pop39
	i32.const	$push38=, 24
	i32.const	$8=, 32
	i32.add 	$8=, $13, $8
	i32.add 	$push14=, $8, $pop38
	i32.store	$push15=, 0($pop14):p2align=3, $2
	i32.store	$discard=, 0($pop27):p2align=3, $pop15
	i32.const	$push18=, 18
	i32.const	$9=, 32
	i32.add 	$9=, $13, $9
	i32.add 	$push24=, $9, $pop18
	i32.const	$push37=, 18
	i32.const	$10=, 64
	i32.add 	$10=, $13, $10
	i32.add 	$push19=, $10, $pop37
	i32.const	$push20=, 0
	i32.store16	$push21=, 0($pop19), $pop20
	i32.store16	$1=, 0($pop24), $pop21
	i32.const	$push36=, 16
	i32.add 	$push28=, $13, $pop36
	i64.store	$push16=, 40($13), $0
	i64.store	$push17=, 32($13):p2align=4, $pop16
	i64.store	$0=, 0($pop28):p2align=4, $pop17
	i32.const	$push35=, 18
	i32.add 	$push30=, $13, $pop35
	i32.store16	$discard=, 0($pop30), $1
	i64.store	$push29=, 8($13), $0
	i64.store	$discard=, 0($13):p2align=4, $pop29
	i64.const	$push22=, 0
	i64.store	$push23=, 74($13):p2align=1, $pop22
	i64.store	$push25=, 42($13):p2align=1, $pop23
	i64.store	$discard=, 10($13):p2align=1, $pop25
	i32.const	$push34=, 30
	i32.const	$11=, 64
	i32.add 	$11=, $13, $11
	block
	i32.call	$push31=, memcmp@FUNCTION, $11, $13, $pop34
	br_if   	0, $pop31       # 0: down to label0
# BB#1:                                 # %lor.lhs.false
	i32.const	$push43=, 30
	i32.const	$12=, 32
	i32.add 	$12=, $13, $12
	i32.call	$push32=, memcmp@FUNCTION, $12, $13, $pop43
	br_if   	0, $pop32       # 0: down to label0
# BB#2:                                 # %if.end
	i32.const	$push33=, 0
	i32.const	$push48=, 96
	i32.add 	$13=, $13, $pop48
	i32.const	$push49=, __stack_pointer
	i32.store	$discard=, 0($pop49), $13
	return  	$pop33
.LBB0_3:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main


	.ident	"clang version 3.9.0 "
