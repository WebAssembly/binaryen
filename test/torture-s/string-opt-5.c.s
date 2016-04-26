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
	i32.const	$push167=, __stack_pointer
	i32.load	$push168=, 0($pop167)
	i32.const	$push169=, 64
	i32.sub 	$4=, $pop168, $pop169
	i32.const	$push170=, __stack_pointer
	i32.store	$discard=, 0($pop170), $4
	block
	i32.const	$push122=, 0
	i32.load	$push121=, bar($pop122)
	tee_local	$push120=, $1=, $pop121
	i32.call	$push5=, strlen@FUNCTION, $pop120
	i32.const	$push6=, 8
	i32.ne  	$push7=, $pop5, $pop6
	br_if   	0, $pop7        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push128=, 0
	i32.const	$push127=, 0
	i32.load	$push126=, x($pop127)
	tee_local	$push125=, $3=, $pop126
	i32.const	$push8=, 1
	i32.add 	$push0=, $pop125, $pop8
	i32.store	$push124=, x($pop128), $pop0
	tee_local	$push123=, $2=, $pop124
	i32.const	$push9=, 2
	i32.and 	$push10=, $pop123, $pop9
	i32.add 	$push11=, $1, $pop10
	i32.call	$push12=, strlen@FUNCTION, $pop11
	i32.const	$push13=, 6
	i32.ne  	$push14=, $pop12, $pop13
	br_if   	0, $pop14       # 0: down to label0
# BB#2:                                 # %if.end4
	i32.const	$push15=, 7
	i32.ne  	$push16=, $2, $pop15
	br_if   	0, $pop16       # 0: down to label0
# BB#3:                                 # %if.end26
	i32.const	$push129=, 0
	i32.const	$push17=, -3
	i32.add 	$push1=, $3, $pop17
	i32.store	$2=, x($pop129), $pop1
	i32.const	$push18=, .L.str.1-3
	i32.add 	$push19=, $3, $pop18
	i32.const	$push20=, .L.str.2
	i32.call	$push21=, strcmp@FUNCTION, $pop19, $pop20
	br_if   	0, $pop21       # 0: down to label0
# BB#4:                                 # %if.end33
	i32.const	$push131=, .L.str.1
	i32.call	$push22=, strcmp@FUNCTION, $pop131, $1
	i32.const	$push130=, 0
	i32.ge_s	$push23=, $pop22, $pop130
	br_if   	0, $pop23       # 0: down to label0
# BB#5:                                 # %if.end37
	i32.const	$push134=, 0
	i32.const	$push24=, -2
	i32.add 	$push2=, $3, $pop24
	i32.store	$0=, x($pop134), $pop2
	i32.const	$push133=, .L.str.1
	i32.const	$push25=, 1
	i32.and 	$push26=, $2, $pop25
	i32.add 	$push27=, $1, $pop26
	i32.call	$push28=, strcmp@FUNCTION, $pop133, $pop27
	i32.const	$push132=, 0
	i32.ge_s	$push29=, $pop28, $pop132
	br_if   	0, $pop29       # 0: down to label0
# BB#6:                                 # %if.end47
	i32.const	$push135=, 0
	i32.const	$push30=, -1
	i32.add 	$push3=, $3, $pop30
	i32.store	$2=, x($pop135), $pop3
	i32.const	$push31=, 7
	i32.and 	$push32=, $0, $pop31
	i32.const	$push33=, .L.str.1
	i32.add 	$push34=, $pop32, $pop33
	i32.const	$push35=, 108
	i32.call	$push36=, strchr@FUNCTION, $pop34, $pop35
	i32.const	$push37=, .L.str.1+9
	i32.ne  	$push38=, $pop36, $pop37
	br_if   	0, $pop38       # 0: down to label0
# BB#7:                                 # %if.end58
	i32.const	$push39=, 111
	i32.call	$push137=, strchr@FUNCTION, $1, $pop39
	tee_local	$push136=, $0=, $pop137
	i32.const	$push40=, 4
	i32.add 	$push41=, $1, $pop40
	i32.ne  	$push42=, $pop136, $pop41
	br_if   	0, $pop42       # 0: down to label0
