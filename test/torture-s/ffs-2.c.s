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
	i32.const	$push61=, 0
	i64.load	$push0=, ffstesttab($pop61):p2align=4
	tee_local	$push60=, $1=, $pop0
	i32.wrap/i64	$0=, $pop60
	block
	i32.ctz 	$push1=, $0
	i32.const	$push59=, 1
	i32.add 	$push2=, $pop1, $pop59
	i32.const	$push58=, 0
	i32.select	$push3=, $0, $pop2, $pop58
	i64.const	$push57=, 32
	i64.shr_u	$push4=, $1, $pop57
	i32.wrap/i64	$push5=, $pop4
	i32.ne  	$push6=, $pop3, $pop5
	br_if   	$pop6, 0        # 0: down to label0
# BB#1:                                 # %for.cond
	i32.const	$push66=, 0
	i64.load	$push7=, ffstesttab+8($pop66)
	tee_local	$push65=, $1=, $pop7
	i32.wrap/i64	$0=, $pop65
	i32.ctz 	$push8=, $0
	i32.const	$push64=, 1
	i32.add 	$push9=, $pop8, $pop64
	i32.const	$push63=, 0
	i32.select	$push10=, $0, $pop9, $pop63
	i64.const	$push62=, 32
	i64.shr_u	$push11=, $1, $pop62
	i32.wrap/i64	$push12=, $pop11
	i32.ne  	$push13=, $pop10, $pop12
	br_if   	$pop13, 0       # 0: down to label0
# BB#2:                                 # %for.cond.1
	i32.const	$push71=, 0
	i64.load	$push14=, ffstesttab+16($pop71):p2align=4
	tee_local	$push70=, $1=, $pop14
	i32.wrap/i64	$0=, $pop70
	i32.ctz 	$push15=, $0
	i32.const	$push69=, 1
	i32.add 	$push16=, $pop15, $pop69
	i32.const	$push68=, 0
	i32.select	$push17=, $0, $pop16, $pop68
	i64.const	$push67=, 32
	i64.shr_u	$push18=, $1, $pop67
	i32.wrap/i64	$push19=, $pop18
	i32.ne  	$push20=, $pop17, $pop19
	br_if   	$pop20, 0       # 0: down to label0
# BB#3:                                 # %for.cond.2
	i32.const	$push76=, 0
	i64.load	$push21=, ffstesttab+24($pop76)
	tee_local	$push75=, $1=, $pop21
	i32.wrap/i64	$0=, $pop75
	i32.ctz 	$push22=, $0
	i32.const	$push74=, 1
	i32.add 	$push23=, $pop22, $pop74
	i32.const	$push73=, 0
	i32.select	$push24=, $0, $pop23, $pop73
	i64.const	$push72=, 32
	i64.shr_u	$push25=, $1, $pop72
	i32.wrap/i64	$push26=, $pop25
	i32.ne  	$push27=, $pop24, $pop26
	br_if   	$pop27, 0       # 0: down to label0
# BB#4:                                 # %for.cond.3
	i32.const	$push81=, 0
	i64.load	$push28=, ffstesttab+32($pop81):p2align=4
	tee_local	$push80=, $1=, $pop28
	i32.wrap/i64	$0=, $pop80
	i32.ctz 	$push29=, $0
	i32.const	$push79=, 1
	i32.add 	$push30=, $pop29, $pop79
	i32.const	$push78=, 0
	i32.select	$push31=, $0, $pop30, $pop78
	i64.const	$push77=, 32
	i64.shr_u	$push32=, $1, $pop77
	i32.wrap/i64	$push33=, $pop32
	i32.ne  	$push34=, $pop31, $pop33
	br_if   	$pop34, 0       # 0: down to label0
# BB#5:                                 # %for.cond.4
	i32.const	$push86=, 0
	i64.load	$push35=, ffstesttab+40($pop86)
	tee_local	$push85=, $1=, $pop35
	i32.wrap/i64	$0=, $pop85
	i32.ctz 	$push36=, $0
	i32.const	$push84=, 1
	i32.add 	$push37=, $pop36, $pop84
	i32.const	$push83=, 0
	i32.select	$push38=, $0, $pop37, $pop83
	i64.const	$push82=, 32
	i64.shr_u	$push39=, $1, $pop82
	i32.wrap/i64	$push40=, $pop39
	i32.ne  	$push41=, $pop38, $pop40
	br_if   	$pop41, 0       # 0: down to label0
# BB#6:                                 # %for.cond.5
	i32.const	$push91=, 0
	i64.load	$push42=, ffstesttab+48($pop91):p2align=4
	tee_local	$push90=, $1=, $pop42
	i32.wrap/i64	$0=, $pop90
	i32.ctz 	$push43=, $0
	i32.const	$push89=, 1
	i32.add 	$push44=, $pop43, $pop89
	i32.const	$push88=, 0
	i32.select	$push45=, $0, $pop44, $pop88
	i64.const	$push87=, 32
	i64.shr_u	$push46=, $1, $pop87
	i32.wrap/i64	$push47=, $pop46
	i32.ne  	$push48=, $pop45, $pop47
	br_if   	$pop48, 0       # 0: down to label0
# BB#7:                                 # %for.cond.6
	i32.const	$push96=, 0
	i64.load	$push49=, ffstesttab+56($pop96)
	tee_local	$push95=, $1=, $pop49
	i32.wrap/i64	$0=, $pop95
	i32.ctz 	$push50=, $0
	i32.const	$push94=, 1
	i32.add 	$push51=, $pop50, $pop94
	i32.const	$push93=, 0
	i32.select	$push52=, $0, $pop51, $pop93
	i64.const	$push92=, 32
	i64.shr_u	$push53=, $1, $pop92
	i32.wrap/i64	$push54=, $pop53
	i32.ne  	$push55=, $pop52, $pop54
	br_if   	$pop55, 0       # 0: down to label0
# BB#8:                                 # %for.cond.7
	i32.const	$push56=, 0
	call    	exit@FUNCTION, $pop56
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
