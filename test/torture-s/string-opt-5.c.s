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
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	i32.const	$push138=, 0
	i32.load	$push137=, bar($pop138)
	tee_local	$push136=, $1=, $pop137
	i32.call	$push5=, strlen@FUNCTION, $pop136
	i32.const	$push6=, 8
	i32.ne  	$push7=, $pop5, $pop6
	br_if   	0, $pop7        # 0: down to label17
# BB#1:                                 # %if.end
	i32.const	$push144=, 0
	i32.const	$push143=, 0
	i32.load	$push142=, x($pop143)
	tee_local	$push141=, $3=, $pop142
	i32.const	$push8=, 1
	i32.add 	$push0=, $pop141, $pop8
	i32.store	$push140=, x($pop144), $pop0
	tee_local	$push139=, $2=, $pop140
	i32.const	$push9=, 2
	i32.and 	$push10=, $pop139, $pop9
	i32.add 	$push11=, $1, $pop10
	i32.call	$push12=, strlen@FUNCTION, $pop11
	i32.const	$push13=, 6
	i32.ne  	$push14=, $pop12, $pop13
	br_if   	1, $pop14       # 1: down to label16
# BB#2:                                 # %if.end4
	i32.const	$push15=, 7
	i32.ne  	$push16=, $2, $pop15
	br_if   	2, $pop16       # 2: down to label15
# BB#3:                                 # %if.end16
	i32.const	$push145=, 0
	i32.const	$push17=, 3
	i32.add 	$push18=, $3, $pop17
	i32.store	$push19=, x($pop145), $pop18
	i32.const	$push20=, 1
	i32.and 	$push21=, $pop19, $pop20
	i32.const	$push22=, .L.str.1
	i32.add 	$push23=, $pop21, $pop22
	i32.call	$push24=, strlen@FUNCTION, $pop23
	i32.const	$push25=, 10
	i32.ne  	$push26=, $pop24, $pop25
	br_if   	3, $pop26       # 3: down to label14
# BB#4:                                 # %if.end26
	i32.const	$push146=, 0
	i32.const	$push27=, -3
	i32.add 	$push1=, $3, $pop27
	i32.store	$2=, x($pop146), $pop1
	i32.const	$push28=, .L.str.1-3
	i32.add 	$push29=, $3, $pop28
	i32.const	$push30=, .L.str.2
	i32.call	$push31=, strcmp@FUNCTION, $pop29, $pop30
	br_if   	4, $pop31       # 4: down to label13
# BB#5:                                 # %if.end33
	i32.const	$push148=, .L.str.1
	i32.call	$push32=, strcmp@FUNCTION, $pop148, $1
	i32.const	$push147=, 0
	i32.ge_s	$push33=, $pop32, $pop147
	br_if   	5, $pop33       # 5: down to label12
# BB#6:                                 # %if.end37
	i32.const	$push151=, 0
	i32.const	$push34=, -2
	i32.add 	$push2=, $3, $pop34
	i32.store	$0=, x($pop151), $pop2
	i32.const	$push150=, .L.str.1
	i32.const	$push35=, 1
	i32.and 	$push36=, $2, $pop35
	i32.add 	$push37=, $1, $pop36
	i32.call	$push38=, strcmp@FUNCTION, $pop150, $pop37
	i32.const	$push149=, 0
	i32.ge_s	$push39=, $pop38, $pop149
	br_if   	6, $pop39       # 6: down to label11
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
	br_if   	7, $pop49       # 7: down to label10
# BB#8:                                 # %if.end58
	i32.const	$push50=, 111
	i32.call	$push153=, strchr@FUNCTION, $1, $pop50
	tee_local	$push152=, $0=, $pop153
	i32.const	$push51=, 4
	i32.add 	$push52=, $1, $pop51
	i32.ne  	$push53=, $pop152, $pop52
	br_if   	8, $pop53       # 8: down to label9
# BB#9:                                 # %if.end63
	i32.call	$push54=, strlen@FUNCTION, $1
	i32.const	$push55=, 8
	i32.ne  	$push56=, $pop54, $pop55
	br_if   	9, $pop56       # 9: down to label8
# BB#10:                                # %if.end68
	i32.const	$push57=, 120
	i32.call	$push58=, strrchr@FUNCTION, $1, $pop57
	br_if   	10, $pop58      # 10: down to label7
# BB#11:                                # %if.end72
	i32.const	$push59=, 111
	i32.call	$push60=, strrchr@FUNCTION, $1, $pop59
	i32.ne  	$push61=, $pop60, $0
	br_if   	11, $pop61      # 11: down to label6
