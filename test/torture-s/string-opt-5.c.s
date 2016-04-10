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
	i32.const	$push178=, __stack_pointer
	i32.load	$push179=, 0($pop178)
	i32.const	$push180=, 64
	i32.sub 	$4=, $pop179, $pop180
	i32.const	$push181=, __stack_pointer
	i32.store	$discard=, 0($pop181), $4
	block
	i32.const	$push133=, 0
	i32.load	$push132=, bar($pop133)
	tee_local	$push131=, $1=, $pop132
	i32.call	$push5=, strlen@FUNCTION, $pop131
	i32.const	$push6=, 8
	i32.ne  	$push7=, $pop5, $pop6
	br_if   	0, $pop7        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push139=, 0
	i32.const	$push138=, 0
	i32.load	$push137=, x($pop138)
	tee_local	$push136=, $3=, $pop137
	i32.const	$push8=, 1
	i32.add 	$push0=, $pop136, $pop8
	i32.store	$push135=, x($pop139), $pop0
	tee_local	$push134=, $2=, $pop135
	i32.const	$push9=, 2
	i32.and 	$push10=, $pop134, $pop9
	i32.add 	$push11=, $1, $pop10
	i32.call	$push12=, strlen@FUNCTION, $pop11
	i32.const	$push13=, 6
	i32.ne  	$push14=, $pop12, $pop13
	br_if   	0, $pop14       # 0: down to label0
# BB#2:                                 # %if.end4
	i32.const	$push15=, 7
	i32.ne  	$push16=, $2, $pop15
	br_if   	0, $pop16       # 0: down to label0
# BB#3:                                 # %if.end16
	i32.const	$push140=, 0
	i32.const	$push17=, 3
	i32.add 	$push18=, $3, $pop17
	i32.store	$push19=, x($pop140), $pop18
	i32.const	$push20=, 1
	i32.and 	$push21=, $pop19, $pop20
	i32.const	$push22=, .L.str.1
	i32.add 	$push23=, $pop21, $pop22
	i32.call	$push24=, strlen@FUNCTION, $pop23
	i32.const	$push25=, 10
	i32.ne  	$push26=, $pop24, $pop25
	br_if   	0, $pop26       # 0: down to label0
# BB#4:                                 # %if.end26
	i32.const	$push141=, 0
	i32.const	$push27=, -3
	i32.add 	$push1=, $3, $pop27
	i32.store	$2=, x($pop141), $pop1
	i32.const	$push28=, .L.str.1-3
	i32.add 	$push29=, $3, $pop28
	i32.const	$push30=, .L.str.2
	i32.call	$push31=, strcmp@FUNCTION, $pop29, $pop30
	br_if   	0, $pop31       # 0: down to label0
# BB#5:                                 # %if.end33
	i32.const	$push143=, .L.str.1
	i32.call	$push32=, strcmp@FUNCTION, $pop143, $1
	i32.const	$push142=, 0
	i32.ge_s	$push33=, $pop32, $pop142
	br_if   	0, $pop33       # 0: down to label0
# BB#6:                                 # %if.end37
	i32.const	$push146=, 0
	i32.const	$push34=, -2
	i32.add 	$push2=, $3, $pop34
	i32.store	$0=, x($pop146), $pop2
	i32.const	$push145=, .L.str.1
	i32.const	$push35=, 1
	i32.and 	$push36=, $2, $pop35
	i32.add 	$push37=, $1, $pop36
	i32.call	$push38=, strcmp@FUNCTION, $pop145, $pop37
	i32.const	$push144=, 0
	i32.ge_s	$push39=, $pop38, $pop144
	br_if   	0, $pop39       # 0: down to label0
# BB#7:                                 # %if.end47
	i32.const	$push41=, 0
	i32.const	$push40=, -1
	i32.add 	$push3=, $3, $pop40
	i32.store	$2=, x($pop41), $pop3
	i32.const	$push42=, 7
	i32.and 	$push43=, $0, $pop42
	i32.const	$push44=, .L.str.1
	i32.add 	$push45=, $pop43, $pop44
	i32.const	$push46=, 108
	i32.call	$push47=, strchr@FUNCTION, $pop45, $pop46
	i32.const	$push48=, .L.str.1+9
	i32.ne  	$push49=, $pop47, $pop48
	br_if   	0, $pop49       # 0: down to label0
