	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/string-opt-5.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push114=, 0
	i32.const	$push111=, 0
	i32.load	$push112=, __stack_pointer($pop111)
	i32.const	$push113=, 64
	i32.sub 	$push122=, $pop112, $pop113
	tee_local	$push121=, $4=, $pop122
	i32.store	__stack_pointer($pop114), $pop121
	block   	
	i32.const	$push120=, 0
	i32.load	$push119=, bar($pop120)
	tee_local	$push118=, $0=, $pop119
	i32.call	$push0=, strlen@FUNCTION, $pop118
	i32.const	$push1=, 8
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push128=, 0
	i32.const	$push127=, 0
	i32.load	$push126=, x($pop127)
	tee_local	$push125=, $1=, $pop126
	i32.const	$push3=, 1
	i32.add 	$push124=, $pop125, $pop3
	tee_local	$push123=, $2=, $pop124
	i32.store	x($pop128), $pop123
	i32.const	$push4=, 2
	i32.and 	$push5=, $2, $pop4
	i32.add 	$push6=, $0, $pop5
	i32.call	$push7=, strlen@FUNCTION, $pop6
	i32.const	$push8=, 6
	i32.ne  	$push9=, $pop7, $pop8
	br_if   	0, $pop9        # 0: down to label0
# BB#2:                                 # %if.end4
	i32.const	$push10=, 7
	i32.ne  	$push11=, $2, $pop10
	br_if   	0, $pop11       # 0: down to label0
# BB#3:                                 # %if.end26
	i32.const	$push131=, 0
	i32.const	$push12=, -3
	i32.add 	$push130=, $1, $pop12
	tee_local	$push129=, $2=, $pop130
	i32.store	x($pop131), $pop129
	i32.const	$push13=, .L.str.1-3
	i32.add 	$push14=, $1, $pop13
	i32.const	$push15=, .L.str.2
	i32.call	$push16=, strcmp@FUNCTION, $pop14, $pop15
	br_if   	0, $pop16       # 0: down to label0
# BB#4:                                 # %if.end33
	i32.const	$push133=, .L.str.1
	i32.call	$push17=, strcmp@FUNCTION, $pop133, $0
	i32.const	$push132=, 0
	i32.ge_s	$push18=, $pop17, $pop132
	br_if   	0, $pop18       # 0: down to label0
# BB#5:                                 # %if.end37
	i32.const	$push138=, 0
	i32.const	$push19=, -2
	i32.add 	$push137=, $1, $pop19
	tee_local	$push136=, $3=, $pop137
	i32.store	x($pop138), $pop136
	i32.const	$push135=, .L.str.1
	i32.const	$push20=, 1
	i32.and 	$push21=, $2, $pop20
	i32.add 	$push22=, $0, $pop21
	i32.call	$push23=, strcmp@FUNCTION, $pop135, $pop22
	i32.const	$push134=, 0
	i32.ge_s	$push24=, $pop23, $pop134
	br_if   	0, $pop24       # 0: down to label0
# BB#6:                                 # %if.end47
	i32.const	$push141=, 0
	i32.const	$push25=, -1
	i32.add 	$push140=, $1, $pop25
	tee_local	$push139=, $2=, $pop140
	i32.store	x($pop141), $pop139
	i32.const	$push26=, 7
	i32.and 	$push27=, $3, $pop26
	i32.const	$push28=, .L.str.1
	i32.add 	$push29=, $pop27, $pop28
	i32.const	$push30=, 108
	i32.call	$push31=, strchr@FUNCTION, $pop29, $pop30
	i32.const	$push32=, .L.str.1+9
	i32.ne  	$push33=, $pop31, $pop32
	br_if   	0, $pop33       # 0: down to label0
# BB#7:                                 # %if.end58
	i32.const	$push36=, 111
	i32.call	$push143=, strchr@FUNCTION, $0, $pop36
	tee_local	$push142=, $3=, $pop143
	i32.const	$push34=, 4
	i32.add 	$push35=, $0, $pop34
	i32.ne  	$push37=, $pop142, $pop35
	br_if   	0, $pop37       # 0: down to label0
# BB#8:                                 # %if.end63
	i32.call	$push38=, strlen@FUNCTION, $0
	i32.const	$push39=, 8
	i32.ne  	$push40=, $pop38, $pop39
	br_if   	0, $pop40       # 0: down to label0
