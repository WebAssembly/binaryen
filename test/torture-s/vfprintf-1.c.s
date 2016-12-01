	.text
	.file	"/usr/local/google/home/jgravelle/code/wasm/waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/vfprintf-1.c"
	.section	.text.inner,"ax",@progbits
	.hidden	inner
	.globl	inner
	.type	inner,@function
inner:                                  # @inner
	.param  	i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push78=, 0
	i32.const	$push75=, 0
	i32.load	$push76=, __stack_pointer($pop75)
	i32.const	$push77=, 16
	i32.sub 	$push83=, $pop76, $pop77
	tee_local	$push82=, $2=, $pop83
	i32.store	__stack_pointer($pop78), $pop82
	i32.store	12($2), $1
	i32.store	8($2), $1
	block   	
	block   	
	block   	
	block   	
	i32.const	$push0=, 10
	i32.gt_u	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label3
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
	i32.const	$push68=, 0
	i32.load	$push86=, stdout($pop68)
	tee_local	$push85=, $1=, $pop86
	i32.const	$push70=, .L.str
	i32.load	$push69=, 12($2)
	i32.call	$drop=, vfprintf@FUNCTION, $pop85, $pop70, $pop69
	i32.const	$push84=, .L.str
	i32.load	$push71=, 8($2)
	i32.call	$push72=, vfprintf@FUNCTION, $1, $pop84, $pop71
	i32.const	$push73=, 5
	i32.eq  	$push74=, $pop72, $pop73
	br_if   	11, $pop74      # 11: down to label1
# BB#3:                                 # %if.then
	call    	abort@FUNCTION
	unreachable
.LBB0_4:                                # %sw.bb4
	end_block                       # label12:
	i32.const	$push61=, 0
	i32.load	$push89=, stdout($pop61)
	tee_local	$push88=, $1=, $pop89
	i32.const	$push63=, .L.str.1
	i32.load	$push62=, 12($2)
	i32.call	$drop=, vfprintf@FUNCTION, $pop88, $pop63, $pop62
	i32.const	$push87=, .L.str.1
	i32.load	$push64=, 8($2)
	i32.call	$push65=, vfprintf@FUNCTION, $1, $pop87, $pop64
	i32.const	$push66=, 6
	i32.eq  	$push67=, $pop65, $pop66
	br_if   	10, $pop67      # 10: down to label1
# BB#5:                                 # %if.then8
	call    	abort@FUNCTION
	unreachable
.LBB0_6:                                # %sw.bb10
	end_block                       # label11:
	i32.const	$push54=, 0
	i32.load	$push92=, stdout($pop54)
	tee_local	$push91=, $1=, $pop92
	i32.const	$push56=, .L.str.2
	i32.load	$push55=, 12($2)
	i32.call	$drop=, vfprintf@FUNCTION, $pop91, $pop56, $pop55
	i32.const	$push90=, .L.str.2
	i32.load	$push57=, 8($2)
	i32.call	$push58=, vfprintf@FUNCTION, $1, $pop90, $pop57
	i32.const	$push59=, 1
	i32.eq  	$push60=, $pop58, $pop59
	br_if   	9, $pop60       # 9: down to label1
# BB#7:                                 # %if.then14
	call    	abort@FUNCTION
	unreachable
.LBB0_8:                                # %sw.bb16
	end_block                       # label10:
	i32.const	$push49=, 0
	i32.load	$push95=, stdout($pop49)
	tee_local	$push94=, $1=, $pop95
	i32.const	$push51=, .L.str.3
	i32.load	$push50=, 12($2)
	i32.call	$drop=, vfprintf@FUNCTION, $pop94, $pop51, $pop50
	i32.const	$push93=, .L.str.3
	i32.load	$push52=, 8($2)
	i32.call	$push53=, vfprintf@FUNCTION, $1, $pop93, $pop52
	i32.eqz 	$push117=, $pop53
	br_if   	8, $pop117      # 8: down to label1
# BB#9:                                 # %if.then20
	call    	abort@FUNCTION
	unreachable
