	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/string-opt-5.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$21=, __stack_pointer
	i32.load	$21=, 0($21)
	i32.const	$22=, 64
	i32.sub 	$39=, $21, $22
	i32.const	$22=, __stack_pointer
	i32.store	$39=, 0($22), $39
	i32.const	$16=, 0
	i32.load	$0=, bar($16)
	i32.call	$8=, strlen, $0
	i32.const	$3=, 8
	block   	.LBB0_48
	i32.ne  	$push5=, $8, $3
	br_if   	$pop5, .LBB0_48
# BB#1:                                 # %if.end
	i32.load	$1=, x($16)
	i32.const	$4=, 1
	i32.add 	$push0=, $1, $4
	i32.store	$8=, x($16), $pop0
	i32.const	$5=, 2
	i32.and 	$push6=, $8, $5
	i32.add 	$push7=, $0, $pop6
	i32.call	$9=, strlen, $pop7
	i32.const	$6=, 6
	block   	.LBB0_47
	i32.ne  	$push8=, $9, $6
	br_if   	$pop8, .LBB0_47
# BB#2:                                 # %if.end4
	i32.const	$7=, 7
	block   	.LBB0_46
	i32.ne  	$push9=, $8, $7
	br_if   	$pop9, .LBB0_46
# BB#3:                                 # %if.end16
	i32.const	$8=, 3
	i32.add 	$push10=, $1, $8
	i32.store	$13=, x($16), $pop10
	i32.const	$9=, .L.str.1
	i32.and 	$push11=, $13, $4
	i32.add 	$push12=, $9, $pop11
	i32.call	$13=, strlen, $pop12
	i32.const	$10=, 10
	block   	.LBB0_45
	i32.ne  	$push13=, $13, $10
	br_if   	$pop13, .LBB0_45
# BB#4:                                 # %if.end26
	block   	.LBB0_44
	i32.const	$push14=, -3
	i32.add 	$push1=, $1, $pop14
	i32.store	$13=, x($16), $pop1
	i32.add 	$push15=, $9, $13
	i32.const	$push16=, .L.str.2
	i32.call	$push17=, strcmp, $pop15, $pop16
	br_if   	$pop17, .LBB0_44
# BB#5:                                 # %if.end33
	block   	.LBB0_43
	i32.call	$push18=, strcmp, $9, $0
	i32.ge_s	$push19=, $pop18, $16
	br_if   	$pop19, .LBB0_43
# BB#6:                                 # %if.end37
	block   	.LBB0_42
	i32.const	$push20=, -2
	i32.add 	$push2=, $1, $pop20
	i32.store	$2=, x($16), $pop2
	i32.and 	$push21=, $13, $4
	i32.add 	$push22=, $0, $pop21
	i32.call	$push23=, strcmp, $9, $pop22
	i32.ge_s	$push24=, $pop23, $16
	br_if   	$pop24, .LBB0_42
# BB#7:                                 # %if.end47
	i32.const	$11=, -1
	i32.const	$12=, 108
	block   	.LBB0_41
	i32.add 	$push3=, $1, $11
	i32.store	$19=, x($16), $pop3
	i32.and 	$push25=, $2, $7
	i32.add 	$push26=, $9, $pop25
	i32.call	$push27=, strchr, $pop26, $12
	i32.const	$push28=, .L.str.1+9
	i32.ne  	$push29=, $pop27, $pop28
	br_if   	$pop29, .LBB0_41
# BB#8:                                 # %if.end58
	i32.const	$13=, 111
	i32.call	$2=, strchr, $0, $13
	i32.const	$14=, 4
	block   	.LBB0_40
	i32.add 	$push30=, $0, $14
	i32.ne  	$push31=, $2, $pop30
	br_if   	$pop31, .LBB0_40
# BB#9:                                 # %if.end63
	block   	.LBB0_39
	i32.call	$push32=, strlen, $0
	i32.ne  	$push33=, $pop32, $3
	br_if   	$pop33, .LBB0_39
