	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/vfprintf-1.c"
	.section	.text.inner,"ax",@progbits
	.hidden	inner
	.globl	inner
	.type	inner,@function
inner:                                  # @inner
	.param  	i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push79=, __stack_pointer
	i32.const	$push76=, __stack_pointer
	i32.load	$push77=, 0($pop76)
	i32.const	$push78=, 16
	i32.sub 	$push83=, $pop77, $pop78
	i32.store	$2=, 0($pop79), $pop83
	i32.store	$push0=, 12($2), $1
	i32.store	$discard=, 8($2), $pop0
	block
	block
	block
	block
	i32.const	$push1=, 10
	i32.gt_u	$push2=, $0, $pop1
	br_if   	0, $pop2        # 0: down to label3
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
	br_table 	$0, 0, 1, 2, 3, 4, 5, 6, 7, 11, 8, 9, 0 # 0: down to label13
                                        # 1: down to label12
                                        # 2: down to label11
                                        # 3: down to label10
                                        # 4: down to label9
                                        # 5: down to label8
                                        # 6: down to label7
                                        # 7: down to label6
                                        # 11: down to label2
                                        # 8: down to label5
                                        # 9: down to label4
.LBB0_2:                                # %sw.bb
	end_block                       # label13:
	i32.const	$push69=, 0
	i32.load	$push86=, stdout($pop69)
	tee_local	$push85=, $0=, $pop86
	i32.const	$push71=, .L.str
	i32.load	$push70=, 12($2)
	i32.call	$discard=, vfprintf@FUNCTION, $pop85, $pop71, $pop70
	i32.const	$push84=, .L.str
	i32.load	$push72=, 8($2)
	i32.call	$push73=, vfprintf@FUNCTION, $0, $pop84, $pop72
	i32.const	$push74=, 5
	i32.eq  	$push75=, $pop73, $pop74
	br_if   	11, $pop75      # 11: down to label1
# BB#3:                                 # %if.then
	call    	abort@FUNCTION
	unreachable
.LBB0_4:                                # %sw.bb4
	end_block                       # label12:
	i32.const	$push62=, 0
	i32.load	$push89=, stdout($pop62)
	tee_local	$push88=, $0=, $pop89
	i32.const	$push64=, .L.str.1
	i32.load	$push63=, 12($2)
	i32.call	$discard=, vfprintf@FUNCTION, $pop88, $pop64, $pop63
	i32.const	$push87=, .L.str.1
	i32.load	$push65=, 8($2)
	i32.call	$push66=, vfprintf@FUNCTION, $0, $pop87, $pop65
	i32.const	$push67=, 6
	i32.eq  	$push68=, $pop66, $pop67
	br_if   	10, $pop68      # 10: down to label1
# BB#5:                                 # %if.then8
	call    	abort@FUNCTION
	unreachable
.LBB0_6:                                # %sw.bb10
	end_block                       # label11:
	i32.const	$push55=, 0
	i32.load	$push92=, stdout($pop55)
	tee_local	$push91=, $0=, $pop92
	i32.const	$push57=, .L.str.2
	i32.load	$push56=, 12($2)
	i32.call	$discard=, vfprintf@FUNCTION, $pop91, $pop57, $pop56
	i32.const	$push90=, .L.str.2
	i32.load	$push58=, 8($2)
	i32.call	$push59=, vfprintf@FUNCTION, $0, $pop90, $pop58
	i32.const	$push60=, 1
	i32.eq  	$push61=, $pop59, $pop60
	br_if   	9, $pop61       # 9: down to label1
# BB#7:                                 # %if.then14
	call    	abort@FUNCTION
	unreachable
.LBB0_8:                                # %sw.bb16
	end_block                       # label10:
	i32.const	$push50=, 0
	i32.load	$push95=, stdout($pop50)
	tee_local	$push94=, $0=, $pop95
	i32.const	$push52=, .L.str.3
	i32.load	$push51=, 12($2)
	i32.call	$discard=, vfprintf@FUNCTION, $pop94, $pop52, $pop51
	i32.const	$push93=, .L.str.3
	i32.load	$push53=, 8($2)
	i32.call	$push54=, vfprintf@FUNCTION, $0, $pop93, $pop53
	i32.eqz 	$push117=, $pop54
	br_if   	8, $pop117      # 8: down to label1
