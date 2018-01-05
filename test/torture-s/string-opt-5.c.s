	.text
	.file	"string-opt-5.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push134=, 0
	i32.load	$push133=, __stack_pointer($pop134)
	i32.const	$push135=, 64
	i32.sub 	$4=, $pop133, $pop135
	i32.const	$push136=, 0
	i32.store	__stack_pointer($pop136), $4
	i32.const	$push140=, 0
	i32.load	$0=, bar($pop140)
	block   	
	i32.call	$push0=, strlen@FUNCTION, $0
	i32.const	$push1=, 8
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$push142=, 0
	i32.load	$1=, x($pop142)
	i32.const	$push3=, 1
	i32.add 	$2=, $1, $pop3
	i32.const	$push141=, 0
	i32.store	x($pop141), $2
	i32.const	$push4=, 2
	i32.and 	$push5=, $2, $pop4
	i32.add 	$push6=, $0, $pop5
	i32.call	$push7=, strlen@FUNCTION, $pop6
	i32.const	$push8=, 6
	i32.ne  	$push9=, $pop7, $pop8
	br_if   	0, $pop9        # 0: down to label0
# %bb.2:                                # %if.end4
	i32.const	$push10=, 7
	i32.ne  	$push11=, $2, $pop10
	br_if   	0, $pop11       # 0: down to label0
# %bb.3:                                # %if.end25
	i32.const	$push12=, -3
	i32.add 	$2=, $1, $pop12
	i32.const	$push143=, 0
	i32.store	x($pop143), $2
	i32.const	$push13=, .L.str.1-3
	i32.add 	$push14=, $1, $pop13
	i32.const	$push15=, .L.str.2
	i32.call	$push16=, strcmp@FUNCTION, $pop14, $pop15
	br_if   	0, $pop16       # 0: down to label0
# %bb.4:                                # %if.end32
	i32.const	$push145=, .L.str.1
	i32.call	$push17=, strcmp@FUNCTION, $pop145, $0
	i32.const	$push144=, 0
	i32.ge_s	$push18=, $pop17, $pop144
	br_if   	0, $pop18       # 0: down to label0
# %bb.5:                                # %if.end36
	i32.const	$push19=, -2
	i32.add 	$3=, $1, $pop19
	i32.const	$push148=, 0
	i32.store	x($pop148), $3
	i32.const	$push147=, .L.str.1
	i32.const	$push20=, 1
	i32.and 	$push21=, $2, $pop20
	i32.add 	$push22=, $0, $pop21
	i32.call	$push23=, strcmp@FUNCTION, $pop147, $pop22
	i32.const	$push146=, 0
	i32.ge_s	$push24=, $pop23, $pop146
	br_if   	0, $pop24       # 0: down to label0
# %bb.6:                                # %if.end46
	i32.const	$push25=, -1
	i32.add 	$2=, $1, $pop25
	i32.const	$push149=, 0
	i32.store	x($pop149), $2
	i32.const	$push26=, 7
	i32.and 	$push27=, $3, $pop26
	i32.const	$push28=, .L.str.1
	i32.add 	$push29=, $pop27, $pop28
	i32.const	$push30=, 108
	i32.call	$push31=, strchr@FUNCTION, $pop29, $pop30
	i32.const	$push32=, .L.str.1+9
	i32.ne  	$push33=, $pop31, $pop32
	br_if   	0, $pop33       # 0: down to label0
# %bb.7:                                # %if.end56
	i32.const	$push36=, 111
	i32.call	$3=, strchr@FUNCTION, $0, $pop36
	i32.const	$push34=, 4
	i32.add 	$push35=, $0, $pop34
	i32.ne  	$push37=, $3, $pop35
	br_if   	0, $pop37       # 0: down to label0
# %bb.8:                                # %if.end61
	i32.call	$push38=, strlen@FUNCTION, $0
	i32.const	$push39=, 8
	i32.ne  	$push40=, $pop38, $pop39
	br_if   	0, $pop40       # 0: down to label0
# %bb.9:                                # %if.end66
	i32.const	$push41=, 120
	i32.call	$push42=, strrchr@FUNCTION, $0, $pop41
	br_if   	0, $pop42       # 0: down to label0
# %bb.10:                               # %if.end70
	i32.const	$push43=, 111
	i32.call	$push44=, strrchr@FUNCTION, $0, $pop43
	i32.ne  	$push45=, $pop44, $3
	br_if   	0, $pop45       # 0: down to label0
