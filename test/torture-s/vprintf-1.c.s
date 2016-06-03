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
	i32.const	$push68=, 0
	i32.const	$push65=, 0
	i32.load	$push66=, __stack_pointer($pop65)
	i32.const	$push67=, 16
	i32.sub 	$push72=, $pop66, $pop67
	i32.store	$push74=, __stack_pointer($pop68), $pop72
	tee_local	$push73=, $2=, $pop74
	i32.store	$push0=, 12($2), $1
	i32.store	$drop=, 8($pop73), $pop0
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
	i32.const	$push60=, .L.str
	i32.load	$push59=, 12($2)
	i32.call	$drop=, vprintf@FUNCTION, $pop60, $pop59
	i32.const	$push75=, .L.str
	i32.load	$push61=, 8($2)
	i32.call	$push62=, vprintf@FUNCTION, $pop75, $pop61
	i32.const	$push63=, 5
	i32.eq  	$push64=, $pop62, $pop63
	br_if   	11, $pop64      # 11: down to label1
# BB#3:                                 # %if.then
	call    	abort@FUNCTION
	unreachable
.LBB0_4:                                # %sw.bb4
	end_block                       # label12:
	i32.const	$push54=, .L.str.1
	i32.load	$push53=, 12($2)
	i32.call	$drop=, vprintf@FUNCTION, $pop54, $pop53
	i32.const	$push76=, .L.str.1
	i32.load	$push55=, 8($2)
	i32.call	$push56=, vprintf@FUNCTION, $pop76, $pop55
	i32.const	$push57=, 6
	i32.eq  	$push58=, $pop56, $pop57
	br_if   	10, $pop58      # 10: down to label1
# BB#5:                                 # %if.then8
	call    	abort@FUNCTION
	unreachable
.LBB0_6:                                # %sw.bb10
	end_block                       # label11:
	i32.const	$push48=, .L.str.2
	i32.load	$push47=, 12($2)
	i32.call	$drop=, vprintf@FUNCTION, $pop48, $pop47
	i32.const	$push77=, .L.str.2
	i32.load	$push49=, 8($2)
	i32.call	$push50=, vprintf@FUNCTION, $pop77, $pop49
	i32.const	$push51=, 1
	i32.eq  	$push52=, $pop50, $pop51
	br_if   	9, $pop52       # 9: down to label1
# BB#7:                                 # %if.then14
	call    	abort@FUNCTION
	unreachable
.LBB0_8:                                # %sw.bb16
	end_block                       # label10:
	i32.const	$push44=, .L.str.3
	i32.load	$push43=, 12($2)
	i32.call	$drop=, vprintf@FUNCTION, $pop44, $pop43
	i32.const	$push78=, .L.str.3
	i32.load	$push45=, 8($2)
	i32.call	$push46=, vprintf@FUNCTION, $pop78, $pop45
	i32.eqz 	$push86=, $pop46
	br_if   	8, $pop86       # 8: down to label1
# BB#9:                                 # %if.then20
	call    	abort@FUNCTION
	unreachable
.LBB0_10:                               # %sw.bb22
	end_block                       # label9:
	i32.const	$push38=, .L.str.4
	i32.load	$push37=, 12($2)
	i32.call	$drop=, vprintf@FUNCTION, $pop38, $pop37
	i32.const	$push79=, .L.str.4
	i32.load	$push39=, 8($2)
	i32.call	$push40=, vprintf@FUNCTION, $pop79, $pop39
	i32.const	$push41=, 5
	i32.eq  	$push42=, $pop40, $pop41
	br_if   	7, $pop42       # 7: down to label1
# BB#11:                                # %if.then26
	call    	abort@FUNCTION
	unreachable
.LBB0_12:                               # %sw.bb28
	end_block                       # label8:
	i32.const	$push32=, .L.str.4
	i32.load	$push31=, 12($2)
	i32.call	$drop=, vprintf@FUNCTION, $pop32, $pop31
	i32.const	$push80=, .L.str.4
	i32.load	$push33=, 8($2)
	i32.call	$push34=, vprintf@FUNCTION, $pop80, $pop33
	i32.const	$push35=, 6
	i32.eq  	$push36=, $pop34, $pop35
	br_if   	6, $pop36       # 6: down to label1
# BB#13:                                # %if.then32
	call    	abort@FUNCTION
	unreachable
.LBB0_14:                               # %sw.bb34
	end_block                       # label7:
	i32.const	$push26=, .L.str.4
	i32.load	$push25=, 12($2)
	i32.call	$drop=, vprintf@FUNCTION, $pop26, $pop25
	i32.const	$push81=, .L.str.4
	i32.load	$push27=, 8($2)
	i32.call	$push28=, vprintf@FUNCTION, $pop81, $pop27
	i32.const	$push29=, 1
	i32.eq  	$push30=, $pop28, $pop29
	br_if   	5, $pop30       # 5: down to label1
