	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20071219-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, 0
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block   	.LBB0_6
	loop    	.LBB0_5
	i32.add 	$2=, $0, $3
	i32.load8_u	$push0=, 0($2)
	br_if   	$pop0, .LBB0_6
# BB#2:                                 # %if.else
                                        #   in Loop: Header=BB0_1 Depth=1
	block   	.LBB0_4
	i32.const	$push5=, 0
	i32.eq  	$push6=, $1, $pop5
	br_if   	$pop6, .LBB0_4
# BB#3:                                 # %if.then3
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.store8	$discard=, 0($2), $1
.LBB0_4:                                # %for.inc
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push1=, 1
	i32.add 	$3=, $3, $pop1
	i32.const	$push2=, 25
	i32.lt_u	$push3=, $3, $pop2
	br_if   	$pop3, .LBB0_1
.LBB0_5:                                # %for.end
	i32.const	$push4=, 0
	i32.store	$discard=, p($pop4), $0
	return
.LBB0_6:                                # %if.then
	call    	abort@FUNCTION
	unreachable
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.test1,"ax",@progbits
	.hidden	test1
	.globl	test1
	.type	test1,@function
test1:                                  # @test1
	.local  	i32, i32, i32, i32, i32, i64, i32, i32, i64, i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$10=, __stack_pointer
	i32.load	$10=, 0($10)
	i32.const	$11=, 64
	i32.sub 	$22=, $10, $11
	i32.const	$11=, __stack_pointer
	i32.store	$22=, 0($11), $22
	i32.const	$0=, 24
	i32.const	$13=, 32
	i32.add 	$13=, $22, $13
	i32.add 	$1=, $13, $0
	i32.const	$push0=, 0
	i32.store8	$2=, 0($1), $pop0
	i32.const	$3=, 16
	i32.const	$14=, 32
	i32.add 	$14=, $22, $14
	i32.add 	$4=, $14, $3
	i64.const	$push1=, 0
	i64.store	$5=, 0($4), $pop1
	i32.const	$6=, 8
	i32.const	$15=, 32
	i32.add 	$15=, $22, $15
	i32.add 	$7=, $15, $6
	i64.store	$push2=, 0($7), $5
	i64.store	$discard=, 32($22), $pop2
	i32.const	$16=, 32
	i32.add 	$16=, $22, $16
	call    	foo@FUNCTION, $16, $2
	i32.const	$17=, 0
	i32.add 	$17=, $22, $17
	i32.add 	$0=, $17, $0
	i64.load	$5=, 0($4)
	i32.load8_u	$push3=, 0($1)
	i32.store8	$discard=, 0($0), $pop3
	i32.const	$18=, 0
	i32.add 	$18=, $22, $18
	i32.add 	$3=, $18, $3
	i64.load	$8=, 0($7)
	i64.store	$discard=, 0($3), $5
	i64.load	$5=, 32($22)
	i32.const	$19=, 0
	i32.add 	$19=, $22, $19
	i32.add 	$6=, $19, $6
	i64.store	$discard=, 0($6), $8
	i64.store	$discard=, 0($22), $5
	i32.const	$push4=, 1
	i32.const	$20=, 0
	i32.add 	$20=, $22, $20
	call    	foo@FUNCTION, $20, $pop4
	i64.load	$5=, 0($4)
	i64.load	$8=, 0($7)
	i64.load	$9=, 32($22)
	i32.load8_u	$push5=, 0($1)
	i32.store8	$discard=, 0($0), $pop5
	i64.store	$discard=, 0($3), $5
	i64.store	$discard=, 0($6), $8
	i64.store	$discard=, 0($22), $9
	i32.const	$21=, 0
	i32.add 	$21=, $22, $21
	call    	foo@FUNCTION, $21, $2
	i32.const	$12=, 64
	i32.add 	$22=, $22, $12
	i32.const	$12=, __stack_pointer
	i32.store	$22=, 0($12), $22
	return
.Lfunc_end1:
	.size	test1, .Lfunc_end1-test1

	.section	.text.test2,"ax",@progbits
	.hidden	test2
	.globl	test2
	.type	test2,@function
