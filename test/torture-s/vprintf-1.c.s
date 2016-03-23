	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/vprintf-1.c"
	.section	.text.inner,"ax",@progbits
	.hidden	inner
	.globl	inner
	.type	inner,@function
inner:                                  # @inner
	.param  	i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push120=, __stack_pointer
	i32.load	$push121=, 0($pop120)
	i32.const	$push122=, 16
	i32.sub 	$2=, $pop121, $pop122
	i32.const	$push123=, __stack_pointer
	i32.store	$discard=, 0($pop123), $2
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
	i32.const	$push90=, 0
	i32.load	$push91=, stdout($pop90)
	i32.const	$push92=, .L.str
	i32.load	$push89=, 12($2)
	i32.call	$discard=, vfprintf@FUNCTION, $pop91, $pop92, $pop89
	i32.const	$push99=, 0
	i32.load	$push94=, stdout($pop99)
	i32.const	$push98=, .L.str
	i32.load	$push93=, 8($2)
	i32.call	$push95=, vfprintf@FUNCTION, $pop94, $pop98, $pop93
	i32.const	$push96=, 5
	i32.eq  	$push97=, $pop95, $pop96
	br_if   	11, $pop97      # 11: down to label1
# BB#3:                                 # %if.then
	call    	abort@FUNCTION
	unreachable
.LBB0_4:                                # %sw.bb4
	end_block                       # label12:
	i32.const	$push81=, 0
	i32.load	$push82=, stdout($pop81)
	i32.const	$push83=, .L.str.1
	i32.load	$push80=, 12($2)
	i32.call	$discard=, vfprintf@FUNCTION, $pop82, $pop83, $pop80
	i32.const	$push101=, 0
	i32.load	$push85=, stdout($pop101)
	i32.const	$push100=, .L.str.1
	i32.load	$push84=, 8($2)
	i32.call	$push86=, vfprintf@FUNCTION, $pop85, $pop100, $pop84
	i32.const	$push87=, 6
	i32.eq  	$push88=, $pop86, $pop87
	br_if   	10, $pop88      # 10: down to label1
# BB#5:                                 # %if.then8
	call    	abort@FUNCTION
	unreachable
.LBB0_6:                                # %sw.bb10
	end_block                       # label11:
	i32.const	$push72=, 0
	i32.load	$push73=, stdout($pop72)
	i32.const	$push74=, .L.str.2
	i32.load	$push71=, 12($2)
	i32.call	$discard=, vfprintf@FUNCTION, $pop73, $pop74, $pop71
	i32.const	$push103=, 0
	i32.load	$push76=, stdout($pop103)
	i32.const	$push102=, .L.str.2
	i32.load	$push75=, 8($2)
	i32.call	$push77=, vfprintf@FUNCTION, $pop76, $pop102, $pop75
	i32.const	$push78=, 1
	i32.eq  	$push79=, $pop77, $pop78
	br_if   	9, $pop79       # 9: down to label1
# BB#7:                                 # %if.then14
	call    	abort@FUNCTION
	unreachable
.LBB0_8:                                # %sw.bb16
	end_block                       # label10:
	i32.const	$push65=, 0
	i32.load	$push66=, stdout($pop65)
	i32.const	$push67=, .L.str.3
	i32.load	$push64=, 12($2)
	i32.call	$discard=, vfprintf@FUNCTION, $pop66, $pop67, $pop64
	i32.const	$push105=, 0
	i32.load	$push69=, stdout($pop105)
	i32.const	$push104=, .L.str.3
	i32.load	$push68=, 8($2)
	i32.call	$push70=, vfprintf@FUNCTION, $pop69, $pop104, $pop68
	i32.const	$push127=, 0
	i32.eq  	$push128=, $pop70, $pop127
	br_if   	8, $pop128      # 8: down to label1
# BB#9:                                 # %if.then20
	call    	abort@FUNCTION
	unreachable
.LBB0_10:                               # %sw.bb22
	end_block                       # label9:
	i32.const	$push56=, 0
	i32.load	$push57=, stdout($pop56)
	i32.const	$push58=, .L.str.4
	i32.load	$push55=, 12($2)
	i32.call	$discard=, vfprintf@FUNCTION, $pop57, $pop58, $pop55
	i32.const	$push107=, 0
	i32.load	$push60=, stdout($pop107)
	i32.const	$push106=, .L.str.4
	i32.load	$push59=, 8($2)
	i32.call	$push61=, vfprintf@FUNCTION, $pop60, $pop106, $pop59
	i32.const	$push62=, 5
	i32.eq  	$push63=, $pop61, $pop62
	br_if   	7, $pop63       # 7: down to label1
