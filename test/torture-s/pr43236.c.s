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
	i32.const	$push47=, __stack_pointer
	i32.load	$push48=, 0($pop47)
	i32.const	$push49=, 96
	i32.sub 	$2=, $pop48, $pop49
	i32.const	$push50=, __stack_pointer
	i32.store	$discard=, 0($pop50), $2
	i32.const	$push0=, 28
	i32.add 	$push29=, $2, $pop0
	i32.const	$push54=, 32
	i32.add 	$push55=, $2, $pop54
	i32.const	$push45=, 28
	i32.add 	$push14=, $pop55, $pop45
	i32.const	$push56=, 64
	i32.add 	$push57=, $2, $pop56
	i32.const	$push44=, 28
	i32.add 	$push1=, $pop57, $pop44
	i32.const	$push2=, 257
	i32.store16	$push3=, 0($pop1), $pop2
	i32.store16	$push15=, 0($pop14), $pop3
	i32.store16	$discard=, 0($pop29), $pop15
	i32.const	$push4=, 24
	i32.add 	$push30=, $2, $pop4
	i32.const	$push58=, 32
	i32.add 	$push59=, $2, $pop58
	i32.const	$push43=, 24
	i32.add 	$push16=, $pop59, $pop43
	i32.const	$push60=, 64
	i32.add 	$push61=, $2, $pop60
	i32.const	$push42=, 24
	i32.add 	$push5=, $pop61, $pop42
	i32.const	$push6=, 16843009
	i32.store	$push7=, 0($pop5), $pop6
	i32.store	$push17=, 0($pop16), $pop7
	i32.store	$discard=, 0($pop30), $pop17
	i32.const	$push62=, 32
	i32.add 	$push63=, $2, $pop62
	i32.const	$push8=, 16
	i32.add 	$push18=, $pop63, $pop8
	i32.const	$push64=, 64
	i32.add 	$push65=, $2, $pop64
	i32.const	$push41=, 16
	i32.add 	$push9=, $pop65, $pop41
	i64.const	$push10=, 72340172838076673
	i64.store	$push11=, 0($pop9), $pop10
	i64.store	$push12=, 64($2), $pop11
	i64.store	$push13=, 72($2), $pop12
	i64.store	$0=, 0($pop18), $pop13
	i32.const	$push66=, 32
	i32.add 	$push67=, $2, $pop66
	i32.const	$push21=, 18
	i32.add 	$push27=, $pop67, $pop21
	i32.const	$push68=, 64
	i32.add 	$push69=, $2, $pop68
	i32.const	$push40=, 18
	i32.add 	$push22=, $pop69, $pop40
	i32.const	$push23=, 0
	i32.store16	$push24=, 0($pop22), $pop23
	i32.store16	$1=, 0($pop27), $pop24
	i32.const	$push39=, 16
	i32.add 	$push31=, $2, $pop39
	i64.store	$push19=, 40($2), $0
	i64.store	$push20=, 32($2), $pop19
	i64.store	$0=, 0($pop31), $pop20
	i32.const	$push38=, 18
	i32.add 	$push33=, $2, $pop38
	i32.store16	$discard=, 0($pop33), $1
	i64.store	$push32=, 8($2), $0
	i64.store	$discard=, 0($2), $pop32
	i64.const	$push25=, 0
	i64.store	$push26=, 74($2):p2align=1, $pop25
	i64.store	$push28=, 42($2):p2align=1, $pop26
	i64.store	$discard=, 10($2):p2align=1, $pop28
	block
	i32.const	$push70=, 64
	i32.add 	$push71=, $2, $pop70
	i32.const	$push37=, 30
	i32.call	$push34=, memcmp@FUNCTION, $pop71, $2, $pop37
	br_if   	0, $pop34       # 0: down to label0
# BB#1:                                 # %lor.lhs.false
	i32.const	$push72=, 32
	i32.add 	$push73=, $2, $pop72
	i32.const	$push46=, 30
	i32.call	$push35=, memcmp@FUNCTION, $pop73, $2, $pop46
	br_if   	0, $pop35       # 0: down to label0
# BB#2:                                 # %if.end
	i32.const	$push36=, 0
	i32.const	$push53=, __stack_pointer
	i32.const	$push51=, 96
	i32.add 	$push52=, $2, $pop51
	i32.store	$discard=, 0($pop53), $pop52
	return  	$pop36
.LBB0_3:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main


	.ident	"clang version 3.9.0 "