# BB#8:                                 # %if.end58
	i32.const	$push50=, 111
	i32.call	$push148=, strchr@FUNCTION, $1, $pop50
	tee_local	$push147=, $0=, $pop148
	i32.const	$push51=, 4
	i32.add 	$push52=, $1, $pop51
	i32.ne  	$push53=, $pop147, $pop52
	br_if   	0, $pop53       # 0: down to label0
# BB#9:                                 # %if.end63
	i32.call	$push54=, strlen@FUNCTION, $1
	i32.const	$push55=, 8
	i32.ne  	$push56=, $pop54, $pop55
	br_if   	0, $pop56       # 0: down to label0
# BB#10:                                # %if.end68
	i32.const	$push57=, 120
	i32.call	$push58=, strrchr@FUNCTION, $1, $pop57
	br_if   	0, $pop58       # 0: down to label0
# BB#11:                                # %if.end72
	i32.const	$push59=, 111
	i32.call	$push60=, strrchr@FUNCTION, $1, $pop59
	i32.ne  	$push61=, $pop60, $0
	br_if   	0, $pop61       # 0: down to label0
# BB#12:                                # %if.end77
	i32.const	$push62=, 0
	i32.const	$push151=, 0
	i32.load	$push67=, y($pop151)
	i32.const	$push68=, -1
	i32.add 	$push4=, $pop67, $pop68
	i32.store	$1=, y($pop62), $pop4
	i32.const	$push150=, 0
	i32.store	$discard=, x($pop150), $3
	i32.const	$push63=, 1
	i32.and 	$push64=, $2, $pop63
	i32.const	$push65=, .L.str.1
	i32.add 	$push66=, $pop64, $pop65
	i32.const	$push149=, 1
	i32.and 	$push69=, $1, $pop149
	i32.const	$push70=, .L.str.3
	i32.add 	$push71=, $pop69, $pop70
	i32.call	$push72=, strcmp@FUNCTION, $pop66, $pop71
	br_if   	0, $pop72       # 0: down to label0
# BB#13:                                # %if.end86
	br_if   	0, $1           # 0: down to label0
# BB#14:                                # %if.end86
	i32.const	$push152=, 6
	i32.ne  	$push73=, $3, $pop152
	br_if   	0, $pop73       # 0: down to label0
# BB#15:                                # %if.end90
	i32.const	$push157=, 0
	i32.const	$push156=, 6
	i32.store	$discard=, x($pop157), $pop156
	i32.const	$push76=, 1869376613
	i32.store	$discard=, 1($4):p2align=0, $pop76
	i32.const	$push155=, 0
	i32.const	$push75=, 1
	i32.store	$1=, y($pop155), $pop75
	i32.const	$push74=, 32
	i32.store16	$3=, 5($4):p2align=0, $pop74
	i32.or  	$push154=, $4, $1
	tee_local	$push153=, $1=, $pop154
	i32.const	$push77=, .L.str.4
	i32.call	$push78=, strcmp@FUNCTION, $pop153, $pop77
	br_if   	0, $pop78       # 0: down to label0
# BB#16:                                # %if.end108
	i32.const	$push81=, 64
	i32.call	$discard=, memset@FUNCTION, $4, $3, $pop81
	i32.const	$push159=, 0
	i32.const	$push83=, 2
	i32.store	$discard=, y($pop159), $pop83
	i32.const	$push158=, 0
	i32.const	$push82=, 7
	i32.store	$3=, x($pop158), $pop82
	i32.const	$push85=, .L.str.5+1
	i32.const	$push84=, 10
	i32.call	$push86=, strncpy@FUNCTION, $1, $pop85, $pop84
	i32.ne  	$push87=, $pop86, $1
	br_if   	0, $pop87       # 0: down to label0
# BB#17:                                # %if.end108
	i32.const	$push160=, 0
	i32.load	$push79=, x($pop160)
	i32.ne  	$push88=, $pop79, $3
	br_if   	0, $pop88       # 0: down to label0
# BB#18:                                # %if.end108
	i32.const	$push161=, 0
	i32.load	$push80=, y($pop161)
	i32.const	$push89=, 2
	i32.ne  	$push90=, $pop80, $pop89
	br_if   	0, $pop90       # 0: down to label0
# BB#19:                                # %lor.lhs.false125
	i32.const	$push91=, .L.str.6
	i32.const	$push92=, 12
	i32.call	$push93=, memcmp@FUNCTION, $4, $pop91, $pop92
	br_if   	0, $pop93       # 0: down to label0
