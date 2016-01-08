	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20020508-2.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i64, i64, i64, i64, i64, i32, i32, i32, i32, i32, i32, i32, i32, i64, i64, i64, i32, i64
# BB#0:                                 # %entry
	i32.const	$11=, 0
	i32.load	$1=, shift1($11)
	i32.load8_s	$0=, c($11)
	i32.const	$push1=, 8
	i32.sub 	$2=, $pop1, $1
	i32.const	$12=, 835
	block   	.LBB0_42
	i32.shl 	$push2=, $0, $2
	i32.shr_s	$push0=, $0, $1
	i32.or  	$push3=, $pop2, $pop0
	i32.ne  	$push4=, $pop3, $12
	br_if   	$pop4, .LBB0_42
# BB#1:                                 # %if.end
	i32.const	$13=, 4
	block   	.LBB0_41
	i32.shr_s	$push5=, $0, $13
	i32.shl 	$push6=, $0, $13
	i32.or  	$push7=, $pop5, $pop6
	i32.ne  	$push8=, $pop7, $12
	br_if   	$pop8, .LBB0_41
# BB#2:                                 # %if.end11
	i32.load16_s	$3=, s($11)
	i32.const	$push10=, 16
	i32.sub 	$4=, $pop10, $1
	i32.const	$14=, 19087651
	block   	.LBB0_40
	i32.shr_s	$push9=, $3, $1
	i32.shl 	$push11=, $3, $4
	i32.or  	$push12=, $pop9, $pop11
	i32.ne  	$push13=, $pop12, $14
	br_if   	$pop13, .LBB0_40
# BB#3:                                 # %if.end21
	i32.const	$15=, 12
	block   	.LBB0_39
	i32.shr_s	$push14=, $3, $13
	i32.shl 	$push15=, $3, $15
	i32.or  	$push16=, $pop14, $pop15
	i32.ne  	$push17=, $pop16, $14
	br_if   	$pop17, .LBB0_39
# BB#4:                                 # %if.end30
	i32.load	$14=, i($11)
	i32.const	$push19=, 32
	i32.sub 	$5=, $pop19, $1
	i32.const	$16=, 1073742115
	block   	.LBB0_38
	i32.shr_s	$push18=, $14, $1
	i32.shl 	$push20=, $14, $5
	i32.or  	$push21=, $pop18, $pop20
	i32.ne  	$push22=, $pop21, $16
	br_if   	$pop22, .LBB0_38
# BB#5:                                 # %if.end38
	i32.const	$17=, 28
	block   	.LBB0_37
	i32.shr_s	$push23=, $14, $13
	i32.shl 	$push24=, $14, $17
	i32.or  	$push25=, $pop23, $pop24
	i32.ne  	$push26=, $pop25, $16
	br_if   	$pop26, .LBB0_37
# BB#6:                                 # %if.end45
	i32.load	$16=, l($11)
	i32.const	$18=, -2128394905
	block   	.LBB0_36
	i32.shr_s	$push27=, $16, $1
	i32.shl 	$push28=, $16, $5
	i32.or  	$push29=, $pop27, $pop28
	i32.ne  	$push30=, $pop29, $18
	br_if   	$pop30, .LBB0_36
# BB#7:                                 # %if.end53
	block   	.LBB0_35
	i32.shr_s	$push31=, $16, $13
	i32.shl 	$push32=, $16, $17
	i32.or  	$push33=, $pop31, $pop32
	i32.ne  	$push34=, $pop33, $18
	br_if   	$pop34, .LBB0_35
# BB#8:                                 # %if.end60
	i64.load	$6=, ll($11)
	i32.const	$18=, 64
	i32.sub 	$push36=, $18, $1
	i64.extend_u/i32	$8=, $pop36
	i64.extend_u/i32	$7=, $1
	i64.const	$19=, 5124095577148911
	block   	.LBB0_34
	i64.shr_s	$push35=, $6, $7
	i64.shl 	$push37=, $6, $8
	i64.or  	$push38=, $pop35, $pop37
	i64.ne  	$push39=, $pop38, $19
	br_if   	$pop39, .LBB0_34
# BB#9:                                 # %if.end69
	i64.const	$20=, 4
	i64.const	$21=, 60
	block   	.LBB0_33
	i64.shr_s	$push40=, $6, $20
	i64.shl 	$push41=, $6, $21
	i64.or  	$push42=, $pop40, $pop41
	i64.ne  	$push43=, $pop42, $19
	br_if   	$pop43, .LBB0_33
# BB#10:                                # %if.end76
	i32.load	$22=, shift2($11)
	i64.extend_u/i32	$9=, $22
	i32.sub 	$push45=, $18, $22
	i64.extend_u/i32	$10=, $pop45
	i64.const	$23=, 1311768467750121216
	block   	.LBB0_32
	i64.shl 	$push46=, $6, $10
	i64.shr_s	$push44=, $6, $9
	i64.or  	$push47=, $pop46, $pop44
	i64.ne  	$push48=, $pop47, $23
	br_if   	$pop48, .LBB0_32
# BB#11:                                # %if.end86
	block   	.LBB0_31
	i64.shr_s	$push49=, $6, $21
	i64.shl 	$push50=, $6, $20
	i64.or  	$push51=, $pop49, $pop50
	i64.ne  	$push52=, $pop51, $23
	br_if   	$pop52, .LBB0_31
# BB#12:                                # %if.end93
	block   	.LBB0_30
	i32.shr_s	$push54=, $0, $2
	i32.shl 	$push53=, $0, $1
	i32.or  	$push55=, $pop54, $pop53
	i32.ne  	$push56=, $pop55, $12
	br_if   	$pop56, .LBB0_30
