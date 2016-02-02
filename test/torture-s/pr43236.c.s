	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr43236.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i64, i32, i32, i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$4=, __stack_pointer
	i32.load	$4=, 0($4)
	i32.const	$5=, 96
	i32.sub 	$21=, $4, $5
	i32.const	$5=, __stack_pointer
	i32.store	$21=, 0($5), $21
	i32.const	$push0=, 16
	i32.const	$7=, 64
	i32.add 	$7=, $21, $7
	i32.add 	$push1=, $7, $pop0
	i64.const	$push2=, 72340172838076673
	i64.store	$0=, 0($pop1):p2align=4, $pop2
	i32.const	$push3=, 28
	i32.const	$8=, 64
	i32.add 	$8=, $21, $8
	i32.add 	$push4=, $8, $pop3
	i32.const	$push5=, 257
	i32.store16	$1=, 0($pop4):p2align=2, $pop5
	i32.const	$push6=, 24
	i32.const	$9=, 64
	i32.add 	$9=, $21, $9
	i32.add 	$push7=, $9, $pop6
	i32.const	$push8=, 16843009
	i32.store	$2=, 0($pop7):p2align=3, $pop8
	i32.const	$push51=, 16
	i32.const	$10=, 32
	i32.add 	$10=, $21, $10
	i32.add 	$push13=, $10, $pop51
	i32.const	$push9=, 8
	i32.const	$11=, 64
	i32.add 	$11=, $21, $11
	i32.or  	$push10=, $11, $pop9
	i64.store	$push11=, 0($pop10), $0
	i64.store	$push12=, 64($21):p2align=4, $pop11
	i64.store	$0=, 0($pop13):p2align=4, $pop12
	i32.const	$push50=, 28
	i32.add 	$push30=, $21, $pop50
	i32.const	$push49=, 28
	i32.const	$12=, 32
	i32.add 	$12=, $21, $12
	i32.add 	$push14=, $12, $pop49
	i32.store16	$push15=, 0($pop14):p2align=2, $1
	i32.store16	$discard=, 0($pop30):p2align=2, $pop15
	i32.const	$push48=, 24
	i32.add 	$push31=, $21, $pop48
	i32.const	$push47=, 24
	i32.const	$13=, 32
	i32.add 	$13=, $21, $13
	i32.add 	$push16=, $13, $pop47
	i32.store	$push17=, 0($pop16):p2align=3, $2
	i32.store	$discard=, 0($pop31):p2align=3, $pop17
	i32.const	$push46=, 8
	i32.const	$14=, 32
	i32.add 	$14=, $21, $14
	i32.or  	$push18=, $14, $pop46
	i64.store	$discard=, 0($pop18), $0
	i32.const	$push22=, 18
	i32.const	$15=, 32
	i32.add 	$15=, $21, $15
	i32.add 	$push29=, $15, $pop22
	i32.const	$push45=, 18
	i32.const	$16=, 64
	i32.add 	$16=, $21, $16
	i32.add 	$push23=, $16, $pop45
	i32.const	$push24=, 0
	i32.store16	$push25=, 0($pop23), $pop24
	i32.store16	$1=, 0($pop29), $pop25
	i32.const	$push44=, 16
	i32.add 	$push32=, $21, $pop44
	i64.store	$push19=, 32($21):p2align=4, $0
	i64.store	$0=, 0($pop32):p2align=4, $pop19
	i32.const	$push43=, 18
	i32.add 	$push35=, $21, $pop43
	i32.store16	$discard=, 0($pop35), $1
	i32.const	$push20=, 10
	i32.const	$17=, 32
	i32.add 	$17=, $21, $17
	i32.or  	$push28=, $17, $pop20
	i32.const	$push42=, 10
	i32.const	$18=, 64
	i32.add 	$18=, $21, $18
	i32.or  	$push21=, $18, $pop42
	i64.const	$push26=, 0
	i64.store	$push27=, 0($pop21):p2align=1, $pop26
	i64.store	$3=, 0($pop28):p2align=1, $pop27
	i32.const	$push41=, 8
	i32.or  	$push33=, $21, $pop41
	i64.store	$discard=, 0($pop33), $0
	i32.const	$push40=, 10
	i32.or  	$push34=, $21, $pop40
	i64.store	$discard=, 0($pop34):p2align=1, $3
	i64.store	$discard=, 0($21):p2align=4, $0
	i32.const	$push39=, 30
	i32.const	$19=, 64
	i32.add 	$19=, $21, $19
	block
	i32.call	$push36=, memcmp@FUNCTION, $19, $21, $pop39
	br_if   	$pop36, 0       # 0: down to label0
# BB#1:                                 # %lor.lhs.false
	i32.const	$push52=, 30
	i32.const	$20=, 32
	i32.add 	$20=, $21, $20
	i32.call	$push37=, memcmp@FUNCTION, $20, $21, $pop52
	br_if   	$pop37, 0       # 0: down to label0
# BB#2:                                 # %if.end
	i32.const	$push38=, 0
	i32.const	$6=, 96
	i32.add 	$21=, $21, $6
	i32.const	$6=, __stack_pointer
	i32.store	$21=, 0($6), $21
	return  	$pop38
.LBB0_3:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main


	.ident	"clang version 3.9.0 "
