	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr28982a.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.local  	i64, i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32
# BB#0:                                 # %entry
	f32.const	$45=, 0x0p0
	i32.const	$23=, 0
	copy_local	$46=, $45
	copy_local	$47=, $45
	copy_local	$48=, $45
	copy_local	$49=, $45
	copy_local	$50=, $45
	copy_local	$51=, $45
	copy_local	$52=, $45
	copy_local	$53=, $45
	copy_local	$54=, $45
	copy_local	$55=, $45
	copy_local	$56=, $45
	copy_local	$57=, $45
	copy_local	$58=, $45
	copy_local	$59=, $45
	copy_local	$60=, $45
	copy_local	$61=, $45
	copy_local	$62=, $45
	copy_local	$63=, $45
	copy_local	$64=, $45
	block   	.LBB0_3
	i32.const	$push51=, 0
	i32.eq  	$push52=, $0, $pop51
	br_if   	$pop52, .LBB0_3
# BB#1:                                 # %while.body.preheader
	i64.load	$2=, incs+72($23)
	i64.load	$1=, incs+64($23)
	i64.const	$24=, 32
	i32.const	$22=, 2
	i64.shr_u	$push0=, $2, $24
	i32.wrap/i64	$push1=, $pop0
	i32.shl 	$3=, $pop1, $22
	i32.wrap/i64	$push2=, $2
	i32.shl 	$4=, $pop2, $22
	i64.shr_u	$push3=, $1, $24
	i32.wrap/i64	$push4=, $pop3
	i32.shl 	$5=, $pop4, $22
	i64.load	$2=, incs+56($23)
	i32.wrap/i64	$push5=, $1
	i32.shl 	$6=, $pop5, $22
	i64.load	$1=, incs+48($23)
	i64.shr_u	$push6=, $2, $24
	i32.wrap/i64	$push7=, $pop6
	i32.shl 	$7=, $pop7, $22
	i32.wrap/i64	$push8=, $2
	i32.shl 	$8=, $pop8, $22
	i64.shr_u	$push9=, $1, $24
	i32.wrap/i64	$push10=, $pop9
	i32.shl 	$9=, $pop10, $22
	i64.load	$2=, incs+40($23)
	i32.wrap/i64	$push11=, $1
	i32.shl 	$10=, $pop11, $22
	i64.load	$1=, incs+32($23)
	i64.shr_u	$push12=, $2, $24
	i32.wrap/i64	$push13=, $pop12
	i32.shl 	$11=, $pop13, $22
	i32.wrap/i64	$push14=, $2
	i32.shl 	$12=, $pop14, $22
	i64.shr_u	$push15=, $1, $24
	i32.wrap/i64	$push16=, $pop15
	i32.shl 	$13=, $pop16, $22
	i64.load	$2=, incs+24($23)
	i32.wrap/i64	$push17=, $1
	i32.shl 	$14=, $pop17, $22
	i64.load	$1=, incs+16($23)
	i64.shr_u	$push18=, $2, $24
	i32.wrap/i64	$push19=, $pop18
	i32.shl 	$15=, $pop19, $22
	i32.wrap/i64	$push20=, $2
	i32.shl 	$16=, $pop20, $22
	i64.shr_u	$push21=, $1, $24
	i32.wrap/i64	$push22=, $pop21
	i32.shl 	$17=, $pop22, $22
	i64.load	$2=, incs+8($23)
	i32.wrap/i64	$push23=, $1
	i32.shl 	$18=, $pop23, $22
	i64.load	$1=, incs($23)
	i64.shr_u	$push24=, $2, $24
	i32.wrap/i64	$push25=, $pop24
	i32.shl 	$19=, $pop25, $22
	i32.wrap/i64	$push26=, $2
	i32.shl 	$20=, $pop26, $22
	i64.shr_u	$push27=, $1, $24
	i32.wrap/i64	$push28=, $pop27
	i32.shl 	$21=, $pop28, $22
	i32.load	$44=, ptrs+76($23)
	i32.load	$43=, ptrs+72($23)
	i32.load	$42=, ptrs+68($23)
	i32.load	$41=, ptrs+64($23)
	i32.load	$40=, ptrs+60($23)
	i32.load	$39=, ptrs+56($23)
	i32.load	$38=, ptrs+52($23)
	i32.load	$37=, ptrs+48($23)
	i32.load	$36=, ptrs+44($23)
	i32.load	$35=, ptrs+40($23)
	i32.load	$34=, ptrs+36($23)
	i32.load	$33=, ptrs+32($23)
	i32.load	$32=, ptrs+28($23)
	i32.load	$31=, ptrs+24($23)
	i32.load	$30=, ptrs+20($23)
	i32.load	$29=, ptrs+16($23)
	i32.load	$28=, ptrs+12($23)
	i32.load	$27=, ptrs+8($23)
	i32.load	$26=, ptrs+4($23)
	i32.load	$25=, ptrs($23)
	f32.const	$45=, 0x0p0
	i32.wrap/i64	$push29=, $1
	i32.shl 	$22=, $pop29, $22
	copy_local	$46=, $45
	copy_local	$47=, $45
	copy_local	$48=, $45
	copy_local	$49=, $45
	copy_local	$50=, $45
	copy_local	$51=, $45
	copy_local	$52=, $45
	copy_local	$53=, $45
	copy_local	$54=, $45
	copy_local	$55=, $45
	copy_local	$56=, $45
	copy_local	$57=, $45
	copy_local	$58=, $45
	copy_local	$59=, $45
	copy_local	$60=, $45
	copy_local	$61=, $45
	copy_local	$62=, $45
	copy_local	$63=, $45
	copy_local	$64=, $45