test2:                                  # @test2
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i64, i64, i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$14=, __stack_pointer
	i32.load	$14=, 0($14)
	i32.const	$15=, 64
	i32.sub 	$26=, $14, $15
	i32.const	$15=, __stack_pointer
	i32.store	$26=, 0($15), $26
	i32.const	$0=, 24
	i32.const	$17=, 32
	i32.add 	$17=, $26, $17
	i32.add 	$10=, $17, $0
	i32.const	$push0=, 0
	i32.store8	$1=, 0($10), $pop0
	i32.const	$2=, 16
	i32.const	$18=, 32
	i32.add 	$18=, $26, $18
	i32.add 	$3=, $18, $2
	i64.const	$push1=, 0
	i64.store	$11=, 0($3), $pop1
	i32.const	$4=, 8
	i32.const	$19=, 32
	i32.add 	$19=, $26, $19
	i32.add 	$5=, $19, $4
	i64.store	$push2=, 0($5), $11
	i64.store	$discard=, 32($26), $pop2
	i32.const	$20=, 32
	i32.add 	$20=, $26, $20
	call    	foo@FUNCTION, $20, $1
	i64.load	$11=, 0($3)
	i32.const	$21=, 0
	i32.add 	$21=, $26, $21
	i32.add 	$6=, $21, $0
	i32.load8_u	$push3=, 0($10)
	i32.store8	$discard=, 0($6), $pop3
	i64.load	$12=, 0($5)
	i32.const	$22=, 0
	i32.add 	$22=, $26, $22
	i32.add 	$7=, $22, $2
	i64.store	$discard=, 0($7), $11
	i64.load	$11=, 32($26)
	i32.const	$23=, 0
	i32.add 	$23=, $26, $23
	i32.add 	$8=, $23, $4
	i64.store	$discard=, 0($8), $12
	i32.const	$9=, 1
	i64.store	$discard=, 0($26), $11
	i32.const	$24=, 0
	i32.add 	$24=, $26, $24
	call    	foo@FUNCTION, $24, $9
	i32.load8_u	$push4=, 0($10)
	i32.store8	$discard=, 0($6), $pop4
	i64.load	$11=, 0($5)
	i64.load	$12=, 32($26)
	i32.load	$10=, p($1)
	i64.load	$push5=, 0($3)
	i64.store	$discard=, 0($7), $pop5
	i64.store	$discard=, 0($8), $11
	i64.store	$discard=, 0($26), $12
	i32.add 	$push6=, $10, $0
	i32.load8_u	$push7=, 0($pop6)
	i32.store8	$discard=, 0($6), $pop7
	i64.const	$11=, 8
	i64.const	$12=, 16
	i64.const	$13=, 32
	i32.const	$push33=, 23
	i32.add 	$push34=, $10, $pop33
	i64.load8_u	$push35=, 0($pop34)
	i64.shl 	$push36=, $pop35, $11
	i32.const	$push37=, 22
	i32.add 	$push38=, $10, $pop37
	i64.load8_u	$push39=, 0($pop38)
	i64.or  	$push40=, $pop36, $pop39
	i64.shl 	$push41=, $pop40, $12
	i32.const	$push25=, 21
	i32.add 	$push26=, $10, $pop25
	i64.load8_u	$push27=, 0($pop26)
	i64.shl 	$push28=, $pop27, $11
	i32.const	$push29=, 20
	i32.add 	$push30=, $10, $pop29
	i64.load8_u	$push31=, 0($pop30)
	i64.or  	$push32=, $pop28, $pop31
	i64.or  	$push42=, $pop41, $pop32
	i64.shl 	$push43=, $pop42, $13
	i32.const	$push15=, 19
	i32.add 	$push16=, $10, $pop15
	i64.load8_u	$push17=, 0($pop16)
	i64.shl 	$push18=, $pop17, $11
	i32.const	$push19=, 18
	i32.add 	$push20=, $10, $pop19
	i64.load8_u	$push21=, 0($pop20)
	i64.or  	$push22=, $pop18, $pop21
	i64.shl 	$push23=, $pop22, $12
	i32.const	$push8=, 17
	i32.add 	$push9=, $10, $pop8
	i64.load8_u	$push10=, 0($pop9)
	i64.shl 	$push11=, $pop10, $11
	i32.add 	$push12=, $10, $2
	i64.load8_u	$push13=, 0($pop12)
	i64.or  	$push14=, $pop11, $pop13
	i64.or  	$push24=, $pop23, $pop14
	i64.or  	$push44=, $pop43, $pop24
	i64.store	$discard=, 0($7), $pop44
	i32.const	$push70=, 15
	i32.add 	$push71=, $10, $pop70
	i64.load8_u	$push72=, 0($pop71)
	i64.shl 	$push73=, $pop72, $11
	i32.const	$push74=, 14
	i32.add 	$push75=, $10, $pop74
	i64.load8_u	$push76=, 0($pop75)
	i64.or  	$push77=, $pop73, $pop76
	i64.shl 	$push78=, $pop77, $12
	i32.const	$push62=, 13
	i32.add 	$push63=, $10, $pop62
	i64.load8_u	$push64=, 0($pop63)
	i64.shl 	$push65=, $pop64, $11
	i32.const	$push66=, 12
	i32.add 	$push67=, $10, $pop66
	i64.load8_u	$push68=, 0($pop67)
	i64.or  	$push69=, $pop65, $pop68
	i64.or  	$push79=, $pop78, $pop69
	i64.shl 	$push80=, $pop79, $13
	i32.const	$push52=, 11
	i32.add 	$push53=, $10, $pop52
	i64.load8_u	$push54=, 0($pop53)
	i64.shl 	$push55=, $pop54, $11
	i32.const	$push56=, 10
	i32.add 	$push57=, $10, $pop56
	i64.load8_u	$push58=, 0($pop57)
	i64.or  	$push59=, $pop55, $pop58
	i64.shl 	$push60=, $pop59, $12
	i32.const	$push45=, 9
	i32.add 	$push46=, $10, $pop45
	i64.load8_u	$push47=, 0($pop46)
	i64.shl 	$push48=, $pop47, $11
	i32.add 	$push49=, $10, $4
	i64.load8_u	$push50=, 0($pop49)
	i64.or  	$push51=, $pop48, $pop50
	i64.or  	$push61=, $pop60, $pop51
	i64.or  	$push81=, $pop80, $pop61
	i64.store	$discard=, 0($8), $pop81
	i32.const	$push90=, 7
	i32.add 	$push91=, $10, $pop90
	i64.load8_u	$push92=, 0($pop91)
	i64.shl 	$push93=, $pop92, $11
	i32.const	$push94=, 6
	i32.add 	$push95=, $10, $pop94
	i64.load8_u	$push96=, 0($pop95)
	i64.or  	$push97=, $pop93, $pop96
	i64.shl 	$push98=, $pop97, $12
	i32.const	$push82=, 5
	i32.add 	$push83=, $10, $pop82
	i64.load8_u	$push84=, 0($pop83)
	i64.shl 	$push85=, $pop84, $11
	i32.const	$push86=, 4
	i32.add 	$push87=, $10, $pop86
	i64.load8_u	$push88=, 0($pop87)
	i64.or  	$push89=, $pop85, $pop88
	i64.or  	$push99=, $pop98, $pop89
	i64.shl 	$push100=, $pop99, $13
	i32.const	$push101=, 3
	i32.add 	$push102=, $10, $pop101
	i64.load8_u	$push103=, 0($pop102)
	i64.shl 	$push104=, $pop103, $11
	i32.const	$push105=, 2
	i32.add 	$push106=, $10, $pop105
	i64.load8_u	$push107=, 0($pop106)
	i64.or  	$push108=, $pop104, $pop107
	i64.shl 	$push109=, $pop108, $12
	i32.add 	$push110=, $10, $9
	i64.load8_u	$push111=, 0($pop110)
	i64.shl 	$push112=, $pop111, $11
	i64.load8_u	$push113=, 0($10)
	i64.or  	$push114=, $pop112, $pop113
	i64.or  	$push115=, $pop109, $pop114
	i64.or  	$push116=, $pop100, $pop115
	i64.store	$discard=, 0($26), $pop116
	i32.const	$25=, 0
	i32.add 	$25=, $26, $25
	call    	foo@FUNCTION, $25, $1
	i32.const	$16=, 64
	i32.add 	$26=, $26, $16
	i32.const	$16=, __stack_pointer
	i32.store	$26=, 0($16), $26
	return