# BB#15:                                # %if.then38
	call    	abort@FUNCTION
	unreachable
.LBB0_16:                               # %sw.bb40
	end_block                       # label6:
	i32.const	$push22=, .L.str.4
	i32.load	$push21=, 12($2)
	i32.call	$drop=, vprintf@FUNCTION, $pop22, $pop21
	i32.const	$push82=, .L.str.4
	i32.load	$push23=, 8($2)
	i32.call	$push24=, vprintf@FUNCTION, $pop82, $pop23
	i32.eqz 	$push87=, $pop24
	br_if   	4, $pop87       # 4: down to label1
# BB#17:                                # %if.then44
	call    	abort@FUNCTION
	unreachable
.LBB0_18:                               # %sw.bb52
	end_block                       # label5:
	i32.const	$push10=, .L.str.6
	i32.load	$push9=, 12($2)
	i32.call	$drop=, vprintf@FUNCTION, $pop10, $pop9
	i32.const	$push83=, .L.str.6
	i32.load	$push11=, 8($2)
	i32.call	$push12=, vprintf@FUNCTION, $pop83, $pop11
	i32.const	$push13=, 7
	i32.eq  	$push14=, $pop12, $pop13
	br_if   	3, $pop14       # 3: down to label1
# BB#19:                                # %if.then56
	call    	abort@FUNCTION
	unreachable
.LBB0_20:                               # %sw.bb58
	end_block                       # label4:
	i32.const	$push4=, .L.str.7
	i32.load	$push3=, 12($2)
	i32.call	$drop=, vprintf@FUNCTION, $pop4, $pop3
	i32.const	$push84=, .L.str.7
	i32.load	$push5=, 8($2)
	i32.call	$push6=, vprintf@FUNCTION, $pop84, $pop5
	i32.const	$push7=, 2
	i32.eq  	$push8=, $pop6, $pop7
	br_if   	2, $pop8        # 2: down to label1
.LBB0_21:                               # %sw.default
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB0_22:                               # %sw.bb46
	end_block                       # label2:
	i32.const	$push16=, .L.str.5
	i32.load	$push15=, 12($2)
	i32.call	$drop=, vprintf@FUNCTION, $pop16, $pop15
	i32.const	$push85=, .L.str.5
	i32.load	$push17=, 8($2)
	i32.call	$push18=, vprintf@FUNCTION, $pop85, $pop17
	i32.const	$push19=, 1
	i32.ne  	$push20=, $pop18, $pop19
	br_if   	1, $pop20       # 1: down to label0
.LBB0_23:                               # %sw.epilog
	end_block                       # label1:
	i32.const	$push71=, 0
	i32.const	$push69=, 16
	i32.add 	$push70=, $2, $pop69
	i32.store	$drop=, __stack_pointer($pop71), $pop70
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
	i32.const	$push19=, 0
	i32.const	$push16=, 0
	i32.load	$push17=, __stack_pointer($pop16)
	i32.const	$push18=, 112
	i32.sub 	$push35=, $pop17, $pop18
	i32.store	$1=, __stack_pointer($pop19), $pop35
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
	i32.store	$drop=, 96($1), $pop4
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
	i32.store	$drop=, 64($1), $pop8
	i32.const	$push9=, 6
	i32.const	$push27=, 64
	i32.add 	$push28=, $1, $pop27
	call    	inner@FUNCTION, $pop9, $pop28
	i32.const	$push10=, .L.str.3
	i32.store	$drop=, 48($1), $pop10
	i32.const	$push11=, 7
	i32.const	$push29=, 48
	i32.add 	$push30=, $1, $pop29
	call    	inner@FUNCTION, $pop11, $pop30
	i32.const	$push12=, 120
	i32.store	$drop=, 32($1), $pop12
	i32.const	$push13=, 8
	i32.const	$push31=, 32
	i32.add 	$push32=, $1, $pop31
	call    	inner@FUNCTION, $pop13, $pop32
	i32.store	$drop=, 16($1), $0
	i32.const	$push14=, 9
	i32.const	$push33=, 16
	i32.add 	$push34=, $1, $pop33
	call    	inner@FUNCTION, $pop14, $pop34
	i32.const	$push36=, 0
	i32.store	$0=, 0($1), $pop36
	i32.const	$push15=, 10
	call    	inner@FUNCTION, $pop15, $1
	i32.const	$push22=, 0
	i32.const	$push20=, 112
	i32.add 	$push21=, $1, $pop20
	i32.store	$drop=, __stack_pointer($pop22), $pop21
	copy_local	$push41=, $0
                                        # fallthrough-return: $pop41
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
	.functype	vprintf, i32, i32, i32
	.functype	abort, void