.LBB0_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB0_3
	f32.load	$push31=, 0($25)
	f32.add 	$64=, $64, $pop31
	f32.load	$push32=, 0($26)
	f32.add 	$63=, $63, $pop32
	f32.load	$push33=, 0($27)
	f32.add 	$62=, $62, $pop33
	f32.load	$push34=, 0($28)
	f32.add 	$61=, $61, $pop34
	f32.load	$push35=, 0($29)
	f32.add 	$60=, $60, $pop35
	f32.load	$push36=, 0($30)
	f32.add 	$59=, $59, $pop36
	f32.load	$push37=, 0($31)
	f32.add 	$58=, $58, $pop37
	f32.load	$push38=, 0($32)
	f32.add 	$57=, $57, $pop38
	f32.load	$push39=, 0($33)
	f32.add 	$56=, $56, $pop39
	f32.load	$push40=, 0($34)
	f32.add 	$55=, $55, $pop40
	f32.load	$push41=, 0($35)
	f32.add 	$54=, $54, $pop41
	f32.load	$push42=, 0($36)
	f32.add 	$53=, $53, $pop42
	f32.load	$push43=, 0($37)
	f32.add 	$52=, $52, $pop43
	f32.load	$push44=, 0($38)
	f32.add 	$51=, $51, $pop44
	f32.load	$push45=, 0($39)
	f32.add 	$50=, $50, $pop45
	f32.load	$push46=, 0($40)
	f32.add 	$49=, $49, $pop46
	f32.load	$push47=, 0($41)
	f32.add 	$48=, $48, $pop47
	f32.load	$push48=, 0($42)
	f32.add 	$47=, $47, $pop48
	f32.load	$push49=, 0($43)
	f32.add 	$46=, $46, $pop49
	i32.const	$push30=, -1
	i32.add 	$0=, $0, $pop30
	f32.load	$push50=, 0($44)
	f32.add 	$45=, $45, $pop50
	i32.add 	$44=, $44, $3
	i32.add 	$43=, $43, $4
	i32.add 	$42=, $42, $5
	i32.add 	$41=, $41, $6
	i32.add 	$40=, $40, $7
	i32.add 	$39=, $39, $8
	i32.add 	$38=, $38, $9
	i32.add 	$37=, $37, $10
	i32.add 	$36=, $36, $11
	i32.add 	$35=, $35, $12
	i32.add 	$34=, $34, $13
	i32.add 	$33=, $33, $14
	i32.add 	$32=, $32, $15
	i32.add 	$31=, $31, $16
	i32.add 	$30=, $30, $17
	i32.add 	$29=, $29, $18
	i32.add 	$28=, $28, $19
	i32.add 	$27=, $27, $20
	i32.add 	$26=, $26, $21
	i32.add 	$25=, $25, $22
	br_if   	$0, .LBB0_2
