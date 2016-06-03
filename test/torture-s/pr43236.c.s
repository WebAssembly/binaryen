	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr43236.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i64, i32, i64, i32
# BB#0:                                 # %entry
	i32.const	$push33=, 0
	i32.const	$push30=, 0
	i32.load	$push31=, __stack_pointer($pop30)
	i32.const	$push32=, 96
	i32.sub 	$push57=, $pop31, $pop32
	i32.store	$push68=, __stack_pointer($pop33), $pop57
	tee_local	$push67=, $5=, $pop68
	i32.const	$push37=, 64
	i32.add 	$push38=, $pop67, $pop37
	i32.const	$push6=, 28
	i32.add 	$push7=, $pop38, $pop6
	i32.const	$push8=, 257
	i32.store16	$0=, 0($pop7), $pop8
	i32.const	$push39=, 64
	i32.add 	$push40=, $5, $pop39
	i32.const	$push9=, 24
	i32.add 	$push10=, $pop40, $pop9
	i32.const	$push11=, 16843009
	i32.store	$1=, 0($pop10), $pop11
	i32.const	$push41=, 64
	i32.add 	$push42=, $5, $pop41
	i32.const	$push12=, 16
	i32.add 	$push13=, $pop42, $pop12
	i64.const	$push14=, 72340172838076673
	i64.store	$2=, 0($pop13), $pop14
	i32.const	$push43=, 32
	i32.add 	$push44=, $5, $pop43
	i32.const	$push66=, 28
	i32.add 	$push15=, $pop44, $pop66
	i32.store16	$drop=, 0($pop15), $0
	i32.const	$push45=, 32
	i32.add 	$push46=, $5, $pop45
	i32.const	$push65=, 24
	i32.add 	$push16=, $pop46, $pop65
	i32.store	$drop=, 0($pop16), $1
	i32.const	$push47=, 32
	i32.add 	$push48=, $5, $pop47
	i32.const	$push64=, 16
	i32.add 	$push17=, $pop48, $pop64
	i64.store	$push0=, 0($pop17), $2
	i64.store	$push1=, 64($5), $pop0
	i64.store	$push2=, 72($5), $pop1
	i64.store	$push3=, 40($5), $pop2
	i64.store	$2=, 32($5), $pop3
	i32.const	$push49=, 64
	i32.add 	$push50=, $5, $pop49
	i32.const	$push18=, 18
	i32.add 	$push19=, $pop50, $pop18
	i32.const	$push20=, 0
	i32.store16	$3=, 0($pop19), $pop20
	i64.const	$push21=, 0
	i64.store	$4=, 74($5):p2align=1, $pop21
	i32.const	$push51=, 32
	i32.add 	$push52=, $5, $pop51
	i32.const	$push63=, 18
	i32.add 	$push22=, $pop52, $pop63
	i32.store16	$drop=, 0($pop22), $3
	i64.store	$drop=, 42($5):p2align=1, $4
	i32.const	$push62=, 28
	i32.add 	$push23=, $5, $pop62
	i32.store16	$drop=, 0($pop23), $0
	i32.const	$push61=, 24
	i32.add 	$push24=, $5, $pop61
	i32.store	$drop=, 0($pop24), $1
	i32.const	$push60=, 16
	i32.add 	$push25=, $5, $pop60
	i64.store	$push4=, 0($pop25), $2
	i64.store	$push5=, 8($5), $pop4
	i64.store	$drop=, 0($5), $pop5
	i32.const	$push59=, 18
	i32.add 	$push26=, $5, $pop59
	i32.store16	$drop=, 0($pop26), $3
	i64.store	$drop=, 10($5):p2align=1, $4
	block
	i32.const	$push53=, 64
	i32.add 	$push54=, $5, $pop53
	i32.const	$push58=, 30
	i32.call	$push27=, memcmp@FUNCTION, $pop54, $5, $pop58
	br_if   	0, $pop27       # 0: down to label0
# BB#1:                                 # %lor.lhs.false
	i32.const	$push55=, 32
	i32.add 	$push56=, $5, $pop55
	i32.const	$push69=, 30
	i32.call	$push28=, memcmp@FUNCTION, $pop56, $5, $pop69
	br_if   	0, $pop28       # 0: down to label0
# BB#2:                                 # %if.end
	i32.const	$push36=, 0
	i32.const	$push34=, 96
	i32.add 	$push35=, $5, $pop34
	i32.store	$drop=, __stack_pointer($pop36), $pop35
	i32.const	$push29=, 0
	return  	$pop29
.LBB0_3:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main


	.ident	"clang version 3.9.0 "
	.functype	memcmp, i32, i32, i32, i32
	.functype	abort, void
