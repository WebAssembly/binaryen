	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20021011-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i64
# BB#0:                                 # %entry
	i32.const	$push44=, 0
	i32.const	$push43=, 0
	i32.load8_u	$push42=, .L.str+8($pop43)
	tee_local	$push41=, $0=, $pop42
	i32.store8	buf+8($pop44), $pop41
	i32.const	$push40=, 0
	i32.const	$push39=, 0
	i64.load	$push38=, .L.str($pop39):p2align=0
	tee_local	$push37=, $1=, $pop38
	i64.store	buf($pop40), $pop37
	block   	
	i32.const	$push36=, buf
	i32.const	$push35=, .L.str
	i32.call	$push0=, strcmp@FUNCTION, $pop36, $pop35
	br_if   	0, $pop0        # 0: down to label0
# BB#1:                                 # %for.body.preheader
	i32.const	$push48=, 0
	i32.store8	buf+8($pop48), $0
	i32.const	$push47=, 0
	i64.store	buf($pop47), $1
	i32.const	$push46=, buf
	i32.const	$push45=, .L.str
	i32.call	$push1=, strcmp@FUNCTION, $pop46, $pop45
	br_if   	0, $pop1        # 0: down to label0
# BB#2:                                 # %for.cond
	i32.const	$push57=, 0
	i32.const	$push56=, 0
	i32.load8_u	$push55=, .L.str+8($pop56)
	tee_local	$push54=, $0=, $pop55
	i32.store8	buf+9($pop57), $pop54
	i32.const	$push53=, 0
	i32.const	$push52=, 0
	i64.load	$push51=, .L.str($pop52):p2align=0
	tee_local	$push50=, $1=, $pop51
	i64.store	buf+1($pop53):p2align=0, $pop50
	i32.const	$push2=, buf+1
	i32.const	$push49=, .L.str
	i32.call	$push3=, strcmp@FUNCTION, $pop2, $pop49
	br_if   	0, $pop3        # 0: down to label0
# BB#3:                                 # %for.cond.1
	i32.const	$push60=, 0
	i32.store8	buf+10($pop60), $0
	i32.const	$push59=, 0
	i64.store	buf+2($pop59):p2align=1, $1
	i32.const	$push4=, buf+2
	i32.const	$push58=, .L.str
	i32.call	$push5=, strcmp@FUNCTION, $pop4, $pop58
	br_if   	0, $pop5        # 0: down to label0
# BB#4:                                 # %for.cond.2
	i32.const	$push69=, 0
	i32.const	$push68=, 0
	i32.load8_u	$push67=, .L.str+8($pop68)
	tee_local	$push66=, $0=, $pop67
	i32.store8	buf+11($pop69), $pop66
	i32.const	$push65=, 0
	i32.const	$push64=, 0
	i64.load	$push63=, .L.str($pop64):p2align=0
	tee_local	$push62=, $1=, $pop63
	i64.store	buf+3($pop65):p2align=0, $pop62
	i32.const	$push6=, buf+3
	i32.const	$push61=, .L.str
	i32.call	$push7=, strcmp@FUNCTION, $pop6, $pop61
	br_if   	0, $pop7        # 0: down to label0
# BB#5:                                 # %for.cond.3
	i32.const	$push72=, 0
	i32.store8	buf+12($pop72), $0
	i32.const	$push71=, 0
	i64.store	buf+4($pop71):p2align=2, $1
	i32.const	$push8=, buf+4
	i32.const	$push70=, .L.str
	i32.call	$push9=, strcmp@FUNCTION, $pop8, $pop70
	br_if   	0, $pop9        # 0: down to label0
# BB#6:                                 # %for.cond.4
	i32.const	$push81=, 0
	i32.const	$push80=, 0
	i32.load8_u	$push79=, .L.str+8($pop80)
	tee_local	$push78=, $0=, $pop79
	i32.store8	buf+13($pop81), $pop78
	i32.const	$push77=, 0
	i32.const	$push76=, 0
	i64.load	$push75=, .L.str($pop76):p2align=0
	tee_local	$push74=, $1=, $pop75
	i64.store	buf+5($pop77):p2align=0, $pop74
	i32.const	$push10=, buf+5
	i32.const	$push73=, .L.str
	i32.call	$push11=, strcmp@FUNCTION, $pop10, $pop73
	br_if   	0, $pop11       # 0: down to label0
# BB#7:                                 # %for.cond.5
	i32.const	$push84=, 0
	i32.store8	buf+14($pop84), $0
	i32.const	$push83=, 0
	i64.store	buf+6($pop83):p2align=1, $1
	i32.const	$push12=, buf+6
	i32.const	$push82=, .L.str
	i32.call	$push13=, strcmp@FUNCTION, $pop12, $pop82
	br_if   	0, $pop13       # 0: down to label0
# BB#8:                                 # %for.cond.6
	i32.const	$push93=, 0
	i32.const	$push92=, 0
	i32.load8_u	$push91=, .L.str+8($pop92)
	tee_local	$push90=, $0=, $pop91
	i32.store8	buf+15($pop93), $pop90
	i32.const	$push89=, 0
	i32.const	$push88=, 0
	i64.load	$push87=, .L.str($pop88):p2align=0
	tee_local	$push86=, $1=, $pop87
	i64.store	buf+7($pop89):p2align=0, $pop86
	i32.const	$push14=, buf+7
	i32.const	$push85=, .L.str
	i32.call	$push15=, strcmp@FUNCTION, $pop14, $pop85
	br_if   	0, $pop15       # 0: down to label0
