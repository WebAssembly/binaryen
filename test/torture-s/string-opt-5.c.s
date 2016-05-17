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
	i32.const	$push119=, __stack_pointer
	i32.const	$push116=, __stack_pointer
	i32.load	$push117=, 0($pop116)
	i32.const	$push118=, 64
	i32.sub 	$push123=, $pop117, $pop118
	i32.store	$1=, 0($pop119), $pop123
	block
	i32.const	$push126=, 0
	i32.load	$push125=, bar($pop126)
	tee_local	$push124=, $2=, $pop125
	i32.call	$push3=, strlen@FUNCTION, $pop124
	i32.const	$push4=, 8
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	0, $pop5        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push132=, 0
	i32.const	$push131=, 0
	i32.load	$push130=, x($pop131)
	tee_local	$push129=, $4=, $pop130
	i32.const	$push6=, 1
	i32.add 	$push128=, $pop129, $pop6
	tee_local	$push127=, $3=, $pop128
	i32.store	$0=, x($pop132), $pop127
	i32.const	$push7=, 2
	i32.and 	$push8=, $3, $pop7
	i32.add 	$push9=, $2, $pop8
	i32.call	$push10=, strlen@FUNCTION, $pop9
	i32.const	$push11=, 6
	i32.ne  	$push12=, $pop10, $pop11
	br_if   	0, $pop12       # 0: down to label0
# BB#2:                                 # %if.end4
	i32.const	$push13=, 7
	i32.ne  	$push14=, $0, $pop13
	br_if   	0, $pop14       # 0: down to label0
# BB#3:                                 # %if.end26
	i32.const	$push133=, 0
	i32.const	$push15=, -3
	i32.add 	$push0=, $4, $pop15
	i32.store	$3=, x($pop133), $pop0
	i32.const	$push16=, .L.str.1-3
	i32.add 	$push17=, $4, $pop16
	i32.const	$push18=, .L.str.2
	i32.call	$push19=, strcmp@FUNCTION, $pop17, $pop18
	br_if   	0, $pop19       # 0: down to label0
# BB#4:                                 # %if.end33
	i32.const	$push135=, .L.str.1
	i32.call	$push20=, strcmp@FUNCTION, $pop135, $2
	i32.const	$push134=, 0
	i32.ge_s	$push21=, $pop20, $pop134
	br_if   	0, $pop21       # 0: down to label0
# BB#5:                                 # %if.end37
	i32.const	$push138=, 0
	i32.const	$push22=, -2
	i32.add 	$push1=, $4, $pop22
	i32.store	$0=, x($pop138), $pop1
	i32.const	$push137=, .L.str.1
	i32.const	$push23=, 1
	i32.and 	$push24=, $3, $pop23
	i32.add 	$push25=, $2, $pop24
	i32.call	$push26=, strcmp@FUNCTION, $pop137, $pop25
	i32.const	$push136=, 0
	i32.ge_s	$push27=, $pop26, $pop136
	br_if   	0, $pop27       # 0: down to label0
# BB#6:                                 # %if.end47
	i32.const	$push139=, 0
	i32.const	$push28=, -1
	i32.add 	$push2=, $4, $pop28
	i32.store	$3=, x($pop139), $pop2
	i32.const	$push29=, 7
	i32.and 	$push30=, $0, $pop29
	i32.const	$push31=, .L.str.1
	i32.add 	$push32=, $pop30, $pop31
	i32.const	$push33=, 108
	i32.call	$push34=, strchr@FUNCTION, $pop32, $pop33
	i32.const	$push35=, .L.str.1+9
	i32.ne  	$push36=, $pop34, $pop35
	br_if   	0, $pop36       # 0: down to label0
# BB#7:                                 # %if.end58
	i32.const	$push37=, 111
	i32.call	$push141=, strchr@FUNCTION, $2, $pop37
	tee_local	$push140=, $0=, $pop141
	i32.const	$push38=, 4
	i32.add 	$push39=, $2, $pop38
	i32.ne  	$push40=, $pop140, $pop39
	br_if   	0, $pop40       # 0: down to label0
