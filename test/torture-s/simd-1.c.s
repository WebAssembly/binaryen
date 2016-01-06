	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/simd-1.c"
	.globl	verify
	.type	verify,@function
verify:                                 # @verify
	.param  	i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	block   	BB0_5
	i32.ne  	$push0=, $0, $4
	br_if   	$pop0, BB0_5
# BB#1:                                 # %entry
	i32.ne  	$push1=, $1, $5
	br_if   	$pop1, BB0_5
# BB#2:                                 # %entry
	i32.ne  	$push2=, $2, $6
	br_if   	$pop2, BB0_5
# BB#3:                                 # %entry
	i32.ne  	$push3=, $3, $7
	br_if   	$pop3, BB0_5
# BB#4:                                 # %if.end
	return
BB0_5:                                  # %if.then
	call    	abort
	unreachable
func_end0:
	.size	verify, func_end0-verify

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$8=, 0
	i32.load	$3=, i+12($8)
	i32.load	$7=, j+12($8)
	i32.add 	$push2=, $7, $3
	i32.store	$9=, k+12($8), $pop2
	i32.load	$2=, i+8($8)
	i32.load	$1=, i+4($8)
	i32.load	$6=, j+8($8)
	i32.load	$0=, i($8)
	i32.load	$5=, j+4($8)
	i32.load	$4=, j($8)
	i32.store	$10=, res+12($8), $9
	block   	BB1_40
	i32.add 	$push1=, $6, $2
	i32.store	$push4=, k+8($8), $pop1
	i32.store	$11=, res+8($8), $pop4
	i32.add 	$push0=, $5, $1
	i32.store	$push5=, k+4($8), $pop0
	i32.store	$9=, res+4($8), $pop5
	i32.add 	$push3=, $4, $0
	i32.store	$push6=, k($8), $pop3
	i32.store	$push7=, res($8), $pop6
	i32.const	$push8=, 160
	i32.ne  	$push9=, $pop7, $pop8
	br_if   	$pop9, BB1_40
# BB#1:                                 # %entry
	i32.const	$push10=, 113
	i32.ne  	$push11=, $9, $pop10
	br_if   	$pop11, BB1_40
# BB#2:                                 # %entry
	i32.const	$push12=, 170
	i32.ne  	$push13=, $11, $pop12
	br_if   	$pop13, BB1_40
# BB#3:                                 # %entry
	i32.const	$push14=, 230
	i32.ne  	$push15=, $10, $pop14
	br_if   	$pop15, BB1_40
# BB#4:                                 # %verify.exit
	block   	BB1_39
	i32.mul 	$push19=, $4, $0
	i32.store	$push20=, k($8), $pop19
	i32.store	$9=, res($8), $pop20
	i32.mul 	$push16=, $5, $1
	i32.store	$push21=, k+4($8), $pop16
	i32.store	$11=, res+4($8), $pop21
	i32.mul 	$push17=, $6, $2
	i32.store	$push22=, k+8($8), $pop17
	i32.store	$10=, res+8($8), $pop22
	i32.mul 	$push18=, $7, $3
	i32.store	$push23=, k+12($8), $pop18
	i32.store	$12=, res+12($8), $pop23
	i32.const	$push24=, 1500
	i32.ne  	$push25=, $9, $pop24
	br_if   	$pop25, BB1_39
# BB#5:                                 # %verify.exit
	i32.const	$push26=, 1300
	i32.ne  	$push27=, $11, $pop26
	br_if   	$pop27, BB1_39
# BB#6:                                 # %verify.exit
	i32.const	$push28=, 3000
	i32.ne  	$push29=, $10, $pop28
	br_if   	$pop29, BB1_39
# BB#7:                                 # %verify.exit
	i32.const	$push30=, 6000
	i32.ne  	$push31=, $12, $pop30
	br_if   	$pop31, BB1_39
# BB#8:                                 # %verify.exit9
	block   	BB1_38
	i32.div_s	$push32=, $1, $5
	i32.store	$push37=, k+4($8), $pop32
	i32.store	$11=, res+4($8), $pop37
	i32.div_s	$push33=, $2, $6
	i32.store	$push38=, k+8($8), $pop33
	i32.store	$10=, res+8($8), $pop38
	i32.div_s	$push34=, $3, $7
	i32.store	$push39=, k+12($8), $pop34
	i32.store	$12=, res+12($8), $pop39
	i32.div_s	$push35=, $0, $4
	i32.store	$push36=, k($8), $pop35
	i32.store	$push40=, res($8), $pop36
	i32.const	$push41=, 15
	i32.ne  	$push42=, $pop40, $pop41
	br_if   	$pop42, BB1_38
