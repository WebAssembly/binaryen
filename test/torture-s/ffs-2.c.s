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
	i32.const	$push70=, 0
	i64.load	$push0=, ffstesttab($pop70):p2align=4
	tee_local	$push69=, $1=, $pop0
	i32.wrap/i64	$push1=, $pop69
	tee_local	$push68=, $0=, $pop1
	i32.ctz 	$push2=, $pop68
	i32.const	$push67=, 1
	i32.add 	$push3=, $pop2, $pop67
	i32.const	$push66=, 0
	i32.select	$push4=, $pop3, $pop66, $0
	i64.const	$push65=, 32
	i64.shr_u	$push5=, $1, $pop65
	i32.wrap/i64	$push6=, $pop5
	i32.ne  	$push7=, $pop4, $pop6
	br_if   	$pop7, 0        # 0: down to label0
# BB#1:                                 # %for.cond
	i32.const	$push76=, 0
	i64.load	$push8=, ffstesttab+8($pop76)
	tee_local	$push75=, $1=, $pop8
	i32.wrap/i64	$push9=, $pop75
	tee_local	$push74=, $0=, $pop9
	i32.ctz 	$push10=, $pop74
	i32.const	$push73=, 1
	i32.add 	$push11=, $pop10, $pop73
	i32.const	$push72=, 0
	i32.select	$push12=, $pop11, $pop72, $0
	i64.const	$push71=, 32
	i64.shr_u	$push13=, $1, $pop71
	i32.wrap/i64	$push14=, $pop13
	i32.ne  	$push15=, $pop12, $pop14
	br_if   	$pop15, 0       # 0: down to label0
# BB#2:                                 # %for.cond.1
	i32.const	$push82=, 0
	i64.load	$push16=, ffstesttab+16($pop82):p2align=4
	tee_local	$push81=, $1=, $pop16
	i32.wrap/i64	$push17=, $pop81
	tee_local	$push80=, $0=, $pop17
	i32.ctz 	$push18=, $pop80
	i32.const	$push79=, 1
	i32.add 	$push19=, $pop18, $pop79
	i32.const	$push78=, 0
	i32.select	$push20=, $pop19, $pop78, $0
	i64.const	$push77=, 32
	i64.shr_u	$push21=, $1, $pop77
	i32.wrap/i64	$push22=, $pop21
	i32.ne  	$push23=, $pop20, $pop22
	br_if   	$pop23, 0       # 0: down to label0
# BB#3:                                 # %for.cond.2
	i32.const	$push88=, 0
	i64.load	$push24=, ffstesttab+24($pop88)
	tee_local	$push87=, $1=, $pop24
	i32.wrap/i64	$push25=, $pop87
	tee_local	$push86=, $0=, $pop25
	i32.ctz 	$push26=, $pop86
	i32.const	$push85=, 1
	i32.add 	$push27=, $pop26, $pop85
	i32.const	$push84=, 0
	i32.select	$push28=, $pop27, $pop84, $0
	i64.const	$push83=, 32
	i64.shr_u	$push29=, $1, $pop83
	i32.wrap/i64	$push30=, $pop29
	i32.ne  	$push31=, $pop28, $pop30
	br_if   	$pop31, 0       # 0: down to label0
# BB#4:                                 # %for.cond.3
	i32.const	$push94=, 0
	i64.load	$push32=, ffstesttab+32($pop94):p2align=4
	tee_local	$push93=, $1=, $pop32
	i32.wrap/i64	$push33=, $pop93
	tee_local	$push92=, $0=, $pop33
	i32.ctz 	$push34=, $pop92
	i32.const	$push91=, 1
	i32.add 	$push35=, $pop34, $pop91
	i32.const	$push90=, 0
	i32.select	$push36=, $pop35, $pop90, $0
	i64.const	$push89=, 32
	i64.shr_u	$push37=, $1, $pop89
	i32.wrap/i64	$push38=, $pop37
	i32.ne  	$push39=, $pop36, $pop38
	br_if   	$pop39, 0       # 0: down to label0
# BB#5:                                 # %for.cond.4
	i32.const	$push100=, 0
	i64.load	$push40=, ffstesttab+40($pop100)
	tee_local	$push99=, $1=, $pop40
	i32.wrap/i64	$push41=, $pop99
	tee_local	$push98=, $0=, $pop41
	i32.ctz 	$push42=, $pop98
	i32.const	$push97=, 1
	i32.add 	$push43=, $pop42, $pop97
	i32.const	$push96=, 0
	i32.select	$push44=, $pop43, $pop96, $0
	i64.const	$push95=, 32
	i64.shr_u	$push45=, $1, $pop95
	i32.wrap/i64	$push46=, $pop45
	i32.ne  	$push47=, $pop44, $pop46
	br_if   	$pop47, 0       # 0: down to label0
# BB#6:                                 # %for.cond.5
	i32.const	$push106=, 0
	i64.load	$push48=, ffstesttab+48($pop106):p2align=4
	tee_local	$push105=, $1=, $pop48
	i32.wrap/i64	$push49=, $pop105
	tee_local	$push104=, $0=, $pop49
	i32.ctz 	$push50=, $pop104
	i32.const	$push103=, 1
	i32.add 	$push51=, $pop50, $pop103
	i32.const	$push102=, 0
	i32.select	$push52=, $pop51, $pop102, $0
	i64.const	$push101=, 32
	i64.shr_u	$push53=, $1, $pop101
	i32.wrap/i64	$push54=, $pop53
	i32.ne  	$push55=, $pop52, $pop54
	br_if   	$pop55, 0       # 0: down to label0
# BB#7:                                 # %for.cond.6
	i32.const	$push112=, 0
	i64.load	$push56=, ffstesttab+56($pop112)
	tee_local	$push111=, $1=, $pop56
	i32.wrap/i64	$push57=, $pop111
	tee_local	$push110=, $0=, $pop57
	i32.ctz 	$push58=, $pop110
	i32.const	$push109=, 1
	i32.add 	$push59=, $pop58, $pop109
	i32.const	$push108=, 0
	i32.select	$push60=, $pop59, $pop108, $0
	i64.const	$push107=, 32
	i64.shr_u	$push61=, $1, $pop107
	i32.wrap/i64	$push62=, $pop61
	i32.ne  	$push63=, $pop60, $pop62
	br_if   	$pop63, 0       # 0: down to label0
# BB#8:                                 # %for.cond.7
	i32.const	$push64=, 0
	call    	exit@FUNCTION, $pop64
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
