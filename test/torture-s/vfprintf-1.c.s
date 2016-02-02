	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/vfprintf-1.c"
	.section	.text.inner,"ax",@progbits
	.hidden	inner
	.globl	inner
	.type	inner,@function
inner:                                  # @inner
	.param  	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 16
	i32.sub 	$4=, $1, $2
	copy_local	$5=, $4
	i32.const	$2=, __stack_pointer
	i32.store	$4=, 0($2), $4
	i32.store	$push0=, 12($4), $5
	i32.store	$discard=, 8($4), $pop0
	block
	i32.const	$push1=, 10
	i32.gt_u	$push2=, $0, $pop1
	br_if   	$pop2, 0        # 0: down to label0
# BB#1:                                 # %entry
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
	tableswitch	$0, 0, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 # 0: down to label12
                                        # 1: down to label11
                                        # 2: down to label10
                                        # 3: down to label9
                                        # 4: down to label8
                                        # 5: down to label7
                                        # 6: down to label6
                                        # 7: down to label5
                                        # 8: down to label4
                                        # 9: down to label3
                                        # 10: down to label2
.LBB0_2:                                # %sw.bb
	end_block                       # label12:
	i32.const	$push89=, 0
	i32.load	$push90=, stdout($pop89)
	i32.const	$push92=, .L.str
	i32.load	$push91=, 12($4)
	i32.call	$discard=, vfprintf@FUNCTION, $pop90, $pop92, $pop91
	i32.const	$push99=, 0
	i32.load	$push93=, stdout($pop99)
	i32.const	$push98=, .L.str
	i32.load	$push94=, 8($4)
	i32.call	$push95=, vfprintf@FUNCTION, $pop93, $pop98, $pop94
	i32.const	$push96=, 5
	i32.eq  	$push97=, $pop95, $pop96
	br_if   	$pop97, 10      # 10: down to label1
# BB#3:                                 # %if.then
	call    	abort@FUNCTION
	unreachable
.LBB0_4:                                # %sw.bb4
	end_block                       # label11:
	i32.const	$push80=, 0
	i32.load	$push81=, stdout($pop80)
	i32.const	$push83=, .L.str.1
	i32.load	$push82=, 12($4)
	i32.call	$discard=, vfprintf@FUNCTION, $pop81, $pop83, $pop82
	i32.const	$push101=, 0
	i32.load	$push84=, stdout($pop101)
	i32.const	$push100=, .L.str.1
	i32.load	$push85=, 8($4)
	i32.call	$push86=, vfprintf@FUNCTION, $pop84, $pop100, $pop85
	i32.const	$push87=, 6
	i32.eq  	$push88=, $pop86, $pop87
	br_if   	$pop88, 9       # 9: down to label1
# BB#5:                                 # %if.then8
	call    	abort@FUNCTION
	unreachable
.LBB0_6:                                # %sw.bb10
	end_block                       # label10:
	i32.const	$push71=, 0
	i32.load	$push72=, stdout($pop71)
	i32.const	$push74=, .L.str.2
	i32.load	$push73=, 12($4)
	i32.call	$discard=, vfprintf@FUNCTION, $pop72, $pop74, $pop73
	i32.const	$push103=, 0
	i32.load	$push75=, stdout($pop103)
	i32.const	$push102=, .L.str.2
	i32.load	$push76=, 8($4)
	i32.call	$push77=, vfprintf@FUNCTION, $pop75, $pop102, $pop76
	i32.const	$push78=, 1
	i32.eq  	$push79=, $pop77, $pop78
	br_if   	$pop79, 8       # 8: down to label1
# BB#7:                                 # %if.then14
	call    	abort@FUNCTION
	unreachable
.LBB0_8:                                # %sw.bb16
	end_block                       # label9:
	i32.const	$push64=, 0
	i32.load	$push65=, stdout($pop64)
	i32.const	$push67=, .L.str.3
	i32.load	$push66=, 12($4)
	i32.call	$discard=, vfprintf@FUNCTION, $pop65, $pop67, $pop66
	i32.const	$push105=, 0
	i32.load	$push68=, stdout($pop105)
	i32.const	$push104=, .L.str.3
	i32.load	$push69=, 8($4)
	i32.call	$push70=, vfprintf@FUNCTION, $pop68, $pop104, $pop69
	i32.const	$push120=, 0
	i32.eq  	$push121=, $pop70, $pop120
	br_if   	$pop121, 7      # 7: down to label1