.LBB0_3:                                # %while.end
	f32.store	$discard=, results($23), $64
	f32.store	$discard=, results+4($23), $63
	f32.store	$discard=, results+8($23), $62
	f32.store	$discard=, results+12($23), $61
	f32.store	$discard=, results+16($23), $60
	f32.store	$discard=, results+20($23), $59
	f32.store	$discard=, results+24($23), $58
	f32.store	$discard=, results+28($23), $57
	f32.store	$discard=, results+32($23), $56
	f32.store	$discard=, results+36($23), $55
	f32.store	$discard=, results+40($23), $54
	f32.store	$discard=, results+44($23), $53
	f32.store	$discard=, results+48($23), $52
	f32.store	$discard=, results+52($23), $51
	f32.store	$discard=, results+56($23), $50
	f32.store	$discard=, results+60($23), $49
	f32.store	$discard=, results+64($23), $48
	f32.store	$discard=, results+68($23), $47
	f32.store	$discard=, results+72($23), $46
	f32.store	$discard=, results+76($23), $45
	return
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, 0
	i32.const	$push0=, input
	i32.store	$2=, ptrs($3), $pop0
	i32.store	$discard=, incs($3), $3
	i32.const	$push1=, input+4
	i32.store	$discard=, ptrs+4($3), $pop1
	i32.const	$push3=, input+8
	i32.store	$discard=, ptrs+8($3), $pop3
	i32.const	$push4=, 2
	i32.store	$discard=, incs+8($3), $pop4
	i32.const	$push5=, input+12
	i32.store	$discard=, ptrs+12($3), $pop5
	i32.const	$push6=, 3
	i32.store	$discard=, incs+12($3), $pop6
	i32.const	$push7=, input+16
	i32.store	$discard=, ptrs+16($3), $pop7
	i32.const	$push9=, input+20
	i32.store	$discard=, ptrs+20($3), $pop9
	i32.const	$push10=, 5
	i32.store	$discard=, incs+20($3), $pop10
	i32.const	$push11=, input+24
	i32.store	$discard=, ptrs+24($3), $pop11
	i32.const	$push12=, 6
	i32.store	$discard=, incs+24($3), $pop12
	i32.const	$push13=, input+28
	i32.store	$discard=, ptrs+28($3), $pop13
	i32.const	$push14=, 7
	i32.store	$discard=, incs+28($3), $pop14
	i32.const	$push15=, input+32
	i32.store	$discard=, ptrs+32($3), $pop15
	i32.const	$push16=, 8
	i32.store	$discard=, incs+32($3), $pop16
	i32.const	$push17=, input+36
	i32.store	$discard=, ptrs+36($3), $pop17
	i32.const	$push18=, 9
	i32.store	$discard=, incs+36($3), $pop18
	i32.const	$push19=, input+40
	i32.store	$discard=, ptrs+40($3), $pop19
	i32.const	$push20=, 10
	i32.store	$discard=, incs+40($3), $pop20
	i32.const	$push21=, input+44
	i32.store	$discard=, ptrs+44($3), $pop21
	i32.const	$push22=, 11
	i32.store	$discard=, incs+44($3), $pop22
	i32.const	$push23=, input+48
	i32.store	$discard=, ptrs+48($3), $pop23
	i32.const	$push24=, 12
	i32.store	$discard=, incs+48($3), $pop24
	i32.const	$push25=, input+52
	i32.store	$discard=, ptrs+52($3), $pop25
	i32.const	$push26=, 13
	i32.store	$discard=, incs+52($3), $pop26
	i32.const	$push27=, input+56
	i32.store	$discard=, ptrs+56($3), $pop27
	i32.const	$push28=, 14
	i32.store	$discard=, incs+56($3), $pop28
	i32.const	$push29=, input+60
	i32.store	$discard=, ptrs+60($3), $pop29
	i32.const	$push30=, 15
	i32.store	$discard=, incs+60($3), $pop30
	i32.const	$push31=, input+64
	i32.store	$discard=, ptrs+64($3), $pop31
	i32.const	$push32=, 16
	i32.store	$discard=, incs+64($3), $pop32
	i32.const	$push33=, input+68
	i32.store	$discard=, ptrs+68($3), $pop33
	i32.const	$push34=, 17
	i32.store	$discard=, incs+68($3), $pop34
	i32.const	$push35=, input+72
	i32.store	$discard=, ptrs+72($3), $pop35
	i32.const	$push36=, 18
	i32.store	$discard=, incs+72($3), $pop36
	i32.const	$push37=, input+76
	i32.store	$discard=, ptrs+76($3), $pop37
	i32.const	$push38=, 19
	i32.store	$discard=, incs+76($3), $pop38
	i32.const	$push2=, 1
	i32.store	$0=, incs+4($3), $pop2
	i32.const	$push8=, 4
	i32.store	$1=, incs+16($3), $pop8
.LBB1_1:                                # %for.body4
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB1_2
	f32.convert_s/i32	$push39=, $3
	f32.store	$discard=, 0($2), $pop39
	i32.add 	$3=, $3, $0
	i32.add 	$2=, $2, $1
	i32.const	$push40=, 80
	i32.ne  	$push41=, $3, $pop40
	br_if   	$pop41, .LBB1_1
