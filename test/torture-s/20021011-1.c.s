	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20021011-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i64
# BB#0:                                 # %entry
	i32.const	$push56=, 0
	i32.const	$push55=, 0
	i32.load8_u	$push0=, .L.str+8($pop55)
	i32.store8	$0=, buf+8($pop56), $pop0
	i32.const	$push54=, 0
	i32.const	$push53=, 0
	i64.load	$push1=, .L.str($pop53):p2align=0
	i64.store	$1=, buf($pop54), $pop1
	block
	i32.const	$push52=, buf
	i32.const	$push51=, .L.str
	i32.call	$push2=, strcmp@FUNCTION, $pop52, $pop51
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %for.body.preheader
	i32.const	$push60=, 0
	i32.store8	$drop=, buf+8($pop60), $0
	i32.const	$push59=, 0
	i64.store	$drop=, buf($pop59), $1
	i32.const	$push58=, buf
	i32.const	$push57=, .L.str
	i32.call	$push3=, strcmp@FUNCTION, $pop58, $pop57
	br_if   	0, $pop3        # 0: down to label0
# BB#2:                                 # %for.cond
	i32.const	$push65=, 0
	i32.const	$push64=, 0
	i32.load8_u	$push4=, .L.str+8($pop64)
	i32.store8	$0=, buf+9($pop65), $pop4
	i32.const	$push63=, 0
	i32.const	$push62=, 0
	i64.load	$push5=, .L.str($pop62):p2align=0
	i64.store	$1=, buf+1($pop63):p2align=0, $pop5
	i32.const	$push6=, buf+1
	i32.const	$push61=, .L.str
	i32.call	$push7=, strcmp@FUNCTION, $pop6, $pop61
	br_if   	0, $pop7        # 0: down to label0
# BB#3:                                 # %for.cond.1
	i32.const	$push68=, 0
	i32.store8	$drop=, buf+10($pop68), $0
	i32.const	$push67=, 0
	i64.store	$drop=, buf+2($pop67):p2align=1, $1
	i32.const	$push8=, buf+2
	i32.const	$push66=, .L.str
	i32.call	$push9=, strcmp@FUNCTION, $pop8, $pop66
	br_if   	0, $pop9        # 0: down to label0
# BB#4:                                 # %for.cond.2
	i32.const	$push73=, 0
	i32.const	$push72=, 0
	i32.load8_u	$push10=, .L.str+8($pop72)
	i32.store8	$0=, buf+11($pop73), $pop10
	i32.const	$push71=, 0
	i32.const	$push70=, 0
	i64.load	$push11=, .L.str($pop70):p2align=0
	i64.store	$1=, buf+3($pop71):p2align=0, $pop11
	i32.const	$push12=, buf+3
	i32.const	$push69=, .L.str
	i32.call	$push13=, strcmp@FUNCTION, $pop12, $pop69
	br_if   	0, $pop13       # 0: down to label0
# BB#5:                                 # %for.cond.3
	i32.const	$push76=, 0
	i32.store8	$drop=, buf+12($pop76), $0
	i32.const	$push75=, 0
	i64.store	$drop=, buf+4($pop75):p2align=2, $1
	i32.const	$push14=, buf+4
	i32.const	$push74=, .L.str
	i32.call	$push15=, strcmp@FUNCTION, $pop14, $pop74
	br_if   	0, $pop15       # 0: down to label0
# BB#6:                                 # %for.cond.4
	i32.const	$push81=, 0
	i32.const	$push80=, 0
	i32.load8_u	$push16=, .L.str+8($pop80)
	i32.store8	$0=, buf+13($pop81), $pop16
	i32.const	$push79=, 0
	i32.const	$push78=, 0
	i64.load	$push17=, .L.str($pop78):p2align=0
	i64.store	$1=, buf+5($pop79):p2align=0, $pop17
	i32.const	$push18=, buf+5
	i32.const	$push77=, .L.str
	i32.call	$push19=, strcmp@FUNCTION, $pop18, $pop77
	br_if   	0, $pop19       # 0: down to label0
# BB#7:                                 # %for.cond.5
	i32.const	$push84=, 0
	i32.store8	$drop=, buf+14($pop84), $0
	i32.const	$push83=, 0
	i64.store	$drop=, buf+6($pop83):p2align=1, $1
	i32.const	$push20=, buf+6
	i32.const	$push82=, .L.str
	i32.call	$push21=, strcmp@FUNCTION, $pop20, $pop82
	br_if   	0, $pop21       # 0: down to label0
# BB#8:                                 # %for.cond.6
	i32.const	$push89=, 0
	i32.const	$push88=, 0
	i32.load8_u	$push22=, .L.str+8($pop88)
	i32.store8	$0=, buf+15($pop89), $pop22
	i32.const	$push87=, 0
	i32.const	$push86=, 0
	i64.load	$push23=, .L.str($pop86):p2align=0
	i64.store	$1=, buf+7($pop87):p2align=0, $pop23
	i32.const	$push24=, buf+7
	i32.const	$push85=, .L.str
	i32.call	$push25=, strcmp@FUNCTION, $pop24, $pop85
	br_if   	0, $pop25       # 0: down to label0
