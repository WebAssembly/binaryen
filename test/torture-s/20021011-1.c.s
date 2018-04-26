	.text
	.file	"20021011-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i64
# %bb.0:                                # %entry
	i32.const	$push40=, 0
	i32.load8_u	$0=, .L.str+8($pop40)
	i32.const	$push39=, 0
	i32.store8	buf+8($pop39), $0
	i32.const	$push38=, 0
	i64.load	$1=, .L.str($pop38):p2align=0
	i32.const	$push37=, 0
	i64.store	buf($pop37), $1
	block   	
	i32.const	$push36=, buf
	i32.const	$push35=, .L.str
	i32.call	$push0=, strcmp@FUNCTION, $pop36, $pop35
	br_if   	0, $pop0        # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$push44=, 0
	i32.store8	buf+8($pop44), $0
	i32.const	$push43=, 0
	i64.store	buf($pop43), $1
	i32.const	$push42=, buf
	i32.const	$push41=, .L.str
	i32.call	$push1=, strcmp@FUNCTION, $pop42, $pop41
	br_if   	0, $pop1        # 0: down to label0
# %bb.2:                                # %for.cond
	i32.const	$push49=, 0
	i32.load8_u	$0=, .L.str+8($pop49)
	i32.const	$push48=, 0
	i32.store8	buf+9($pop48), $0
	i32.const	$push47=, 0
	i64.load	$1=, .L.str($pop47):p2align=0
	i32.const	$push46=, 0
	i64.store	buf+1($pop46):p2align=0, $1
	i32.const	$push2=, buf+1
	i32.const	$push45=, .L.str
	i32.call	$push3=, strcmp@FUNCTION, $pop2, $pop45
	br_if   	0, $pop3        # 0: down to label0
# %bb.3:                                # %for.cond.1
	i32.const	$push52=, 0
	i32.store8	buf+10($pop52), $0
	i32.const	$push51=, 0
	i64.store	buf+2($pop51):p2align=1, $1
	i32.const	$push4=, buf+2
	i32.const	$push50=, .L.str
	i32.call	$push5=, strcmp@FUNCTION, $pop4, $pop50
	br_if   	0, $pop5        # 0: down to label0
# %bb.4:                                # %for.cond.2
	i32.const	$push57=, 0
	i32.load8_u	$0=, .L.str+8($pop57)
	i32.const	$push56=, 0
	i32.store8	buf+11($pop56), $0
	i32.const	$push55=, 0
	i64.load	$1=, .L.str($pop55):p2align=0
	i32.const	$push54=, 0
	i64.store	buf+3($pop54):p2align=0, $1
	i32.const	$push6=, buf+3
	i32.const	$push53=, .L.str
	i32.call	$push7=, strcmp@FUNCTION, $pop6, $pop53
	br_if   	0, $pop7        # 0: down to label0
# %bb.5:                                # %for.cond.3
	i32.const	$push60=, 0
	i32.store8	buf+12($pop60), $0
	i32.const	$push59=, 0
	i64.store	buf+4($pop59):p2align=2, $1
	i32.const	$push8=, buf+4
	i32.const	$push58=, .L.str
	i32.call	$push9=, strcmp@FUNCTION, $pop8, $pop58
	br_if   	0, $pop9        # 0: down to label0
# %bb.6:                                # %for.cond.4
	i32.const	$push65=, 0
	i32.load8_u	$0=, .L.str+8($pop65)
	i32.const	$push64=, 0
	i32.store8	buf+13($pop64), $0
	i32.const	$push63=, 0
	i64.load	$1=, .L.str($pop63):p2align=0
	i32.const	$push62=, 0
	i64.store	buf+5($pop62):p2align=0, $1
	i32.const	$push10=, buf+5
	i32.const	$push61=, .L.str
	i32.call	$push11=, strcmp@FUNCTION, $pop10, $pop61
	br_if   	0, $pop11       # 0: down to label0
# %bb.7:                                # %for.cond.5
	i32.const	$push68=, 0
	i32.store8	buf+14($pop68), $0
	i32.const	$push67=, 0
	i64.store	buf+6($pop67):p2align=1, $1
	i32.const	$push12=, buf+6
	i32.const	$push66=, .L.str
	i32.call	$push13=, strcmp@FUNCTION, $pop12, $pop66
	br_if   	0, $pop13       # 0: down to label0
# %bb.8:                                # %for.cond.6
	i32.const	$push73=, 0
	i32.load8_u	$0=, .L.str+8($pop73)
	i32.const	$push72=, 0
	i32.store8	buf+15($pop72), $0
	i32.const	$push71=, 0
	i64.load	$1=, .L.str($pop71):p2align=0
	i32.const	$push70=, 0
	i64.store	buf+7($pop70):p2align=0, $1
	i32.const	$push14=, buf+7
	i32.const	$push69=, .L.str
	i32.call	$push15=, strcmp@FUNCTION, $pop14, $pop69
	br_if   	0, $pop15       # 0: down to label0