# BB#10:                                # %if.end68
	block   	.LBB0_38
	i32.const	$push34=, 120
	i32.call	$push35=, strrchr, $0, $pop34
	br_if   	$pop35, .LBB0_38
# BB#11:                                # %if.end72
	block   	.LBB0_37
	i32.call	$push36=, strrchr, $0, $13
	i32.ne  	$push37=, $pop36, $2
	br_if   	$pop37, .LBB0_37
# BB#12:                                # %if.end77
	i32.load	$push40=, y($16)
	i32.add 	$push4=, $pop40, $11
	i32.store	$0=, y($16), $pop4
	i32.store	$discard=, x($16), $1
	block   	.LBB0_36
	i32.and 	$push38=, $19, $4
	i32.add 	$push39=, $9, $pop38
	i32.const	$push42=, .L.str.3
	i32.and 	$push41=, $0, $4
	i32.add 	$push43=, $pop42, $pop41
	i32.call	$push44=, strcmp, $pop39, $pop43
	br_if   	$pop44, .LBB0_36
# BB#13:                                # %if.end86
	block   	.LBB0_35
	br_if   	$0, .LBB0_35
# BB#14:                                # %if.end86
	i32.ne  	$push45=, $1, $6
	br_if   	$pop45, .LBB0_35
# BB#15:                                # %if.end90
	i32.const	$24=, 0
	i32.add 	$24=, $39, $24
	i32.or  	$push48=, $24, $6
	i32.store8	$discard=, 0($pop48), $16
	i32.const	$25=, 0
	i32.add 	$25=, $39, $25
	i32.or  	$push49=, $25, $8
	i32.store8	$9=, 0($pop49), $12
	i32.store	$1=, y($16), $4
	i32.const	$26=, 0
	i32.add 	$26=, $39, $26
	i32.or  	$0=, $26, $1
	i32.const	$push50=, 101
	i32.store8	$discard=, 0($0), $pop50
	i32.add 	$push51=, $0, $8
	i32.store8	$discard=, 0($pop51), $13
	i32.add 	$push52=, $0, $1
	i32.store8	$discard=, 0($pop52), $9
	i32.const	$4=, 5
	i32.const	$27=, 0
	i32.add 	$27=, $39, $27
	i32.or  	$push46=, $27, $4
	i32.const	$push47=, 32
	i32.store8	$15=, 0($pop46), $pop47
	i32.store	$17=, x($16), $6
	block   	.LBB0_34
	i32.const	$push53=, .L.str.4
	i32.call	$push54=, strcmp, $0, $pop53
	br_if   	$pop54, .LBB0_34
# BB#16:                                # %if.end108
	i32.const	$push57=, 56
	i32.const	$28=, 0
	i32.add 	$28=, $39, $28
	i32.add 	$9=, $28, $pop57
	i64.const	$push58=, 2314885530818453536
	i64.store	$18=, 0($9), $pop58
	i32.const	$push59=, 48
	i32.const	$29=, 0
	i32.add 	$29=, $39, $29
	i32.add 	$13=, $29, $pop59
	i64.store	$discard=, 0($13), $18
	i32.const	$push60=, 40
	i32.const	$30=, 0
	i32.add 	$30=, $39, $30
	i32.add 	$11=, $30, $pop60
	i64.store	$discard=, 0($11), $18
	i32.const	$31=, 0
	i32.add 	$31=, $39, $31
	i32.add 	$2=, $31, $15
	i64.store	$discard=, 0($2), $18
	i32.const	$push61=, 24
	i32.const	$32=, 0
	i32.add 	$32=, $39, $32
	i32.add 	$12=, $32, $pop61
	i64.store	$discard=, 0($12), $18
	i32.const	$push62=, 16
	i32.const	$33=, 0
	i32.add 	$33=, $39, $33
	i32.add 	$19=, $33, $pop62
	i64.store	$discard=, 0($19), $18
	i32.const	$34=, 0
	i32.add 	$34=, $39, $34
	i32.or  	$20=, $34, $3
	i64.store	$push63=, 0($20), $18
	i64.store	$18=, 0($39), $pop63
	i32.store	$6=, x($16), $7
	i32.store	$7=, y($16), $5
	block   	.LBB0_33
	i32.const	$push64=, .L.str.5+1
	i32.call	$push65=, strncpy, $0, $pop64, $10
	i32.ne  	$push66=, $pop65, $0
	br_if   	$pop66, .LBB0_33
