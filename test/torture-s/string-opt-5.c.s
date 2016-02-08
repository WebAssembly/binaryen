	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/string-opt-5.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$4=, __stack_pointer
	i32.load	$4=, 0($4)
	i32.const	$5=, 64
	i32.sub 	$7=, $4, $5
	i32.const	$5=, __stack_pointer
	i32.store	$7=, 0($5), $7
	block
	i32.const	$push144=, 0
	i32.load	$push0=, bar($pop144)
	tee_local	$push143=, $1=, $pop0
	i32.call	$push9=, strlen@FUNCTION, $pop143
	i32.const	$push10=, 8
	i32.ne  	$push11=, $pop9, $pop10
	br_if   	0, $pop11       # 0: down to label0
# BB#1:                                 # %if.end
	block
	i32.const	$push148=, 0
	i32.const	$push147=, 0
	i32.load	$push1=, x($pop147)
	tee_local	$push146=, $3=, $pop1
	i32.const	$push12=, 1
	i32.add 	$push2=, $pop146, $pop12
	i32.store	$push13=, x($pop148), $pop2
	tee_local	$push145=, $2=, $pop13
	i32.const	$push14=, 2
	i32.and 	$push15=, $pop145, $pop14
	i32.add 	$push16=, $1, $pop15
	i32.call	$push17=, strlen@FUNCTION, $pop16
	i32.const	$push18=, 6
	i32.ne  	$push19=, $pop17, $pop18
	br_if   	0, $pop19       # 0: down to label1
# BB#2:                                 # %if.end4
	block
	i32.const	$push20=, 7
	i32.ne  	$push21=, $2, $pop20
	br_if   	0, $pop21       # 0: down to label2
# BB#3:                                 # %if.end16
	block
	i32.const	$push149=, 0
	i32.const	$push22=, 3
	i32.add 	$push23=, $3, $pop22
	i32.store	$push24=, x($pop149), $pop23
	i32.const	$push25=, 1
	i32.and 	$push26=, $pop24, $pop25
	i32.const	$push27=, .L.str.1
	i32.add 	$push28=, $pop26, $pop27
	i32.call	$push29=, strlen@FUNCTION, $pop28
	i32.const	$push30=, 10
	i32.ne  	$push31=, $pop29, $pop30
	br_if   	0, $pop31       # 0: down to label3
# BB#4:                                 # %if.end26
	i32.const	$push150=, 0
	i32.const	$push32=, -3
	i32.add 	$push3=, $3, $pop32
	i32.store	$2=, x($pop150), $pop3
	block
	i32.const	$push33=, .L.str.1-3
	i32.add 	$push34=, $3, $pop33
	i32.const	$push35=, .L.str.2
	i32.call	$push36=, strcmp@FUNCTION, $pop34, $pop35
	br_if   	0, $pop36       # 0: down to label4
# BB#5:                                 # %if.end33
	block
	i32.const	$push152=, .L.str.1
	i32.call	$push37=, strcmp@FUNCTION, $pop152, $1
	i32.const	$push151=, 0
	i32.ge_s	$push38=, $pop37, $pop151
	br_if   	0, $pop38       # 0: down to label5
# BB#6:                                 # %if.end37
	i32.const	$push155=, 0
	i32.const	$push39=, -2
	i32.add 	$push4=, $3, $pop39
	i32.store	$0=, x($pop155), $pop4
	block
	i32.const	$push154=, .L.str.1
	i32.const	$push40=, 1
	i32.and 	$push41=, $2, $pop40
	i32.add 	$push42=, $1, $pop41
	i32.call	$push43=, strcmp@FUNCTION, $pop154, $pop42
	i32.const	$push153=, 0
	i32.ge_s	$push44=, $pop43, $pop153
	br_if   	0, $pop44       # 0: down to label6
# BB#7:                                 # %if.end47
	i32.const	$push46=, 0
	i32.const	$push45=, -1
	i32.add 	$push5=, $3, $pop45
	i32.store	$2=, x($pop46), $pop5
	block
	i32.const	$push47=, 7
	i32.and 	$push48=, $0, $pop47
	i32.const	$push49=, .L.str.1
	i32.add 	$push50=, $pop48, $pop49
	i32.const	$push51=, 108
	i32.call	$push52=, strchr@FUNCTION, $pop50, $pop51
	i32.const	$push53=, .L.str.1+9
	i32.ne  	$push54=, $pop52, $pop53
	br_if   	0, $pop54       # 0: down to label7
# BB#8:                                 # %if.end58
	block
	i32.const	$push55=, 111
	i32.call	$push6=, strchr@FUNCTION, $1, $pop55
	tee_local	$push156=, $0=, $pop6
	i32.const	$push56=, 4
	i32.add 	$push57=, $1, $pop56
	i32.ne  	$push58=, $pop156, $pop57
	br_if   	0, $pop58       # 0: down to label8
# BB#9:                                 # %if.end63
	block
	i32.call	$push59=, strlen@FUNCTION, $1
	i32.const	$push60=, 8
	i32.ne  	$push61=, $pop59, $pop60
	br_if   	0, $pop61       # 0: down to label9