# %bb.11:                               # %if.end75
	i32.const	$push46=, 0
	i32.store	x($pop46), $1
	i32.const	$push152=, 0
	i32.load	$push47=, y($pop152)
	i32.const	$push48=, -1
	i32.add 	$0=, $pop47, $pop48
	i32.const	$push151=, 0
	i32.store	y($pop151), $0
	i32.const	$push49=, 1
	i32.and 	$push50=, $2, $pop49
	i32.const	$push51=, .L.str.1
	i32.add 	$push52=, $pop50, $pop51
	i32.const	$push150=, 1
	i32.and 	$push53=, $0, $pop150
	i32.const	$push54=, .L.str.3
	i32.add 	$push55=, $pop53, $pop54
	i32.call	$push56=, strcmp@FUNCTION, $pop52, $pop55
	br_if   	0, $pop56       # 0: down to label0
# %bb.12:                               # %if.end84
	br_if   	0, $0           # 0: down to label0
# %bb.13:                               # %if.end88
	i32.const	$push156=, 0
	i32.const	$push57=, 1
	i32.store	y($pop156), $pop57
	i32.const	$push155=, 0
	i32.const	$push58=, 6
	i32.store	x($pop155), $pop58
	i32.const	$push154=, 32
	i32.store16	5($4):p2align=0, $pop154
	i32.const	$push59=, 1869376613
	i32.store	1($4):p2align=0, $pop59
	i32.const	$push153=, 1
	i32.or  	$0=, $4, $pop153
	i32.const	$push60=, .L.str.4
	i32.call	$push61=, strcmp@FUNCTION, $0, $pop60
	br_if   	0, $pop61       # 0: down to label0
# %bb.14:                               # %if.end106
	i32.const	$push167=, 0
	i32.const	$push166=, 7
	i32.store	x($pop167), $pop166
	i32.const	$push165=, 0
	i32.const	$push64=, 2
	i32.store	y($pop165), $pop64
	i32.const	$push65=, 56
	i32.add 	$push66=, $4, $pop65
	i64.const	$push67=, 2314885530818453536
	i64.store	0($pop66), $pop67
	i32.const	$push68=, 48
	i32.add 	$push69=, $4, $pop68
	i64.const	$push164=, 2314885530818453536
	i64.store	0($pop69), $pop164
	i32.const	$push70=, 40
	i32.add 	$push71=, $4, $pop70
	i64.const	$push163=, 2314885530818453536
	i64.store	0($pop71), $pop163
	i32.const	$push162=, 32
	i32.add 	$push72=, $4, $pop162
	i64.const	$push161=, 2314885530818453536
	i64.store	0($pop72), $pop161
	i32.const	$push73=, 24
	i32.add 	$push74=, $4, $pop73
	i64.const	$push160=, 2314885530818453536
	i64.store	0($pop74), $pop160
	i32.const	$push75=, 16
	i32.add 	$push76=, $4, $pop75
	i64.const	$push159=, 2314885530818453536
	i64.store	0($pop76), $pop159
	i64.const	$push158=, 2314885530818453536
	i64.store	8($4), $pop158
	i64.const	$push157=, 2314885530818453536
	i64.store	0($4), $pop157
	i32.const	$push78=, .L.str.5+1
	i32.const	$push77=, 10
	i32.call	$push79=, strncpy@FUNCTION, $0, $pop78, $pop77
	i32.ne  	$push80=, $pop79, $0
	br_if   	0, $pop80       # 0: down to label0
# %bb.15:                               # %if.end106
	i32.const	$push169=, 0
	i32.load	$push62=, x($pop169)
	i32.const	$push168=, 7
	i32.ne  	$push81=, $pop62, $pop168
	br_if   	0, $pop81       # 0: down to label0
# %bb.16:                               # %if.end106
	i32.const	$push170=, 0
	i32.load	$push63=, y($pop170)
	i32.const	$push82=, 2
	i32.ne  	$push83=, $pop63, $pop82
	br_if   	0, $pop83       # 0: down to label0
# %bb.17:                               # %lor.lhs.false123
	i32.const	$push85=, .L.str.6
	i32.const	$push84=, 12
	i32.call	$push86=, memcmp@FUNCTION, $4, $pop85, $pop84
	br_if   	0, $pop86       # 0: down to label0
