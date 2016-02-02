	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20030914-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32, i32, i64, i64
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$5=, __stack_pointer
	i32.load	$5=, 0($5)
	i32.const	$6=, 512
	i32.sub 	$70=, $5, $6
	i32.const	$6=, __stack_pointer
	i32.store	$70=, 0($6), $70
	i32.load	$push0=, 0($2)
	i32.const	$8=, 496
	i32.add 	$8=, $70, $8
	call    	__floatsitf@FUNCTION, $8, $pop0
	i64.load	$push4=, 496($70)
	i32.const	$push1=, 8
	i32.const	$9=, 496
	i32.add 	$9=, $70, $9
	i32.add 	$push2=, $9, $pop1
	i64.load	$push3=, 0($pop2)
	i32.const	$10=, 480
	i32.add 	$10=, $70, $10
	call    	__addtf3@FUNCTION, $10, $pop4, $pop3, $3, $4
	i32.const	$push114=, 8
	i32.const	$11=, 480
	i32.add 	$11=, $70, $11
	i32.add 	$push5=, $11, $pop114
	i64.load	$4=, 0($pop5)
	i64.load	$3=, 480($70)
	i32.load	$push6=, 4($2)
	i32.const	$12=, 464
	i32.add 	$12=, $70, $12
	call    	__floatsitf@FUNCTION, $12, $pop6
	i64.load	$push9=, 464($70)
	i32.const	$push113=, 8
	i32.const	$13=, 464
	i32.add 	$13=, $70, $13
	i32.add 	$push7=, $13, $pop113
	i64.load	$push8=, 0($pop7)
	i32.const	$14=, 448
	i32.add 	$14=, $70, $14
	call    	__addtf3@FUNCTION, $14, $3, $4, $pop9, $pop8
	i32.const	$push112=, 8
	i32.const	$15=, 448
	i32.add 	$15=, $70, $15
	i32.add 	$push10=, $15, $pop112
	i64.load	$4=, 0($pop10)
	i64.load	$3=, 448($70)
	i32.load	$push11=, 8($2)
	i32.const	$16=, 432
	i32.add 	$16=, $70, $16
	call    	__floatsitf@FUNCTION, $16, $pop11
	i64.load	$push14=, 432($70)
	i32.const	$push111=, 8
	i32.const	$17=, 432
	i32.add 	$17=, $70, $17
	i32.add 	$push12=, $17, $pop111
	i64.load	$push13=, 0($pop12)
	i32.const	$18=, 416
	i32.add 	$18=, $70, $18
	call    	__addtf3@FUNCTION, $18, $3, $4, $pop14, $pop13
	i32.const	$push110=, 8
	i32.const	$19=, 416
	i32.add 	$19=, $70, $19
	i32.add 	$push15=, $19, $pop110
	i64.load	$4=, 0($pop15)
	i64.load	$3=, 416($70)
	i32.load	$push16=, 12($2)
	i32.const	$20=, 400
	i32.add 	$20=, $70, $20
	call    	__floatsitf@FUNCTION, $20, $pop16
	i64.load	$push19=, 400($70)
	i32.const	$push109=, 8
	i32.const	$21=, 400
	i32.add 	$21=, $70, $21
	i32.add 	$push17=, $21, $pop109
	i64.load	$push18=, 0($pop17)
	i32.const	$22=, 384
	i32.add 	$22=, $70, $22
	call    	__addtf3@FUNCTION, $22, $3, $4, $pop19, $pop18
	i32.const	$push108=, 8
	i32.const	$23=, 384
	i32.add 	$23=, $70, $23
	i32.add 	$push20=, $23, $pop108
	i64.load	$4=, 0($pop20)
	i64.load	$3=, 384($70)
	i32.load	$push21=, 16($2)
	i32.const	$24=, 368
	i32.add 	$24=, $70, $24
	call    	__floatsitf@FUNCTION, $24, $pop21
	i64.load	$push24=, 368($70)
	i32.const	$push107=, 8
	i32.const	$25=, 368
	i32.add 	$25=, $70, $25
	i32.add 	$push22=, $25, $pop107
	i64.load	$push23=, 0($pop22)
	i32.const	$26=, 352
	i32.add 	$26=, $70, $26
	call    	__addtf3@FUNCTION, $26, $3, $4, $pop24, $pop23
	i32.const	$push106=, 8
	i32.const	$27=, 352
	i32.add 	$27=, $70, $27
	i32.add 	$push25=, $27, $pop106
	i64.load	$4=, 0($pop25)
	i64.load	$3=, 352($70)
	i32.load	$push26=, 20($2)
	i32.const	$28=, 336
	i32.add 	$28=, $70, $28
	call    	__floatsitf@FUNCTION, $28, $pop26
	i64.load	$push29=, 336($70)
	i32.const	$push105=, 8
	i32.const	$29=, 336
	i32.add 	$29=, $70, $29
	i32.add 	$push27=, $29, $pop105
	i64.load	$push28=, 0($pop27)
	i32.const	$30=, 320
	i32.add 	$30=, $70, $30
	call    	__addtf3@FUNCTION, $30, $3, $4, $pop29, $pop28
	i32.const	$push104=, 8
	i32.const	$31=, 320
	i32.add 	$31=, $70, $31
	i32.add 	$push30=, $31, $pop104
	i64.load	$4=, 0($pop30)
	i64.load	$3=, 320($70)
	i32.load	$push31=, 24($2)
	i32.const	$32=, 304
	i32.add 	$32=, $70, $32
	call    	__floatsitf@FUNCTION, $32, $pop31
	i64.load	$push34=, 304($70)
	i32.const	$push103=, 8
	i32.const	$33=, 304
	i32.add 	$33=, $70, $33
	i32.add 	$push32=, $33, $pop103
	i64.load	$push33=, 0($pop32)
	i32.const	$34=, 288
	i32.add 	$34=, $70, $34
	call    	__addtf3@FUNCTION, $34, $3, $4, $pop34, $pop33
	i32.const	$push102=, 8
	i32.const	$35=, 288
	i32.add 	$35=, $70, $35
	i32.add 	$push35=, $35, $pop102
	i64.load	$4=, 0($pop35)
	i64.load	$3=, 288($70)
	i32.load	$push36=, 28($2)
	i32.const	$36=, 272
	i32.add 	$36=, $70, $36
	call    	__floatsitf@FUNCTION, $36, $pop36
	i64.load	$push39=, 272($70)
	i32.const	$push101=, 8
	i32.const	$37=, 272
	i32.add 	$37=, $70, $37
	i32.add 	$push37=, $37, $pop101
	i64.load	$push38=, 0($pop37)
	i32.const	$38=, 256
	i32.add 	$38=, $70, $38
	call    	__addtf3@FUNCTION, $38, $3, $4, $pop39, $pop38
	i32.const	$push100=, 8
	i32.const	$39=, 256
	i32.add 	$39=, $70, $39
	i32.add 	$push40=, $39, $pop100
	i64.load	$4=, 0($pop40)
	i64.load	$3=, 256($70)
	i32.load	$push41=, 32($2)
	i32.const	$40=, 240
	i32.add 	$40=, $70, $40
	call    	__floatsitf@FUNCTION, $40, $pop41
	i64.load	$push44=, 240($70)
	i32.const	$push99=, 8
	i32.const	$41=, 240
	i32.add 	$41=, $70, $41
	i32.add 	$push42=, $41, $pop99
	i64.load	$push43=, 0($pop42)
	i32.const	$42=, 224
	i32.add 	$42=, $70, $42
	call    	__addtf3@FUNCTION, $42, $3, $4, $pop44, $pop43
	i32.const	$push98=, 8
	i32.const	$43=, 224
	i32.add 	$43=, $70, $43
	i32.add 	$push45=, $43, $pop98
	i64.load	$4=, 0($pop45)
	i64.load	$3=, 224($70)
	i32.load	$push46=, 36($2)
	i32.const	$44=, 208
	i32.add 	$44=, $70, $44
	call    	__floatsitf@FUNCTION, $44, $pop46
	i64.load	$push49=, 208($70)
	i32.const	$push97=, 8
	i32.const	$45=, 208
	i32.add 	$45=, $70, $45
	i32.add 	$push47=, $45, $pop97
	i64.load	$push48=, 0($pop47)
	i32.const	$46=, 192
	i32.add 	$46=, $70, $46
	call    	__addtf3@FUNCTION, $46, $3, $4, $pop49, $pop48
	i32.const	$push96=, 8
	i32.const	$47=, 192
	i32.add 	$47=, $70, $47
	i32.add 	$push50=, $47, $pop96
	i64.load	$4=, 0($pop50)
	i64.load	$3=, 192($70)
	i32.load	$push51=, 40($2)
	i32.const	$48=, 176
	i32.add 	$48=, $70, $48
	call    	__floatsitf@FUNCTION, $48, $pop51
	i64.load	$push54=, 176($70)
	i32.const	$push95=, 8
	i32.const	$49=, 176
	i32.add 	$49=, $70, $49
	i32.add 	$push52=, $49, $pop95
	i64.load	$push53=, 0($pop52)
	i32.const	$50=, 160
	i32.add 	$50=, $70, $50
	call    	__addtf3@FUNCTION, $50, $3, $4, $pop54, $pop53
	i32.const	$push94=, 8
	i32.const	$51=, 160
	i32.add 	$51=, $70, $51
	i32.add 	$push55=, $51, $pop94
	i64.load	$4=, 0($pop55)
	i64.load	$3=, 160($70)
	i32.load	$push56=, 44($2)
	i32.const	$52=, 144
	i32.add 	$52=, $70, $52
	call    	__floatsitf@FUNCTION, $52, $pop56
	i64.load	$push59=, 144($70)
	i32.const	$push93=, 8
	i32.const	$53=, 144
	i32.add 	$53=, $70, $53
	i32.add 	$push57=, $53, $pop93
	i64.load	$push58=, 0($pop57)
	i32.const	$54=, 128
	i32.add 	$54=, $70, $54
	call    	__addtf3@FUNCTION, $54, $3, $4, $pop59, $pop58
	i32.const	$push92=, 8
	i32.const	$55=, 128
	i32.add 	$55=, $70, $55
	i32.add 	$push60=, $55, $pop92
	i64.load	$4=, 0($pop60)
	i64.load	$3=, 128($70)
	i32.load	$push61=, 48($2)
	i32.const	$56=, 112
	i32.add 	$56=, $70, $56
	call    	__floatsitf@FUNCTION, $56, $pop61
	i64.load	$push64=, 112($70)
	i32.const	$push91=, 8
	i32.const	$57=, 112
	i32.add 	$57=, $70, $57
	i32.add 	$push62=, $57, $pop91
	i64.load	$push63=, 0($pop62)
	i32.const	$58=, 96
	i32.add 	$58=, $70, $58
	call    	__addtf3@FUNCTION, $58, $3, $4, $pop64, $pop63
	i32.const	$push90=, 8
	i32.const	$59=, 96
	i32.add 	$59=, $70, $59
	i32.add 	$push65=, $59, $pop90
	i64.load	$4=, 0($pop65)
	i64.load	$3=, 96($70)
	i32.load	$push66=, 52($2)
	i32.const	$60=, 80
	i32.add 	$60=, $70, $60
	call    	__floatsitf@FUNCTION, $60, $pop66
	i64.load	$push69=, 80($70)
	i32.const	$push89=, 8
	i32.const	$61=, 80
	i32.add 	$61=, $70, $61
	i32.add 	$push67=, $61, $pop89
	i64.load	$push68=, 0($pop67)
	i32.const	$62=, 64
	i32.add 	$62=, $70, $62
	call    	__addtf3@FUNCTION, $62, $3, $4, $pop69, $pop68
	i32.const	$push88=, 8
	i32.const	$63=, 64
	i32.add 	$63=, $70, $63
	i32.add 	$push70=, $63, $pop88
	i64.load	$4=, 0($pop70)
	i64.load	$3=, 64($70)
	i32.load	$push71=, 56($2)
	i32.const	$64=, 48
	i32.add 	$64=, $70, $64
	call    	__floatsitf@FUNCTION, $64, $pop71
	i64.load	$push74=, 48($70)
	i32.const	$push87=, 8
	i32.const	$65=, 48
	i32.add 	$65=, $70, $65
	i32.add 	$push72=, $65, $pop87
	i64.load	$push73=, 0($pop72)
	i32.const	$66=, 32
	i32.add 	$66=, $70, $66
	call    	__addtf3@FUNCTION, $66, $3, $4, $pop74, $pop73
	i32.const	$push86=, 8
	i32.const	$67=, 32
	i32.add 	$67=, $70, $67
	i32.add 	$push75=, $67, $pop86
	i64.load	$4=, 0($pop75)
	i64.load	$3=, 32($70)
	i32.load	$push76=, 60($2)
	i32.const	$68=, 16
	i32.add 	$68=, $70, $68
	call    	__floatsitf@FUNCTION, $68, $pop76
	i64.load	$push79=, 16($70)
	i32.const	$push85=, 8
	i32.const	$69=, 16
	i32.add 	$69=, $70, $69
	i32.add 	$push77=, $69, $pop85
	i64.load	$push78=, 0($pop77)
	call    	__addtf3@FUNCTION, $70, $3, $4, $pop79, $pop78
	i64.load	$4=, 0($70)
	i32.const	$push84=, 8
	i32.add 	$push82=, $0, $pop84
	i32.const	$push83=, 8
	i32.add 	$push80=, $70, $pop83
	i64.load	$push81=, 0($pop80)
	i64.store	$discard=, 0($pop82), $pop81
	i64.store	$discard=, 0($0):p2align=4, $4
	i32.const	$7=, 512
	i32.add 	$70=, $70, $7
	i32.const	$7=, __stack_pointer
	i32.store	$70=, 0($7), $70
	return
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