# BB#9:                                 # %if.end68
	i32.const	$push41=, 120
	i32.call	$push42=, strrchr@FUNCTION, $0, $pop41
	br_if   	0, $pop42       # 0: down to label0
# BB#10:                                # %if.end72
	i32.const	$push43=, 111
	i32.call	$push44=, strrchr@FUNCTION, $0, $pop43
	i32.ne  	$push45=, $pop44, $3
	br_if   	0, $pop45       # 0: down to label0
# BB#11:                                # %if.end77
	i32.const	$push46=, 0
	i32.store	x($pop46), $1
	i32.const	$push148=, 0
	i32.const	$push147=, 0
	i32.load	$push47=, y($pop147)
	i32.const	$push48=, -1
	i32.add 	$push146=, $pop47, $pop48
	tee_local	$push145=, $0=, $pop146
	i32.store	y($pop148), $pop145
	i32.const	$push49=, 1
	i32.and 	$push50=, $2, $pop49
	i32.const	$push51=, .L.str.1
	i32.add 	$push52=, $pop50, $pop51
	i32.const	$push144=, 1
	i32.and 	$push53=, $0, $pop144
	i32.const	$push54=, .L.str.3
	i32.add 	$push55=, $pop53, $pop54
	i32.call	$push56=, strcmp@FUNCTION, $pop52, $pop55
	br_if   	0, $pop56       # 0: down to label0
# BB#12:                                # %if.end86
	br_if   	0, $0           # 0: down to label0
# BB#13:                                # %if.end90
	i32.const	$push154=, 0
	i32.const	$push57=, 1
	i32.store	y($pop154), $pop57
	i32.const	$push153=, 0
	i32.const	$push58=, 6
	i32.store	x($pop153), $pop58
	i32.const	$push152=, 32
	i32.store16	5($4):p2align=0, $pop152
	i32.const	$push59=, 1869376613
	i32.store	1($4):p2align=0, $pop59
	i32.const	$push151=, 1
	i32.or  	$push150=, $4, $pop151
	tee_local	$push149=, $0=, $pop150
	i32.const	$push60=, .L.str.4
	i32.call	$push61=, strcmp@FUNCTION, $pop149, $pop60
	br_if   	0, $pop61       # 0: down to label0
# BB#14:                                # %if.end108
	i32.const	$push158=, 32
	i32.const	$push64=, 64
	i32.call	$1=, memset@FUNCTION, $4, $pop158, $pop64
	i32.const	$push157=, 0
	i32.const	$push65=, 2
	i32.store	y($pop157), $pop65
	i32.const	$push156=, 0
	i32.const	$push155=, 7
	i32.store	x($pop156), $pop155
	i32.const	$push67=, .L.str.5+1
	i32.const	$push66=, 10
	i32.call	$push68=, strncpy@FUNCTION, $0, $pop67, $pop66
	i32.ne  	$push69=, $pop68, $0
	br_if   	0, $pop69       # 0: down to label0
# BB#15:                                # %if.end108
	i32.const	$push160=, 0
	i32.load	$push62=, x($pop160)
	i32.const	$push159=, 7
	i32.ne  	$push70=, $pop62, $pop159
	br_if   	0, $pop70       # 0: down to label0
# BB#16:                                # %if.end108
	i32.const	$push161=, 0
	i32.load	$push63=, y($pop161)
	i32.const	$push71=, 2
	i32.ne  	$push72=, $pop63, $pop71
	br_if   	0, $pop72       # 0: down to label0
# BB#17:                                # %lor.lhs.false125
	i32.const	$push74=, .L.str.6
	i32.const	$push73=, 12
	i32.call	$push75=, memcmp@FUNCTION, $1, $pop74, $pop73
	br_if   	0, $pop75       # 0: down to label0
# BB#18:                                # %if.end130
	i32.const	$push77=, 32
	i32.const	$push76=, 64
	i32.call	$push163=, memset@FUNCTION, $1, $pop77, $pop76
	tee_local	$push162=, $0=, $pop163
	i32.const	$push79=, .L.str.7
	i32.const	$push78=, 8
	i32.call	$push80=, strncpy@FUNCTION, $0, $pop79, $pop78
	i32.ne  	$push81=, $pop162, $pop80
	br_if   	0, $pop81       # 0: down to label0