# %bb.18:                               # %if.end128
	i32.const	$push87=, 56
	i32.add 	$push88=, $4, $pop87
	i64.const	$push89=, 2314885530818453536
	i64.store	0($pop88), $pop89
	i32.const	$push90=, 48
	i32.add 	$push91=, $4, $pop90
	i64.const	$push177=, 2314885530818453536
	i64.store	0($pop91), $pop177
	i32.const	$push92=, 40
	i32.add 	$push93=, $4, $pop92
	i64.const	$push176=, 2314885530818453536
	i64.store	0($pop93), $pop176
	i32.const	$push94=, 32
	i32.add 	$push95=, $4, $pop94
	i64.const	$push175=, 2314885530818453536
	i64.store	0($pop95), $pop175
	i32.const	$push96=, 24
	i32.add 	$push97=, $4, $pop96
	i64.const	$push174=, 2314885530818453536
	i64.store	0($pop97), $pop174
	i32.const	$push98=, 16
	i32.add 	$push99=, $4, $pop98
	i64.const	$push173=, 2314885530818453536
	i64.store	0($pop99), $pop173
	i64.const	$push172=, 2314885530818453536
	i64.store	8($4), $pop172
	i64.const	$push171=, 2314885530818453536
	i64.store	0($4), $pop171
	i32.const	$push101=, .L.str.7
	i32.const	$push100=, 8
	i32.call	$push102=, strncpy@FUNCTION, $4, $pop101, $pop100
	i32.ne  	$push103=, $pop102, $4
	br_if   	0, $pop103      # 0: down to label0
# %bb.19:                               # %lor.lhs.false134
	i32.const	$push105=, .L.str.8
	i32.const	$push104=, 9
	i32.call	$push106=, memcmp@FUNCTION, $4, $pop105, $pop104
	br_if   	0, $pop106      # 0: down to label0
# %bb.20:                               # %if.end139
	i32.const	$push108=, 0
	i64.const	$push107=, 2314885530818453536
	i64.store	buf+56($pop108), $pop107
	i32.const	$push195=, 0
	i64.const	$push194=, 2314885530818453536
	i64.store	buf+48($pop195), $pop194
	i32.const	$push193=, 0
	i64.const	$push192=, 2314885530818453536
	i64.store	buf+40($pop193), $pop192
	i32.const	$push191=, 0
	i64.const	$push190=, 2314885530818453536
	i64.store	buf+32($pop191), $pop190
	i32.const	$push189=, 0
	i64.const	$push188=, 2314885530818453536
	i64.store	buf+24($pop189), $pop188
	i32.const	$push187=, 0
	i64.const	$push186=, 2314885530818453536
	i64.store	buf+16($pop187), $pop186
	i32.const	$push185=, 0
	i64.const	$push184=, 2314885530818453536
	i64.store	buf+8($pop185), $pop184
	i32.const	$push183=, 0
	i64.const	$push182=, 2314885530818453536
	i64.store	buf($pop183), $pop182
	i32.const	$push181=, 0
	i32.const	$push109=, 34
	i32.store	x($pop181), $pop109
	i32.const	$push180=, 0
	i32.load	$0=, y($pop180)
	i32.const	$push110=, 1
	i32.add 	$1=, $0, $pop110
	i32.const	$push179=, 0
	i32.store	y($pop179), $1
	i32.const	$push112=, buf
	i32.const	$push111=, 33
	i32.call	$2=, memset@FUNCTION, $pop112, $pop111, $1
	i32.const	$push178=, 3
	i32.ne  	$push113=, $1, $pop178
	br_if   	0, $pop113      # 0: down to label0
# %bb.21:                               # %lor.lhs.false146
	i32.const	$push114=, .L.str.9
	i32.const	$push196=, 3
	i32.call	$push115=, memcmp@FUNCTION, $2, $pop114, $pop196
	br_if   	0, $pop115      # 0: down to label0
# %bb.22:                               # %lor.lhs.false156
	i32.const	$push199=, 0
	i64.const	$push116=, 3255307777713450285
	i64.store	buf+3($pop199):p2align=0, $pop116
	i32.const	$push198=, 0
	i32.const	$push117=, 2
	i32.add 	$push118=, $0, $pop117
	i32.store	y($pop198), $pop118
	i32.const	$push120=, buf
	i32.const	$push119=, .L.str.10
	i32.const	$push197=, 11
	i32.call	$push121=, memcmp@FUNCTION, $pop120, $pop119, $pop197
	br_if   	0, $pop121      # 0: down to label0
