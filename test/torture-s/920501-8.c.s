	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/920501-8.c"
	.section	.text.va,"ax",@progbits
	.hidden	va
	.globl	va
	.type	va,@function
va:                                     # @va
	.param  	i32, f64, i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$16=, __stack_pointer
	i32.load	$16=, 0($16)
	i32.const	$17=, 80
	i32.sub 	$19=, $16, $17
	i32.const	$17=, __stack_pointer
	i32.store	$19=, 0($17), $19
	i32.store	$push0=, 76($19), $3
	i32.const	$push1=, 3
	i32.add 	$push2=, $pop0, $pop1
	i32.const	$push3=, -4
	i32.and 	$push124=, $pop2, $pop3
	tee_local	$push123=, $3=, $pop124
	i32.const	$push4=, 4
	i32.add 	$push5=, $pop123, $pop4
	i32.store	$discard=, 76($19), $pop5
	i32.load	$4=, 0($3)
	i32.const	$push6=, 7
	i32.add 	$push7=, $3, $pop6
	i32.const	$push122=, -4
	i32.and 	$push121=, $pop7, $pop122
	tee_local	$push120=, $3=, $pop121
	i32.const	$push119=, 4
	i32.add 	$push8=, $pop120, $pop119
	i32.store	$discard=, 76($19), $pop8
	i32.load	$5=, 0($3)
	i32.const	$push118=, 7
	i32.add 	$push9=, $3, $pop118
	i32.const	$push117=, -4
	i32.and 	$push116=, $pop9, $pop117
	tee_local	$push115=, $3=, $pop116
	i32.const	$push114=, 4
	i32.add 	$push10=, $pop115, $pop114
	i32.store	$discard=, 76($19), $pop10
	i32.load	$6=, 0($3)
	i32.const	$push113=, 7
	i32.add 	$push11=, $3, $pop113
	i32.const	$push112=, -4
	i32.and 	$push111=, $pop11, $pop112
	tee_local	$push110=, $3=, $pop111
	i32.const	$push109=, 4
	i32.add 	$push12=, $pop110, $pop109
	i32.store	$discard=, 76($19), $pop12
	i32.load	$7=, 0($3)
	i32.const	$push108=, 7
	i32.add 	$push13=, $3, $pop108
	i32.const	$push107=, -4
	i32.and 	$push106=, $pop13, $pop107
	tee_local	$push105=, $3=, $pop106
	i32.const	$push104=, 4
	i32.add 	$push14=, $pop105, $pop104
	i32.store	$discard=, 76($19), $pop14
	i32.load	$8=, 0($3)
	i32.const	$push103=, 7
	i32.add 	$push15=, $3, $pop103
	i32.const	$push102=, -4
	i32.and 	$push101=, $pop15, $pop102
	tee_local	$push100=, $3=, $pop101
	i32.const	$push99=, 4
	i32.add 	$push16=, $pop100, $pop99
	i32.store	$discard=, 76($19), $pop16
	i32.load	$9=, 0($3)
	i32.const	$push98=, 7
	i32.add 	$push17=, $3, $pop98
	i32.const	$push97=, -4
	i32.and 	$push96=, $pop17, $pop97
	tee_local	$push95=, $3=, $pop96
	i32.const	$push94=, 4
	i32.add 	$push18=, $pop95, $pop94
	i32.store	$discard=, 76($19), $pop18
	i32.load	$10=, 0($3)
	i32.const	$push93=, 7
	i32.add 	$push19=, $3, $pop93
	i32.const	$push92=, -4
	i32.and 	$push91=, $pop19, $pop92
	tee_local	$push90=, $3=, $pop91
	i32.const	$push89=, 4
	i32.add 	$push20=, $pop90, $pop89
	i32.store	$discard=, 76($19), $pop20
	i32.load	$11=, 0($3)
	i32.const	$push88=, 7
	i32.add 	$push21=, $3, $pop88
	i32.const	$push87=, -4
	i32.and 	$push86=, $pop21, $pop87
	tee_local	$push85=, $3=, $pop86
	i32.const	$push84=, 4
	i32.add 	$push22=, $pop85, $pop84
	i32.store	$discard=, 76($19), $pop22
	i32.load	$12=, 0($3)
	i32.const	$push83=, 7
	i32.add 	$push23=, $3, $pop83
	i32.const	$push82=, -4
	i32.and 	$push81=, $pop23, $pop82
	tee_local	$push80=, $3=, $pop81
	i32.const	$push79=, 4
	i32.add 	$push24=, $pop80, $pop79
	i32.store	$discard=, 76($19), $pop24
	i32.load	$13=, 0($3)
	i32.const	$push78=, 7
	i32.add 	$push25=, $3, $pop78
	i32.const	$push77=, -4
	i32.and 	$push76=, $pop25, $pop77
	tee_local	$push75=, $3=, $pop76
	i32.const	$push74=, 4
	i32.add 	$push26=, $pop75, $pop74
	i32.store	$discard=, 76($19), $pop26
	i32.load	$14=, 0($3)
	i32.const	$push73=, 7
	i32.add 	$push27=, $3, $pop73
	i32.const	$push72=, -4
	i32.and 	$push71=, $pop27, $pop72
	tee_local	$push70=, $3=, $pop71
	i32.const	$push69=, 4
	i32.add 	$push28=, $pop70, $pop69
	i32.store	$discard=, 76($19), $pop28
	i32.load	$15=, 0($3)
	i32.const	$push68=, 7
	i32.add 	$push29=, $3, $pop68
	i32.const	$push67=, -4
	i32.and 	$push66=, $pop29, $pop67
	tee_local	$push65=, $3=, $pop66
	i32.const	$push64=, 4
	i32.add 	$push30=, $pop65, $pop64
	i32.store	$discard=, 76($19), $pop30
	i32.const	$push32=, 68
	i32.add 	$push33=, $19, $pop32
	i32.load	$push31=, 0($3)
	i32.store	$discard=, 0($pop33), $pop31
	i32.const	$push34=, 64
	i32.add 	$push35=, $19, $pop34
	i32.store	$discard=, 0($pop35):p2align=4, $15
	i32.const	$push36=, 60
	i32.add 	$push37=, $19, $pop36
	i32.store	$discard=, 0($pop37), $14
	i32.const	$push38=, 56
	i32.add 	$push39=, $19, $pop38
	i32.store	$discard=, 0($pop39):p2align=3, $13
	i32.const	$push40=, 52
	i32.add 	$push41=, $19, $pop40
	i32.store	$discard=, 0($pop41), $12
	i32.const	$push42=, 48
	i32.add 	$push43=, $19, $pop42
	i32.store	$discard=, 0($pop43):p2align=4, $11
	i32.const	$push44=, 44
	i32.add 	$push45=, $19, $pop44
	i32.store	$discard=, 0($pop45), $10
	i32.const	$push46=, 40
	i32.add 	$push47=, $19, $pop46
	i32.store	$discard=, 0($pop47):p2align=3, $9
	i32.const	$push48=, 36
	i32.add 	$push49=, $19, $pop48
	i32.store	$discard=, 0($pop49), $8
	i32.const	$push50=, 32
	i32.add 	$push51=, $19, $pop50
	i32.store	$discard=, 0($pop51):p2align=4, $7
	i32.const	$push52=, 28
	i32.add 	$push53=, $19, $pop52
	i32.store	$discard=, 0($pop53), $6
	i32.const	$push54=, 24
	i32.add 	$push55=, $19, $pop54
	i32.store	$discard=, 0($pop55):p2align=3, $5
	i32.const	$push56=, 20
	i32.add 	$push57=, $19, $pop56
	i32.store	$discard=, 0($pop57), $4
	i32.const	$push58=, 16
	i32.add 	$push59=, $19, $pop58
	i32.store	$discard=, 0($pop59):p2align=4, $2
	i32.const	$push60=, 8
	i32.or  	$push61=, $19, $pop60
	f64.store	$discard=, 0($pop61), $1
	i32.store	$discard=, 0($19):p2align=4, $0
	i32.const	$push63=, buf
	i32.const	$push62=, .L.str
	i32.call	$discard=, sprintf@FUNCTION, $pop63, $pop62, $19
	i32.const	$18=, 80
	i32.add 	$19=, $19, $18
	i32.const	$18=, __stack_pointer
	i32.store	$19=, 0($18), $19
	return  	$3
	.endfunc
