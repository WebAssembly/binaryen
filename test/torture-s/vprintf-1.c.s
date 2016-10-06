	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/vprintf-1.c"
	.section	.text.inner,"ax",@progbits
	.hidden	inner
	.globl	inner
	.type	inner,@function
inner:                                  # @inner
	.param  	i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push67=, 0
	i32.const	$push64=, 0
	i32.load	$push65=, __stack_pointer($pop64)
	i32.const	$push66=, 16
	i32.sub 	$push72=, $pop65, $pop66
	tee_local	$push71=, $2=, $pop72
	i32.store	__stack_pointer($pop67), $pop71
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
	i32.const	$push59=, .L.str
	i32.load	$push58=, 12($2)
	i32.call	$drop=, vprintf@FUNCTION, $pop59, $pop58
	i32.const	$push73=, .L.str
	i32.load	$push60=, 8($2)
	i32.call	$push61=, vprintf@FUNCTION, $pop73, $pop60
	i32.const	$push62=, 5
	i32.eq  	$push63=, $pop61, $pop62
	br_if   	11, $pop63      # 11: down to label1
# BB#3:                                 # %if.then
	call    	abort@FUNCTION
	unreachable
.LBB0_4:                                # %sw.bb4
	end_block                       # label12:
	i32.const	$push53=, .L.str.1
	i32.load	$push52=, 12($2)
	i32.call	$drop=, vprintf@FUNCTION, $pop53, $pop52
	i32.const	$push74=, .L.str.1
	i32.load	$push54=, 8($2)
	i32.call	$push55=, vprintf@FUNCTION, $pop74, $pop54
	i32.const	$push56=, 6
	i32.eq  	$push57=, $pop55, $pop56
	br_if   	10, $pop57      # 10: down to label1
# BB#5:                                 # %if.then8
	call    	abort@FUNCTION
	unreachable
.LBB0_6:                                # %sw.bb10
	end_block                       # label11:
	i32.const	$push47=, .L.str.2
	i32.load	$push46=, 12($2)
	i32.call	$drop=, vprintf@FUNCTION, $pop47, $pop46
	i32.const	$push75=, .L.str.2
	i32.load	$push48=, 8($2)
	i32.call	$push49=, vprintf@FUNCTION, $pop75, $pop48
	i32.const	$push50=, 1
	i32.eq  	$push51=, $pop49, $pop50
	br_if   	9, $pop51       # 9: down to label1
# BB#7:                                 # %if.then14
	call    	abort@FUNCTION
	unreachable
.LBB0_8:                                # %sw.bb16
	end_block                       # label10:
	i32.const	$push43=, .L.str.3
	i32.load	$push42=, 12($2)
	i32.call	$drop=, vprintf@FUNCTION, $pop43, $pop42
	i32.const	$push76=, .L.str.3
	i32.load	$push44=, 8($2)
	i32.call	$push45=, vprintf@FUNCTION, $pop76, $pop44
	i32.eqz 	$push84=, $pop45
	br_if   	8, $pop84       # 8: down to label1
# BB#9:                                 # %if.then20
	call    	abort@FUNCTION
	unreachable
.LBB0_10:                               # %sw.bb22
	end_block                       # label9:
	i32.const	$push37=, .L.str.4
	i32.load	$push36=, 12($2)
	i32.call	$drop=, vprintf@FUNCTION, $pop37, $pop36
	i32.const	$push77=, .L.str.4
	i32.load	$push38=, 8($2)
	i32.call	$push39=, vprintf@FUNCTION, $pop77, $pop38
	i32.const	$push40=, 5
	i32.eq  	$push41=, $pop39, $pop40
	br_if   	7, $pop41       # 7: down to label1
# BB#11:                                # %if.then26
	call    	abort@FUNCTION
	unreachable