# BB#9:                                 # %if.then20
	call    	abort@FUNCTION
	unreachable
.LBB0_10:                               # %sw.bb22
	end_block                       # label8:
	i32.const	$push55=, 0
	i32.load	$push56=, stdout($pop55)
	i32.const	$push58=, .L.str.4
	i32.load	$push57=, 12($4)
	i32.call	$discard=, vfprintf@FUNCTION, $pop56, $pop58, $pop57
	i32.const	$push107=, 0
	i32.load	$push59=, stdout($pop107)
	i32.const	$push106=, .L.str.4
	i32.load	$push60=, 8($4)
	i32.call	$push61=, vfprintf@FUNCTION, $pop59, $pop106, $pop60
	i32.const	$push62=, 5
	i32.eq  	$push63=, $pop61, $pop62
	br_if   	$pop63, 6       # 6: down to label1
# BB#11:                                # %if.then26
	call    	abort@FUNCTION
	unreachable
.LBB0_12:                               # %sw.bb28
	end_block                       # label7:
	i32.const	$push46=, 0
	i32.load	$push47=, stdout($pop46)
	i32.const	$push49=, .L.str.4
	i32.load	$push48=, 12($4)
	i32.call	$discard=, vfprintf@FUNCTION, $pop47, $pop49, $pop48
	i32.const	$push109=, 0
	i32.load	$push50=, stdout($pop109)
	i32.const	$push108=, .L.str.4
	i32.load	$push51=, 8($4)
	i32.call	$push52=, vfprintf@FUNCTION, $pop50, $pop108, $pop51
	i32.const	$push53=, 6
	i32.eq  	$push54=, $pop52, $pop53
	br_if   	$pop54, 5       # 5: down to label1
# BB#13:                                # %if.then32
	call    	abort@FUNCTION
	unreachable
.LBB0_14:                               # %sw.bb34
	end_block                       # label6:
	i32.const	$push37=, 0
	i32.load	$push38=, stdout($pop37)
	i32.const	$push40=, .L.str.4
	i32.load	$push39=, 12($4)
	i32.call	$discard=, vfprintf@FUNCTION, $pop38, $pop40, $pop39
	i32.const	$push111=, 0
	i32.load	$push41=, stdout($pop111)
	i32.const	$push110=, .L.str.4
	i32.load	$push42=, 8($4)
	i32.call	$push43=, vfprintf@FUNCTION, $pop41, $pop110, $pop42
	i32.const	$push44=, 1
	i32.eq  	$push45=, $pop43, $pop44
	br_if   	$pop45, 4       # 4: down to label1
# BB#15:                                # %if.then38
	call    	abort@FUNCTION
	unreachable
.LBB0_16:                               # %sw.bb40
	end_block                       # label5:
	i32.const	$push30=, 0
	i32.load	$push31=, stdout($pop30)
	i32.const	$push33=, .L.str.4
	i32.load	$push32=, 12($4)
	i32.call	$discard=, vfprintf@FUNCTION, $pop31, $pop33, $pop32
	i32.const	$push113=, 0
	i32.load	$push34=, stdout($pop113)
	i32.const	$push112=, .L.str.4
	i32.load	$push35=, 8($4)
	i32.call	$push36=, vfprintf@FUNCTION, $pop34, $pop112, $pop35
	i32.const	$push122=, 0
	i32.eq  	$push123=, $pop36, $pop122
	br_if   	$pop123, 3      # 3: down to label1
# BB#17:                                # %if.then44
	call    	abort@FUNCTION
	unreachable
.LBB0_18:                               # %sw.bb46
	end_block                       # label4:
	i32.const	$push21=, 0
	i32.load	$push22=, stdout($pop21)
	i32.const	$push24=, .L.str.5
	i32.load	$push23=, 12($4)
	i32.call	$discard=, vfprintf@FUNCTION, $pop22, $pop24, $pop23
	i32.const	$push115=, 0
	i32.load	$push25=, stdout($pop115)
	i32.const	$push114=, .L.str.5
	i32.load	$push26=, 8($4)
	i32.call	$push27=, vfprintf@FUNCTION, $pop25, $pop114, $pop26
	i32.const	$push28=, 1
	i32.eq  	$push29=, $pop27, $pop28
	br_if   	$pop29, 2       # 2: down to label1