# BB#9:                                 # %if.then20
	call    	abort@FUNCTION
	unreachable
.LBB0_10:                               # %sw.bb22
	end_block                       # label9:
	i32.const	$push43=, 0
	i32.load	$push98=, stdout($pop43)
	tee_local	$push97=, $0=, $pop98
	i32.const	$push45=, .L.str.4
	i32.load	$push44=, 12($2)
	i32.call	$discard=, vfprintf@FUNCTION, $pop97, $pop45, $pop44
	i32.const	$push96=, .L.str.4
	i32.load	$push46=, 8($2)
	i32.call	$push47=, vfprintf@FUNCTION, $0, $pop96, $pop46
	i32.const	$push48=, 5
	i32.eq  	$push49=, $pop47, $pop48
	br_if   	7, $pop49       # 7: down to label1
# BB#11:                                # %if.then26
	call    	abort@FUNCTION
	unreachable
.LBB0_12:                               # %sw.bb28
	end_block                       # label8:
	i32.const	$push36=, 0
	i32.load	$push101=, stdout($pop36)
	tee_local	$push100=, $0=, $pop101
	i32.const	$push38=, .L.str.4
	i32.load	$push37=, 12($2)
	i32.call	$discard=, vfprintf@FUNCTION, $pop100, $pop38, $pop37
	i32.const	$push99=, .L.str.4
	i32.load	$push39=, 8($2)
	i32.call	$push40=, vfprintf@FUNCTION, $0, $pop99, $pop39
	i32.const	$push41=, 6
	i32.eq  	$push42=, $pop40, $pop41
	br_if   	6, $pop42       # 6: down to label1
# BB#13:                                # %if.then32
	call    	abort@FUNCTION
	unreachable
.LBB0_14:                               # %sw.bb34
	end_block                       # label7:
	i32.const	$push29=, 0
	i32.load	$push104=, stdout($pop29)
	tee_local	$push103=, $0=, $pop104
	i32.const	$push31=, .L.str.4
	i32.load	$push30=, 12($2)
	i32.call	$discard=, vfprintf@FUNCTION, $pop103, $pop31, $pop30
	i32.const	$push102=, .L.str.4
	i32.load	$push32=, 8($2)
	i32.call	$push33=, vfprintf@FUNCTION, $0, $pop102, $pop32
	i32.const	$push34=, 1
	i32.eq  	$push35=, $pop33, $pop34
	br_if   	5, $pop35       # 5: down to label1
# BB#15:                                # %if.then38
	call    	abort@FUNCTION
	unreachable
.LBB0_16:                               # %sw.bb40
	end_block                       # label6:
	i32.const	$push24=, 0
	i32.load	$push107=, stdout($pop24)
	tee_local	$push106=, $0=, $pop107
	i32.const	$push26=, .L.str.4
	i32.load	$push25=, 12($2)
	i32.call	$discard=, vfprintf@FUNCTION, $pop106, $pop26, $pop25
	i32.const	$push105=, .L.str.4
	i32.load	$push27=, 8($2)
	i32.call	$push28=, vfprintf@FUNCTION, $0, $pop105, $pop27
	i32.eqz 	$push118=, $pop28
	br_if   	4, $pop118      # 4: down to label1
# BB#17:                                # %if.then44
	call    	abort@FUNCTION
	unreachable
.LBB0_18:                               # %sw.bb52
	end_block                       # label5:
	i32.const	$push10=, 0
	i32.load	$push110=, stdout($pop10)
	tee_local	$push109=, $0=, $pop110
	i32.const	$push12=, .L.str.6
	i32.load	$push11=, 12($2)
	i32.call	$discard=, vfprintf@FUNCTION, $pop109, $pop12, $pop11
	i32.const	$push108=, .L.str.6
	i32.load	$push13=, 8($2)
	i32.call	$push14=, vfprintf@FUNCTION, $0, $pop108, $pop13
	i32.const	$push15=, 7
	i32.eq  	$push16=, $pop14, $pop15
	br_if   	3, $pop16       # 3: down to label1
# BB#19:                                # %if.then56
	call    	abort@FUNCTION
	unreachable