.LBB0_12:                               # %sw.bb28
	end_block                       # label8:
	i32.const	$push31=, .L.str.4
	i32.load	$push30=, 12($2)
	i32.call	$drop=, vprintf@FUNCTION, $pop31, $pop30
	i32.const	$push78=, .L.str.4
	i32.load	$push32=, 8($2)
	i32.call	$push33=, vprintf@FUNCTION, $pop78, $pop32
	i32.const	$push34=, 6
	i32.eq  	$push35=, $pop33, $pop34
	br_if   	6, $pop35       # 6: down to label1
# BB#13:                                # %if.then32
	call    	abort@FUNCTION
	unreachable
.LBB0_14:                               # %sw.bb34
	end_block                       # label7:
	i32.const	$push25=, .L.str.4
	i32.load	$push24=, 12($2)
	i32.call	$drop=, vprintf@FUNCTION, $pop25, $pop24
	i32.const	$push79=, .L.str.4
	i32.load	$push26=, 8($2)
	i32.call	$push27=, vprintf@FUNCTION, $pop79, $pop26
	i32.const	$push28=, 1
	i32.eq  	$push29=, $pop27, $pop28
	br_if   	5, $pop29       # 5: down to label1
# BB#15:                                # %if.then38
	call    	abort@FUNCTION
	unreachable
.LBB0_16:                               # %sw.bb40
	end_block                       # label6:
	i32.const	$push21=, .L.str.4
	i32.load	$push20=, 12($2)
	i32.call	$drop=, vprintf@FUNCTION, $pop21, $pop20
	i32.const	$push80=, .L.str.4
	i32.load	$push22=, 8($2)
	i32.call	$push23=, vprintf@FUNCTION, $pop80, $pop22
	i32.eqz 	$push85=, $pop23
	br_if   	4, $pop85       # 4: down to label1
# BB#17:                                # %if.then44
	call    	abort@FUNCTION
	unreachable
.LBB0_18:                               # %sw.bb52
	end_block                       # label5:
	i32.const	$push9=, .L.str.6
	i32.load	$push8=, 12($2)
	i32.call	$drop=, vprintf@FUNCTION, $pop9, $pop8
	i32.const	$push81=, .L.str.6
	i32.load	$push10=, 8($2)
	i32.call	$push11=, vprintf@FUNCTION, $pop81, $pop10
	i32.const	$push12=, 7
	i32.eq  	$push13=, $pop11, $pop12
	br_if   	3, $pop13       # 3: down to label1
# BB#19:                                # %if.then56
	call    	abort@FUNCTION
	unreachable
.LBB0_20:                               # %sw.bb58
	end_block                       # label4:
	i32.const	$push3=, .L.str.7
	i32.load	$push2=, 12($2)
	i32.call	$drop=, vprintf@FUNCTION, $pop3, $pop2
	i32.const	$push82=, .L.str.7
	i32.load	$push4=, 8($2)
	i32.call	$push5=, vprintf@FUNCTION, $pop82, $pop4
	i32.const	$push6=, 2
	i32.eq  	$push7=, $pop5, $pop6
	br_if   	2, $pop7        # 2: down to label1
.LBB0_21:                               # %sw.default
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB0_22:                               # %sw.bb46
	end_block                       # label2:
	i32.const	$push15=, .L.str.5
	i32.load	$push14=, 12($2)
	i32.call	$drop=, vprintf@FUNCTION, $pop15, $pop14
	i32.const	$push83=, .L.str.5
	i32.load	$push16=, 8($2)
	i32.call	$push17=, vprintf@FUNCTION, $pop83, $pop16
	i32.const	$push18=, 1
	i32.ne  	$push19=, $pop17, $pop18
	br_if   	1, $pop19       # 1: down to label0
.LBB0_23:                               # %sw.epilog
	end_block                       # label1:
	i32.const	$push70=, 0
	i32.const	$push68=, 16
	i32.add 	$push69=, $2, $pop68
	i32.store	__stack_pointer($pop70), $pop69
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	vprintf, i32, i32, i32
	.functype	abort, void