# BB#8:                                 # %if.end63
	i32.call	$push41=, strlen@FUNCTION, $2
	i32.const	$push42=, 8
	i32.ne  	$push43=, $pop41, $pop42
	br_if   	0, $pop43       # 0: down to label0
# BB#9:                                 # %if.end68
	i32.const	$push44=, 120
	i32.call	$push45=, strrchr@FUNCTION, $2, $pop44
	br_if   	0, $pop45       # 0: down to label0
# BB#10:                                # %if.end72
	i32.const	$push46=, 111
	i32.call	$push47=, strrchr@FUNCTION, $2, $pop46
	i32.ne  	$push48=, $pop47, $0
	br_if   	0, $pop48       # 0: down to label0
# BB#11:                                # %if.end77
	i32.const	$push49=, 0
	i32.load	$2=, y($pop49)
	i32.const	$push146=, 0
	i32.store	$drop=, x($pop146), $4
	i32.const	$push145=, 0
	i32.const	$push54=, -1
	i32.add 	$push144=, $2, $pop54
	tee_local	$push143=, $2=, $pop144
	i32.store	$0=, y($pop145), $pop143
	i32.const	$push50=, 1
	i32.and 	$push51=, $3, $pop50
	i32.const	$push52=, .L.str.1
	i32.add 	$push53=, $pop51, $pop52
	i32.const	$push142=, 1
	i32.and 	$push55=, $2, $pop142
	i32.const	$push56=, .L.str.3
	i32.add 	$push57=, $pop55, $pop56
	i32.call	$push58=, strcmp@FUNCTION, $pop53, $pop57
	br_if   	0, $pop58       # 0: down to label0
# BB#12:                                # %if.end86
	br_if   	0, $0           # 0: down to label0
# BB#13:                                # %if.end86
	i32.const	$push147=, 6
	i32.ne  	$push59=, $4, $pop147
	br_if   	0, $pop59       # 0: down to label0
# BB#14:                                # %if.end90
	i32.const	$push152=, 0
	i32.const	$push151=, 6
	i32.store	$drop=, x($pop152), $pop151
	i32.const	$push62=, 1869376613
	i32.store	$drop=, 1($1):p2align=0, $pop62
	i32.const	$push150=, 0
	i32.const	$push61=, 1
	i32.store	$2=, y($pop150), $pop61
	i32.const	$push60=, 32
	i32.store16	$4=, 5($1):p2align=0, $pop60
	i32.or  	$push149=, $1, $2
	tee_local	$push148=, $2=, $pop149
	i32.const	$push63=, .L.str.4
	i32.call	$push64=, strcmp@FUNCTION, $pop148, $pop63
	br_if   	0, $pop64       # 0: down to label0
# BB#15:                                # %if.end108
	i32.const	$push67=, 64
	i32.call	$4=, memset@FUNCTION, $1, $4, $pop67
	i32.const	$push154=, 0
	i32.const	$push69=, 2
	i32.store	$drop=, y($pop154), $pop69
	i32.const	$push153=, 0
	i32.const	$push68=, 7
	i32.store	$1=, x($pop153), $pop68
	i32.const	$push71=, .L.str.5+1
	i32.const	$push70=, 10
	i32.call	$push72=, strncpy@FUNCTION, $2, $pop71, $pop70
	i32.ne  	$push73=, $pop72, $2
	br_if   	0, $pop73       # 0: down to label0
# BB#16:                                # %if.end108
	i32.const	$push155=, 0
	i32.load	$push65=, x($pop155)
	i32.ne  	$push74=, $pop65, $1
	br_if   	0, $pop74       # 0: down to label0
# BB#17:                                # %if.end108
	i32.const	$push156=, 0
	i32.load	$push66=, y($pop156)
	i32.const	$push75=, 2
	i32.ne  	$push76=, $pop66, $pop75
	br_if   	0, $pop76       # 0: down to label0
# BB#18:                                # %lor.lhs.false125
	i32.const	$push77=, .L.str.6
	i32.const	$push78=, 12
	i32.call	$push79=, memcmp@FUNCTION, $4, $pop77, $pop78
	br_if   	0, $pop79       # 0: down to label0