# %bb.23:                               # %lor.lhs.false169
	i32.const	$push204=, 0
	i32.const	$push203=, 11
	i32.store	x($pop204), $pop203
	i32.const	$push202=, 0
	i32.const	$push122=, 3
	i32.add 	$push123=, $0, $pop122
	i32.store	y($pop202), $pop123
	i32.const	$push201=, 0
	i32.const	$push200=, 0
	i32.store	buf+11($pop201):p2align=0, $pop200
	i32.const	$push126=, buf+8
	i32.const	$push125=, .L.str.11
	i32.const	$push124=, 7
	i32.call	$push127=, memcmp@FUNCTION, $pop126, $pop125, $pop124
	br_if   	0, $pop127      # 0: down to label0
# %bb.24:                               # %lor.lhs.false178
	i32.const	$push209=, 0
	i32.const	$push128=, 15
	i32.store	x($pop209), $pop128
	i32.const	$push208=, 0
	i32.const	$push207=, 0
	i32.store16	buf+19($pop208):p2align=0, $pop207
	i32.const	$push206=, 0
	i32.const	$push205=, 0
	i32.store	buf+15($pop206):p2align=0, $pop205
	i32.const	$push131=, buf+10
	i32.const	$push130=, .L.str.12
	i32.const	$push129=, 11
	i32.call	$push132=, memcmp@FUNCTION, $pop131, $pop130, $pop129
	br_if   	0, $pop132      # 0: down to label0
# %bb.25:                               # %if.end182
	i32.const	$push139=, 0
	i32.const	$push137=, 64
	i32.add 	$push138=, $4, $pop137
	i32.store	__stack_pointer($pop139), $pop138
	i32.const	$push210=, 0
	return  	$pop210
.LBB0_26:                               # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.hidden	x                       # @x
	.type	x,@object
	.section	.data.x,"aw",@progbits
	.globl	x
	.p2align	2
x:
	.int32	6                       # 0x6
	.size	x, 4

	.hidden	y                       # @y
	.type	y,@object
	.section	.data.y,"aw",@progbits
	.globl	y
	.p2align	2
y:
	.int32	1                       # 0x1
	.size	y, 4

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"hi world"
	.size	.L.str, 9

	.hidden	bar                     # @bar
	.type	bar,@object
	.section	.data.bar,"aw",@progbits
	.globl	bar
	.p2align	2
bar:
	.int32	.L.str
	.size	bar, 4

	.type	.L.str.1,@object        # @.str.1
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str.1:
	.asciz	"hello world"
	.size	.L.str.1, 12

	.type	.L.str.2,@object        # @.str.2
.L.str.2:
	.asciz	"lo world"
	.size	.L.str.2, 9

	.type	.L.str.3,@object        # @.str.3
.L.str.3:
	.asciz	"ello world"
	.size	.L.str.3, 11

	.type	.L.str.4,@object        # @.str.4
.L.str.4:
	.asciz	"ello "
	.size	.L.str.4, 6

	.type	.L.str.5,@object        # @.str.5
.L.str.5:
	.asciz	"foo"
	.size	.L.str.5, 4

	.type	.L.str.6,@object        # @.str.6
	.section	.rodata..L.str.6,"a",@progbits
.L.str.6:
	.asciz	" oo\000\000\000\000\000\000\000\000 "
	.size	.L.str.6, 13

	.type	.L.str.7,@object        # @.str.7
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str.7:
	.asciz	"hello"
	.size	.L.str.7, 6

	.type	.L.str.8,@object        # @.str.8
	.section	.rodata..L.str.8,"a",@progbits
.L.str.8:
	.asciz	"hello\000\000\000 "
	.size	.L.str.8, 10

	.hidden	buf                     # @buf
	.type	buf,@object
	.section	.bss.buf,"aw",@nobits
	.globl	buf
	.p2align	4
buf:
	.skip	64
	.size	buf, 64

	.type	.L.str.9,@object        # @.str.9
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str.9:
	.asciz	"!!!"
	.size	.L.str.9, 4

	.type	.L.str.10,@object       # @.str.10
.L.str.10:
	.asciz	"!!!--------"
	.size	.L.str.10, 12

	.type	.L.str.11,@object       # @.str.11
	.section	.rodata..L.str.11,"a",@progbits
.L.str.11:
	.asciz	"---\000\000\000"
	.size	.L.str.11, 7

	.type	.L.str.12,@object       # @.str.12
	.section	.rodata..L.str.12,"a",@progbits
.L.str.12:
	.asciz	"-\000\000\000\000\000\000\000\000\000"
	.size	.L.str.12, 11


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	strlen, i32, i32
	.functype	abort, void
	.functype	strcmp, i32, i32, i32
	.functype	strchr, i32, i32, i32
	.functype	strrchr, i32, i32, i32
	.functype	strncpy, i32, i32, i32, i32
	.functype	memcmp, i32, i32, i32, i32