# BB#12:                                # %if.end77
	i32.const	$push62=, 0
	i32.const	$push156=, 0
	i32.load	$push67=, y($pop156)
	i32.const	$push68=, -1
	i32.add 	$push4=, $pop67, $pop68
	i32.store	$1=, y($pop62), $pop4
	i32.const	$push155=, 0
	i32.store	$discard=, x($pop155), $3
	i32.const	$push63=, 1
	i32.and 	$push64=, $2, $pop63
	i32.const	$push65=, .L.str.1
	i32.add 	$push66=, $pop64, $pop65
	i32.const	$push154=, 1
	i32.and 	$push69=, $1, $pop154
	i32.const	$push70=, .L.str.3
	i32.add 	$push71=, $pop69, $pop70
	i32.call	$push72=, strcmp@FUNCTION, $pop66, $pop71
	br_if   	12, $pop72      # 12: down to label5
# BB#13:                                # %if.end86
	br_if   	13, $1          # 13: down to label4
# BB#14:                                # %if.end86
	i32.const	$push157=, 6
	i32.ne  	$push73=, $3, $pop157
	br_if   	13, $pop73      # 13: down to label4
# BB#15:                                # %if.end90
	i32.const	$push74=, 5
	i32.or  	$push75=, $7, $pop74
	i32.const	$push76=, 32
	i32.store8	$2=, 0($pop75), $pop76
	i32.const	$push163=, 6
	i32.or  	$push77=, $7, $pop163
	i32.const	$push78=, 0
	i32.store8	$push162=, 0($pop77):p2align=1, $pop78
	tee_local	$push161=, $1=, $pop162
	i32.const	$push160=, 6
	i32.store	$discard=, x($pop161), $pop160
	i32.const	$push79=, 1
	i32.store	$push80=, y($1), $pop79
	i32.or  	$push159=, $7, $pop80
	tee_local	$push158=, $3=, $pop159
	i32.const	$push81=, 1869376613
	i32.store	$discard=, 0($pop158):p2align=0, $pop81
	i32.const	$push82=, .L.str.4
	i32.call	$push83=, strcmp@FUNCTION, $3, $pop82
	br_if   	14, $pop83      # 14: down to label3
# BB#16:                                # %if.end108
	i32.const	$push86=, 64
	i32.call	$discard=, memset@FUNCTION, $7, $2, $pop86
	i32.const	$push88=, 2
	i32.store	$discard=, y($1), $pop88
	i32.const	$push87=, 7
	i32.store	$2=, x($1), $pop87
	block
	block
	block
	i32.const	$push90=, .L.str.5+1
	i32.const	$push89=, 10
	i32.call	$push91=, strncpy@FUNCTION, $3, $pop90, $pop89
	i32.ne  	$push92=, $pop91, $3
	br_if   	0, $pop92       # 0: down to label20
# BB#17:                                # %if.end108
	i32.load	$push84=, x($1)
	i32.ne  	$push93=, $pop84, $2
	br_if   	0, $pop93       # 0: down to label20
# BB#18:                                # %if.end108
	i32.load	$push85=, y($1)
	i32.const	$push94=, 2
	i32.ne  	$push95=, $pop85, $pop94
	br_if   	0, $pop95       # 0: down to label20
# BB#19:                                # %lor.lhs.false125
	i32.const	$push96=, .L.str.6
	i32.const	$push97=, 12
	i32.call	$push98=, memcmp@FUNCTION, $7, $pop96, $pop97
	br_if   	0, $pop98       # 0: down to label20
# BB#20:                                # %if.end130
	i32.const	$push100=, 32
	i32.const	$push99=, 64
	i32.call	$discard=, memset@FUNCTION, $7, $pop100, $pop99
	i32.const	$push101=, .L.str.7
	i32.const	$push102=, 8
	i32.call	$push103=, strncpy@FUNCTION, $7, $pop101, $pop102
	i32.ne  	$push104=, $pop103, $7
	br_if   	1, $pop104      # 1: down to label19
# BB#21:                                # %lor.lhs.false136
	i32.const	$push105=, .L.str.8
	i32.const	$push106=, 9
	i32.call	$push107=, memcmp@FUNCTION, $7, $pop105, $pop106
	br_if   	1, $pop107      # 1: down to label19
# BB#22:                                # %if.end141
	i32.const	$push108=, buf
	i32.const	$push110=, 32
	i32.const	$push109=, 64
	i32.call	$3=, memset@FUNCTION, $pop108, $pop110, $pop109
	i32.const	$push111=, 0
	i32.const	$push166=, 0
	i32.load	$push113=, y($pop166)
	i32.const	$push114=, 1
	i32.add 	$push115=, $pop113, $pop114
	i32.store	$1=, y($pop111), $pop115
	i32.const	$push165=, 0
	i32.const	$push112=, 34
	i32.store	$discard=, x($pop165), $pop112
	i32.const	$push116=, 33
	i32.call	$discard=, memset@FUNCTION, $3, $pop116, $1
	i32.const	$push164=, 3
	i32.ne  	$push117=, $1, $pop164
	br_if   	2, $pop117      # 2: down to label18
