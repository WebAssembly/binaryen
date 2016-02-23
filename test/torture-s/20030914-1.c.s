	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20030914-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32, i32, i64, i64
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push115=, __stack_pointer
	i32.load	$push116=, 0($pop115)
	i32.const	$push117=, 512
	i32.sub 	$67=, $pop116, $pop117
	i32.const	$push118=, __stack_pointer
	i32.store	$discard=, 0($pop118), $67
	i32.load	$push0=, 0($2)
	i32.const	$5=, 496
	i32.add 	$5=, $67, $5
	call    	__floatsitf@FUNCTION, $5, $pop0
	i64.load	$push4=, 496($67)
	i32.const	$push1=, 8
	i32.const	$6=, 496
	i32.add 	$6=, $67, $6
	i32.add 	$push2=, $6, $pop1
	i64.load	$push3=, 0($pop2)
	i32.const	$7=, 480
	i32.add 	$7=, $67, $7
	call    	__addtf3@FUNCTION, $7, $pop4, $pop3, $3, $4
	i32.const	$push114=, 8
	i32.const	$8=, 480
	i32.add 	$8=, $67, $8
	i32.add 	$push5=, $8, $pop114
	i64.load	$4=, 0($pop5)
	i64.load	$3=, 480($67)
	i32.load	$push6=, 4($2)
	i32.const	$9=, 464
	i32.add 	$9=, $67, $9
	call    	__floatsitf@FUNCTION, $9, $pop6
	i64.load	$push9=, 464($67)
	i32.const	$push113=, 8
	i32.const	$10=, 464
	i32.add 	$10=, $67, $10
	i32.add 	$push7=, $10, $pop113
	i64.load	$push8=, 0($pop7)
	i32.const	$11=, 448
	i32.add 	$11=, $67, $11
	call    	__addtf3@FUNCTION, $11, $3, $4, $pop9, $pop8
	i32.const	$push112=, 8
	i32.const	$12=, 448
	i32.add 	$12=, $67, $12
	i32.add 	$push10=, $12, $pop112
	i64.load	$4=, 0($pop10)
	i64.load	$3=, 448($67)
	i32.load	$push11=, 8($2)
	i32.const	$13=, 432
	i32.add 	$13=, $67, $13
	call    	__floatsitf@FUNCTION, $13, $pop11
	i64.load	$push14=, 432($67)
	i32.const	$push111=, 8
	i32.const	$14=, 432
	i32.add 	$14=, $67, $14
	i32.add 	$push12=, $14, $pop111
	i64.load	$push13=, 0($pop12)
	i32.const	$15=, 416
	i32.add 	$15=, $67, $15
	call    	__addtf3@FUNCTION, $15, $3, $4, $pop14, $pop13
	i32.const	$push110=, 8
	i32.const	$16=, 416
	i32.add 	$16=, $67, $16
	i32.add 	$push15=, $16, $pop110
	i64.load	$4=, 0($pop15)
	i64.load	$3=, 416($67)
	i32.load	$push16=, 12($2)
	i32.const	$17=, 400
	i32.add 	$17=, $67, $17
	call    	__floatsitf@FUNCTION, $17, $pop16
	i64.load	$push19=, 400($67)
	i32.const	$push109=, 8
	i32.const	$18=, 400
	i32.add 	$18=, $67, $18
	i32.add 	$push17=, $18, $pop109
	i64.load	$push18=, 0($pop17)
	i32.const	$19=, 384
	i32.add 	$19=, $67, $19
	call    	__addtf3@FUNCTION, $19, $3, $4, $pop19, $pop18
	i32.const	$push108=, 8
	i32.const	$20=, 384
	i32.add 	$20=, $67, $20
	i32.add 	$push20=, $20, $pop108
	i64.load	$4=, 0($pop20)
	i64.load	$3=, 384($67)
	i32.load	$push21=, 16($2)
	i32.const	$21=, 368
	i32.add 	$21=, $67, $21
	call    	__floatsitf@FUNCTION, $21, $pop21
	i64.load	$push24=, 368($67)
	i32.const	$push107=, 8
	i32.const	$22=, 368
	i32.add 	$22=, $67, $22
	i32.add 	$push22=, $22, $pop107
	i64.load	$push23=, 0($pop22)
	i32.const	$23=, 352
	i32.add 	$23=, $67, $23
	call    	__addtf3@FUNCTION, $23, $3, $4, $pop24, $pop23
	i32.const	$push106=, 8
	i32.const	$24=, 352
	i32.add 	$24=, $67, $24
	i32.add 	$push25=, $24, $pop106
	i64.load	$4=, 0($pop25)
	i64.load	$3=, 352($67)
	i32.load	$push26=, 20($2)
	i32.const	$25=, 336
	i32.add 	$25=, $67, $25
	call    	__floatsitf@FUNCTION, $25, $pop26
	i64.load	$push29=, 336($67)
	i32.const	$push105=, 8
	i32.const	$26=, 336
	i32.add 	$26=, $67, $26
	i32.add 	$push27=, $26, $pop105
	i64.load	$push28=, 0($pop27)
	i32.const	$27=, 320
	i32.add 	$27=, $67, $27
	call    	__addtf3@FUNCTION, $27, $3, $4, $pop29, $pop28
	i32.const	$push104=, 8
	i32.const	$28=, 320
	i32.add 	$28=, $67, $28
	i32.add 	$push30=, $28, $pop104
	i64.load	$4=, 0($pop30)
	i64.load	$3=, 320($67)
	i32.load	$push31=, 24($2)
	i32.const	$29=, 304
	i32.add 	$29=, $67, $29
	call    	__floatsitf@FUNCTION, $29, $pop31
	i64.load	$push34=, 304($67)
	i32.const	$push103=, 8
	i32.const	$30=, 304
	i32.add 	$30=, $67, $30
	i32.add 	$push32=, $30, $pop103
	i64.load	$push33=, 0($pop32)
	i32.const	$31=, 288
	i32.add 	$31=, $67, $31
	call    	__addtf3@FUNCTION, $31, $3, $4, $pop34, $pop33
	i32.const	$push102=, 8
	i32.const	$32=, 288
	i32.add 	$32=, $67, $32
	i32.add 	$push35=, $32, $pop102
	i64.load	$4=, 0($pop35)
	i64.load	$3=, 288($67)
	i32.load	$push36=, 28($2)
	i32.const	$33=, 272
	i32.add 	$33=, $67, $33
	call    	__floatsitf@FUNCTION, $33, $pop36
	i64.load	$push39=, 272($67)
	i32.const	$push101=, 8
	i32.const	$34=, 272
	i32.add 	$34=, $67, $34
	i32.add 	$push37=, $34, $pop101
	i64.load	$push38=, 0($pop37)
	i32.const	$35=, 256
	i32.add 	$35=, $67, $35
	call    	__addtf3@FUNCTION, $35, $3, $4, $pop39, $pop38
	i32.const	$push100=, 8
	i32.const	$36=, 256
	i32.add 	$36=, $67, $36
	i32.add 	$push40=, $36, $pop100
	i64.load	$4=, 0($pop40)
	i64.load	$3=, 256($67)
	i32.load	$push41=, 32($2)
	i32.const	$37=, 240
	i32.add 	$37=, $67, $37
	call    	__floatsitf@FUNCTION, $37, $pop41
	i64.load	$push44=, 240($67)
	i32.const	$push99=, 8
	i32.const	$38=, 240
	i32.add 	$38=, $67, $38
	i32.add 	$push42=, $38, $pop99
	i64.load	$push43=, 0($pop42)
	i32.const	$39=, 224
	i32.add 	$39=, $67, $39
	call    	__addtf3@FUNCTION, $39, $3, $4, $pop44, $pop43
	i32.const	$push98=, 8
	i32.const	$40=, 224
	i32.add 	$40=, $67, $40
	i32.add 	$push45=, $40, $pop98
	i64.load	$4=, 0($pop45)
	i64.load	$3=, 224($67)
	i32.load	$push46=, 36($2)
	i32.const	$41=, 208
	i32.add 	$41=, $67, $41
	call    	__floatsitf@FUNCTION, $41, $pop46
	i64.load	$push49=, 208($67)
	i32.const	$push97=, 8
	i32.const	$42=, 208
	i32.add 	$42=, $67, $42
	i32.add 	$push47=, $42, $pop97
	i64.load	$push48=, 0($pop47)
	i32.const	$43=, 192
	i32.add 	$43=, $67, $43
	call    	__addtf3@FUNCTION, $43, $3, $4, $pop49, $pop48
	i32.const	$push96=, 8
	i32.const	$44=, 192
	i32.add 	$44=, $67, $44
	i32.add 	$push50=, $44, $pop96
	i64.load	$4=, 0($pop50)
	i64.load	$3=, 192($67)
	i32.load	$push51=, 40($2)
	i32.const	$45=, 176
	i32.add 	$45=, $67, $45
	call    	__floatsitf@FUNCTION, $45, $pop51
	i64.load	$push54=, 176($67)
	i32.const	$push95=, 8
	i32.const	$46=, 176
	i32.add 	$46=, $67, $46
	i32.add 	$push52=, $46, $pop95
	i64.load	$push53=, 0($pop52)
	i32.const	$47=, 160
	i32.add 	$47=, $67, $47
	call    	__addtf3@FUNCTION, $47, $3, $4, $pop54, $pop53
	i32.const	$push94=, 8
	i32.const	$48=, 160
	i32.add 	$48=, $67, $48
	i32.add 	$push55=, $48, $pop94
	i64.load	$4=, 0($pop55)
	i64.load	$3=, 160($67)
	i32.load	$push56=, 44($2)
	i32.const	$49=, 144
	i32.add 	$49=, $67, $49
	call    	__floatsitf@FUNCTION, $49, $pop56
	i64.load	$push59=, 144($67)
	i32.const	$push93=, 8
	i32.const	$50=, 144
	i32.add 	$50=, $67, $50
	i32.add 	$push57=, $50, $pop93
	i64.load	$push58=, 0($pop57)
	i32.const	$51=, 128
	i32.add 	$51=, $67, $51
	call    	__addtf3@FUNCTION, $51, $3, $4, $pop59, $pop58
	i32.const	$push92=, 8
	i32.const	$52=, 128
	i32.add 	$52=, $67, $52
	i32.add 	$push60=, $52, $pop92
	i64.load	$4=, 0($pop60)
	i64.load	$3=, 128($67)
	i32.load	$push61=, 48($2)
	i32.const	$53=, 112
	i32.add 	$53=, $67, $53
	call    	__floatsitf@FUNCTION, $53, $pop61
	i64.load	$push64=, 112($67)
	i32.const	$push91=, 8
	i32.const	$54=, 112
	i32.add 	$54=, $67, $54
	i32.add 	$push62=, $54, $pop91
	i64.load	$push63=, 0($pop62)
	i32.const	$55=, 96
	i32.add 	$55=, $67, $55
	call    	__addtf3@FUNCTION, $55, $3, $4, $pop64, $pop63
	i32.const	$push90=, 8
	i32.const	$56=, 96
	i32.add 	$56=, $67, $56
	i32.add 	$push65=, $56, $pop90
	i64.load	$4=, 0($pop65)
	i64.load	$3=, 96($67)
	i32.load	$push66=, 52($2)
	i32.const	$57=, 80
	i32.add 	$57=, $67, $57
	call    	__floatsitf@FUNCTION, $57, $pop66
	i64.load	$push69=, 80($67)
	i32.const	$push89=, 8
	i32.const	$58=, 80
	i32.add 	$58=, $67, $58
	i32.add 	$push67=, $58, $pop89
	i64.load	$push68=, 0($pop67)
	i32.const	$59=, 64
	i32.add 	$59=, $67, $59
	call    	__addtf3@FUNCTION, $59, $3, $4, $pop69, $pop68
	i32.const	$push88=, 8
	i32.const	$60=, 64
	i32.add 	$60=, $67, $60
	i32.add 	$push70=, $60, $pop88
	i64.load	$4=, 0($pop70)
	i64.load	$3=, 64($67)
	i32.load	$push71=, 56($2)
	i32.const	$61=, 48
	i32.add 	$61=, $67, $61
	call    	__floatsitf@FUNCTION, $61, $pop71
	i64.load	$push74=, 48($67)
	i32.const	$push87=, 8
	i32.const	$62=, 48
	i32.add 	$62=, $67, $62
	i32.add 	$push72=, $62, $pop87
	i64.load	$push73=, 0($pop72)
	i32.const	$63=, 32
	i32.add 	$63=, $67, $63
	call    	__addtf3@FUNCTION, $63, $3, $4, $pop74, $pop73
	i32.const	$push86=, 8
	i32.const	$64=, 32
	i32.add 	$64=, $67, $64
	i32.add 	$push75=, $64, $pop86
	i64.load	$4=, 0($pop75)
	i64.load	$3=, 32($67)
	i32.load	$push76=, 60($2)
	i32.const	$65=, 16
	i32.add 	$65=, $67, $65
	call    	__floatsitf@FUNCTION, $65, $pop76
	i64.load	$push79=, 16($67)
	i32.const	$push85=, 8
	i32.const	$66=, 16
	i32.add 	$66=, $67, $66
	i32.add 	$push77=, $66, $pop85
	i64.load	$push78=, 0($pop77)
	call    	__addtf3@FUNCTION, $67, $3, $4, $pop79, $pop78
	i64.load	$4=, 0($67)
	i32.const	$push84=, 8
	i32.add 	$push82=, $0, $pop84
	i32.const	$push83=, 8
	i32.add 	$push80=, $67, $pop83
	i64.load	$push81=, 0($pop80)
	i64.store	$discard=, 0($pop82), $pop81
	i64.store	$discard=, 0($0):p2align=4, $4
	i32.const	$push119=, 512
	i32.add 	$67=, $67, $pop119
	i32.const	$push120=, __stack_pointer
	i32.store	$discard=, 0($pop120), $67
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
