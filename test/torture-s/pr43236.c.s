	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr43236.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push27=, 0
	i32.const	$push24=, 0
	i32.load	$push25=, __stack_pointer($pop24)
	i32.const	$push26=, 96
	i32.sub 	$push77=, $pop25, $pop26
	tee_local	$push76=, $0=, $pop77
	i32.store	__stack_pointer($pop27), $pop76
	i32.const	$push31=, 64
	i32.add 	$push32=, $0, $pop31
	i32.const	$push0=, 28
	i32.add 	$push1=, $pop32, $pop0
	i32.const	$push2=, 257
	i32.store16	0($pop1), $pop2
	i32.const	$push33=, 64
	i32.add 	$push34=, $0, $pop33
	i32.const	$push3=, 24
	i32.add 	$push4=, $pop34, $pop3
	i32.const	$push5=, 16843009
	i32.store	0($pop4), $pop5
	i32.const	$push35=, 64
	i32.add 	$push36=, $0, $pop35
	i32.const	$push6=, 16
	i32.add 	$push7=, $pop36, $pop6
	i64.const	$push8=, 72340172838076673
	i64.store	0($pop7), $pop8
	i32.const	$push37=, 32
	i32.add 	$push38=, $0, $pop37
	i32.const	$push75=, 28
	i32.add 	$push9=, $pop38, $pop75
	i32.const	$push74=, 257
	i32.store16	0($pop9), $pop74
	i32.const	$push39=, 32
	i32.add 	$push40=, $0, $pop39
	i32.const	$push73=, 24
	i32.add 	$push10=, $pop40, $pop73
	i32.const	$push72=, 16843009
	i32.store	0($pop10), $pop72
	i32.const	$push41=, 32
	i32.add 	$push42=, $0, $pop41
	i32.const	$push71=, 16
	i32.add 	$push11=, $pop42, $pop71
	i64.const	$push70=, 72340172838076673
	i64.store	0($pop11), $pop70
	i64.const	$push69=, 72340172838076673
	i64.store	64($0), $pop69
	i64.const	$push68=, 72340172838076673
	i64.store	72($0), $pop68
	i64.const	$push67=, 72340172838076673
	i64.store	40($0), $pop67
	i64.const	$push66=, 72340172838076673
	i64.store	32($0), $pop66
	i32.const	$push43=, 64
	i32.add 	$push44=, $0, $pop43
	i32.const	$push12=, 18
	i32.add 	$push13=, $pop44, $pop12
	i32.const	$push14=, 0
	i32.store16	0($pop13), $pop14
	i64.const	$push15=, 0
	i64.store	74($0):p2align=1, $pop15
	i32.const	$push45=, 32
	i32.add 	$push46=, $0, $pop45
	i32.const	$push65=, 18
	i32.add 	$push16=, $pop46, $pop65
	i32.const	$push64=, 0
	i32.store16	0($pop16), $pop64
	i64.const	$push63=, 0
	i64.store	42($0):p2align=1, $pop63
	i32.const	$push62=, 28
	i32.add 	$push17=, $0, $pop62
	i32.const	$push61=, 257
	i32.store16	0($pop17), $pop61
	i32.const	$push60=, 24
	i32.add 	$push18=, $0, $pop60
	i32.const	$push59=, 16843009
	i32.store	0($pop18), $pop59
	i32.const	$push58=, 16
	i32.add 	$push19=, $0, $pop58
	i64.const	$push57=, 72340172838076673
	i64.store	0($pop19), $pop57
	i64.const	$push56=, 72340172838076673
	i64.store	8($0), $pop56
	i64.const	$push55=, 72340172838076673
	i64.store	0($0), $pop55
	i32.const	$push54=, 18
	i32.add 	$push20=, $0, $pop54
	i32.const	$push53=, 0
	i32.store16	0($pop20), $pop53
	i64.const	$push52=, 0
	i64.store	10($0):p2align=1, $pop52
	block   	
	i32.const	$push47=, 64
	i32.add 	$push48=, $0, $pop47
	i32.const	$push51=, 30
	i32.call	$push21=, memcmp@FUNCTION, $pop48, $0, $pop51
	br_if   	0, $pop21       # 0: down to label0
# BB#1:                                 # %lor.lhs.false
	i32.const	$push49=, 32
	i32.add 	$push50=, $0, $pop49
	i32.const	$push78=, 30
	i32.call	$push22=, memcmp@FUNCTION, $pop50, $0, $pop78
	br_if   	0, $pop22       # 0: down to label0
# BB#2:                                 # %if.end
	i32.const	$push30=, 0
	i32.const	$push28=, 96
	i32.add 	$push29=, $0, $pop28
	i32.store	__stack_pointer($pop30), $pop29
	i32.const	$push23=, 0
	return  	$pop23
.LBB0_3:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	memcmp, i32, i32, i32, i32
	.functype	abort, void