# BB#19:                                # %if.end130
	i32.const	$push81=, 32
	i32.const	$push80=, 64
	i32.call	$2=, memset@FUNCTION, $4, $pop81, $pop80
	i32.const	$push82=, .L.str.7
	i32.const	$push83=, 8
	i32.call	$push84=, strncpy@FUNCTION, $2, $pop82, $pop83
	i32.ne  	$push85=, $2, $pop84
	br_if   	0, $pop85       # 0: down to label0
# BB#20:                                # %lor.lhs.false136
	i32.const	$push86=, .L.str.8
	i32.const	$push87=, 9
	i32.call	$push88=, memcmp@FUNCTION, $2, $pop86, $pop87
	br_if   	0, $pop88       # 0: down to label0
# BB#21:                                # %if.end141
	i32.const	$push89=, buf
	i32.const	$push91=, 32
	i32.const	$push90=, 64
	i32.call	$4=, memset@FUNCTION, $pop89, $pop91, $pop90
	i32.const	$push92=, 0
	i32.load	$1=, y($pop92)
	i32.const	$push161=, 0
	i32.const	$push93=, 34
	i32.store	$drop=, x($pop161), $pop93
	i32.const	$push96=, 33
	i32.const	$push160=, 0
	i32.const	$push94=, 1
	i32.add 	$push95=, $1, $pop94
	i32.store	$push159=, y($pop160), $pop95
	tee_local	$push158=, $1=, $pop159
	i32.call	$drop=, memset@FUNCTION, $4, $pop96, $pop158
	i32.const	$push157=, 3
	i32.ne  	$push97=, $1, $pop157
	br_if   	0, $pop97       # 0: down to label0
# BB#22:                                # %lor.lhs.false148
	i32.const	$push98=, .L.str.9
	i32.const	$push162=, 3
	i32.call	$push99=, memcmp@FUNCTION, $4, $pop98, $pop162
	br_if   	0, $pop99       # 0: down to label0
# BB#23:                                # %lor.lhs.false158
	i32.const	$push165=, 0
	i32.const	$push100=, 4
	i32.store	$drop=, y($pop165), $pop100
	i32.const	$push164=, 0
	i64.const	$push101=, 3255307777713450285
	i64.store	$drop=, buf+3($pop164):p2align=0, $pop101
	i32.const	$push102=, buf
	i32.const	$push103=, .L.str.10
	i32.const	$push163=, 11
	i32.call	$push104=, memcmp@FUNCTION, $pop102, $pop103, $pop163
	br_if   	0, $pop104      # 0: down to label0
# BB#24:                                # %lor.lhs.false171
	i32.const	$push170=, 0
	i32.const	$push169=, 11
	i32.store	$drop=, x($pop170), $pop169
	i32.const	$push168=, 0
	i32.const	$push105=, 5
	i32.store	$drop=, y($pop168), $pop105
	i32.const	$push167=, 0
	i32.const	$push166=, 0
	i32.store	$drop=, buf+11($pop167):p2align=0, $pop166
	i32.const	$push108=, buf+8
	i32.const	$push106=, .L.str.11
	i32.const	$push107=, 7
	i32.call	$push109=, memcmp@FUNCTION, $pop108, $pop106, $pop107
	br_if   	0, $pop109      # 0: down to label0
# BB#25:                                # %lor.lhs.false180
	i32.const	$push111=, 0
	i32.const	$push110=, 15
	i32.store	$drop=, x($pop111), $pop110
	i32.const	$push174=, 0
	i32.const	$push173=, 0
	i32.store16	$push172=, buf+19($pop174):p2align=0, $pop173
	tee_local	$push171=, $4=, $pop172
	i32.store	$drop=, buf+15($pop171):p2align=0, $4
	i32.const	$push114=, buf+10
	i32.const	$push112=, .L.str.12
	i32.const	$push113=, 11
	i32.call	$push115=, memcmp@FUNCTION, $pop114, $pop112, $pop113
	br_if   	0, $pop115      # 0: down to label0
# BB#26:                                # %if.end184
	i32.const	$push122=, __stack_pointer
	i32.const	$push120=, 64
	i32.add 	$push121=, $2, $pop120
	i32.store	$drop=, 0($pop122), $pop121
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