# BB#13:                                # %if.end112
	i32.const	$0=, 74561
	block   	.LBB0_29
	i32.shl 	$push57=, $3, $1
	i32.shr_s	$push58=, $3, $4
	i32.or  	$push59=, $pop57, $pop58
	i32.ne  	$push60=, $pop59, $0
	br_if   	$pop60, .LBB0_29
# BB#14:                                # %if.end122
	block   	.LBB0_28
	i32.shl 	$push61=, $3, $13
	i32.shr_s	$push62=, $3, $15
	i32.or  	$push63=, $pop61, $pop62
	i32.ne  	$push64=, $pop63, $0
	br_if   	$pop64, .LBB0_28
# BB#15:                                # %if.end131
	i32.const	$0=, 74560
	block   	.LBB0_27
	i32.shl 	$push65=, $14, $1
	i32.shr_s	$push66=, $14, $5
	i32.or  	$push67=, $pop65, $pop66
	i32.ne  	$push68=, $pop67, $0
	br_if   	$pop68, .LBB0_27
# BB#16:                                # %if.end139
	block   	.LBB0_26
	i32.shl 	$push69=, $14, $13
	i32.shr_s	$push70=, $14, $17
	i32.or  	$push71=, $pop69, $pop70
	i32.ne  	$push72=, $pop71, $0
	br_if   	$pop72, .LBB0_26
# BB#17:                                # %if.end146
	i32.const	$0=, 591751041
	block   	.LBB0_25
	i32.shl 	$push73=, $16, $1
	i32.shr_s	$push74=, $16, $5
	i32.or  	$push75=, $pop73, $pop74
	i32.ne  	$push76=, $pop75, $0
	br_if   	$pop76, .LBB0_25
# BB#18:                                # %if.end154
	block   	.LBB0_24
	i32.shl 	$push77=, $16, $13
	i32.shr_s	$push78=, $16, $17
	i32.or  	$push79=, $pop77, $pop78
	i32.ne  	$push80=, $pop79, $0
	br_if   	$pop80, .LBB0_24
# BB#19:                                # %if.end161
	block   	.LBB0_23
	i64.shl 	$push81=, $6, $7
	i64.shr_s	$push82=, $6, $8
	i64.or  	$push83=, $pop81, $pop82
	i64.ne  	$push84=, $pop83, $23
	br_if   	$pop84, .LBB0_23
# BB#20:                                # %if.end178
	block   	.LBB0_22
	i64.shr_s	$push86=, $6, $10
	i64.shl 	$push85=, $6, $9
	i64.or  	$push87=, $pop86, $pop85
	i64.ne  	$push88=, $pop87, $19
	br_if   	$pop88, .LBB0_22
# BB#21:                                # %if.end195
	call    	exit, $11
	unreachable
.LBB0_22:                               # %if.then187
	call    	abort
	unreachable
.LBB0_23:                               # %if.then170
	call    	abort
	unreachable
.LBB0_24:                               # %if.then160
	call    	abort
	unreachable
.LBB0_25:                               # %if.then153
	call    	abort
	unreachable
.LBB0_26:                               # %if.then145
	call    	abort
	unreachable
.LBB0_27:                               # %if.then138
	call    	abort
	unreachable
.LBB0_28:                               # %if.then130
	call    	abort
	unreachable
.LBB0_29:                               # %if.then121
	call    	abort
	unreachable
.LBB0_30:                               # %if.then102
	call    	abort
	unreachable
.LBB0_31:                               # %if.then92
	call    	abort
	unreachable
.LBB0_32:                               # %if.then85
	call    	abort
	unreachable
.LBB0_33:                               # %if.then75
	call    	abort
	unreachable
.LBB0_34:                               # %if.then68
	call    	abort
	unreachable
.LBB0_35:                               # %if.then59
	call    	abort
	unreachable
.LBB0_36:                               # %if.then52
	call    	abort
	unreachable
.LBB0_37:                               # %if.then44
	call    	abort
	unreachable
.LBB0_38:                               # %if.then37
	call    	abort
	unreachable
.LBB0_39:                               # %if.then29
	call    	abort
	unreachable
.LBB0_40:                               # %if.then20
	call    	abort
	unreachable
.LBB0_41:                               # %if.then10
	call    	abort
	unreachable
.LBB0_42:                               # %if.then
	call    	abort
	unreachable
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	c                       # @c
	.type	c,@object
	.section	.data.c,"aw",@progbits
	.globl	c
c:
	.int8	52                      # 0x34
	.size	c, 1

	.hidden	s                       # @s
	.type	s,@object
	.section	.data.s,"aw",@progbits
	.globl	s
	.align	1
s:
	.int16	4660                    # 0x1234
	.size	s, 2

	.hidden	i                       # @i
	.type	i,@object
	.section	.data.i,"aw",@progbits
	.globl	i
	.align	2
i:
	.int32	4660                    # 0x1234
	.size	i, 4

	.hidden	l                       # @l
	.type	l,@object
	.section	.data.l,"aw",@progbits
	.globl	l
	.align	2
l:
	.int32	305419896               # 0x12345678
	.size	l, 4

	.hidden	ll                      # @ll
	.type	ll,@object
	.section	.data.ll,"aw",@progbits
	.globl	ll
	.align	3
ll:
	.int64	81985529234382576       # 0x12345678abcdef0
	.size	ll, 8

	.hidden	shift1                  # @shift1
	.type	shift1,@object
	.section	.data.shift1,"aw",@progbits
	.globl	shift1
	.align	2
shift1:
	.int32	4                       # 0x4
	.size	shift1, 4

	.hidden	shift2                  # @shift2
	.type	shift2,@object
	.section	.data.shift2,"aw",@progbits
	.globl	shift2
	.align	2
shift2:
	.int32	60                      # 0x3c
	.size	shift2, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
