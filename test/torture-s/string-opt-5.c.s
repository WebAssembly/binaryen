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
	i32.const	$push175=, __stack_pointer
	i32.load	$push176=, 0($pop175)
	i32.const	$push177=, 64
	i32.sub 	$4=, $pop176, $pop177
	i32.const	$push178=, __stack_pointer
	i32.store	$discard=, 0($pop178), $4
	block
	i32.const	$push134=, 0
	i32.load	$push133=, bar($pop134)
	tee_local	$push132=, $1=, $pop133
	i32.call	$push5=, strlen@FUNCTION, $pop132
	i32.const	$push6=, 8
	i32.ne  	$push7=, $pop5, $pop6
	br_if   	0, $pop7        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push140=, 0
	i32.const	$push139=, 0
	i32.load	$push138=, x($pop139)
	tee_local	$push137=, $3=, $pop138
	i32.const	$push8=, 1
	i32.add 	$push0=, $pop137, $pop8
	i32.store	$push136=, x($pop140), $pop0
	tee_local	$push135=, $2=, $pop136
	i32.const	$push9=, 2
	i32.and 	$push10=, $pop135, $pop9
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
	i32.const	$push141=, 0
	i32.const	$push17=, 3
	i32.add 	$push18=, $3, $pop17
	i32.store	$push19=, x($pop141), $pop18
	i32.const	$push20=, 1
	i32.and 	$push21=, $pop19, $pop20
	i32.const	$push22=, .L.str.1
	i32.add 	$push23=, $pop21, $pop22
	i32.call	$push24=, strlen@FUNCTION, $pop23
	i32.const	$push25=, 10
	i32.ne  	$push26=, $pop24, $pop25
	br_if   	0, $pop26       # 0: down to label0
# BB#4:                                 # %if.end26
	i32.const	$push142=, 0
	i32.const	$push27=, -3
	i32.add 	$push1=, $3, $pop27
	i32.store	$2=, x($pop142), $pop1
	i32.const	$push28=, .L.str.1-3
	i32.add 	$push29=, $3, $pop28
	i32.const	$push30=, .L.str.2
	i32.call	$push31=, strcmp@FUNCTION, $pop29, $pop30
	br_if   	0, $pop31       # 0: down to label0
# BB#5:                                 # %if.end33
	i32.const	$push144=, .L.str.1
	i32.call	$push32=, strcmp@FUNCTION, $pop144, $1
	i32.const	$push143=, 0
	i32.ge_s	$push33=, $pop32, $pop143
	br_if   	0, $pop33       # 0: down to label0
# BB#6:                                 # %if.end37
	i32.const	$push147=, 0
	i32.const	$push34=, -2
	i32.add 	$push2=, $3, $pop34
	i32.store	$0=, x($pop147), $pop2
	i32.const	$push146=, .L.str.1
	i32.const	$push35=, 1
	i32.and 	$push36=, $2, $pop35
	i32.add 	$push37=, $1, $pop36
	i32.call	$push38=, strcmp@FUNCTION, $pop146, $pop37
	i32.const	$push145=, 0
	i32.ge_s	$push39=, $pop38, $pop145
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
	i32.call	$push149=, strchr@FUNCTION, $1, $pop50
	tee_local	$push148=, $0=, $pop149
	i32.const	$push51=, 4
	i32.add 	$push52=, $1, $pop51
	i32.ne  	$push53=, $pop148, $pop52
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
	i32.const	$push152=, 0
	i32.load	$push67=, y($pop152)
	i32.const	$push68=, -1
	i32.add 	$push4=, $pop67, $pop68
	i32.store	$1=, y($pop62), $pop4
	i32.const	$push151=, 0
	i32.store	$discard=, x($pop151), $3
	i32.const	$push63=, 1
	i32.and 	$push64=, $2, $pop63
	i32.const	$push65=, .L.str.1
	i32.add 	$push66=, $pop64, $pop65
	i32.const	$push150=, 1
	i32.and 	$push69=, $1, $pop150
	i32.const	$push70=, .L.str.3
	i32.add 	$push71=, $pop69, $pop70
	i32.call	$push72=, strcmp@FUNCTION, $pop66, $pop71
	br_if   	0, $pop72       # 0: down to label0
# BB#13:                                # %if.end86
	br_if   	0, $1           # 0: down to label0
# BB#14:                                # %if.end86
	i32.const	$push153=, 6
	i32.ne  	$push73=, $3, $pop153
	br_if   	0, $pop73       # 0: down to label0
# BB#15:                                # %if.end90
	i32.const	$push75=, 0
	i32.store8	$push158=, 6($4):p2align=1, $pop75
	tee_local	$push157=, $1=, $pop158
	i32.const	$push156=, 6
	i32.store	$discard=, x($pop157), $pop156
	i32.const	$push77=, 1869376613
	i32.store	$discard=, 1($4):p2align=0, $pop77
	i32.const	$push76=, 1
	i32.store	$3=, y($1), $pop76
	i32.const	$push74=, 32
	i32.store8	$2=, 5($4), $pop74
	i32.or  	$push155=, $4, $3
	tee_local	$push154=, $3=, $pop155
	i32.const	$push78=, .L.str.4
	i32.call	$push79=, strcmp@FUNCTION, $pop154, $pop78
	br_if   	0, $pop79       # 0: down to label0