# BB#19:                                # %lor.lhs.false136
	i32.const	$push83=, .L.str.8
	i32.const	$push82=, 9
	i32.call	$push84=, memcmp@FUNCTION, $0, $pop83, $pop82
	br_if   	0, $pop84       # 0: down to label0
# BB#20:                                # %if.end141
	i32.const	$push87=, buf
	i32.const	$push86=, 32
	i32.const	$push85=, 64
	i32.call	$4=, memset@FUNCTION, $pop87, $pop86, $pop85
	i32.const	$push89=, 0
	i32.const	$push88=, 34
	i32.store	x($pop89), $pop88
	i32.const	$push168=, 0
	i32.const	$push167=, 0
	i32.load	$push90=, y($pop167)
	i32.const	$push91=, 1
	i32.add 	$push166=, $pop90, $pop91
	tee_local	$push165=, $1=, $pop166
	i32.store	y($pop168), $pop165
	i32.const	$push92=, 33
	i32.call	$drop=, memset@FUNCTION, $4, $pop92, $1
	i32.const	$push164=, 3
	i32.ne  	$push93=, $1, $pop164
	br_if   	0, $pop93       # 0: down to label0
# BB#21:                                # %lor.lhs.false148
	i32.const	$push94=, .L.str.9
	i32.const	$push169=, 3
	i32.call	$push95=, memcmp@FUNCTION, $4, $pop94, $pop169
	br_if   	0, $pop95       # 0: down to label0
# BB#22:                                # %lor.lhs.false158
	i32.const	$push172=, 0
	i64.const	$push96=, 3255307777713450285
	i64.store	buf+3($pop172):p2align=0, $pop96
	i32.const	$push171=, 0
	i32.const	$push97=, 4
	i32.store	y($pop171), $pop97
	i32.const	$push99=, buf
	i32.const	$push98=, .L.str.10
	i32.const	$push170=, 11
	i32.call	$push100=, memcmp@FUNCTION, $pop99, $pop98, $pop170
	br_if   	0, $pop100      # 0: down to label0
# BB#23:                                # %lor.lhs.false171
	i32.const	$push177=, 0
	i32.const	$push101=, 5
	i32.store	y($pop177), $pop101
	i32.const	$push176=, 0
	i32.const	$push175=, 11
	i32.store	x($pop176), $pop175
	i32.const	$push174=, 0
	i32.const	$push173=, 0
	i32.store	buf+11($pop174):p2align=0, $pop173
	i32.const	$push104=, buf+8
	i32.const	$push103=, .L.str.11
	i32.const	$push102=, 7
	i32.call	$push105=, memcmp@FUNCTION, $pop104, $pop103, $pop102
	br_if   	0, $pop105      # 0: down to label0
# BB#24:                                # %lor.lhs.false180
	i32.const	$push182=, 0
	i32.const	$push106=, 15
	i32.store	x($pop182), $pop106
	i32.const	$push181=, 0
	i32.const	$push180=, 0
	i32.store16	buf+19($pop181):p2align=0, $pop180
	i32.const	$push179=, 0
	i32.const	$push178=, 0
	i32.store	buf+15($pop179):p2align=0, $pop178
	i32.const	$push109=, buf+10
	i32.const	$push108=, .L.str.12
	i32.const	$push107=, 11
	i32.call	$push110=, memcmp@FUNCTION, $pop109, $pop108, $pop107
	br_if   	0, $pop110      # 0: down to label0
# BB#25:                                # %if.end184
	i32.const	$push117=, 0
	i32.const	$push115=, 64
	i32.add 	$push116=, $0, $pop115
	i32.store	__stack_pointer($pop117), $pop116
	i32.const	$push183=, 0
	return  	$pop183
.LBB0_26:                               # %if.then183
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	strlen, i32, i32
	.functype	abort, void
	.functype	strcmp, i32, i32, i32
	.functype	strchr, i32, i32, i32
	.functype	strrchr, i32, i32, i32
	.functype	strncpy, i32, i32, i32, i32
	.functype	memcmp, i32, i32, i32, i32