.LBB0_10:                               # %sw.bb22
	end_block                       # label9:
	i32.const	$push42=, 0
	i32.load	$push98=, stdout($pop42)
	tee_local	$push97=, $1=, $pop98
	i32.const	$push44=, .L.str.4
	i32.load	$push43=, 12($2)
	i32.call	$drop=, vfprintf@FUNCTION, $pop97, $pop44, $pop43
	i32.const	$push96=, .L.str.4
	i32.load	$push45=, 8($2)
	i32.call	$push46=, vfprintf@FUNCTION, $1, $pop96, $pop45
	i32.const	$push47=, 5
	i32.eq  	$push48=, $pop46, $pop47
	br_if   	7, $pop48       # 7: down to label1
# BB#11:                                # %if.then26
	call    	abort@FUNCTION
	unreachable
.LBB0_12:                               # %sw.bb28
	end_block                       # label8:
	i32.const	$push35=, 0
	i32.load	$push101=, stdout($pop35)
	tee_local	$push100=, $1=, $pop101
	i32.const	$push37=, .L.str.4
	i32.load	$push36=, 12($2)
	i32.call	$drop=, vfprintf@FUNCTION, $pop100, $pop37, $pop36
	i32.const	$push99=, .L.str.4
	i32.load	$push38=, 8($2)
	i32.call	$push39=, vfprintf@FUNCTION, $1, $pop99, $pop38
	i32.const	$push40=, 6
	i32.eq  	$push41=, $pop39, $pop40
	br_if   	6, $pop41       # 6: down to label1
# BB#13:                                # %if.then32
	call    	abort@FUNCTION
	unreachable
.LBB0_14:                               # %sw.bb34
	end_block                       # label7:
	i32.const	$push28=, 0
	i32.load	$push104=, stdout($pop28)
	tee_local	$push103=, $1=, $pop104
	i32.const	$push30=, .L.str.4
	i32.load	$push29=, 12($2)
	i32.call	$drop=, vfprintf@FUNCTION, $pop103, $pop30, $pop29
	i32.const	$push102=, .L.str.4
	i32.load	$push31=, 8($2)
	i32.call	$push32=, vfprintf@FUNCTION, $1, $pop102, $pop31
	i32.const	$push33=, 1
	i32.eq  	$push34=, $pop32, $pop33
	br_if   	5, $pop34       # 5: down to label1
# BB#15:                                # %if.then38
	call    	abort@FUNCTION
	unreachable
.LBB0_16:                               # %sw.bb40
	end_block                       # label6:
	i32.const	$push23=, 0
	i32.load	$push107=, stdout($pop23)
	tee_local	$push106=, $1=, $pop107
	i32.const	$push25=, .L.str.4
	i32.load	$push24=, 12($2)
	i32.call	$drop=, vfprintf@FUNCTION, $pop106, $pop25, $pop24
	i32.const	$push105=, .L.str.4
	i32.load	$push26=, 8($2)
	i32.call	$push27=, vfprintf@FUNCTION, $1, $pop105, $pop26
	i32.eqz 	$push118=, $pop27
	br_if   	4, $pop118      # 4: down to label1
# BB#17:                                # %if.then44
	call    	abort@FUNCTION
	unreachable
.LBB0_18:                               # %sw.bb52
	end_block                       # label5:
	i32.const	$push9=, 0
	i32.load	$push110=, stdout($pop9)
	tee_local	$push109=, $1=, $pop110
	i32.const	$push11=, .L.str.6
	i32.load	$push10=, 12($2)
	i32.call	$drop=, vfprintf@FUNCTION, $pop109, $pop11, $pop10
	i32.const	$push108=, .L.str.6
	i32.load	$push12=, 8($2)
	i32.call	$push13=, vfprintf@FUNCTION, $1, $pop108, $pop12
	i32.const	$push14=, 7
	i32.eq  	$push15=, $pop13, $pop14
	br_if   	3, $pop15       # 3: down to label1
# BB#19:                                # %if.then56
	call    	abort@FUNCTION
	unreachable
.LBB0_20:                               # %sw.bb58
	end_block                       # label4:
	i32.const	$push2=, 0
	i32.load	$push113=, stdout($pop2)
	tee_local	$push112=, $1=, $pop113
	i32.const	$push4=, .L.str.7
	i32.load	$push3=, 12($2)
	i32.call	$drop=, vfprintf@FUNCTION, $pop112, $pop4, $pop3
	i32.const	$push111=, .L.str.7
	i32.load	$push5=, 8($2)
	i32.call	$push6=, vfprintf@FUNCTION, $1, $pop111, $pop5
	i32.const	$push7=, 2
	i32.eq  	$push8=, $pop6, $pop7
	br_if   	2, $pop8        # 2: down to label1
