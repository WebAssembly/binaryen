	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/string-opt-5.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push123=, 0
	i32.const	$push120=, 0
	i32.load	$push121=, __stack_pointer($pop120)
	i32.const	$push122=, 64
	i32.sub 	$push127=, $pop121, $pop122
	i32.store	$2=, __stack_pointer($pop123), $pop127
	block
	i32.const	$push130=, 0
	i32.load	$push129=, bar($pop130)
	tee_local	$push128=, $3=, $pop129
	i32.call	$push5=, strlen@FUNCTION, $pop128
	i32.const	$push6=, 8
	i32.ne  	$push7=, $pop5, $pop6
	br_if   	0, $pop7        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push136=, 0
	i32.const	$push135=, 0
	i32.load	$push134=, x($pop135)
	tee_local	$push133=, $4=, $pop134
	i32.const	$push8=, 1
	i32.add 	$push0=, $pop133, $pop8
	i32.store	$push132=, x($pop136), $pop0
	tee_local	$push131=, $0=, $pop132
	i32.const	$push9=, 2
	i32.and 	$push10=, $pop131, $pop9
	i32.add 	$push11=, $3, $pop10
	i32.call	$push12=, strlen@FUNCTION, $pop11
	i32.const	$push13=, 6
	i32.ne  	$push14=, $pop12, $pop13
	br_if   	0, $pop14       # 0: down to label0
# BB#2:                                 # %if.end4
	i32.const	$push15=, 7
	i32.ne  	$push16=, $0, $pop15
	br_if   	0, $pop16       # 0: down to label0
# BB#3:                                 # %if.end26
	i32.const	$push137=, 0
	i32.const	$push17=, -3
	i32.add 	$push1=, $4, $pop17
	i32.store	$0=, x($pop137), $pop1
	i32.const	$push18=, .L.str.1-3
	i32.add 	$push19=, $4, $pop18
	i32.const	$push20=, .L.str.2
	i32.call	$push21=, strcmp@FUNCTION, $pop19, $pop20
	br_if   	0, $pop21       # 0: down to label0
# BB#4:                                 # %if.end33
	i32.const	$push139=, .L.str.1
	i32.call	$push22=, strcmp@FUNCTION, $pop139, $3
	i32.const	$push138=, 0
	i32.ge_s	$push23=, $pop22, $pop138
	br_if   	0, $pop23       # 0: down to label0
# BB#5:                                 # %if.end37
	i32.const	$push142=, 0
	i32.const	$push24=, -2
	i32.add 	$push2=, $4, $pop24
	i32.store	$1=, x($pop142), $pop2
	i32.const	$push141=, .L.str.1
	i32.const	$push25=, 1
	i32.and 	$push26=, $0, $pop25
	i32.add 	$push27=, $3, $pop26
	i32.call	$push28=, strcmp@FUNCTION, $pop141, $pop27
	i32.const	$push140=, 0
	i32.ge_s	$push29=, $pop28, $pop140
	br_if   	0, $pop29       # 0: down to label0
# BB#6:                                 # %if.end47
	i32.const	$push143=, 0
	i32.const	$push30=, -1
	i32.add 	$push3=, $4, $pop30
	i32.store	$0=, x($pop143), $pop3
	i32.const	$push31=, 7
	i32.and 	$push32=, $1, $pop31
	i32.const	$push33=, .L.str.1
	i32.add 	$push34=, $pop32, $pop33
	i32.const	$push35=, 108
	i32.call	$push36=, strchr@FUNCTION, $pop34, $pop35
	i32.const	$push37=, .L.str.1+9
	i32.ne  	$push38=, $pop36, $pop37
	br_if   	0, $pop38       # 0: down to label0
# BB#7:                                 # %if.end58
	i32.const	$push41=, 111
	i32.call	$push145=, strchr@FUNCTION, $3, $pop41
	tee_local	$push144=, $1=, $pop145
	i32.const	$push39=, 4
	i32.add 	$push40=, $3, $pop39
	i32.ne  	$push42=, $pop144, $pop40
	br_if   	0, $pop42       # 0: down to label0
# BB#8:                                 # %if.end63
	i32.call	$push43=, strlen@FUNCTION, $3
	i32.const	$push44=, 8
	i32.ne  	$push45=, $pop43, $pop44
	br_if   	0, $pop45       # 0: down to label0
