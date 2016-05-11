	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/980707-1.c"
	.section	.text.buildargv,"ax",@progbits
	.hidden	buildargv
	.globl	buildargv
	.type	buildargv,@function
buildargv:                              # @buildargv
	.param  	i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
.LBB0_1:                                # %while.cond1
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_5 Depth 2
	block
	loop                            # label1:
	block
	i32.load8_u	$push11=, 0($0)
	tee_local	$push10=, $2=, $pop11
	i32.const	$push9=, 32
	i32.ne  	$push1=, $pop10, $pop9
	br_if   	0, $pop1        # 0: down to label3
# BB#2:                                 # %while.body3
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push8=, 1
	i32.add 	$0=, $0, $pop8
	br      	1               # 1: up to label1
.LBB0_3:                                # %while.cond1
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label3:
	i32.const	$push20=, 0
	i32.eq  	$push21=, $2, $pop20
	br_if   	2, $pop21       # 2: down to label0
# BB#4:                                 # %if.end
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push13=, 2
	i32.shl 	$push2=, $1, $pop13
	i32.store	$discard=, buildargv.arglist($pop2), $0
	i32.const	$push12=, 1
	i32.add 	$1=, $1, $pop12
.LBB0_5:                                # %while.cond7
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label4:
	i32.load8_u	$push16=, 0($0)
	tee_local	$push15=, $2=, $pop16
	i32.const	$push22=, 0
	i32.eq  	$push23=, $pop15, $pop22
	br_if   	3, $pop23       # 3: down to label2
# BB#6:                                 # %while.cond7
                                        #   in Loop: Header=BB0_5 Depth=2
	i32.const	$push17=, 32
	i32.eq  	$push3=, $2, $pop17
	br_if   	1, $pop3        # 1: down to label5
# BB#7:                                 # %while.body14
                                        #   in Loop: Header=BB0_5 Depth=2
	i32.const	$push14=, 1
	i32.add 	$0=, $0, $pop14
	br      	0               # 0: up to label4
.LBB0_8:                                # %if.end21
                                        #   in Loop: Header=BB0_1 Depth=1
	end_loop                        # label5:
	i32.const	$push19=, 0
	i32.store8	$discard=, 0($0), $pop19
	i32.const	$push18=, 1
	i32.add 	$push0=, $0, $pop18
	copy_local	$0=, $pop0
	copy_local	$1=, $1
	br      	0               # 0: up to label1
.LBB0_9:
	end_loop                        # label2:
	copy_local	$1=, $1
.LBB0_10:                               # %while.end23
	end_block                       # label0:
	i32.const	$push4=, 2
	i32.shl 	$push5=, $1, $pop4
	i32.const	$push7=, 0
	i32.store	$discard=, buildargv.arglist($pop5), $pop7
	i32.const	$push6=, buildargv.arglist
	return  	$pop6
	.endfunc
.Lfunc_end0:
	.size	buildargv, .Lfunc_end0-buildargv

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push23=, __stack_pointer
	i32.const	$push20=, __stack_pointer
	i32.load	$push21=, 0($pop20)
	i32.const	$push22=, 256
	i32.sub 	$push24=, $pop21, $pop22
	i32.store	$push28=, 0($pop23), $pop24
	tee_local	$push27=, $1=, $pop28
	copy_local	$0=, $pop27
	i32.const	$push26=, 0
	i32.load8_u	$push2=, .L.str+4($pop26)
	i32.store8	$discard=, 4($1), $pop2
	i32.const	$push25=, 0
	i32.load	$push3=, .L.str($pop25):p2align=0
	i32.store	$discard=, 0($1), $pop3
	i32.const	$1=, 0
.LBB1_1:                                # %while.cond1.i
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB1_5 Depth 2
	block
	loop                            # label7:
	block
	i32.load8_u	$push32=, 0($0)
	tee_local	$push31=, $2=, $pop32
	i32.const	$push30=, 32
	i32.ne  	$push4=, $pop31, $pop30
	br_if   	0, $pop4        # 0: down to label9