# BB#19:                                # %if.then50
	call    	abort@FUNCTION
	unreachable
.LBB0_20:                               # %sw.bb52
	end_block                       # label3:
	i32.const	$push12=, 0
	i32.load	$push13=, stdout($pop12)
	i32.const	$push15=, .L.str.6
	i32.load	$push14=, 12($4)
	i32.call	$discard=, vfprintf@FUNCTION, $pop13, $pop15, $pop14
	i32.const	$push117=, 0
	i32.load	$push16=, stdout($pop117)
	i32.const	$push116=, .L.str.6
	i32.load	$push17=, 8($4)
	i32.call	$push18=, vfprintf@FUNCTION, $pop16, $pop116, $pop17
	i32.const	$push19=, 7
	i32.eq  	$push20=, $pop18, $pop19
	br_if   	$pop20, 1       # 1: down to label1
# BB#21:                                # %if.then56
	call    	abort@FUNCTION
	unreachable
.LBB0_22:                               # %sw.bb58
	end_block                       # label2:
	i32.const	$push3=, 0
	i32.load	$push4=, stdout($pop3)
	i32.const	$push6=, .L.str.7
	i32.load	$push5=, 12($4)
	i32.call	$discard=, vfprintf@FUNCTION, $pop4, $pop6, $pop5
	i32.const	$push119=, 0
	i32.load	$push7=, stdout($pop119)
	i32.const	$push118=, .L.str.7
	i32.load	$push8=, 8($4)
	i32.call	$push9=, vfprintf@FUNCTION, $pop7, $pop118, $pop8
	i32.const	$push10=, 2
	i32.eq  	$push11=, $pop9, $pop10
	br_if   	$pop11, 0       # 0: down to label1
# BB#23:                                # %if.then62
	call    	abort@FUNCTION
	unreachable
.LBB0_24:                               # %sw.epilog
	end_block                       # label1:
	i32.const	$3=, 16
	i32.add 	$4=, $5, $3
	i32.const	$3=, __stack_pointer
	i32.store	$4=, 0($3), $4
	return