# BB#9:                                 # %for.cond.7
	i32.const	$push96=, 0
	i32.store8	buf+16($pop96), $0
	i32.const	$push95=, 0
	i64.store	buf+8($pop95), $1
	i32.const	$push16=, buf+8
	i32.const	$push94=, .L.str
	i32.call	$push17=, strcmp@FUNCTION, $pop16, $pop94
	br_if   	0, $pop17       # 0: down to label0
# BB#10:                                # %for.cond.8
	i32.const	$push105=, 0
	i32.const	$push104=, 0
	i32.load8_u	$push103=, .L.str+8($pop104)
	tee_local	$push102=, $0=, $pop103
	i32.store8	buf+17($pop105), $pop102
	i32.const	$push101=, 0
	i32.const	$push100=, 0
	i64.load	$push99=, .L.str($pop100):p2align=0
	tee_local	$push98=, $1=, $pop99
	i64.store	buf+9($pop101):p2align=0, $pop98
	i32.const	$push18=, buf+9
	i32.const	$push97=, .L.str
	i32.call	$push19=, strcmp@FUNCTION, $pop18, $pop97
	br_if   	0, $pop19       # 0: down to label0
# BB#11:                                # %for.cond.9
	i32.const	$push108=, 0
	i32.store8	buf+18($pop108), $0
	i32.const	$push107=, 0
	i64.store	buf+10($pop107):p2align=1, $1
	i32.const	$push20=, buf+10
	i32.const	$push106=, .L.str
	i32.call	$push21=, strcmp@FUNCTION, $pop20, $pop106
	br_if   	0, $pop21       # 0: down to label0
# BB#12:                                # %for.cond.10
	i32.const	$push117=, 0
	i32.const	$push116=, 0
	i32.load8_u	$push115=, .L.str+8($pop116)
	tee_local	$push114=, $0=, $pop115
	i32.store8	buf+19($pop117), $pop114
	i32.const	$push113=, 0
	i32.const	$push112=, 0
	i64.load	$push111=, .L.str($pop112):p2align=0
	tee_local	$push110=, $1=, $pop111
	i64.store	buf+11($pop113):p2align=0, $pop110
	i32.const	$push22=, buf+11
	i32.const	$push109=, .L.str
	i32.call	$push23=, strcmp@FUNCTION, $pop22, $pop109
	br_if   	0, $pop23       # 0: down to label0
# BB#13:                                # %for.cond.11
	i32.const	$push120=, 0
	i32.store8	buf+20($pop120), $0
	i32.const	$push119=, 0
	i64.store	buf+12($pop119):p2align=2, $1
	i32.const	$push24=, buf+12
	i32.const	$push118=, .L.str
	i32.call	$push25=, strcmp@FUNCTION, $pop24, $pop118
	br_if   	0, $pop25       # 0: down to label0
# BB#14:                                # %for.cond.12
	i32.const	$push129=, 0
	i32.const	$push128=, 0
	i32.load8_u	$push127=, .L.str+8($pop128)
	tee_local	$push126=, $0=, $pop127
	i32.store8	buf+21($pop129), $pop126
	i32.const	$push125=, 0
	i32.const	$push124=, 0
	i64.load	$push123=, .L.str($pop124):p2align=0
	tee_local	$push122=, $1=, $pop123
	i64.store	buf+13($pop125):p2align=0, $pop122
	i32.const	$push26=, buf+13
	i32.const	$push121=, .L.str
	i32.call	$push27=, strcmp@FUNCTION, $pop26, $pop121
	br_if   	0, $pop27       # 0: down to label0
# BB#15:                                # %for.cond.13
	i32.const	$push132=, 0
	i32.store8	buf+22($pop132), $0
	i32.const	$push131=, 0
	i64.store	buf+14($pop131):p2align=1, $1
	i32.const	$push28=, buf+14
	i32.const	$push130=, .L.str
	i32.call	$push29=, strcmp@FUNCTION, $pop28, $pop130
	br_if   	0, $pop29       # 0: down to label0
# BB#16:                                # %for.cond.14
	i32.const	$push136=, 0
	i32.const	$push135=, 0
	i32.load8_u	$push30=, .L.str+8($pop135)
	i32.store8	buf+23($pop136), $pop30
	i32.const	$push134=, 0
	i32.const	$push133=, 0
	i64.load	$push31=, .L.str($pop133):p2align=0
	i64.store	buf+15($pop134):p2align=0, $pop31
	i32.const	$push33=, buf+15
	i32.const	$push32=, .L.str
	i32.call	$push34=, strcmp@FUNCTION, $pop33, $pop32
	br_if   	0, $pop34       # 0: down to label0
# BB#17:                                # %for.cond.15
	i32.const	$push137=, 0
	return  	$pop137
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	strcmp, i32, i32, i32
	.functype	abort, void