.LBB0_20:                               # %sw.bb58
	end_block                       # label4:
	i32.const	$push3=, 0
	i32.load	$push113=, stdout($pop3)
	tee_local	$push112=, $0=, $pop113
	i32.const	$push5=, .L.str.7
	i32.load	$push4=, 12($2)
	i32.call	$discard=, vfprintf@FUNCTION, $pop112, $pop5, $pop4
	i32.const	$push111=, .L.str.7
	i32.load	$push6=, 8($2)
	i32.call	$push7=, vfprintf@FUNCTION, $0, $pop111, $pop6
	i32.const	$push8=, 2
	i32.eq  	$push9=, $pop7, $pop8
	br_if   	2, $pop9        # 2: down to label1
.LBB0_21:                               # %sw.default
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB0_22:                               # %sw.bb46
	end_block                       # label2:
	i32.const	$push17=, 0
	i32.load	$push116=, stdout($pop17)
	tee_local	$push115=, $0=, $pop116
	i32.const	$push19=, .L.str.5
	i32.load	$push18=, 12($2)
	i32.call	$discard=, vfprintf@FUNCTION, $pop115, $pop19, $pop18
	i32.const	$push114=, .L.str.5
	i32.load	$push20=, 8($2)
	i32.call	$push21=, vfprintf@FUNCTION, $0, $pop114, $pop20
	i32.const	$push22=, 1
	i32.ne  	$push23=, $pop21, $pop22
	br_if   	1, $pop23       # 1: down to label0
.LBB0_23:                               # %sw.epilog
	end_block                       # label1:
	i32.const	$push82=, __stack_pointer
	i32.const	$push80=, 16
	i32.add 	$push81=, $2, $pop80
	i32.store	$discard=, 0($pop82), $pop81
	return
.LBB0_24:                               # %if.then50
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
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push19=, __stack_pointer
	i32.const	$push16=, __stack_pointer
	i32.load	$push17=, 0($pop16)
	i32.const	$push18=, 112
	i32.sub 	$push35=, $pop17, $pop18
	i32.store	$1=, 0($pop19), $pop35
	i32.const	$push0=, 0
	i32.const	$push40=, 0
	call    	inner@FUNCTION, $pop0, $pop40
	i32.const	$push1=, 1
	i32.const	$push39=, 0
	call    	inner@FUNCTION, $pop1, $pop39
	i32.const	$push2=, 2
	i32.const	$push38=, 0
	call    	inner@FUNCTION, $pop2, $pop38
	i32.const	$push3=, 3
	i32.const	$push37=, 0
	call    	inner@FUNCTION, $pop3, $pop37
	i32.const	$push4=, .L.str
	i32.store	$discard=, 96($1), $pop4
	i32.const	$push5=, 4
	i32.const	$push23=, 96
	i32.add 	$push24=, $1, $pop23
	call    	inner@FUNCTION, $pop5, $pop24
	i32.const	$push6=, .L.str.1
	i32.store	$0=, 80($1), $pop6
	i32.const	$push7=, 5
	i32.const	$push25=, 80
	i32.add 	$push26=, $1, $pop25
	call    	inner@FUNCTION, $pop7, $pop26
	i32.const	$push8=, .L.str.2
	i32.store	$discard=, 64($1), $pop8
	i32.const	$push9=, 6
	i32.const	$push27=, 64
	i32.add 	$push28=, $1, $pop27
	call    	inner@FUNCTION, $pop9, $pop28
	i32.const	$push10=, .L.str.3
	i32.store	$discard=, 48($1), $pop10
	i32.const	$push11=, 7
	i32.const	$push29=, 48
	i32.add 	$push30=, $1, $pop29
	call    	inner@FUNCTION, $pop11, $pop30
	i32.const	$push12=, 120
	i32.store	$discard=, 32($1), $pop12
	i32.const	$push13=, 8
	i32.const	$push31=, 32
	i32.add 	$push32=, $1, $pop31
	call    	inner@FUNCTION, $pop13, $pop32
	i32.store	$discard=, 16($1), $0
	i32.const	$push14=, 9
	i32.const	$push33=, 16
	i32.add 	$push34=, $1, $pop33
	call    	inner@FUNCTION, $pop14, $pop34
	i32.const	$push36=, 0
	i32.store	$0=, 0($1), $pop36
	i32.const	$push15=, 10
	call    	inner@FUNCTION, $pop15, $1
	i32.const	$push22=, __stack_pointer
	i32.const	$push20=, 112
	i32.add 	$push21=, $1, $pop20
	i32.store	$discard=, 0($pop22), $pop21
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