# BB#9:                                 # %if.end68
	i32.const	$push46=, 120
	i32.call	$push47=, strrchr@FUNCTION, $3, $pop46
	br_if   	0, $pop47       # 0: down to label0
# BB#10:                                # %if.end72
	i32.const	$push48=, 111
	i32.call	$push49=, strrchr@FUNCTION, $3, $pop48
	i32.ne  	$push50=, $pop49, $1
	br_if   	0, $pop50       # 0: down to label0
# BB#11:                                # %if.end77
	i32.const	$push51=, 0
	i32.store	$3=, x($pop51), $4
	i32.const	$push54=, 1
	i32.and 	$push55=, $0, $pop54
	i32.const	$push56=, .L.str.1
	i32.add 	$push57=, $pop55, $pop56
	i32.const	$push150=, 0
	i32.const	$push149=, 0
	i32.load	$push52=, y($pop149)
	i32.const	$push53=, -1
	i32.add 	$push4=, $pop52, $pop53
	i32.store	$push148=, y($pop150), $pop4
	tee_local	$push147=, $4=, $pop148
	i32.const	$push146=, 1
	i32.and 	$push58=, $pop147, $pop146
	i32.const	$push59=, .L.str.3
	i32.add 	$push60=, $pop58, $pop59
	i32.call	$push61=, strcmp@FUNCTION, $pop57, $pop60
	br_if   	0, $pop61       # 0: down to label0
# BB#12:                                # %if.end86
	br_if   	0, $4           # 0: down to label0
# BB#13:                                # %if.end86
	i32.const	$push151=, 6
	i32.ne  	$push62=, $3, $pop151
	br_if   	0, $pop62       # 0: down to label0
# BB#14:                                # %if.end90
	i32.const	$push156=, 0
	i32.const	$push63=, 1
	i32.store	$3=, y($pop156), $pop63
	i32.const	$push155=, 0
	i32.const	$push154=, 6
	i32.store	$drop=, x($pop155), $pop154
	i32.const	$push64=, 32
	i32.store16	$4=, 5($2):p2align=0, $pop64
	i32.const	$push65=, 1869376613
	i32.store	$drop=, 1($2):p2align=0, $pop65
	i32.or  	$push153=, $2, $3
	tee_local	$push152=, $3=, $pop153
	i32.const	$push66=, .L.str.4
	i32.call	$push67=, strcmp@FUNCTION, $pop152, $pop66
	br_if   	0, $pop67       # 0: down to label0
# BB#15:                                # %if.end108
	i32.const	$push70=, 64
	i32.call	$4=, memset@FUNCTION, $2, $4, $pop70
	i32.const	$push158=, 0
	i32.const	$push71=, 2
	i32.store	$drop=, y($pop158), $pop71
	i32.const	$push157=, 0
	i32.const	$push72=, 7
	i32.store	$2=, x($pop157), $pop72
	i32.const	$push74=, .L.str.5+1
	i32.const	$push73=, 10
	i32.call	$push75=, strncpy@FUNCTION, $3, $pop74, $pop73
	i32.ne  	$push76=, $pop75, $3
	br_if   	0, $pop76       # 0: down to label0
# BB#16:                                # %if.end108
	i32.const	$push159=, 0
	i32.load	$push68=, x($pop159)
	i32.ne  	$push77=, $pop68, $2
	br_if   	0, $pop77       # 0: down to label0
# BB#17:                                # %if.end108
	i32.const	$push160=, 0
	i32.load	$push69=, y($pop160)
	i32.const	$push78=, 2
	i32.ne  	$push79=, $pop69, $pop78
	br_if   	0, $pop79       # 0: down to label0
# BB#18:                                # %lor.lhs.false125
	i32.const	$push81=, .L.str.6
	i32.const	$push80=, 12
	i32.call	$push82=, memcmp@FUNCTION, $4, $pop81, $pop80
	br_if   	0, $pop82       # 0: down to label0
# BB#19:                                # %if.end130
	i32.const	$push84=, 32
	i32.const	$push83=, 64
	i32.call	$push162=, memset@FUNCTION, $4, $pop84, $pop83
	tee_local	$push161=, $3=, $pop162
	i32.const	$push86=, .L.str.7
	i32.const	$push85=, 8
	i32.call	$push87=, strncpy@FUNCTION, $3, $pop86, $pop85
	i32.ne  	$push88=, $pop161, $pop87
	br_if   	0, $pop88       # 0: down to label0
