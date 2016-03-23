	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr43236.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i64, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push44=, __stack_pointer
	i32.load	$push45=, 0($pop44)
	i32.const	$push46=, 96
	i32.sub 	$3=, $pop45, $pop46
	i32.const	$push47=, __stack_pointer
	i32.store	$discard=, 0($pop47), $3
	i32.const	$push51=, 64
	i32.add 	$push52=, $3, $pop51
	i32.const	$push0=, 16
	i32.add 	$push1=, $pop52, $pop0
	i64.const	$push2=, 72340172838076673
	i64.store	$0=, 0($pop1):p2align=4, $pop2
	i32.const	$push53=, 64
	i32.add 	$push54=, $3, $pop53
	i32.const	$push3=, 28
	i32.add 	$push4=, $pop54, $pop3
	i32.const	$push5=, 257
	i32.store16	$1=, 0($pop4):p2align=2, $pop5
	i32.const	$push55=, 64
	i32.add 	$push56=, $3, $pop55
	i32.const	$push6=, 24
	i32.add 	$push7=, $pop56, $pop6
	i32.const	$push8=, 16843009
	i32.store	$2=, 0($pop7):p2align=3, $pop8
	i32.const	$push57=, 32
	i32.add 	$push58=, $3, $pop57
	i32.const	$push42=, 16
	i32.add 	$push11=, $pop58, $pop42
	i64.store	$push9=, 72($3), $0
	i64.store	$push10=, 64($3):p2align=4, $pop9
	i64.store	$0=, 0($pop11):p2align=4, $pop10
	i32.const	$push41=, 28
	i32.add 	$push26=, $3, $pop41
	i32.const	$push59=, 32
	i32.add 	$push60=, $3, $pop59
	i32.const	$push40=, 28
	i32.add 	$push12=, $pop60, $pop40
	i32.store16	$push13=, 0($pop12):p2align=2, $1
	i32.store16	$discard=, 0($pop26):p2align=2, $pop13
	i32.const	$push39=, 24
	i32.add 	$push27=, $3, $pop39
	i32.const	$push61=, 32
	i32.add 	$push62=, $3, $pop61
	i32.const	$push38=, 24
	i32.add 	$push14=, $pop62, $pop38
	i32.store	$push15=, 0($pop14):p2align=3, $2
	i32.store	$discard=, 0($pop27):p2align=3, $pop15
	i32.const	$push63=, 32
	i32.add 	$push64=, $3, $pop63
	i32.const	$push18=, 18
	i32.add 	$push24=, $pop64, $pop18
	i32.const	$push65=, 64
	i32.add 	$push66=, $3, $pop65
	i32.const	$push37=, 18
	i32.add 	$push19=, $pop66, $pop37
	i32.const	$push20=, 0
	i32.store16	$push21=, 0($pop19), $pop20
	i32.store16	$1=, 0($pop24), $pop21
	i32.const	$push36=, 16
	i32.add 	$push28=, $3, $pop36
	i64.store	$push16=, 40($3), $0
	i64.store	$push17=, 32($3):p2align=4, $pop16
	i64.store	$0=, 0($pop28):p2align=4, $pop17
	i32.const	$push35=, 18
	i32.add 	$push30=, $3, $pop35
	i32.store16	$discard=, 0($pop30), $1
	i64.store	$push29=, 8($3), $0
	i64.store	$discard=, 0($3):p2align=4, $pop29
	i64.const	$push22=, 0
	i64.store	$push23=, 74($3):p2align=1, $pop22
	i64.store	$push25=, 42($3):p2align=1, $pop23
	i64.store	$discard=, 10($3):p2align=1, $pop25
	block
	i32.const	$push67=, 64
	i32.add 	$push68=, $3, $pop67
	i32.const	$push34=, 30
	i32.call	$push31=, memcmp@FUNCTION, $pop68, $3, $pop34
	br_if   	0, $pop31       # 0: down to label0
# BB#1:                                 # %lor.lhs.false
	i32.const	$push69=, 32
	i32.add 	$push70=, $3, $pop69
	i32.const	$push43=, 30
	i32.call	$push32=, memcmp@FUNCTION, $pop70, $3, $pop43
	br_if   	0, $pop32       # 0: down to label0
# BB#2:                                 # %if.end
	i32.const	$push33=, 0
	i32.const	$push50=, __stack_pointer
	i32.const	$push48=, 96
	i32.add 	$push49=, $3, $pop48
	i32.store	$discard=, 0($pop50), $pop49
	return  	$pop33
.LBB0_3:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main


	.ident	"clang version 3.9.0 "