# BB#2:                                 # %while.body3.i
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push29=, 1
	i32.add 	$0=, $0, $pop29
	br      	1               # 1: up to label7
.LBB1_3:                                # %while.cond1.i
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label9:
	i32.const	$push47=, 0
	i32.eq  	$push48=, $2, $pop47
	br_if   	2, $pop48       # 2: down to label6
# BB#4:                                 # %if.end.i
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push34=, 2
	i32.shl 	$push5=, $1, $pop34
	i32.store	$discard=, buildargv.arglist($pop5), $0
	i32.const	$push33=, 1
	i32.add 	$2=, $1, $pop33
.LBB1_5:                                # %while.cond7.i
                                        #   Parent Loop BB1_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label10:
	i32.load8_u	$push38=, 0($0)
	tee_local	$push37=, $1=, $pop38
	i32.const	$push36=, 32
	i32.eq  	$push6=, $pop37, $pop36
	br_if   	1, $pop6        # 1: down to label11
# BB#6:                                 # %while.cond7.i
                                        #   in Loop: Header=BB1_5 Depth=2
	i32.const	$push49=, 0
	i32.eq  	$push50=, $1, $pop49
	br_if   	3, $pop50       # 3: down to label8
# BB#7:                                 # %while.body14.i
                                        #   in Loop: Header=BB1_5 Depth=2
	i32.const	$push35=, 1
	i32.add 	$0=, $0, $pop35
	br      	0               # 0: up to label10
.LBB1_8:                                # %if.end21.i
                                        #   in Loop: Header=BB1_1 Depth=1
	end_loop                        # label11:
	i32.const	$push40=, 0
	i32.store8	$discard=, 0($0), $pop40
	i32.const	$push39=, 1
	i32.add 	$push1=, $0, $pop39
	copy_local	$0=, $pop1
	copy_local	$1=, $2
	br      	0               # 0: up to label7
.LBB1_9:
	end_loop                        # label8:
	copy_local	$1=, $2
.LBB1_10:                               # %buildargv.exit
	end_block                       # label6:
	block
	block
	i32.const	$push7=, 2
	i32.shl 	$push8=, $1, $pop7
	i32.const	$push9=, 0
	i32.store	$push0=, buildargv.arglist($pop8), $pop9
	i32.load	$push42=, buildargv.arglist($pop0)
	tee_local	$push41=, $0=, $pop42
	i32.load8_u	$push10=, 0($pop41)
	i32.const	$push11=, 97
	i32.ne  	$push12=, $pop10, $pop11
	br_if   	0, $pop12       # 0: down to label13
# BB#11:                                # %if.end37
	i32.load8_u	$push13=, 1($0)
	br_if   	0, $pop13       # 0: down to label13
# BB#12:                                # %cond.true52
	i32.const	$push14=, 0
	i32.load	$push44=, buildargv.arglist+4($pop14)
	tee_local	$push43=, $0=, $pop44
	i32.load8_u	$push15=, 0($pop43)
	i32.const	$push16=, 98
	i32.ne  	$push17=, $pop15, $pop16
	br_if   	1, $pop17       # 1: down to label12
# BB#13:                                # %if.end94
	i32.load8_u	$push18=, 1($0)
	br_if   	1, $pop18       # 1: down to label12
# BB#14:                                # %if.end104
	i32.const	$push45=, 0
	i32.load	$push19=, buildargv.arglist+8($pop45)
	br_if   	1, $pop19       # 1: down to label12
# BB#15:                                # %if.end109
	i32.const	$push46=, 0
	call    	exit@FUNCTION, $pop46
	unreachable
.LBB1_16:                               # %if.then42
	end_block                       # label13:
	call    	abort@FUNCTION
	unreachable
.LBB1_17:                               # %if.then108
	end_block                       # label12:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	buildargv.arglist,@object # @buildargv.arglist
	.lcomm	buildargv.arglist,1024,4
	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	" a b"
	.size	.L.str, 5


	.ident	"clang version 3.9.0 "
