	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/ffs-2.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i64
# BB#0:                                 # %entry
	block
	i32.const	$push56=, 0
	i64.load	$push55=, ffstesttab($pop56):p2align=4
	tee_local	$push54=, $1=, $pop55
	i32.wrap/i64	$push53=, $pop54
	tee_local	$push52=, $0=, $pop53
	i32.ctz 	$push0=, $pop52
	i32.const	$push51=, 1
	i32.add 	$push1=, $pop0, $pop51
	i32.const	$push50=, 0
	i32.select	$push2=, $pop1, $pop50, $0
	i64.const	$push49=, 32
	i64.shr_u	$push3=, $1, $pop49
	i32.wrap/i64	$push4=, $pop3
	i32.ne  	$push5=, $pop2, $pop4
	br_if   	0, $pop5        # 0: down to label0
# BB#1:                                 # %for.cond
	i32.const	$push64=, 0
	i64.load	$push63=, ffstesttab+8($pop64)
	tee_local	$push62=, $1=, $pop63
	i32.wrap/i64	$push61=, $pop62
	tee_local	$push60=, $0=, $pop61
	i32.ctz 	$push6=, $pop60
	i32.const	$push59=, 1
	i32.add 	$push7=, $pop6, $pop59
	i32.const	$push58=, 0
	i32.select	$push8=, $pop7, $pop58, $0
	i64.const	$push57=, 32
	i64.shr_u	$push9=, $1, $pop57
	i32.wrap/i64	$push10=, $pop9
	i32.ne  	$push11=, $pop8, $pop10
	br_if   	0, $pop11       # 0: down to label0
# BB#2:                                 # %for.cond.1
	i32.const	$push72=, 0
	i64.load	$push71=, ffstesttab+16($pop72):p2align=4
	tee_local	$push70=, $1=, $pop71
	i32.wrap/i64	$push69=, $pop70
	tee_local	$push68=, $0=, $pop69
	i32.ctz 	$push12=, $pop68
	i32.const	$push67=, 1
	i32.add 	$push13=, $pop12, $pop67
	i32.const	$push66=, 0
	i32.select	$push14=, $pop13, $pop66, $0
	i64.const	$push65=, 32
	i64.shr_u	$push15=, $1, $pop65
	i32.wrap/i64	$push16=, $pop15
	i32.ne  	$push17=, $pop14, $pop16
	br_if   	0, $pop17       # 0: down to label0
# BB#3:                                 # %for.cond.2
	i32.const	$push80=, 0
	i64.load	$push79=, ffstesttab+24($pop80)
	tee_local	$push78=, $1=, $pop79
	i32.wrap/i64	$push77=, $pop78
	tee_local	$push76=, $0=, $pop77
	i32.ctz 	$push18=, $pop76
	i32.const	$push75=, 1
	i32.add 	$push19=, $pop18, $pop75
	i32.const	$push74=, 0
	i32.select	$push20=, $pop19, $pop74, $0
	i64.const	$push73=, 32
	i64.shr_u	$push21=, $1, $pop73
	i32.wrap/i64	$push22=, $pop21
	i32.ne  	$push23=, $pop20, $pop22
	br_if   	0, $pop23       # 0: down to label0
# BB#4:                                 # %for.cond.3
	i32.const	$push88=, 0
	i64.load	$push87=, ffstesttab+32($pop88):p2align=4
	tee_local	$push86=, $1=, $pop87
	i32.wrap/i64	$push85=, $pop86
	tee_local	$push84=, $0=, $pop85
	i32.ctz 	$push24=, $pop84
	i32.const	$push83=, 1
	i32.add 	$push25=, $pop24, $pop83
	i32.const	$push82=, 0
	i32.select	$push26=, $pop25, $pop82, $0
	i64.const	$push81=, 32
	i64.shr_u	$push27=, $1, $pop81
	i32.wrap/i64	$push28=, $pop27
	i32.ne  	$push29=, $pop26, $pop28
	br_if   	0, $pop29       # 0: down to label0
# BB#5:                                 # %for.cond.4
	i32.const	$push96=, 0
	i64.load	$push95=, ffstesttab+40($pop96)
	tee_local	$push94=, $1=, $pop95
	i32.wrap/i64	$push93=, $pop94
	tee_local	$push92=, $0=, $pop93
	i32.ctz 	$push30=, $pop92
	i32.const	$push91=, 1
	i32.add 	$push31=, $pop30, $pop91
	i32.const	$push90=, 0
	i32.select	$push32=, $pop31, $pop90, $0
	i64.const	$push89=, 32
	i64.shr_u	$push33=, $1, $pop89
	i32.wrap/i64	$push34=, $pop33
	i32.ne  	$push35=, $pop32, $pop34
	br_if   	0, $pop35       # 0: down to label0
# BB#6:                                 # %for.cond.5
	i32.const	$push104=, 0
	i64.load	$push103=, ffstesttab+48($pop104):p2align=4
	tee_local	$push102=, $1=, $pop103
	i32.wrap/i64	$push101=, $pop102
	tee_local	$push100=, $0=, $pop101
	i32.ctz 	$push36=, $pop100
	i32.const	$push99=, 1
	i32.add 	$push37=, $pop36, $pop99
	i32.const	$push98=, 0
	i32.select	$push38=, $pop37, $pop98, $0
	i64.const	$push97=, 32
	i64.shr_u	$push39=, $1, $pop97
	i32.wrap/i64	$push40=, $pop39
	i32.ne  	$push41=, $pop38, $pop40
	br_if   	0, $pop41       # 0: down to label0
# BB#7:                                 # %for.cond.6
	i32.const	$push112=, 0
	i64.load	$push111=, ffstesttab+56($pop112)
	tee_local	$push110=, $1=, $pop111
	i32.wrap/i64	$push109=, $pop110
	tee_local	$push108=, $0=, $pop109
	i32.ctz 	$push42=, $pop108
	i32.const	$push107=, 1
	i32.add 	$push43=, $pop42, $pop107
	i32.const	$push106=, 0
	i32.select	$push44=, $pop43, $pop106, $0
	i64.const	$push105=, 32
	i64.shr_u	$push45=, $1, $pop105
	i32.wrap/i64	$push46=, $pop45
	i32.ne  	$push47=, $pop44, $pop46
	br_if   	0, $pop47       # 0: down to label0
# BB#8:                                 # %for.cond.7
	i32.const	$push48=, 0
	call    	exit@FUNCTION, $pop48
	unreachable
.LBB0_9:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	ffstesttab              # @ffstesttab
	.type	ffstesttab,@object
	.section	.data.ffstesttab,"aw",@progbits
	.globl	ffstesttab
	.p2align	4
ffstesttab:
	.int32	2147483648              # 0x80000000
	.int32	32                      # 0x20
	.int32	2779096485              # 0xa5a5a5a5
	.int32	1                       # 0x1
	.int32	1515870810              # 0x5a5a5a5a
	.int32	2                       # 0x2
	.int32	3405643776              # 0xcafe0000
	.int32	18                      # 0x12
	.int32	32768                   # 0x8000
	.int32	16                      # 0x10
	.int32	42405                   # 0xa5a5
	.int32	1                       # 0x1
	.int32	23130                   # 0x5a5a
	.int32	2                       # 0x2
	.int32	3232                    # 0xca0
	.int32	6                       # 0x6
	.size	ffstesttab, 64


	.ident	"clang version 3.9.0 "