# BB#17:                                # %if.end108
	i32.load	$push55=, x($16)
	i32.ne  	$push67=, $pop55, $6
	br_if   	$pop67, .LBB0_33
# BB#18:                                # %if.end108
	i32.load	$push56=, y($16)
	i32.ne  	$push68=, $pop56, $7
	br_if   	$pop68, .LBB0_33
# BB#19:                                # %lor.lhs.false125
	i32.const	$push69=, .L.str.6
	i32.const	$push70=, 12
	i32.const	$35=, 0
	i32.add 	$35=, $39, $35
	i32.call	$push71=, memcmp, $35, $pop69, $pop70
	br_if   	$pop71, .LBB0_33
# BB#20:                                # %if.end130
	i64.store	$push72=, 0($9), $18
	i64.store	$push73=, 0($13), $pop72
	i64.store	$push74=, 0($11), $pop73
	i64.store	$push75=, 0($2), $pop74
	i64.store	$push76=, 0($12), $pop75
	i64.store	$push77=, 0($19), $pop76
	i64.store	$push78=, 0($20), $pop77
	i64.store	$discard=, 0($39), $pop78
	i32.const	$push79=, .L.str.7
	i32.const	$36=, 0
	i32.add 	$36=, $39, $36
	i32.call	$push80=, strncpy, $36, $pop79, $3
	i32.const	$37=, 0
	i32.add 	$37=, $39, $37
	block   	.LBB0_32
	i32.ne  	$push81=, $pop80, $37
	br_if   	$pop81, .LBB0_32
# BB#21:                                # %lor.lhs.false136
	i32.const	$push82=, .L.str.8
	i32.const	$push83=, 9
	i32.const	$38=, 0
	i32.add 	$38=, $39, $38
	i32.call	$push84=, memcmp, $38, $pop82, $pop83
	br_if   	$pop84, .LBB0_32
# BB#22:                                # %if.end141
	i32.const	$9=, buf
	block   	.LBB0_31
	i32.const	$push85=, 64
	call    	memset, $9, $15, $pop85
	i32.load	$push87=, y($16)
	i32.add 	$push88=, $pop87, $1
	i32.store	$0=, y($16), $pop88
	i32.const	$push86=, 34
	i32.store	$discard=, x($16), $pop86
	i32.const	$push89=, 33
	call    	memset, $9, $pop89, $0
	i32.ne  	$push90=, $0, $8
	br_if   	$pop90, .LBB0_31
# BB#23:                                # %lor.lhs.false148
	i32.const	$push91=, .L.str.9
	i32.call	$push92=, memcmp, $9, $pop91, $8
	br_if   	$pop92, .LBB0_31
# BB#24:                                # %lor.lhs.false158
	i64.const	$push94=, 45
	i64.store8	$18=, buf+3($16), $pop94
	i32.const	$0=, buf+3
	i32.add 	$push95=, $0, $6
	i64.store8	$discard=, 0($pop95), $18
	i32.add 	$push96=, $0, $17
	i64.store8	$discard=, 0($pop96), $18
	i32.add 	$push97=, $0, $4
	i64.store8	$discard=, 0($pop97), $18
	i32.store	$push93=, y($16), $14
	i32.add 	$push98=, $0, $pop93
	i64.store8	$discard=, 0($pop98), $18
	i32.add 	$push99=, $0, $8
	i64.store8	$discard=, 0($pop99), $18
	i32.add 	$push100=, $0, $7
	i64.store8	$discard=, 0($pop100), $18
	i32.const	$3=, 11
	block   	.LBB0_30
	i32.add 	$push101=, $0, $1
	i64.store8	$discard=, 0($pop101), $18
	i32.const	$push102=, .L.str.10
	i32.call	$push103=, memcmp, $9, $pop102, $3
	br_if   	$pop103, .LBB0_30