# BB#11:                                # %if.then26
	call    	abort@FUNCTION
	unreachable
.LBB0_12:                               # %sw.bb28
	end_block                       # label8:
	i32.const	$push47=, 0
	i32.load	$push48=, stdout($pop47)
	i32.const	$push49=, .L.str.4
	i32.load	$push46=, 12($2)
	i32.call	$discard=, vfprintf@FUNCTION, $pop48, $pop49, $pop46
	i32.const	$push109=, 0
	i32.load	$push51=, stdout($pop109)
	i32.const	$push108=, .L.str.4
	i32.load	$push50=, 8($2)
	i32.call	$push52=, vfprintf@FUNCTION, $pop51, $pop108, $pop50
	i32.const	$push53=, 6
	i32.eq  	$push54=, $pop52, $pop53
	br_if   	6, $pop54       # 6: down to label1
# BB#13:                                # %if.then32
	call    	abort@FUNCTION
	unreachable
.LBB0_14:                               # %sw.bb34
	end_block                       # label7:
	i32.const	$push38=, 0
	i32.load	$push39=, stdout($pop38)
	i32.const	$push40=, .L.str.4
	i32.load	$push37=, 12($2)
	i32.call	$discard=, vfprintf@FUNCTION, $pop39, $pop40, $pop37
	i32.const	$push111=, 0
	i32.load	$push42=, stdout($pop111)
	i32.const	$push110=, .L.str.4
	i32.load	$push41=, 8($2)
	i32.call	$push43=, vfprintf@FUNCTION, $pop42, $pop110, $pop41
	i32.const	$push44=, 1
	i32.eq  	$push45=, $pop43, $pop44
	br_if   	5, $pop45       # 5: down to label1
# BB#15:                                # %if.then38
	call    	abort@FUNCTION
	unreachable
.LBB0_16:                               # %sw.bb40
	end_block                       # label6:
	i32.const	$push31=, 0
	i32.load	$push32=, stdout($pop31)
	i32.const	$push33=, .L.str.4
	i32.load	$push30=, 12($2)
	i32.call	$discard=, vfprintf@FUNCTION, $pop32, $pop33, $pop30
	i32.const	$push113=, 0
	i32.load	$push35=, stdout($pop113)
	i32.const	$push112=, .L.str.4
	i32.load	$push34=, 8($2)
	i32.call	$push36=, vfprintf@FUNCTION, $pop35, $pop112, $pop34
	i32.const	$push129=, 0
	i32.eq  	$push130=, $pop36, $pop129
	br_if   	4, $pop130      # 4: down to label1
# BB#17:                                # %if.then44
	call    	abort@FUNCTION
	unreachable
.LBB0_18:                               # %sw.bb52
	end_block                       # label5:
	i32.const	$push13=, 0
	i32.load	$push14=, stdout($pop13)
	i32.const	$push15=, .L.str.6
	i32.load	$push12=, 12($2)
	i32.call	$discard=, vfprintf@FUNCTION, $pop14, $pop15, $pop12
	i32.const	$push117=, 0
	i32.load	$push17=, stdout($pop117)
	i32.const	$push116=, .L.str.6
	i32.load	$push16=, 8($2)
	i32.call	$push18=, vfprintf@FUNCTION, $pop17, $pop116, $pop16
	i32.const	$push19=, 7
	i32.eq  	$push20=, $pop18, $pop19
	br_if   	3, $pop20       # 3: down to label1
# BB#19:                                # %if.then56
	call    	abort@FUNCTION
	unreachable
.LBB0_20:                               # %sw.bb58
	end_block                       # label4:
	i32.const	$push4=, 0
	i32.load	$push5=, stdout($pop4)
	i32.const	$push6=, .L.str.7
	i32.load	$push3=, 12($2)
	i32.call	$discard=, vfprintf@FUNCTION, $pop5, $pop6, $pop3
	i32.const	$push119=, 0
	i32.load	$push8=, stdout($pop119)
	i32.const	$push118=, .L.str.7
	i32.load	$push7=, 8($2)
	i32.call	$push9=, vfprintf@FUNCTION, $pop8, $pop118, $pop7
	i32.const	$push10=, 2
	i32.eq  	$push11=, $pop9, $pop10
	br_if   	2, $pop11       # 2: down to label1