# BB#9:                                 # %verify.exit9
	i32.const	$9=, 7
	i32.ne  	$push43=, $11, $9
	br_if   	$pop43, BB1_38
# BB#10:                                # %verify.exit9
	i32.ne  	$push44=, $10, $9
	br_if   	$pop44, BB1_38
# BB#11:                                # %verify.exit9
	i32.const	$push45=, 6
	i32.ne  	$push46=, $12, $pop45
	br_if   	$pop46, BB1_38
# BB#12:                                # %verify.exit18
	block   	BB1_37
	i32.and 	$push50=, $4, $0
	i32.store	$push51=, k($8), $pop50
	i32.store	$9=, res($8), $pop51
	i32.and 	$push47=, $5, $1
	i32.store	$push52=, k+4($8), $pop47
	i32.store	$11=, res+4($8), $pop52
	i32.and 	$push48=, $6, $2
	i32.store	$push53=, k+8($8), $pop48
	i32.store	$10=, res+8($8), $pop53
	i32.and 	$push49=, $7, $3
	i32.store	$push54=, k+12($8), $pop49
	i32.store	$12=, res+12($8), $pop54
	i32.const	$push55=, 2
	i32.ne  	$push56=, $9, $pop55
	br_if   	$pop56, BB1_37
# BB#13:                                # %verify.exit18
	i32.const	$push57=, 4
	i32.ne  	$push58=, $11, $pop57
	br_if   	$pop58, BB1_37
# BB#14:                                # %verify.exit18
	i32.const	$push59=, 20
	i32.ne  	$push60=, $10, $pop59
	br_if   	$pop60, BB1_37
# BB#15:                                # %verify.exit18
	i32.const	$push61=, 8
	i32.ne  	$push62=, $12, $pop61
	br_if   	$pop62, BB1_37
# BB#16:                                # %verify.exit27
	block   	BB1_36
	i32.or  	$push66=, $4, $0
	i32.store	$push67=, k($8), $pop66
	i32.store	$9=, res($8), $pop67
	i32.or  	$push63=, $5, $1
	i32.store	$push68=, k+4($8), $pop63
	i32.store	$11=, res+4($8), $pop68
	i32.or  	$push64=, $6, $2
	i32.store	$push69=, k+8($8), $pop64
	i32.store	$10=, res+8($8), $pop69
	i32.or  	$push65=, $7, $3
	i32.store	$push70=, k+12($8), $pop65
	i32.store	$12=, res+12($8), $pop70
	i32.const	$push71=, 158
	i32.ne  	$push72=, $9, $pop71
	br_if   	$pop72, BB1_36
# BB#17:                                # %verify.exit27
	i32.const	$push73=, 109
	i32.ne  	$push74=, $11, $pop73
	br_if   	$pop74, BB1_36
# BB#18:                                # %verify.exit27
	i32.const	$9=, 150
	i32.ne  	$push75=, $10, $9
	br_if   	$pop75, BB1_36
# BB#19:                                # %verify.exit27
	i32.const	$push76=, 222
	i32.ne  	$push77=, $12, $pop76
	br_if   	$pop77, BB1_36
# BB#20:                                # %verify.exit36
	block   	BB1_35
	i32.xor 	$push81=, $0, $4
	i32.store	$push82=, k($8), $pop81
	i32.store	$4=, res($8), $pop82
	i32.xor 	$push78=, $1, $5
	i32.store	$push83=, k+4($8), $pop78
	i32.store	$5=, res+4($8), $pop83
	i32.xor 	$push79=, $2, $6
	i32.store	$push84=, k+8($8), $pop79
	i32.store	$6=, res+8($8), $pop84
	i32.xor 	$push80=, $3, $7
	i32.store	$push85=, k+12($8), $pop80
	i32.store	$7=, res+12($8), $pop85
	i32.const	$push86=, 156
	i32.ne  	$push87=, $4, $pop86
	br_if   	$pop87, BB1_35
# BB#21:                                # %verify.exit36
	i32.const	$push88=, 105
	i32.ne  	$push89=, $5, $pop88
	br_if   	$pop89, BB1_35