.LBB0_25:                               # %sw.default
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	inner, .Lfunc_end0-inner

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$29=, __stack_pointer
	i32.load	$29=, 0($29)
	i32.const	$30=, 16
	i32.sub 	$32=, $29, $30
	i32.const	$30=, __stack_pointer
	i32.store	$32=, 0($30), $32
	i32.const	$push0=, 0
	call    	inner@FUNCTION, $pop0
	i32.const	$push1=, 1
	call    	inner@FUNCTION, $pop1
	i32.const	$push2=, 2
	call    	inner@FUNCTION, $pop2
	i32.const	$push3=, 3
	call    	inner@FUNCTION, $pop3
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 4
	i32.sub 	$32=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$32=, 0($2), $32
	i32.const	$push4=, .L.str
	i32.store	$discard=, 0($32), $pop4
	i32.const	$push5=, 4
	call    	inner@FUNCTION, $pop5
	i32.const	$3=, __stack_pointer
	i32.load	$3=, 0($3)
	i32.const	$4=, 4
	i32.add 	$32=, $3, $4
	i32.const	$4=, __stack_pointer
	i32.store	$32=, 0($4), $32
	i32.const	$5=, __stack_pointer
	i32.load	$5=, 0($5)
	i32.const	$6=, 4
	i32.sub 	$32=, $5, $6
	i32.const	$6=, __stack_pointer
	i32.store	$32=, 0($6), $32
	i32.const	$push6=, .L.str.1
	i32.store	$0=, 0($32), $pop6
	i32.const	$push7=, 5
	call    	inner@FUNCTION, $pop7
	i32.const	$7=, __stack_pointer
	i32.load	$7=, 0($7)
	i32.const	$8=, 4
	i32.add 	$32=, $7, $8
	i32.const	$8=, __stack_pointer
	i32.store	$32=, 0($8), $32
	i32.const	$9=, __stack_pointer
	i32.load	$9=, 0($9)
	i32.const	$10=, 4
	i32.sub 	$32=, $9, $10
	i32.const	$10=, __stack_pointer
	i32.store	$32=, 0($10), $32
	i32.const	$push8=, .L.str.2
	i32.store	$discard=, 0($32), $pop8
	i32.const	$push9=, 6
	call    	inner@FUNCTION, $pop9
	i32.const	$11=, __stack_pointer
	i32.load	$11=, 0($11)
	i32.const	$12=, 4
	i32.add 	$32=, $11, $12
	i32.const	$12=, __stack_pointer
	i32.store	$32=, 0($12), $32
	i32.const	$13=, __stack_pointer
	i32.load	$13=, 0($13)
	i32.const	$14=, 4
	i32.sub 	$32=, $13, $14
	i32.const	$14=, __stack_pointer
	i32.store	$32=, 0($14), $32
	i32.const	$push10=, .L.str.3
	i32.store	$discard=, 0($32), $pop10
	i32.const	$push11=, 7
	call    	inner@FUNCTION, $pop11
	i32.const	$15=, __stack_pointer
	i32.load	$15=, 0($15)
	i32.const	$16=, 4
	i32.add 	$32=, $15, $16
	i32.const	$16=, __stack_pointer
	i32.store	$32=, 0($16), $32
	i32.const	$17=, __stack_pointer
	i32.load	$17=, 0($17)
	i32.const	$18=, 4
	i32.sub 	$32=, $17, $18
	i32.const	$18=, __stack_pointer
	i32.store	$32=, 0($18), $32
	i32.const	$push12=, 120
	i32.store	$discard=, 0($32), $pop12
	i32.const	$push13=, 8
	call    	inner@FUNCTION, $pop13
	i32.const	$19=, __stack_pointer
	i32.load	$19=, 0($19)
	i32.const	$20=, 4
	i32.add 	$32=, $19, $20
	i32.const	$20=, __stack_pointer
	i32.store	$32=, 0($20), $32
	i32.const	$21=, __stack_pointer
	i32.load	$21=, 0($21)
	i32.const	$22=, 4
	i32.sub 	$32=, $21, $22
	i32.const	$22=, __stack_pointer
	i32.store	$32=, 0($22), $32
	i32.store	$discard=, 0($32), $0
	i32.const	$push14=, 9
	call    	inner@FUNCTION, $pop14
	i32.const	$23=, __stack_pointer
	i32.load	$23=, 0($23)
	i32.const	$24=, 4
	i32.add 	$32=, $23, $24
	i32.const	$24=, __stack_pointer
	i32.store	$32=, 0($24), $32
	i32.const	$25=, __stack_pointer
	i32.load	$25=, 0($25)
	i32.const	$26=, 4
	i32.sub 	$32=, $25, $26
	i32.const	$26=, __stack_pointer
	i32.store	$32=, 0($26), $32
	i32.const	$push16=, 0
	i32.store	$0=, 0($32), $pop16
	i32.const	$push15=, 10
	call    	inner@FUNCTION, $pop15
	i32.const	$27=, __stack_pointer
	i32.load	$27=, 0($27)
	i32.const	$28=, 4
	i32.add 	$32=, $27, $28
	i32.const	$28=, __stack_pointer
	i32.store	$32=, 0($28), $32
	i32.const	$31=, 16
	i32.add 	$32=, $32, $31
	i32.const	$31=, __stack_pointer
	i32.store	$32=, 0($31), $32
	return  	$0
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"hello"
	.size	.L.str, 6

	.type	.L.str.1,@object        # @.str.1
.L.str.1:
	.asciz	"hello\n"
	.size	.L.str.1, 7

	.type	.L.str.2,@object        # @.str.2
.L.str.2:
	.asciz	"a"
	.size	.L.str.2, 2

	.type	.L.str.3,@object        # @.str.3
.L.str.3:
	.skip	1
	.size	.L.str.3, 1

	.type	.L.str.4,@object        # @.str.4
.L.str.4:
	.asciz	"%s"
	.size	.L.str.4, 3

	.type	.L.str.5,@object        # @.str.5
.L.str.5:
	.asciz	"%c"
	.size	.L.str.5, 3

	.type	.L.str.6,@object        # @.str.6
.L.str.6:
	.asciz	"%s\n"
	.size	.L.str.6, 4

	.type	.L.str.7,@object        # @.str.7
.L.str.7:
	.asciz	"%d\n"
	.size	.L.str.7, 4


	.ident	"clang version 3.9.0 "