# BB#16:                                # %if.end108
	i32.const	$push82=, 64
	i32.call	$discard=, memset@FUNCTION, $4, $2, $pop82
	i32.const	$push84=, 2
	i32.store	$discard=, y($1), $pop84
	i32.const	$push83=, 7
	i32.store	$2=, x($1), $pop83
	i32.const	$push86=, .L.str.5+1
	i32.const	$push85=, 10
	i32.call	$push87=, strncpy@FUNCTION, $3, $pop86, $pop85
	i32.ne  	$push88=, $pop87, $3
	br_if   	0, $pop88       # 0: down to label0
# BB#17:                                # %if.end108
	i32.load	$push80=, x($1)
	i32.ne  	$push89=, $pop80, $2
	br_if   	0, $pop89       # 0: down to label0
# BB#18:                                # %if.end108
	i32.load	$push81=, y($1)
	i32.const	$push90=, 2
	i32.ne  	$push91=, $pop81, $pop90
	br_if   	0, $pop91       # 0: down to label0
# BB#19:                                # %lor.lhs.false125
	i32.const	$push92=, .L.str.6
	i32.const	$push93=, 12
	i32.call	$push94=, memcmp@FUNCTION, $4, $pop92, $pop93
	br_if   	0, $pop94       # 0: down to label0
# BB#20:                                # %if.end130
	i32.const	$push96=, 32
	i32.const	$push95=, 64
	i32.call	$discard=, memset@FUNCTION, $4, $pop96, $pop95
	i32.const	$push97=, .L.str.7
	i32.const	$push98=, 8
	i32.call	$push99=, strncpy@FUNCTION, $4, $pop97, $pop98
	i32.ne  	$push100=, $pop99, $4
	br_if   	0, $pop100      # 0: down to label0
# BB#21:                                # %lor.lhs.false136
	i32.const	$push101=, .L.str.8
	i32.const	$push102=, 9
	i32.call	$push103=, memcmp@FUNCTION, $4, $pop101, $pop102
	br_if   	0, $pop103      # 0: down to label0
# BB#22:                                # %if.end141
	i32.const	$push104=, buf
	i32.const	$push106=, 32
	i32.const	$push105=, 64
	i32.call	$3=, memset@FUNCTION, $pop104, $pop106, $pop105
	i32.const	$push107=, 0
	i32.const	$push161=, 0
	i32.load	$push109=, y($pop161)
	i32.const	$push110=, 1
	i32.add 	$push111=, $pop109, $pop110
	i32.store	$1=, y($pop107), $pop111
	i32.const	$push160=, 0
	i32.const	$push108=, 34
	i32.store	$discard=, x($pop160), $pop108
	i32.const	$push112=, 33
	i32.call	$discard=, memset@FUNCTION, $3, $pop112, $1
	i32.const	$push159=, 3
	i32.ne  	$push113=, $1, $pop159
	br_if   	0, $pop113      # 0: down to label0
# BB#23:                                # %lor.lhs.false148
	i32.const	$push114=, .L.str.9
	i32.const	$push162=, 3
	i32.call	$push115=, memcmp@FUNCTION, $3, $pop114, $pop162
	br_if   	0, $pop115      # 0: down to label0
# BB#24:                                # %lor.lhs.false158
	i32.const	$push165=, 0
	i32.const	$push116=, 4
	i32.store	$discard=, y($pop165), $pop116
	i32.const	$push164=, 0
	i64.const	$push117=, 3255307777713450285
	i64.store	$discard=, buf+3($pop164):p2align=0, $pop117
	i32.const	$push118=, buf
	i32.const	$push119=, .L.str.10
	i32.const	$push163=, 11
	i32.call	$push120=, memcmp@FUNCTION, $pop118, $pop119, $pop163
	br_if   	0, $pop120      # 0: down to label0
# BB#25:                                # %lor.lhs.false171
	i32.const	$push170=, 0
	i32.const	$push169=, 11
	i32.store	$discard=, x($pop170), $pop169
	i32.const	$push168=, 0
	i32.const	$push121=, 5
	i32.store	$discard=, y($pop168), $pop121
	i32.const	$push167=, 0
	i32.const	$push166=, 0
	i32.store	$discard=, buf+11($pop167):p2align=0, $pop166
	i32.const	$push124=, buf+8
	i32.const	$push122=, .L.str.11
	i32.const	$push123=, 7
	i32.call	$push125=, memcmp@FUNCTION, $pop124, $pop122, $pop123
	br_if   	0, $pop125      # 0: down to label0
# BB#26:                                # %lor.lhs.false180
	i32.const	$push127=, 0
	i32.const	$push126=, 15
	i32.store	$discard=, x($pop127), $pop126
	i32.const	$push174=, 0
	i32.const	$push173=, 0
	i32.store16	$push172=, buf+19($pop174):p2align=0, $pop173
	tee_local	$push171=, $1=, $pop172
	i32.store	$discard=, buf+15($pop171):p2align=0, $1
	i32.const	$push130=, buf+10
	i32.const	$push128=, .L.str.12
	i32.const	$push129=, 11
	i32.call	$push131=, memcmp@FUNCTION, $pop130, $pop128, $pop129
	br_if   	0, $pop131      # 0: down to label0
# BB#27:                                # %if.end184
	i32.const	$push181=, __stack_pointer
	i32.const	$push179=, 64
	i32.add 	$push180=, $4, $pop179
	i32.store	$discard=, 0($pop181), $pop180
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
