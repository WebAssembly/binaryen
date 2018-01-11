	.text
	.file	"20020508-2.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i64, i64, i64, i64, i64, i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.load	$1=, shift1($pop0)
	i32.const	$push119=, 0
	i32.load8_s	$0=, c($pop119)
	i32.const	$push2=, 8
	i32.sub 	$2=, $pop2, $1
	block   	
	i32.shl 	$push3=, $0, $2
	i32.shr_s	$push1=, $0, $1
	i32.or  	$push4=, $pop3, $pop1
	i32.const	$push118=, 835
	i32.ne  	$push5=, $pop4, $pop118
	br_if   	0, $pop5        # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$push6=, 4
	i32.shr_s	$push8=, $0, $pop6
	i32.const	$push121=, 4
	i32.shl 	$push7=, $0, $pop121
	i32.or  	$push9=, $pop8, $pop7
	i32.const	$push120=, 835
	i32.ne  	$push10=, $pop9, $pop120
	br_if   	0, $pop10       # 0: down to label0
# %bb.2:                                # %if.end11
	i32.const	$push11=, 16
	i32.sub 	$4=, $pop11, $1
	i32.const	$push12=, 0
	i32.load16_s	$3=, s($pop12)
	i32.shr_s	$push14=, $3, $1
	i32.shl 	$push13=, $3, $4
	i32.or  	$push15=, $pop14, $pop13
	i32.const	$push122=, 19087651
	i32.ne  	$push16=, $pop15, $pop122
	br_if   	0, $pop16       # 0: down to label0
# %bb.3:                                # %if.end21
	i32.const	$push19=, 4
	i32.shr_s	$push20=, $3, $pop19
	i32.const	$push17=, 12
	i32.shl 	$push18=, $3, $pop17
	i32.or  	$push21=, $pop20, $pop18
	i32.const	$push123=, 19087651
	i32.ne  	$push22=, $pop21, $pop123
	br_if   	0, $pop22       # 0: down to label0
# %bb.4:                                # %if.end30
	i32.const	$push23=, 32
	i32.sub 	$6=, $pop23, $1
	i32.const	$push24=, 0
	i32.load	$5=, i($pop24)
	i32.shr_s	$push26=, $5, $1
	i32.shl 	$push25=, $5, $6
	i32.or  	$push27=, $pop26, $pop25
	i32.const	$push124=, 1073742115
	i32.ne  	$push28=, $pop27, $pop124
	br_if   	0, $pop28       # 0: down to label0
# %bb.5:                                # %if.end38
	i32.const	$push31=, 4
	i32.shr_s	$push32=, $5, $pop31
	i32.const	$push29=, 28
	i32.shl 	$push30=, $5, $pop29
	i32.or  	$push33=, $pop32, $pop30
	i32.const	$push125=, 1073742115
	i32.ne  	$push34=, $pop33, $pop125
	br_if   	0, $pop34       # 0: down to label0
# %bb.6:                                # %if.end45
	i32.const	$push35=, 0
	i32.load	$7=, l($pop35)
	i32.shr_s	$push37=, $7, $1
	i32.shl 	$push36=, $7, $6
	i32.or  	$push38=, $pop37, $pop36
	i32.const	$push126=, -2128394905
	i32.ne  	$push39=, $pop38, $pop126
	br_if   	0, $pop39       # 0: down to label0
# %bb.7:                                # %if.end53
	i32.const	$push42=, 4
	i32.shr_s	$push43=, $7, $pop42
	i32.const	$push40=, 28
	i32.shl 	$push41=, $7, $pop40
	i32.or  	$push44=, $pop43, $pop41
	i32.const	$push127=, -2128394905
	i32.ne  	$push45=, $pop44, $pop127
	br_if   	0, $pop45       # 0: down to label0
# %bb.8:                                # %if.end60
	i64.extend_u/i32	$9=, $1
	i32.const	$push46=, 0
	i64.load	$8=, ll($pop46)
	i32.const	$push48=, 64
	i32.sub 	$push49=, $pop48, $1
	i64.extend_u/i32	$10=, $pop49
	i64.shr_s	$push47=, $8, $9
	i64.shl 	$push50=, $8, $10
	i64.or  	$push51=, $pop47, $pop50
	i64.const	$push128=, 5124095577148911
	i64.ne  	$push52=, $pop51, $pop128
	br_if   	0, $pop52       # 0: down to label0
# %bb.9:                                # %if.end69
	i64.const	$push55=, 4
	i64.shr_s	$push56=, $8, $pop55
	i64.const	$push53=, 60
	i64.shl 	$push54=, $8, $pop53
	i64.or  	$push57=, $pop56, $pop54
	i64.const	$push129=, 5124095577148911
	i64.ne  	$push58=, $pop57, $pop129
	br_if   	0, $pop58       # 0: down to label0
# %bb.10:                               # %if.end76
	i32.const	$push59=, 0
	i32.load	$13=, shift2($pop59)
	i64.extend_u/i32	$11=, $13
	i32.const	$push61=, 64
	i32.sub 	$push62=, $pop61, $13
	i64.extend_u/i32	$12=, $pop62
	i64.shl 	$push63=, $8, $12
	i64.shr_s	$push60=, $8, $11
	i64.or  	$push64=, $pop63, $pop60
	i64.const	$push130=, 1311768467750121216
	i64.ne  	$push65=, $pop64, $pop130
	br_if   	0, $pop65       # 0: down to label0