.Lfunc_end0:
	.size	va, .Lfunc_end0-va

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, __stack_pointer
	i32.load	$0=, 0($0)
	i32.const	$1=, 64
	i32.sub 	$2=, $0, $1
	i32.const	$1=, __stack_pointer
	i32.store	$2=, 0($1), $2
	i32.const	$push0=, 48
	i32.add 	$push1=, $2, $pop0
	i32.const	$push2=, 15
	i32.store	$discard=, 0($pop1):p2align=4, $pop2
	i32.const	$push3=, 40
	i32.add 	$push4=, $2, $pop3
	i64.const	$push5=, 60129542157
	i64.store	$discard=, 0($pop4), $pop5
	i32.const	$push6=, 32
	i32.add 	$push7=, $2, $pop6
	i64.const	$push8=, 51539607563
	i64.store	$discard=, 0($pop7):p2align=4, $pop8
	i32.const	$push9=, 24
	i32.add 	$push10=, $2, $pop9
	i64.const	$push11=, 42949672969
	i64.store	$discard=, 0($pop10), $pop11
	i32.const	$push12=, 16
	i32.add 	$push13=, $2, $pop12
	i64.const	$push14=, 34359738375
	i64.store	$discard=, 0($pop13):p2align=4, $pop14
	i32.const	$push15=, 8
	i32.or  	$push16=, $2, $pop15
	i64.const	$push17=, 25769803781
	i64.store	$discard=, 0($pop16), $pop17
	i64.const	$push18=, 17179869187
	i64.store	$discard=, 0($2):p2align=4, $pop18
	i32.const	$push21=, 1
	f64.const	$push20=, 0x1p0
	i32.const	$push19=, 2
	i32.call	$discard=, va@FUNCTION, $pop21, $pop20, $pop19, $2
	block
	i32.const	$push23=, .L.str.1
	i32.const	$push22=, buf
	i32.call	$push24=, strcmp@FUNCTION, $pop23, $pop22
	br_if   	0, $pop24       # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push25=, 0
	call    	exit@FUNCTION, $pop25
	unreachable
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	buf                     # @buf
	.type	buf,@object
	.section	.bss.buf,"aw",@nobits
	.globl	buf
	.p2align	4
buf:
	.skip	50
	.size	buf, 50

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"%d,%f,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d"
	.size	.L.str, 48

	.type	.L.str.1,@object        # @.str.1
.L.str.1:
	.asciz	"1,1.000000,2,3,4,5,6,7,8,9,10,11,12,13,14,15"
	.size	.L.str.1, 45


	.ident	"clang version 3.9.0 "