# BB#8:                                 # %if.end63
	i32.call	$push43=, strlen@FUNCTION, $1
	i32.const	$push44=, 8
	i32.ne  	$push45=, $pop43, $pop44
	br_if   	0, $pop45       # 0: down to label0
# BB#9:                                 # %if.end68
	i32.const	$push46=, 120
	i32.call	$push47=, strrchr@FUNCTION, $1, $pop46
	br_if   	0, $pop47       # 0: down to label0
# BB#10:                                # %if.end72
	i32.const	$push48=, 111
	i32.call	$push49=, strrchr@FUNCTION, $1, $pop48
	i32.ne  	$push50=, $pop49, $0
	br_if   	0, $pop50       # 0: down to label0
# BB#11:                                # %if.end77
	i32.const	$push51=, 0
	i32.const	$push140=, 0
	i32.load	$push56=, y($pop140)
	i32.const	$push57=, -1
	i32.add 	$push4=, $pop56, $pop57
	i32.store	$1=, y($pop51), $pop4
	i32.const	$push139=, 0
	i32.store	$discard=, x($pop139), $3
	i32.const	$push52=, 1
	i32.and 	$push53=, $2, $pop52
	i32.const	$push54=, .L.str.1
	i32.add 	$push55=, $pop53, $pop54
	i32.const	$push138=, 1
	i32.and 	$push58=, $1, $pop138
	i32.const	$push59=, .L.str.3
	i32.add 	$push60=, $pop58, $pop59
	i32.call	$push61=, strcmp@FUNCTION, $pop55, $pop60
	br_if   	0, $pop61       # 0: down to label0
# BB#12:                                # %if.end86
	br_if   	0, $1           # 0: down to label0
# BB#13:                                # %if.end86
	i32.const	$push141=, 6
	i32.ne  	$push62=, $3, $pop141
	br_if   	0, $pop62       # 0: down to label0
# BB#14:                                # %if.end90
	i32.const	$push146=, 0
	i32.const	$push145=, 6
	i32.store	$discard=, x($pop146), $pop145
	i32.const	$push65=, 1869376613
	i32.store	$discard=, 1($4):p2align=0, $pop65
	i32.const	$push144=, 0
	i32.const	$push64=, 1
	i32.store	$1=, y($pop144), $pop64
	i32.const	$push63=, 32
	i32.store16	$3=, 5($4):p2align=0, $pop63
	i32.or  	$push143=, $4, $1
	tee_local	$push142=, $1=, $pop143
	i32.const	$push66=, .L.str.4
	i32.call	$push67=, strcmp@FUNCTION, $pop142, $pop66
	br_if   	0, $pop67       # 0: down to label0
# BB#15:                                # %if.end108
	i32.const	$push70=, 64
	i32.call	$discard=, memset@FUNCTION, $4, $3, $pop70
	i32.const	$push148=, 0
	i32.const	$push72=, 2
	i32.store	$discard=, y($pop148), $pop72
	i32.const	$push147=, 0
	i32.const	$push71=, 7
	i32.store	$3=, x($pop147), $pop71
	i32.const	$push74=, .L.str.5+1
	i32.const	$push73=, 10
	i32.call	$push75=, strncpy@FUNCTION, $1, $pop74, $pop73
	i32.ne  	$push76=, $pop75, $1
	br_if   	0, $pop76       # 0: down to label0
# BB#16:                                # %if.end108
	i32.const	$push149=, 0
	i32.load	$push68=, x($pop149)
	i32.ne  	$push77=, $pop68, $3
	br_if   	0, $pop77       # 0: down to label0
# BB#17:                                # %if.end108
	i32.const	$push150=, 0
	i32.load	$push69=, y($pop150)
	i32.const	$push78=, 2
	i32.ne  	$push79=, $pop69, $pop78
	br_if   	0, $pop79       # 0: down to label0
# BB#18:                                # %lor.lhs.false125
	i32.const	$push80=, .L.str.6
	i32.const	$push81=, 12
	i32.call	$push82=, memcmp@FUNCTION, $4, $pop80, $pop81
	br_if   	0, $pop82       # 0: down to label0