# BB#9:                                 # %for.cond.7
	i32.const	$push92=, 0
	i32.store8	$drop=, buf+16($pop92), $0
	i32.const	$push91=, 0
	i64.store	$drop=, buf+8($pop91), $1
	i32.const	$push26=, buf+8
	i32.const	$push90=, .L.str
	i32.call	$push27=, strcmp@FUNCTION, $pop26, $pop90
	br_if   	0, $pop27       # 0: down to label0
# BB#10:                                # %for.cond.8
	i32.const	$push97=, 0
	i32.const	$push96=, 0
	i32.load8_u	$push28=, .L.str+8($pop96)
	i32.store8	$0=, buf+17($pop97), $pop28
	i32.const	$push95=, 0
	i32.const	$push94=, 0
	i64.load	$push29=, .L.str($pop94):p2align=0
	i64.store	$1=, buf+9($pop95):p2align=0, $pop29
	i32.const	$push30=, buf+9
	i32.const	$push93=, .L.str
	i32.call	$push31=, strcmp@FUNCTION, $pop30, $pop93
	br_if   	0, $pop31       # 0: down to label0
# BB#11:                                # %for.cond.9
	i32.const	$push100=, 0
	i32.store8	$drop=, buf+18($pop100), $0
	i32.const	$push99=, 0
	i64.store	$drop=, buf+10($pop99):p2align=1, $1
	i32.const	$push32=, buf+10
	i32.const	$push98=, .L.str
	i32.call	$push33=, strcmp@FUNCTION, $pop32, $pop98
	br_if   	0, $pop33       # 0: down to label0
# BB#12:                                # %for.cond.10
	i32.const	$push105=, 0
	i32.const	$push104=, 0
	i32.load8_u	$push34=, .L.str+8($pop104)
	i32.store8	$0=, buf+19($pop105), $pop34
	i32.const	$push103=, 0
	i32.const	$push102=, 0
	i64.load	$push35=, .L.str($pop102):p2align=0
	i64.store	$1=, buf+11($pop103):p2align=0, $pop35
	i32.const	$push36=, buf+11
	i32.const	$push101=, .L.str
	i32.call	$push37=, strcmp@FUNCTION, $pop36, $pop101
	br_if   	0, $pop37       # 0: down to label0
# BB#13:                                # %for.cond.11
	i32.const	$push108=, 0
	i32.store8	$drop=, buf+20($pop108), $0
	i32.const	$push107=, 0
	i64.store	$drop=, buf+12($pop107):p2align=2, $1
	i32.const	$push38=, buf+12
	i32.const	$push106=, .L.str
	i32.call	$push39=, strcmp@FUNCTION, $pop38, $pop106
	br_if   	0, $pop39       # 0: down to label0
# BB#14:                                # %for.cond.12
	i32.const	$push113=, 0
	i32.const	$push112=, 0
	i32.load8_u	$push40=, .L.str+8($pop112)
	i32.store8	$0=, buf+21($pop113), $pop40
	i32.const	$push111=, 0
	i32.const	$push110=, 0
	i64.load	$push41=, .L.str($pop110):p2align=0
	i64.store	$1=, buf+13($pop111):p2align=0, $pop41
	i32.const	$push42=, buf+13
	i32.const	$push109=, .L.str
	i32.call	$push43=, strcmp@FUNCTION, $pop42, $pop109
	br_if   	0, $pop43       # 0: down to label0
# BB#15:                                # %for.cond.13
	i32.const	$push116=, 0
	i32.store8	$drop=, buf+22($pop116), $0
	i32.const	$push115=, 0
	i64.store	$drop=, buf+14($pop115):p2align=1, $1
	i32.const	$push44=, buf+14
	i32.const	$push114=, .L.str
	i32.call	$push45=, strcmp@FUNCTION, $pop44, $pop114
	br_if   	0, $pop45       # 0: down to label0
# BB#16:                                # %for.cond.14
	i32.const	$push120=, 0
	i32.const	$push119=, 0
	i32.load8_u	$push46=, .L.str+8($pop119)
	i32.store8	$drop=, buf+23($pop120), $pop46
	i32.const	$push118=, 0
	i32.const	$push117=, 0
	i64.load	$push47=, .L.str($pop117):p2align=0
	i64.store	$drop=, buf+15($pop118):p2align=0, $pop47
	i32.const	$push49=, buf+15
	i32.const	$push48=, .L.str
	i32.call	$push50=, strcmp@FUNCTION, $pop49, $pop48
	br_if   	0, $pop50       # 0: down to label0
# BB#17:                                # %for.cond.15
	i32.const	$push121=, 0
	return  	$pop121
.LBB0_18:                               # %if.then7
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	buf                     # @buf
	.type	buf,@object
	.section	.bss.buf,"aw",@nobits
	.globl	buf
	.p2align	4
buf:
	.skip	64
	.size	buf, 64

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"mystring"
	.size	.L.str, 9


	.ident	"clang version 3.9.0 "
	.functype	strcmp, i32, i32, i32
	.functype	abort, void