.LBB1_2:                                # %for.end8
	call    	foo@FUNCTION, $1
	i32.const	$3=, 0
	f32.load	$push42=, results($3)
	f32.const	$push43=, 0x0p0
	f32.ne  	$push44=, $pop42, $pop43
	f32.load	$push45=, results+4($3)
	f32.const	$push46=, 0x1.4p3
	f32.ne  	$push47=, $pop45, $pop46
	i32.or  	$push48=, $pop44, $pop47
	f32.load	$push49=, results+8($3)
	f32.const	$push50=, 0x1.4p4
	f32.ne  	$push51=, $pop49, $pop50
	i32.or  	$push52=, $pop48, $pop51
	f32.load	$push53=, results+12($3)
	f32.const	$push54=, 0x1.ep4
	f32.ne  	$push55=, $pop53, $pop54
	i32.or  	$push56=, $pop52, $pop55
	f32.load	$push57=, results+16($3)
	f32.const	$push58=, 0x1.4p5
	f32.ne  	$push59=, $pop57, $pop58
	i32.or  	$push60=, $pop56, $pop59
	f32.load	$push61=, results+20($3)
	f32.const	$push62=, 0x1.9p5
	f32.ne  	$push63=, $pop61, $pop62
	i32.or  	$push64=, $pop60, $pop63
	f32.load	$push65=, results+24($3)
	f32.const	$push66=, 0x1.ep5
	f32.ne  	$push67=, $pop65, $pop66
	i32.or  	$push68=, $pop64, $pop67
	f32.load	$push69=, results+28($3)
	f32.const	$push70=, 0x1.18p6
	f32.ne  	$push71=, $pop69, $pop70
	i32.or  	$push72=, $pop68, $pop71
	f32.load	$push73=, results+32($3)
	f32.const	$push74=, 0x1.4p6
	f32.ne  	$push75=, $pop73, $pop74
	i32.or  	$push76=, $pop72, $pop75
	f32.load	$push77=, results+36($3)
	f32.const	$push78=, 0x1.68p6
	f32.ne  	$push79=, $pop77, $pop78
	i32.or  	$push80=, $pop76, $pop79
	f32.load	$push81=, results+40($3)
	f32.const	$push82=, 0x1.9p6
	f32.ne  	$push83=, $pop81, $pop82
	i32.or  	$push84=, $pop80, $pop83
	f32.load	$push85=, results+44($3)
	f32.const	$push86=, 0x1.b8p6
	f32.ne  	$push87=, $pop85, $pop86
	i32.or  	$push88=, $pop84, $pop87
	f32.load	$push89=, results+48($3)
	f32.const	$push90=, 0x1.ep6
	f32.ne  	$push91=, $pop89, $pop90
	i32.or  	$push92=, $pop88, $pop91
	f32.load	$push93=, results+52($3)
	f32.const	$push94=, 0x1.04p7
	f32.ne  	$push95=, $pop93, $pop94
	i32.or  	$push96=, $pop92, $pop95
	f32.load	$push97=, results+56($3)
	f32.const	$push98=, 0x1.18p7
	f32.ne  	$push99=, $pop97, $pop98
	i32.or  	$push100=, $pop96, $pop99
	f32.load	$push101=, results+60($3)
	f32.const	$push102=, 0x1.2cp7
	f32.ne  	$push103=, $pop101, $pop102
	i32.or  	$push104=, $pop100, $pop103
	f32.load	$push105=, results+64($3)
	f32.const	$push106=, 0x1.4p7
	f32.ne  	$push107=, $pop105, $pop106
	i32.or  	$push108=, $pop104, $pop107
	f32.load	$push109=, results+68($3)
	f32.const	$push110=, 0x1.54p7
	f32.ne  	$push111=, $pop109, $pop110
	i32.or  	$push112=, $pop108, $pop111
	f32.load	$push113=, results+72($3)
	f32.const	$push114=, 0x1.68p7
	f32.ne  	$push115=, $pop113, $pop114
	i32.or  	$push116=, $pop112, $pop115
	f32.load	$push117=, results+76($3)
	f32.const	$push118=, 0x1.7cp7
	f32.ne  	$push119=, $pop117, $pop118
	i32.or  	$push120=, $pop116, $pop119
	i32.and 	$push121=, $pop120, $0
	return  	$pop121
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	incs                    # @incs
	.type	incs,@object
	.section	.bss.incs,"aw",@nobits
	.globl	incs
	.align	4
incs:
	.skip	80
	.size	incs, 80

	.hidden	ptrs                    # @ptrs
	.type	ptrs,@object
	.section	.bss.ptrs,"aw",@nobits
	.globl	ptrs
	.align	4
ptrs:
	.skip	80
	.size	ptrs, 80

	.hidden	results                 # @results
	.type	results,@object
	.section	.bss.results,"aw",@nobits
	.globl	results
	.align	4
results:
	.skip	80
	.size	results, 80

	.hidden	input                   # @input
	.type	input,@object
	.section	.bss.input,"aw",@nobits
	.globl	input
	.align	4
input:
	.skip	320
	.size	input, 320


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