# %bb.9:                                # %for.cond.7
	i32.const	$push76=, 0
	i32.store8	buf+16($pop76), $0
	i32.const	$push75=, 0
	i64.store	buf+8($pop75), $1
	i32.const	$push16=, buf+8
	i32.const	$push74=, .L.str
	i32.call	$push17=, strcmp@FUNCTION, $pop16, $pop74
	br_if   	0, $pop17       # 0: down to label0
# %bb.10:                               # %for.cond.8
	i32.const	$push81=, 0
	i32.load8_u	$0=, .L.str+8($pop81)
	i32.const	$push80=, 0
	i32.store8	buf+17($pop80), $0
	i32.const	$push79=, 0
	i64.load	$1=, .L.str($pop79):p2align=0
	i32.const	$push78=, 0
	i64.store	buf+9($pop78):p2align=0, $1
	i32.const	$push18=, buf+9
	i32.const	$push77=, .L.str
	i32.call	$push19=, strcmp@FUNCTION, $pop18, $pop77
	br_if   	0, $pop19       # 0: down to label0
# %bb.11:                               # %for.cond.9
	i32.const	$push84=, 0
	i32.store8	buf+18($pop84), $0
	i32.const	$push83=, 0
	i64.store	buf+10($pop83):p2align=1, $1
	i32.const	$push20=, buf+10
	i32.const	$push82=, .L.str
	i32.call	$push21=, strcmp@FUNCTION, $pop20, $pop82
	br_if   	0, $pop21       # 0: down to label0
# %bb.12:                               # %for.cond.10
	i32.const	$push89=, 0
	i32.load8_u	$0=, .L.str+8($pop89)
	i32.const	$push88=, 0
	i32.store8	buf+19($pop88), $0
	i32.const	$push87=, 0
	i64.load	$1=, .L.str($pop87):p2align=0
	i32.const	$push86=, 0
	i64.store	buf+11($pop86):p2align=0, $1
	i32.const	$push22=, buf+11
	i32.const	$push85=, .L.str
	i32.call	$push23=, strcmp@FUNCTION, $pop22, $pop85
	br_if   	0, $pop23       # 0: down to label0
# %bb.13:                               # %for.cond.11
	i32.const	$push92=, 0
	i32.store8	buf+20($pop92), $0
	i32.const	$push91=, 0
	i64.store	buf+12($pop91):p2align=2, $1
	i32.const	$push24=, buf+12
	i32.const	$push90=, .L.str
	i32.call	$push25=, strcmp@FUNCTION, $pop24, $pop90
	br_if   	0, $pop25       # 0: down to label0
# %bb.14:                               # %for.cond.12
	i32.const	$push97=, 0
	i32.load8_u	$0=, .L.str+8($pop97)
	i32.const	$push96=, 0
	i32.store8	buf+21($pop96), $0
	i32.const	$push95=, 0
	i64.load	$1=, .L.str($pop95):p2align=0
	i32.const	$push94=, 0
	i64.store	buf+13($pop94):p2align=0, $1
	i32.const	$push26=, buf+13
	i32.const	$push93=, .L.str
	i32.call	$push27=, strcmp@FUNCTION, $pop26, $pop93
	br_if   	0, $pop27       # 0: down to label0
# %bb.15:                               # %for.cond.13
	i32.const	$push100=, 0
	i32.store8	buf+22($pop100), $0
	i32.const	$push99=, 0
	i64.store	buf+14($pop99):p2align=1, $1
	i32.const	$push28=, buf+14
	i32.const	$push98=, .L.str
	i32.call	$push29=, strcmp@FUNCTION, $pop28, $pop98
	br_if   	0, $pop29       # 0: down to label0
# %bb.16:                               # %for.cond.14
	i32.const	$push104=, 0
	i32.const	$push103=, 0
	i32.load8_u	$push30=, .L.str+8($pop103)
	i32.store8	buf+23($pop104), $pop30
	i32.const	$push102=, 0
	i32.const	$push101=, 0
	i64.load	$push31=, .L.str($pop101):p2align=0
	i64.store	buf+15($pop102):p2align=0, $pop31
	i32.const	$push33=, buf+15
	i32.const	$push32=, .L.str
	i32.call	$push34=, strcmp@FUNCTION, $pop33, $pop32
	br_if   	0, $pop34       # 0: down to label0
# %bb.17:                               # %for.cond.15
	i32.const	$push105=, 0
	return  	$pop105
.LBB0_18:                               # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
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


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	strcmp, i32, i32, i32
	.functype	abort, void
