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
	i32.and 	$push4=, $pop2, $pop3
	tee_local	$push124=, $3=, $pop4
	i32.const	$push5=, 4
	i32.add 	$push6=, $pop124, $pop5
	i32.store	$discard=, 76($19), $pop6
	i32.load	$4=, 0($3)
	i32.const	$push7=, 7
	i32.add 	$push8=, $3, $pop7
	i32.const	$push123=, -4
	i32.and 	$push9=, $pop8, $pop123
	tee_local	$push122=, $3=, $pop9
	i32.const	$push121=, 4
	i32.add 	$push10=, $pop122, $pop121
	i32.store	$discard=, 76($19), $pop10
	i32.load	$5=, 0($3)
	i32.const	$push120=, 7
	i32.add 	$push11=, $3, $pop120
	i32.const	$push119=, -4
	i32.and 	$push12=, $pop11, $pop119
	tee_local	$push118=, $3=, $pop12
	i32.const	$push117=, 4
	i32.add 	$push13=, $pop118, $pop117
	i32.store	$discard=, 76($19), $pop13
	i32.load	$6=, 0($3)
	i32.const	$push116=, 7
	i32.add 	$push14=, $3, $pop116
	i32.const	$push115=, -4
	i32.and 	$push15=, $pop14, $pop115
	tee_local	$push114=, $3=, $pop15
	i32.const	$push113=, 4
	i32.add 	$push16=, $pop114, $pop113
	i32.store	$discard=, 76($19), $pop16
	i32.load	$7=, 0($3)
	i32.const	$push112=, 7
	i32.add 	$push17=, $3, $pop112
	i32.const	$push111=, -4
	i32.and 	$push18=, $pop17, $pop111
	tee_local	$push110=, $3=, $pop18
	i32.const	$push109=, 4
	i32.add 	$push19=, $pop110, $pop109
	i32.store	$discard=, 76($19), $pop19
	i32.load	$8=, 0($3)
	i32.const	$push108=, 7
	i32.add 	$push20=, $3, $pop108
	i32.const	$push107=, -4
	i32.and 	$push21=, $pop20, $pop107
	tee_local	$push106=, $3=, $pop21
	i32.const	$push105=, 4
	i32.add 	$push22=, $pop106, $pop105
	i32.store	$discard=, 76($19), $pop22
	i32.load	$9=, 0($3)
	i32.const	$push104=, 7
	i32.add 	$push23=, $3, $pop104
	i32.const	$push103=, -4
	i32.and 	$push24=, $pop23, $pop103
	tee_local	$push102=, $3=, $pop24
	i32.const	$push101=, 4
	i32.add 	$push25=, $pop102, $pop101
	i32.store	$discard=, 76($19), $pop25
	i32.load	$10=, 0($3)
	i32.const	$push100=, 7
	i32.add 	$push26=, $3, $pop100
	i32.const	$push99=, -4
	i32.and 	$push27=, $pop26, $pop99
	tee_local	$push98=, $3=, $pop27
	i32.const	$push97=, 4
	i32.add 	$push28=, $pop98, $pop97
	i32.store	$discard=, 76($19), $pop28
	i32.load	$11=, 0($3)
	i32.const	$push96=, 7
	i32.add 	$push29=, $3, $pop96
	i32.const	$push95=, -4
	i32.and 	$push30=, $pop29, $pop95
	tee_local	$push94=, $3=, $pop30
	i32.const	$push93=, 4
	i32.add 	$push31=, $pop94, $pop93
	i32.store	$discard=, 76($19), $pop31
	i32.load	$12=, 0($3)
	i32.const	$push92=, 7
	i32.add 	$push32=, $3, $pop92
	i32.const	$push91=, -4
	i32.and 	$push33=, $pop32, $pop91
	tee_local	$push90=, $3=, $pop33
	i32.const	$push89=, 4
	i32.add 	$push34=, $pop90, $pop89
	i32.store	$discard=, 76($19), $pop34
	i32.load	$13=, 0($3)
	i32.const	$push88=, 7
	i32.add 	$push35=, $3, $pop88
	i32.const	$push87=, -4
	i32.and 	$push36=, $pop35, $pop87
	tee_local	$push86=, $3=, $pop36
	i32.const	$push85=, 4
	i32.add 	$push37=, $pop86, $pop85
	i32.store	$discard=, 76($19), $pop37
	i32.load	$14=, 0($3)
	i32.const	$push84=, 7
	i32.add 	$push38=, $3, $pop84
	i32.const	$push83=, -4
	i32.and 	$push39=, $pop38, $pop83
	tee_local	$push82=, $3=, $pop39
	i32.const	$push81=, 4
	i32.add 	$push40=, $pop82, $pop81
	i32.store	$discard=, 76($19), $pop40
	i32.load	$15=, 0($3)
	i32.const	$push80=, 7
	i32.add 	$push41=, $3, $pop80
	i32.const	$push79=, -4
	i32.and 	$push42=, $pop41, $pop79
	tee_local	$push78=, $3=, $pop42
	i32.const	$push77=, 4
	i32.add 	$push43=, $pop78, $pop77
	i32.store	$discard=, 76($19), $pop43
	i32.const	$push45=, 68
	i32.add 	$push46=, $19, $pop45
	i32.load	$push44=, 0($3)
	i32.store	$discard=, 0($pop46), $pop44
	i32.const	$push47=, 64
	i32.add 	$push48=, $19, $pop47
	i32.store	$discard=, 0($pop48):p2align=4, $15
	i32.const	$push49=, 60
	i32.add 	$push50=, $19, $pop49
	i32.store	$discard=, 0($pop50), $14
	i32.const	$push51=, 56
	i32.add 	$push52=, $19, $pop51
	i32.store	$discard=, 0($pop52):p2align=3, $13
	i32.const	$push53=, 52
	i32.add 	$push54=, $19, $pop53
	i32.store	$discard=, 0($pop54), $12
	i32.const	$push55=, 48
	i32.add 	$push56=, $19, $pop55
	i32.store	$discard=, 0($pop56):p2align=4, $11
	i32.const	$push57=, 44
	i32.add 	$push58=, $19, $pop57
	i32.store	$discard=, 0($pop58), $10
	i32.const	$push59=, 40
	i32.add 	$push60=, $19, $pop59
	i32.store	$discard=, 0($pop60):p2align=3, $9
	i32.const	$push61=, 36
	i32.add 	$push62=, $19, $pop61
	i32.store	$discard=, 0($pop62), $8
	i32.const	$push63=, 32
	i32.add 	$push64=, $19, $pop63
	i32.store	$discard=, 0($pop64):p2align=4, $7
	i32.const	$push65=, 28
	i32.add 	$push66=, $19, $pop65
	i32.store	$discard=, 0($pop66), $6
	i32.const	$push67=, 24
	i32.add 	$push68=, $19, $pop67
	i32.store	$discard=, 0($pop68):p2align=3, $5
	i32.const	$push69=, 20
	i32.add 	$push70=, $19, $pop69
	i32.store	$discard=, 0($pop70), $4
	i32.const	$push71=, 16
	i32.add 	$push72=, $19, $pop71
	i32.store	$discard=, 0($pop72):p2align=4, $2
	i32.const	$push73=, 8
	i32.or  	$push74=, $19, $pop73
	f64.store	$discard=, 0($pop74), $1
	i32.store	$discard=, 0($19):p2align=4, $0
	i32.const	$push76=, buf
	i32.const	$push75=, .L.str
	i32.call	$discard=, sprintf@FUNCTION, $pop76, $pop75, $19
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