# BB#10:                                # %if.end68
	block
	i32.const	$push62=, 120
	i32.call	$push63=, strrchr@FUNCTION, $1, $pop62
	br_if   	0, $pop63       # 0: down to label10
# BB#11:                                # %if.end72
	block
	i32.const	$push64=, 111
	i32.call	$push65=, strrchr@FUNCTION, $1, $pop64
	i32.ne  	$push66=, $pop65, $0
	br_if   	0, $pop66       # 0: down to label11
# BB#12:                                # %if.end77
	i32.const	$push67=, 0
	i32.const	$push159=, 0
	i32.load	$push72=, y($pop159)
	i32.const	$push73=, -1
	i32.add 	$push7=, $pop72, $pop73
	i32.store	$1=, y($pop67), $pop7
	i32.const	$push158=, 0
	i32.store	$discard=, x($pop158), $3
	block
	i32.const	$push68=, 1
	i32.and 	$push69=, $2, $pop68
	i32.const	$push70=, .L.str.1
	i32.add 	$push71=, $pop69, $pop70
	i32.const	$push157=, 1
	i32.and 	$push74=, $1, $pop157
	i32.const	$push75=, .L.str.3
	i32.add 	$push76=, $pop74, $pop75
	i32.call	$push77=, strcmp@FUNCTION, $pop71, $pop76
	br_if   	0, $pop77       # 0: down to label12
# BB#13:                                # %if.end86
	block
	br_if   	0, $1           # 0: down to label13
# BB#14:                                # %if.end86
	i32.const	$push160=, 6
	i32.ne  	$push78=, $3, $pop160
	br_if   	0, $pop78       # 0: down to label13
# BB#15:                                # %if.end90
	i32.const	$push79=, 5
	i32.or  	$push80=, $7, $pop79
	i32.const	$push81=, 32
	i32.store8	$2=, 0($pop80), $pop81
	i32.const	$push164=, 6
	i32.or  	$push82=, $7, $pop164
	i32.const	$push83=, 0
	i32.store8	$push84=, 0($pop82):p2align=1, $pop83
	tee_local	$push163=, $1=, $pop84
	i32.const	$push162=, 6
	i32.store	$discard=, x($pop163), $pop162
	i32.const	$push85=, 1
	i32.store	$push86=, y($1), $pop85
	i32.or  	$push8=, $7, $pop86
	tee_local	$push161=, $3=, $pop8
	i32.const	$push87=, 1869376613
	i32.store	$discard=, 0($pop161):p2align=0, $pop87
	block
	i32.const	$push88=, .L.str.4
	i32.call	$push89=, strcmp@FUNCTION, $3, $pop88
	br_if   	0, $pop89       # 0: down to label14
# BB#16:                                # %if.end108
	i32.const	$push92=, 64
	i32.call	$discard=, memset@FUNCTION, $7, $2, $pop92
	i32.const	$push94=, 2
	i32.store	$discard=, y($1), $pop94
	i32.const	$push93=, 7
	i32.store	$2=, x($1), $pop93
	block
	i32.const	$push96=, .L.str.5+1
	i32.const	$push95=, 10
	i32.call	$push97=, strncpy@FUNCTION, $3, $pop96, $pop95
	i32.ne  	$push98=, $pop97, $3
	br_if   	0, $pop98       # 0: down to label15
# BB#17:                                # %if.end108
	i32.load	$push90=, x($1)
	i32.ne  	$push99=, $pop90, $2
	br_if   	0, $pop99       # 0: down to label15
# BB#18:                                # %if.end108
	i32.load	$push91=, y($1)
	i32.const	$push100=, 2
	i32.ne  	$push101=, $pop91, $pop100
	br_if   	0, $pop101      # 0: down to label15
# BB#19:                                # %lor.lhs.false125
	i32.const	$push102=, .L.str.6
	i32.const	$push103=, 12
	i32.call	$push104=, memcmp@FUNCTION, $7, $pop102, $pop103
	br_if   	0, $pop104      # 0: down to label15
# BB#20:                                # %if.end130
	i32.const	$push106=, 32
	i32.const	$push105=, 64
	i32.call	$discard=, memset@FUNCTION, $7, $pop106, $pop105
	block
	i32.const	$push107=, .L.str.7
	i32.const	$push108=, 8
	i32.call	$push109=, strncpy@FUNCTION, $7, $pop107, $pop108
	i32.ne  	$push110=, $pop109, $7
	br_if   	0, $pop110      # 0: down to label16
# BB#21:                                # %lor.lhs.false136
	i32.const	$push111=, .L.str.8
	i32.const	$push112=, 9
	i32.call	$push113=, memcmp@FUNCTION, $7, $pop111, $pop112
	br_if   	0, $pop113      # 0: down to label16