# BB#20:                                # %if.end130
	i32.const	$push95=, 32
	i32.const	$push94=, 64
	i32.call	$discard=, memset@FUNCTION, $4, $pop95, $pop94
	i32.const	$push96=, .L.str.7
	i32.const	$push97=, 8
	i32.call	$push98=, strncpy@FUNCTION, $4, $pop96, $pop97
	i32.ne  	$push99=, $pop98, $4
	br_if   	0, $pop99       # 0: down to label0
# BB#21:                                # %lor.lhs.false136
	i32.const	$push100=, .L.str.8
	i32.const	$push101=, 9
	i32.call	$push102=, memcmp@FUNCTION, $4, $pop100, $pop101
	br_if   	0, $pop102      # 0: down to label0
# BB#22:                                # %if.end141
	i32.const	$push103=, buf
	i32.const	$push105=, 32
	i32.const	$push104=, 64
	i32.call	$3=, memset@FUNCTION, $pop103, $pop105, $pop104
	i32.const	$push106=, 0
	i32.const	$push164=, 0
	i32.load	$push108=, y($pop164)
	i32.const	$push109=, 1
	i32.add 	$push110=, $pop108, $pop109
	i32.store	$1=, y($pop106), $pop110
	i32.const	$push163=, 0
	i32.const	$push107=, 34
	i32.store	$discard=, x($pop163), $pop107
	i32.const	$push111=, 33
	i32.call	$discard=, memset@FUNCTION, $3, $pop111, $1
	i32.const	$push162=, 3
	i32.ne  	$push112=, $1, $pop162
	br_if   	0, $pop112      # 0: down to label0
# BB#23:                                # %lor.lhs.false148
	i32.const	$push113=, .L.str.9
	i32.const	$push165=, 3
	i32.call	$push114=, memcmp@FUNCTION, $3, $pop113, $pop165
	br_if   	0, $pop114      # 0: down to label0
# BB#24:                                # %lor.lhs.false158
	i32.const	$push168=, 0
	i32.const	$push115=, 4
	i32.store	$discard=, y($pop168), $pop115
	i32.const	$push167=, 0
	i64.const	$push116=, 3255307777713450285
	i64.store	$discard=, buf+3($pop167):p2align=0, $pop116
	i32.const	$push117=, buf
	i32.const	$push118=, .L.str.10
	i32.const	$push166=, 11
	i32.call	$push119=, memcmp@FUNCTION, $pop117, $pop118, $pop166
	br_if   	0, $pop119      # 0: down to label0
# BB#25:                                # %lor.lhs.false171
	i32.const	$push173=, 0
	i32.const	$push172=, 11
	i32.store	$discard=, x($pop173), $pop172
	i32.const	$push171=, 0
	i32.const	$push120=, 5
	i32.store	$discard=, y($pop171), $pop120
	i32.const	$push170=, 0
	i32.const	$push169=, 0
	i32.store	$discard=, buf+11($pop170):p2align=0, $pop169
	i32.const	$push123=, buf+8
	i32.const	$push121=, .L.str.11
	i32.const	$push122=, 7
	i32.call	$push124=, memcmp@FUNCTION, $pop123, $pop121, $pop122
	br_if   	0, $pop124      # 0: down to label0
# BB#26:                                # %lor.lhs.false180
	i32.const	$push126=, 0
	i32.const	$push125=, 15
	i32.store	$discard=, x($pop126), $pop125
	i32.const	$push177=, 0
	i32.const	$push176=, 0
	i32.store16	$push175=, buf+19($pop177):p2align=0, $pop176
	tee_local	$push174=, $1=, $pop175
	i32.store	$discard=, buf+15($pop174):p2align=0, $1
	i32.const	$push129=, buf+10
	i32.const	$push127=, .L.str.12
	i32.const	$push128=, 11
	i32.call	$push130=, memcmp@FUNCTION, $pop129, $pop127, $pop128
	br_if   	0, $pop130      # 0: down to label0
# BB#27:                                # %if.end184
	i32.const	$push184=, __stack_pointer
	i32.const	$push182=, 64
	i32.add 	$push183=, $4, $pop182
	i32.store	$discard=, 0($pop184), $pop183
	return  	$1
.LBB0_28:                               # %if.then183
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
