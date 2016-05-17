	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr43236.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i64, i32, i32
# BB#0:                                 # %entry
	i32.const	$push40=, __stack_pointer
	i32.const	$push37=, __stack_pointer
	i32.load	$push38=, 0($pop37)
	i32.const	$push39=, 96
	i32.sub 	$push64=, $pop38, $pop39
	i32.store	$push75=, 0($pop40), $pop64
	tee_local	$push74=, $2=, $pop75
	i32.const	$push13=, 28
	i32.add 	$push30=, $pop74, $pop13
	i32.const	$push46=, 32
	i32.add 	$push47=, $2, $pop46
	i32.const	$push73=, 28
	i32.add 	$push22=, $pop47, $pop73
	i32.const	$push44=, 64
	i32.add 	$push45=, $2, $pop44
	i32.const	$push72=, 28
	i32.add 	$push14=, $pop45, $pop72
	i32.const	$push15=, 257
	i32.store16	$push0=, 0($pop14), $pop15
	i32.store16	$push5=, 0($pop22), $pop0
	i32.store16	$drop=, 0($pop30), $pop5
	i32.const	$push16=, 24
	i32.add 	$push31=, $2, $pop16
	i32.const	$push50=, 32
	i32.add 	$push51=, $2, $pop50
	i32.const	$push71=, 24
	i32.add 	$push23=, $pop51, $pop71
	i32.const	$push48=, 64
	i32.add 	$push49=, $2, $pop48
	i32.const	$push70=, 24
	i32.add 	$push17=, $pop49, $pop70
	i32.const	$push18=, 16843009
	i32.store	$push1=, 0($pop17), $pop18
	i32.store	$push6=, 0($pop23), $pop1
	i32.store	$drop=, 0($pop31), $pop6
	i32.const	$push54=, 32
	i32.add 	$push55=, $2, $pop54
	i32.const	$push19=, 16
	i32.add 	$push24=, $pop55, $pop19
	i32.const	$push52=, 64
	i32.add 	$push53=, $2, $pop52
	i32.const	$push69=, 16
	i32.add 	$push20=, $pop53, $pop69
	i64.const	$push21=, 72340172838076673
	i64.store	$push2=, 0($pop20), $pop21
	i64.store	$0=, 0($pop24), $pop2
	i32.const	$push58=, 32
	i32.add 	$push59=, $2, $pop58
	i32.const	$push25=, 18
	i32.add 	$push29=, $pop59, $pop25
	i32.const	$push56=, 64
	i32.add 	$push57=, $2, $pop56
	i32.const	$push68=, 18
	i32.add 	$push26=, $pop57, $pop68
	i32.const	$push27=, 0
	i32.store16	$push9=, 0($pop26), $pop27
	i32.store16	$1=, 0($pop29), $pop9
	i32.const	$push67=, 16
	i32.add 	$push32=, $2, $pop67
	i64.store	$drop=, 0($pop32), $0
	i32.const	$push66=, 18
	i32.add 	$push33=, $2, $pop66
	i32.store16	$drop=, 0($pop33), $1
	i64.store	$push3=, 64($2), $0
	i64.store	$push4=, 72($2), $pop3
	i64.store	$push7=, 40($2), $pop4
	i64.store	$push8=, 32($2), $pop7
	i64.store	$push12=, 8($2), $pop8
	i64.store	$drop=, 0($2), $pop12
	i64.const	$push28=, 0
	i64.store	$push10=, 74($2):p2align=1, $pop28
	i64.store	$push11=, 42($2):p2align=1, $pop10
	i64.store	$drop=, 10($2):p2align=1, $pop11
	block
	i32.const	$push60=, 64
	i32.add 	$push61=, $2, $pop60
	i32.const	$push65=, 30
	i32.call	$push34=, memcmp@FUNCTION, $pop61, $2, $pop65
	br_if   	0, $pop34       # 0: down to label0
# BB#1:                                 # %lor.lhs.false
	i32.const	$push62=, 32
	i32.add 	$push63=, $2, $pop62
	i32.const	$push76=, 30
	i32.call	$push35=, memcmp@FUNCTION, $pop63, $2, $pop76
	br_if   	0, $pop35       # 0: down to label0
# BB#2:                                 # %if.end
	i32.const	$push43=, __stack_pointer
	i32.const	$push41=, 96
	i32.add 	$push42=, $2, $pop41
	i32.store	$drop=, 0($pop43), $pop42
	i32.const	$push36=, 0
	return  	$pop36
.LBB0_3:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main


	.ident	"clang version 3.9.0 "