# %bb.11:                               # %if.end86
	i64.const	$push68=, 60
	i64.shr_s	$push69=, $8, $pop68
	i64.const	$push66=, 4
	i64.shl 	$push67=, $8, $pop66
	i64.or  	$push70=, $pop69, $pop67
	i64.const	$push131=, 1311768467750121216
	i64.ne  	$push71=, $pop70, $pop131
	br_if   	0, $pop71       # 0: down to label0
# %bb.12:                               # %if.end93
	i32.shr_s	$push73=, $0, $2
	i32.shl 	$push72=, $0, $1
	i32.or  	$push74=, $pop73, $pop72
	i32.const	$push75=, 835
	i32.ne  	$push76=, $pop74, $pop75
	br_if   	0, $pop76       # 0: down to label0
# %bb.13:                               # %if.end112
	i32.shl 	$push78=, $3, $1
	i32.shr_s	$push77=, $3, $4
	i32.or  	$push79=, $pop78, $pop77
	i32.const	$push132=, 74561
	i32.ne  	$push80=, $pop79, $pop132
	br_if   	0, $pop80       # 0: down to label0
# %bb.14:                               # %if.end122
	i32.const	$push83=, 4
	i32.shl 	$push84=, $3, $pop83
	i32.const	$push81=, 12
	i32.shr_s	$push82=, $3, $pop81
	i32.or  	$push85=, $pop84, $pop82
	i32.const	$push133=, 74561
	i32.ne  	$push86=, $pop85, $pop133
	br_if   	0, $pop86       # 0: down to label0
# %bb.15:                               # %if.end131
	i32.shl 	$push88=, $5, $1
	i32.shr_s	$push87=, $5, $6
	i32.or  	$push89=, $pop88, $pop87
	i32.const	$push134=, 74560
	i32.ne  	$push90=, $pop89, $pop134
	br_if   	0, $pop90       # 0: down to label0
# %bb.16:                               # %if.end139
	i32.const	$push93=, 4
	i32.shl 	$push94=, $5, $pop93
	i32.const	$push91=, 28
	i32.shr_s	$push92=, $5, $pop91
	i32.or  	$push95=, $pop94, $pop92
	i32.const	$push135=, 74560
	i32.ne  	$push96=, $pop95, $pop135
	br_if   	0, $pop96       # 0: down to label0
# %bb.17:                               # %if.end146
	i32.shl 	$push98=, $7, $1
	i32.shr_s	$push97=, $7, $6
	i32.or  	$push99=, $pop98, $pop97
	i32.const	$push136=, 591751041
	i32.ne  	$push100=, $pop99, $pop136
	br_if   	0, $pop100      # 0: down to label0
# %bb.18:                               # %if.end154
	i32.const	$push103=, 4
	i32.shl 	$push104=, $7, $pop103
	i32.const	$push101=, 28
	i32.shr_s	$push102=, $7, $pop101
	i32.or  	$push105=, $pop104, $pop102
	i32.const	$push137=, 591751041
	i32.ne  	$push106=, $pop105, $pop137
	br_if   	0, $pop106      # 0: down to label0
# %bb.19:                               # %if.end161
	i64.shl 	$push108=, $8, $9
	i64.shr_s	$push107=, $8, $10
	i64.or  	$push109=, $pop108, $pop107
	i64.const	$push110=, 1311768467750121216
	i64.ne  	$push111=, $pop109, $pop110
	br_if   	0, $pop111      # 0: down to label0
# %bb.20:                               # %if.end178
	i64.shr_s	$push113=, $8, $12
	i64.shl 	$push112=, $8, $11
	i64.or  	$push114=, $pop113, $pop112
	i64.const	$push115=, 5124095577148911
	i64.ne  	$push116=, $pop114, $pop115
	br_if   	0, $pop116      # 0: down to label0
# %bb.21:                               # %if.end195
	i32.const	$push117=, 0
	call    	exit@FUNCTION, $pop117
	unreachable
.LBB0_22:                               # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.hidden	c                       # @c
	.type	c,@object
	.section	.data.c,"aw",@progbits
	.globl	c
c:
	.int8	52                      # 0x34
	.size	c, 1

	.hidden	s                       # @s
	.type	s,@object
	.section	.data.s,"aw",@progbits
	.globl	s
	.p2align	1
s:
	.int16	4660                    # 0x1234
	.size	s, 2

	.hidden	i                       # @i
	.type	i,@object
	.section	.data.i,"aw",@progbits
	.globl	i
	.p2align	2
i:
	.int32	4660                    # 0x1234
	.size	i, 4

	.hidden	l                       # @l
	.type	l,@object
	.section	.data.l,"aw",@progbits
	.globl	l
	.p2align	2
l:
	.int32	305419896               # 0x12345678
	.size	l, 4

	.hidden	ll                      # @ll
	.type	ll,@object
	.section	.data.ll,"aw",@progbits
	.globl	ll
	.p2align	3
ll:
	.int64	81985529234382576       # 0x12345678abcdef0
	.size	ll, 8

	.hidden	shift1                  # @shift1
	.type	shift1,@object
	.section	.data.shift1,"aw",@progbits
	.globl	shift1
	.p2align	2
shift1:
	.int32	4                       # 0x4
	.size	shift1, 4

	.hidden	shift2                  # @shift2
	.type	shift2,@object
	.section	.data.shift2,"aw",@progbits
	.globl	shift2
	.p2align	2
shift2:
	.int32	60                      # 0x3c
	.size	shift2, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