# BB#22:                                # %if.end141
	i32.const	$push114=, buf
	i32.const	$push116=, 32
	i32.const	$push115=, 64
	i32.call	$3=, memset@FUNCTION, $pop114, $pop116, $pop115
	i32.const	$push117=, 0
	i32.const	$push167=, 0
	i32.load	$push119=, y($pop167)
	i32.const	$push120=, 1
	i32.add 	$push121=, $pop119, $pop120
	i32.store	$1=, y($pop117), $pop121
	i32.const	$push166=, 0
	i32.const	$push118=, 34
	i32.store	$discard=, x($pop166), $pop118
	i32.const	$push122=, 33
	i32.call	$discard=, memset@FUNCTION, $3, $pop122, $1
	block
	i32.const	$push165=, 3
	i32.ne  	$push123=, $1, $pop165
	br_if   	0, $pop123      # 0: down to label17
# BB#23:                                # %lor.lhs.false148
	i32.const	$push124=, .L.str.9
	i32.const	$push168=, 3
	i32.call	$push125=, memcmp@FUNCTION, $3, $pop124, $pop168
	br_if   	0, $pop125      # 0: down to label17
# BB#24:                                # %lor.lhs.false158
	i32.const	$push171=, 0
	i32.const	$push126=, 4
	i32.store	$discard=, y($pop171), $pop126
	i32.const	$push170=, 0
	i64.const	$push127=, 3255307777713450285
	i64.store	$discard=, buf+3($pop170):p2align=0, $pop127
	block
	i32.const	$push128=, buf
	i32.const	$push129=, .L.str.10
	i32.const	$push169=, 11
	i32.call	$push130=, memcmp@FUNCTION, $pop128, $pop129, $pop169
	br_if   	0, $pop130      # 0: down to label18
# BB#25:                                # %lor.lhs.false171
	i32.const	$push176=, 0
	i32.const	$push175=, 11
	i32.store	$discard=, x($pop176), $pop175
	i32.const	$push174=, 0
	i32.const	$push131=, 5
	i32.store	$discard=, y($pop174), $pop131
	i32.const	$push173=, 0
	i32.const	$push172=, 0
	i32.store	$discard=, buf+11($pop173):p2align=0, $pop172
	block
	i32.const	$push134=, buf+8
	i32.const	$push132=, .L.str.11
	i32.const	$push133=, 7
	i32.call	$push135=, memcmp@FUNCTION, $pop134, $pop132, $pop133
	br_if   	0, $pop135      # 0: down to label19
# BB#26:                                # %lor.lhs.false180
	i32.const	$push137=, 0
	i32.const	$push136=, 15
	i32.store	$discard=, x($pop137), $pop136
	i32.const	$push179=, 0
	i32.const	$push178=, 0
	i32.store16	$push138=, buf+19($pop179):p2align=0, $pop178
	tee_local	$push177=, $1=, $pop138
	i32.store	$discard=, buf+15($pop177):p2align=0, $1
	block
	i32.const	$push141=, buf+10
	i32.const	$push139=, .L.str.12
	i32.const	$push140=, 11
	i32.call	$push142=, memcmp@FUNCTION, $pop141, $pop139, $pop140
	br_if   	0, $pop142      # 0: down to label20
# BB#27:                                # %if.end184
	i32.const	$6=, 64
	i32.add 	$7=, $7, $6
	i32.const	$6=, __stack_pointer
	i32.store	$7=, 0($6), $7
	return  	$1
.LBB0_28:                               # %if.then183
	end_block                       # label20:
	call    	abort@FUNCTION
	unreachable
.LBB0_29:                               # %if.then174
	end_block                       # label19:
	call    	abort@FUNCTION
	unreachable
.LBB0_30:                               # %if.then161
	end_block                       # label18:
	call    	abort@FUNCTION
	unreachable
.LBB0_31:                               # %if.then151
	end_block                       # label17:
	call    	abort@FUNCTION
	unreachable
.LBB0_32:                               # %if.then140
	end_block                       # label16:
	call    	abort@FUNCTION
	unreachable
.LBB0_33:                               # %if.then129
	end_block                       # label15:
	call    	abort@FUNCTION
	unreachable
.LBB0_34:                               # %if.then107
	end_block                       # label14:
	call    	abort@FUNCTION
	unreachable
.LBB0_35:                               # %if.then89
	end_block                       # label13:
	call    	abort@FUNCTION
	unreachable
.LBB0_36:                               # %if.then85
	end_block                       # label12:
	call    	abort@FUNCTION
	unreachable
.LBB0_37:                               # %if.then76
	end_block                       # label11:
	call    	abort@FUNCTION
	unreachable
.LBB0_38:                               # %if.then71
	end_block                       # label10:
	call    	abort@FUNCTION
	unreachable
.LBB0_39:                               # %if.then67
	end_block                       # label9:
	call    	abort@FUNCTION
	unreachable
.LBB0_40:                               # %if.then62
	end_block                       # label8:
	call    	abort@FUNCTION
	unreachable
.LBB0_41:                               # %if.then54
	end_block                       # label7:
	call    	abort@FUNCTION
	unreachable
.LBB0_42:                               # %if.then43
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
.LBB0_43:                               # %if.then36
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
.LBB0_44:                               # %if.then29
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB0_45:                               # %if.then22
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB0_46:                               # %if.then6
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB0_47:                               # %if.then3
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_48:                               # %if.then
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