# BB#23:                                # %lor.lhs.false148
	i32.const	$push118=, .L.str.9
	i32.const	$push167=, 3
	i32.call	$push119=, memcmp@FUNCTION, $3, $pop118, $pop167
	br_if   	2, $pop119      # 2: down to label18
# BB#24:                                # %lor.lhs.false158
	i32.const	$push170=, 0
	i32.const	$push120=, 4
	i32.store	$discard=, y($pop170), $pop120
	i32.const	$push169=, 0
	i64.const	$push121=, 3255307777713450285
	i64.store	$discard=, buf+3($pop169):p2align=0, $pop121
	i32.const	$push122=, buf
	i32.const	$push123=, .L.str.10
	i32.const	$push168=, 11
	i32.call	$push124=, memcmp@FUNCTION, $pop122, $pop123, $pop168
	br_if   	18, $pop124     # 18: down to label2
# BB#25:                                # %lor.lhs.false171
	i32.const	$push175=, 0
	i32.const	$push174=, 11
	i32.store	$discard=, x($pop175), $pop174
	i32.const	$push173=, 0
	i32.const	$push125=, 5
	i32.store	$discard=, y($pop173), $pop125
	i32.const	$push172=, 0
	i32.const	$push171=, 0
	i32.store	$discard=, buf+11($pop172):p2align=0, $pop171
	i32.const	$push128=, buf+8
	i32.const	$push126=, .L.str.11
	i32.const	$push127=, 7
	i32.call	$push129=, memcmp@FUNCTION, $pop128, $pop126, $pop127
	br_if   	19, $pop129     # 19: down to label1
# BB#26:                                # %lor.lhs.false180
	i32.const	$push131=, 0
	i32.const	$push130=, 15
	i32.store	$discard=, x($pop131), $pop130
	i32.const	$push179=, 0
	i32.const	$push178=, 0
	i32.store16	$push177=, buf+19($pop179):p2align=0, $pop178
	tee_local	$push176=, $1=, $pop177
	i32.store	$discard=, buf+15($pop176):p2align=0, $1
	i32.const	$push134=, buf+10
	i32.const	$push132=, .L.str.12
	i32.const	$push133=, 11
	i32.call	$push135=, memcmp@FUNCTION, $pop134, $pop132, $pop133
	br_if   	20, $pop135     # 20: down to label0
# BB#27:                                # %if.end184
	i32.const	$6=, 64
	i32.add 	$7=, $7, $6
	i32.const	$6=, __stack_pointer
	i32.store	$7=, 0($6), $7
	return  	$1
.LBB0_28:                               # %if.then129
	end_block                       # label20:
	call    	abort@FUNCTION
	unreachable
.LBB0_29:                               # %if.then140
	end_block                       # label19:
	call    	abort@FUNCTION
	unreachable
.LBB0_30:                               # %if.then151
	end_block                       # label18:
	call    	abort@FUNCTION
	unreachable
.LBB0_31:                               # %if.then
	end_block                       # label17:
	call    	abort@FUNCTION
	unreachable
.LBB0_32:                               # %if.then3
	end_block                       # label16:
	call    	abort@FUNCTION
	unreachable
.LBB0_33:                               # %if.then6
	end_block                       # label15:
	call    	abort@FUNCTION
	unreachable
.LBB0_34:                               # %if.then22
	end_block                       # label14:
	call    	abort@FUNCTION
	unreachable
.LBB0_35:                               # %if.then29
	end_block                       # label13:
	call    	abort@FUNCTION
	unreachable
.LBB0_36:                               # %if.then36
	end_block                       # label12:
	call    	abort@FUNCTION
	unreachable
.LBB0_37:                               # %if.then43
	end_block                       # label11:
	call    	abort@FUNCTION
	unreachable
.LBB0_38:                               # %if.then54
	end_block                       # label10:
	call    	abort@FUNCTION
	unreachable
.LBB0_39:                               # %if.then62
	end_block                       # label9:
	call    	abort@FUNCTION
	unreachable
.LBB0_40:                               # %if.then67
	end_block                       # label8:
	call    	abort@FUNCTION
	unreachable
.LBB0_41:                               # %if.then71
	end_block                       # label7:
	call    	abort@FUNCTION
	unreachable
.LBB0_42:                               # %if.then76
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
.LBB0_43:                               # %if.then85
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
.LBB0_44:                               # %if.then89
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB0_45:                               # %if.then107
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB0_46:                               # %if.then161
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB0_47:                               # %if.then174
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_48:                               # %if.then183
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