.LBB0_21:                               # %sw.default
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB0_22:                               # %sw.bb46
	end_block                       # label2:
	i32.const	$push16=, 0
	i32.load	$push116=, stdout($pop16)
	tee_local	$push115=, $1=, $pop116
	i32.const	$push18=, .L.str.5
	i32.load	$push17=, 12($2)
	i32.call	$drop=, vfprintf@FUNCTION, $pop115, $pop18, $pop17
	i32.const	$push114=, .L.str.5
	i32.load	$push19=, 8($2)
	i32.call	$push20=, vfprintf@FUNCTION, $1, $pop114, $pop19
	i32.const	$push21=, 1
	i32.ne  	$push22=, $pop20, $pop21
	br_if   	1, $pop22       # 1: down to label0
.LBB0_23:                               # %sw.epilog
	end_block                       # label1:
	i32.const	$push81=, 0
	i32.const	$push79=, 16
	i32.add 	$push80=, $2, $pop79
	i32.store	__stack_pointer($pop81), $pop80
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
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push19=, 0
	i32.const	$push16=, 0
	i32.load	$push17=, __stack_pointer($pop16)
	i32.const	$push18=, 112
	i32.sub 	$push43=, $pop17, $pop18
	tee_local	$push42=, $0=, $pop43
	i32.store	__stack_pointer($pop19), $pop42
	i32.const	$push0=, 0
	i32.const	$push41=, 0
	call    	inner@FUNCTION, $pop0, $pop41
	i32.const	$push1=, 1
	i32.const	$push40=, 0
	call    	inner@FUNCTION, $pop1, $pop40
	i32.const	$push2=, 2
	i32.const	$push39=, 0
	call    	inner@FUNCTION, $pop2, $pop39
	i32.const	$push3=, 3
	i32.const	$push38=, 0
	call    	inner@FUNCTION, $pop3, $pop38
	i32.const	$push4=, .L.str
	i32.store	96($0), $pop4
	i32.const	$push5=, 4
	i32.const	$push23=, 96
	i32.add 	$push24=, $0, $pop23
	call    	inner@FUNCTION, $pop5, $pop24
	i32.const	$push6=, .L.str.1
	i32.store	80($0), $pop6
	i32.const	$push7=, 5
	i32.const	$push25=, 80
	i32.add 	$push26=, $0, $pop25
	call    	inner@FUNCTION, $pop7, $pop26
	i32.const	$push8=, .L.str.2
	i32.store	64($0), $pop8
	i32.const	$push9=, 6
	i32.const	$push27=, 64
	i32.add 	$push28=, $0, $pop27
	call    	inner@FUNCTION, $pop9, $pop28
	i32.const	$push10=, .L.str.3
	i32.store	48($0), $pop10
	i32.const	$push11=, 7
	i32.const	$push29=, 48
	i32.add 	$push30=, $0, $pop29
	call    	inner@FUNCTION, $pop11, $pop30
	i32.const	$push12=, 120
	i32.store	32($0), $pop12
	i32.const	$push13=, 8
	i32.const	$push31=, 32
	i32.add 	$push32=, $0, $pop31
	call    	inner@FUNCTION, $pop13, $pop32
	i32.const	$push37=, .L.str.1
	i32.store	16($0), $pop37
	i32.const	$push14=, 9
	i32.const	$push33=, 16
	i32.add 	$push34=, $0, $pop33
	call    	inner@FUNCTION, $pop14, $pop34
	i32.const	$push36=, 0
	i32.store	0($0), $pop36
	i32.const	$push15=, 10
	call    	inner@FUNCTION, $pop15, $0
	i32.const	$push22=, 0
	i32.const	$push20=, 112
	i32.add 	$push21=, $0, $pop20
	i32.store	__stack_pointer($pop22), $pop21
	i32.const	$push35=, 0
                                        # fallthrough-return: $pop35
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


	.ident	"clang version 4.0.0 "
	.functype	vfprintf, i32, i32, i32, i32
	.functype	abort, void
	.import_global	stdout