# BB#20:                                # %lor.lhs.false136
	i32.const	$push90=, .L.str.8
	i32.const	$push89=, 9
	i32.call	$push91=, memcmp@FUNCTION, $3, $pop90, $pop89
	br_if   	0, $pop91       # 0: down to label0
# BB#21:                                # %if.end141
	i32.const	$push94=, buf
	i32.const	$push93=, 32
	i32.const	$push92=, 64
	i32.call	$4=, memset@FUNCTION, $pop94, $pop93, $pop92
	i32.const	$push96=, 0
	i32.const	$push95=, 34
	i32.store	$drop=, x($pop96), $pop95
	i32.const	$push100=, 33
	i32.const	$push167=, 0
	i32.const	$push166=, 0
	i32.load	$push97=, y($pop166)
	i32.const	$push98=, 1
	i32.add 	$push99=, $pop97, $pop98
	i32.store	$push165=, y($pop167), $pop99
	tee_local	$push164=, $2=, $pop165
	i32.call	$drop=, memset@FUNCTION, $4, $pop100, $pop164
	i32.const	$push163=, 3
	i32.ne  	$push101=, $2, $pop163
	br_if   	0, $pop101      # 0: down to label0
# BB#22:                                # %lor.lhs.false148
	i32.const	$push102=, .L.str.9
	i32.const	$push168=, 3
	i32.call	$push103=, memcmp@FUNCTION, $4, $pop102, $pop168
	br_if   	0, $pop103      # 0: down to label0
# BB#23:                                # %lor.lhs.false158
	i32.const	$push171=, 0
	i64.const	$push104=, 3255307777713450285
	i64.store	$drop=, buf+3($pop171):p2align=0, $pop104
	i32.const	$push170=, 0
	i32.const	$push105=, 4
	i32.store	$drop=, y($pop170), $pop105
	i32.const	$push107=, buf
	i32.const	$push106=, .L.str.10
	i32.const	$push169=, 11
	i32.call	$push108=, memcmp@FUNCTION, $pop107, $pop106, $pop169
	br_if   	0, $pop108      # 0: down to label0
# BB#24:                                # %lor.lhs.false171
	i32.const	$push176=, 0
	i32.const	$push109=, 5
	i32.store	$drop=, y($pop176), $pop109
	i32.const	$push175=, 0
	i32.const	$push174=, 11
	i32.store	$drop=, x($pop175), $pop174
	i32.const	$push173=, 0
	i32.const	$push172=, 0
	i32.store	$drop=, buf+11($pop173):p2align=0, $pop172
	i32.const	$push112=, buf+8
	i32.const	$push111=, .L.str.11
	i32.const	$push110=, 7
	i32.call	$push113=, memcmp@FUNCTION, $pop112, $pop111, $pop110
	br_if   	0, $pop113      # 0: down to label0
# BB#25:                                # %lor.lhs.false180
	i32.const	$push115=, 0
	i32.const	$push114=, 15
	i32.store	$drop=, x($pop115), $pop114
	i32.const	$push180=, 0
	i32.const	$push179=, 0
	i32.store16	$push178=, buf+19($pop180):p2align=0, $pop179
	tee_local	$push177=, $4=, $pop178
	i32.store	$drop=, buf+15($pop177):p2align=0, $4
	i32.const	$push118=, buf+10
	i32.const	$push117=, .L.str.12
	i32.const	$push116=, 11
	i32.call	$push119=, memcmp@FUNCTION, $pop118, $pop117, $pop116
	br_if   	0, $pop119      # 0: down to label0
# BB#26:                                # %if.end184
	i32.const	$push126=, 0
	i32.const	$push124=, 64
	i32.add 	$push125=, $3, $pop124
	i32.store	$drop=, __stack_pointer($pop126), $pop125
	return  	$4
.LBB0_27:                               # %if.then183
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

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


	.ident	"clang version 3.9.0 "
	.functype	strlen, i32, i32
	.functype	abort, void
	.functype	strcmp, i32, i32, i32
	.functype	strchr, i32, i32, i32
	.functype	strrchr, i32, i32, i32
	.functype	strncpy, i32, i32, i32, i32
	.functype	memcmp, i32, i32, i32, i32