# BB#25:                                # %lor.lhs.false171
	i32.store	$discard=, y($16), $4
	i32.store	$9=, x($16), $3
	i32.const	$0=, buf+11
	i32.add 	$push104=, $0, $8
	i32.store8	$discard=, 0($pop104), $16
	i32.add 	$push105=, $0, $7
	i32.store8	$discard=, 0($pop105), $16
	i32.add 	$push106=, $0, $1
	i32.store8	$discard=, 0($pop106), $16
	i32.store8	$discard=, buf+11($16), $16
	block   	.LBB0_29
	i32.const	$push108=, buf+8
	i32.const	$push107=, .L.str.11
	i32.call	$push109=, memcmp, $pop108, $pop107, $6
	br_if   	$pop109, .LBB0_29
# BB#26:                                # %lor.lhs.false180
	i32.const	$push110=, 15
	i32.store	$discard=, x($16), $pop110
	i32.store8	$discard=, buf+20($16), $16
	i32.store8	$discard=, buf+19($16), $16
	i32.store8	$discard=, buf+18($16), $16
	i32.store8	$discard=, buf+17($16), $16
	i32.store8	$discard=, buf+16($16), $16
	i32.store8	$discard=, buf+15($16), $16
	block   	.LBB0_28
	i32.const	$push112=, buf+10
	i32.const	$push111=, .L.str.12
	i32.call	$push113=, memcmp, $pop112, $pop111, $9
	br_if   	$pop113, .LBB0_28
# BB#27:                                # %if.end184
	i32.const	$23=, 64
	i32.add 	$39=, $39, $23
	i32.const	$23=, __stack_pointer
	i32.store	$39=, 0($23), $39
	return  	$16
.LBB0_28:                               # %if.then183
	call    	abort
	unreachable
.LBB0_29:                               # %if.then174
	call    	abort
	unreachable
.LBB0_30:                               # %if.then161
	call    	abort
	unreachable
.LBB0_31:                               # %if.then151
	call    	abort
	unreachable
.LBB0_32:                               # %if.then140
	call    	abort
	unreachable
.LBB0_33:                               # %if.then129
	call    	abort
	unreachable
.LBB0_34:                               # %if.then107
	call    	abort
	unreachable
.LBB0_35:                               # %if.then89
	call    	abort
	unreachable
.LBB0_36:                               # %if.then85
	call    	abort
	unreachable
.LBB0_37:                               # %if.then76
	call    	abort
	unreachable
.LBB0_38:                               # %if.then71
	call    	abort
	unreachable
.LBB0_39:                               # %if.then67
	call    	abort
	unreachable
.LBB0_40:                               # %if.then62
	call    	abort
	unreachable
.LBB0_41:                               # %if.then54
	call    	abort
	unreachable
.LBB0_42:                               # %if.then43
	call    	abort
	unreachable
.LBB0_43:                               # %if.then36
	call    	abort
	unreachable
.LBB0_44:                               # %if.then29
	call    	abort
	unreachable
.LBB0_45:                               # %if.then22
	call    	abort
	unreachable
.LBB0_46:                               # %if.then6
	call    	abort
	unreachable
.LBB0_47:                               # %if.then3
	call    	abort
	unreachable
.LBB0_48:                               # %if.then
	call    	abort
	unreachable
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	x                       # @x
	.type	x,@object
	.section	.data.x,"aw",@progbits
	.globl	x
	.align	2
x:
	.int32	6                       # 0x6
	.size	x, 4

	.hidden	y                       # @y
	.type	y,@object
	.section	.data.y,"aw",@progbits
	.globl	y
	.align	2
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
	.align	2
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
	.align	4
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


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