.LBB0_21:                               # %sw.default
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB0_22:                               # %sw.bb46
	end_block                       # label2:
	i32.const	$push22=, 0
	i32.load	$push23=, stdout($pop22)
	i32.const	$push24=, .L.str.5
	i32.load	$push21=, 12($2)
	i32.call	$discard=, vfprintf@FUNCTION, $pop23, $pop24, $pop21
	i32.const	$push115=, 0
	i32.load	$push26=, stdout($pop115)
	i32.const	$push114=, .L.str.5
	i32.load	$push25=, 8($2)
	i32.call	$push27=, vfprintf@FUNCTION, $pop26, $pop114, $pop25
	i32.const	$push28=, 1
	i32.ne  	$push29=, $pop27, $pop28
	br_if   	1, $pop29       # 1: down to label0
.LBB0_23:                               # %sw.epilog
	end_block                       # label1:
	i32.const	$push126=, __stack_pointer
	i32.const	$push124=, 16
	i32.add 	$push125=, $2, $pop124
	i32.store	$discard=, 0($pop126), $pop125
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
	i32.const	$push21=, __stack_pointer
	i32.load	$push22=, 0($pop21)
	i32.const	$push23=, 112
	i32.sub 	$1=, $pop22, $pop23
	i32.const	$push24=, __stack_pointer
	i32.store	$discard=, 0($pop24), $1
	i32.const	$push0=, 0
	i32.const	$push20=, 0
	call    	inner@FUNCTION, $pop0, $pop20
	i32.const	$push1=, 1
	i32.const	$push19=, 0
	call    	inner@FUNCTION, $pop1, $pop19
	i32.const	$push2=, 2
	i32.const	$push18=, 0
	call    	inner@FUNCTION, $pop2, $pop18
	i32.const	$push3=, 3
	i32.const	$push17=, 0
	call    	inner@FUNCTION, $pop3, $pop17
	i32.const	$push4=, .L.str
	i32.store	$discard=, 96($1):p2align=4, $pop4
	i32.const	$push5=, 4
	i32.const	$push28=, 96
	i32.add 	$push29=, $1, $pop28
	call    	inner@FUNCTION, $pop5, $pop29
	i32.const	$push6=, .L.str.1
	i32.store	$0=, 80($1):p2align=4, $pop6
	i32.const	$push7=, 5
	i32.const	$push30=, 80
	i32.add 	$push31=, $1, $pop30
	call    	inner@FUNCTION, $pop7, $pop31
	i32.const	$push8=, .L.str.2
	i32.store	$discard=, 64($1):p2align=4, $pop8
	i32.const	$push9=, 6
	i32.const	$push32=, 64
	i32.add 	$push33=, $1, $pop32
	call    	inner@FUNCTION, $pop9, $pop33
	i32.const	$push10=, .L.str.3
	i32.store	$discard=, 48($1):p2align=4, $pop10
	i32.const	$push11=, 7
	i32.const	$push34=, 48
	i32.add 	$push35=, $1, $pop34
	call    	inner@FUNCTION, $pop11, $pop35
	i32.const	$push12=, 120
	i32.store	$discard=, 32($1):p2align=4, $pop12
	i32.const	$push13=, 8
	i32.const	$push36=, 32
	i32.add 	$push37=, $1, $pop36
	call    	inner@FUNCTION, $pop13, $pop37
	i32.store	$discard=, 16($1):p2align=4, $0
	i32.const	$push14=, 9
	i32.const	$push38=, 16
	i32.add 	$push39=, $1, $pop38
	call    	inner@FUNCTION, $pop14, $pop39
	i32.const	$push16=, 0
	i32.store	$0=, 0($1):p2align=4, $pop16
	i32.const	$push15=, 10
	call    	inner@FUNCTION, $pop15, $1
	i32.const	$push27=, __stack_pointer
	i32.const	$push25=, 112
	i32.add 	$push26=, $1, $pop25
	i32.store	$discard=, 0($pop27), $pop26
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