# BB#19:                                # %if.end130
	i32.const	$push84=, 32
	i32.const	$push83=, 64
	i32.call	$discard=, memset@FUNCTION, $4, $pop84, $pop83
	i32.const	$push85=, .L.str.7
	i32.const	$push86=, 8
	i32.call	$push87=, strncpy@FUNCTION, $4, $pop85, $pop86
	i32.ne  	$push88=, $pop87, $4
	br_if   	0, $pop88       # 0: down to label0
# BB#20:                                # %lor.lhs.false136
	i32.const	$push89=, .L.str.8
	i32.const	$push90=, 9
	i32.call	$push91=, memcmp@FUNCTION, $4, $pop89, $pop90
	br_if   	0, $pop91       # 0: down to label0
# BB#21:                                # %if.end141
	i32.const	$push92=, buf
	i32.const	$push94=, 32
	i32.const	$push93=, 64
	i32.call	$3=, memset@FUNCTION, $pop92, $pop94, $pop93
	i32.const	$push95=, 0
	i32.const	$push153=, 0
	i32.load	$push97=, y($pop153)
	i32.const	$push98=, 1
	i32.add 	$push99=, $pop97, $pop98
	i32.store	$1=, y($pop95), $pop99
	i32.const	$push152=, 0
	i32.const	$push96=, 34
	i32.store	$discard=, x($pop152), $pop96
	i32.const	$push100=, 33
	i32.call	$discard=, memset@FUNCTION, $3, $pop100, $1
	i32.const	$push151=, 3
	i32.ne  	$push101=, $1, $pop151
	br_if   	0, $pop101      # 0: down to label0
# BB#22:                                # %lor.lhs.false148
	i32.const	$push102=, .L.str.9
	i32.const	$push154=, 3
	i32.call	$push103=, memcmp@FUNCTION, $3, $pop102, $pop154
	br_if   	0, $pop103      # 0: down to label0
# BB#23:                                # %lor.lhs.false158
	i32.const	$push157=, 0
	i32.const	$push104=, 4
	i32.store	$discard=, y($pop157), $pop104
	i32.const	$push156=, 0
	i64.const	$push105=, 3255307777713450285
	i64.store	$discard=, buf+3($pop156):p2align=0, $pop105
	i32.const	$push106=, buf
	i32.const	$push107=, .L.str.10
	i32.const	$push155=, 11
	i32.call	$push108=, memcmp@FUNCTION, $pop106, $pop107, $pop155
	br_if   	0, $pop108      # 0: down to label0
# BB#24:                                # %lor.lhs.false171
	i32.const	$push162=, 0
	i32.const	$push161=, 11
	i32.store	$discard=, x($pop162), $pop161
	i32.const	$push160=, 0
	i32.const	$push109=, 5
	i32.store	$discard=, y($pop160), $pop109
	i32.const	$push159=, 0
	i32.const	$push158=, 0
	i32.store	$discard=, buf+11($pop159):p2align=0, $pop158
	i32.const	$push112=, buf+8
	i32.const	$push110=, .L.str.11
	i32.const	$push111=, 7
	i32.call	$push113=, memcmp@FUNCTION, $pop112, $pop110, $pop111
	br_if   	0, $pop113      # 0: down to label0
# BB#25:                                # %lor.lhs.false180
	i32.const	$push115=, 0
	i32.const	$push114=, 15
	i32.store	$discard=, x($pop115), $pop114
	i32.const	$push166=, 0
	i32.const	$push165=, 0
	i32.store16	$push164=, buf+19($pop166):p2align=0, $pop165
	tee_local	$push163=, $1=, $pop164
	i32.store	$discard=, buf+15($pop163):p2align=0, $1
	i32.const	$push118=, buf+10
	i32.const	$push116=, .L.str.12
	i32.const	$push117=, 11
	i32.call	$push119=, memcmp@FUNCTION, $pop118, $pop116, $pop117
	br_if   	0, $pop119      # 0: down to label0
# BB#26:                                # %if.end184
	i32.const	$push173=, __stack_pointer
	i32.const	$push171=, 64
	i32.add 	$push172=, $4, $pop171
	i32.store	$discard=, 0($pop173), $pop172
	return  	$1
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