# BB#22:                                # %verify.exit36
	i32.const	$push90=, 130
	i32.ne  	$push91=, $6, $pop90
	br_if   	$pop91, BB1_35
# BB#23:                                # %verify.exit36
	i32.const	$push92=, 214
	i32.ne  	$push93=, $7, $pop92
	br_if   	$pop93, BB1_35
# BB#24:                                # %verify.exit45
	i32.sub 	$push97=, $8, $0
	i32.store	$push98=, k($8), $pop97
	i32.store	$6=, res($8), $pop98
	i32.sub 	$push94=, $8, $1
	i32.store	$push99=, k+4($8), $pop94
	i32.store	$5=, res+4($8), $pop99
	i32.sub 	$push95=, $8, $2
	i32.store	$push100=, k+8($8), $pop95
	i32.store	$4=, res+8($8), $pop100
	i32.sub 	$push96=, $8, $3
	i32.store	$push101=, k+12($8), $pop96
	i32.store	$11=, res+12($8), $pop101
	i32.const	$7=, -150
	block   	BB1_34
	i32.ne  	$push102=, $6, $7
	br_if   	$pop102, BB1_34
# BB#25:                                # %verify.exit45
	i32.const	$push103=, -100
	i32.ne  	$push104=, $5, $pop103
	br_if   	$pop104, BB1_34
# BB#26:                                # %verify.exit45
	i32.ne  	$push105=, $4, $7
	br_if   	$pop105, BB1_34
# BB#27:                                # %verify.exit45
	i32.const	$push106=, -200
	i32.ne  	$push107=, $11, $pop106
	br_if   	$pop107, BB1_34
# BB#28:                                # %verify.exit54
	i32.const	$7=, -1
	block   	BB1_33
	i32.xor 	$push111=, $0, $7
	i32.store	$push112=, k($8), $pop111
	i32.store	$discard=, res($8), $pop112
	i32.xor 	$push108=, $1, $7
	i32.store	$push113=, k+4($8), $pop108
	i32.store	$1=, res+4($8), $pop113
	i32.xor 	$push109=, $2, $7
	i32.store	$push114=, k+8($8), $pop109
	i32.store	$2=, res+8($8), $pop114
	i32.xor 	$push110=, $3, $7
	i32.store	$push115=, k+12($8), $pop110
	i32.store	$3=, res+12($8), $pop115
	i32.ne  	$push116=, $0, $9
	br_if   	$pop116, BB1_33
# BB#29:                                # %verify.exit54
	i32.const	$push117=, -101
	i32.ne  	$push118=, $1, $pop117
	br_if   	$pop118, BB1_33
# BB#30:                                # %verify.exit54
	i32.const	$push119=, -151
	i32.ne  	$push120=, $2, $pop119
	br_if   	$pop120, BB1_33
# BB#31:                                # %verify.exit54
	i32.const	$push121=, -201
	i32.ne  	$push122=, $3, $pop121
	br_if   	$pop122, BB1_33
# BB#32:                                # %verify.exit63
	call    	exit, $8
	unreachable
BB1_33:                                 # %if.then.i62
	call    	abort
	unreachable
BB1_34:                                 # %if.then.i53
	call    	abort
	unreachable
BB1_35:                                 # %if.then.i44
	call    	abort
	unreachable
BB1_36:                                 # %if.then.i35
	call    	abort
	unreachable
BB1_37:                                 # %if.then.i26
	call    	abort
	unreachable
BB1_38:                                 # %if.then.i17
	call    	abort
	unreachable
BB1_39:                                 # %if.then.i8
	call    	abort
	unreachable
BB1_40:                                 # %if.then.i
	call    	abort
	unreachable
func_end1:
	.size	main, func_end1-main

	.type	i,@object               # @i
	.data
	.globl	i
	.align	4
i:
	.int32	150                     # 0x96
	.int32	100                     # 0x64
	.int32	150                     # 0x96
	.int32	200                     # 0xc8
	.size	i, 16

	.type	j,@object               # @j
	.globl	j
	.align	4
j:
	.int32	10                      # 0xa
	.int32	13                      # 0xd
	.int32	20                      # 0x14
	.int32	30                      # 0x1e
	.size	j, 16

	.type	k,@object               # @k
	.bss
	.globl	k
	.align	4
k:
	.zero	16
	.size	k, 16

	.type	res,@object             # @res
	.globl	res
	.align	4
res:
	.zero	16
	.size	res, 16


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