.Lfunc_end2:
	.size	test2, .Lfunc_end2-test2

	.section	.text.test3,"ax",@progbits
	.hidden	test3
	.globl	test3
	.type	test3,@function
test3:                                  # @test3
	.local  	i32, i32, i32, i32, i32, i64, i32, i32, i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$9=, __stack_pointer
	i32.load	$9=, 0($9)
	i32.const	$10=, 64
	i32.sub 	$23=, $9, $10
	i32.const	$10=, __stack_pointer
	i32.store	$23=, 0($10), $23
	i32.const	$0=, 24
	i32.const	$12=, 32
	i32.add 	$12=, $23, $12
	i32.add 	$1=, $12, $0
	i32.const	$push0=, 0
	i32.store8	$2=, 0($1), $pop0
	i32.const	$3=, 16
	i32.const	$13=, 32
	i32.add 	$13=, $23, $13
	i32.add 	$4=, $13, $3
	i64.const	$push1=, 0
	i64.store	$5=, 0($4), $pop1
	i32.const	$6=, 8
	i32.const	$14=, 32
	i32.add 	$14=, $23, $14
	i32.add 	$7=, $14, $6
	i64.store	$push2=, 0($7), $5
	i64.store	$discard=, 32($23), $pop2
	i32.const	$15=, 32
	i32.add 	$15=, $23, $15
	call    	foo@FUNCTION, $15, $2
	i64.load	$5=, 0($4)
	i32.const	$16=, 0
	i32.add 	$16=, $23, $16
	i32.add 	$push3=, $16, $0
	i32.load8_u	$push4=, 0($1)
	i32.store8	$discard=, 0($pop3), $pop4
	i64.load	$8=, 0($7)
	i32.const	$17=, 0
	i32.add 	$17=, $23, $17
	i32.add 	$push5=, $17, $3
	i64.store	$discard=, 0($pop5), $5
	i64.load	$5=, 32($23)
	i32.const	$18=, 0
	i32.add 	$18=, $23, $18
	i32.add 	$push6=, $18, $6
	i64.store	$discard=, 0($pop6), $8
	i64.store	$discard=, 0($23), $5
	i32.const	$push7=, 1
	i32.const	$19=, 0
	i32.add 	$19=, $23, $19
	call    	foo@FUNCTION, $19, $pop7
	i32.load	$0=, p($2)
	i32.const	$1=, 25
	i32.const	$20=, 32
	i32.add 	$20=, $23, $20
	call    	memcpy@FUNCTION, $0, $20, $1
	i32.const	$21=, 0
	i32.add 	$21=, $23, $21
	call    	memcpy@FUNCTION, $0, $21, $1
	i32.const	$22=, 0
	i32.add 	$22=, $23, $22
	call    	foo@FUNCTION, $22, $2
	i32.const	$11=, 64
	i32.add 	$23=, $23, $11
	i32.const	$11=, __stack_pointer
	i32.store	$23=, 0($11), $23
	return
.Lfunc_end3:
	.size	test3, .Lfunc_end3-test3

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	call    	test1@FUNCTION
	call    	test2@FUNCTION
	call    	test3@FUNCTION
	i32.const	$push0=, 0
	return  	$pop0
.Lfunc_end4:
	.size	main, .Lfunc_end4-main

	.hidden	p                       # @p
	.type	p,@object
	.section	.bss.p,"aw",@nobits
	.globl	p
	.align	2
p:
	.int32	0
	.size	p, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
