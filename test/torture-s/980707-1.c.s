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
	i32.load8_u	$push9=, 0($0)
	tee_local	$push8=, $2=, $pop9
	i32.const	$push7=, 32
	i32.ne  	$push0=, $pop8, $pop7
	br_if   	0, $pop0        # 0: down to label3
# BB#2:                                 # %while.body3
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push10=, 1
	i32.add 	$0=, $0, $pop10
	br      	1               # 1: up to label1
.LBB0_3:                                # %while.cond1
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label3:
	i32.const	$push19=, 0
	i32.eq  	$push20=, $2, $pop19
	br_if   	2, $pop20       # 2: down to label0
# BB#4:                                 # %if.end
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push12=, 2
	i32.shl 	$push1=, $1, $pop12
	i32.store	$discard=, buildargv.arglist($pop1), $0
	i32.const	$push11=, 1
	i32.add 	$1=, $1, $pop11
.LBB0_5:                                # %while.cond7
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label4:
	i32.load8_u	$push14=, 0($0)
	tee_local	$push13=, $2=, $pop14
	i32.const	$push21=, 0
	i32.eq  	$push22=, $pop13, $pop21
	br_if   	3, $pop22       # 3: down to label2
# BB#6:                                 # %while.cond7
                                        #   in Loop: Header=BB0_5 Depth=2
	i32.const	$push15=, 32
	i32.eq  	$push2=, $2, $pop15
	br_if   	1, $pop2        # 1: down to label5
# BB#7:                                 # %while.body14
                                        #   in Loop: Header=BB0_5 Depth=2
	i32.const	$push16=, 1
	i32.add 	$0=, $0, $pop16
	br      	0               # 0: up to label4
.LBB0_8:                                # %if.end21
                                        #   in Loop: Header=BB0_1 Depth=1
	end_loop                        # label5:
	i32.const	$push18=, 0
	i32.store8	$discard=, 0($0), $pop18
	i32.const	$push17=, 1
	i32.add 	$0=, $0, $pop17
	br      	0               # 0: up to label1
.LBB0_9:
	end_loop                        # label2:
.LBB0_10:                               # %while.end23
	end_block                       # label0:
	i32.const	$push3=, 2
	i32.shl 	$push4=, $1, $pop3
	i32.const	$push6=, 0
	i32.store	$discard=, buildargv.arglist($pop4), $pop6
	i32.const	$push5=, buildargv.arglist
	return  	$pop5
	.endfunc
.Lfunc_end0:
	.size	buildargv, .Lfunc_end0-buildargv

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push39=, __stack_pointer
	i32.load	$push40=, 0($pop39)
	i32.const	$push41=, 256
	i32.sub 	$3=, $pop40, $pop41
	i32.const	$push42=, __stack_pointer
	i32.store	$discard=, 0($pop42), $3
	copy_local	$0=, $3
	i32.const	$push20=, 0
	i32.load8_u	$push0=, .L.str+4($pop20)
	i32.store8	$discard=, 4($3):p2align=2, $pop0
	i32.const	$push19=, 0
	i32.load	$push1=, .L.str($pop19):p2align=0
	i32.store	$discard=, 0($3):p2align=4, $pop1
	i32.const	$1=, 0
.LBB1_1:                                # %while.cond1.i
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB1_5 Depth 2
	block
	loop                            # label7:
	block
	i32.load8_u	$push23=, 0($0)
	tee_local	$push22=, $2=, $pop23
	i32.const	$push21=, 32
	i32.ne  	$push2=, $pop22, $pop21
	br_if   	0, $pop2        # 0: down to label9
# BB#2:                                 # %while.body3.i
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push24=, 1
	i32.add 	$0=, $0, $pop24
	br      	1               # 1: up to label7
.LBB1_3:                                # %while.cond1.i
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label9:
	i32.const	$push43=, 0
	i32.eq  	$push44=, $2, $pop43
	br_if   	2, $pop44       # 2: down to label6
# BB#4:                                 # %if.end.i
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push26=, 2
	i32.shl 	$push3=, $1, $pop26
	i32.store	$discard=, buildargv.arglist($pop3), $0
	i32.const	$push25=, 1
	i32.add 	$2=, $1, $pop25
.LBB1_5:                                # %while.cond7.i
                                        #   Parent Loop BB1_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label10:
	i32.load8_u	$push29=, 0($0)
	tee_local	$push28=, $1=, $pop29
	i32.const	$push27=, 32
	i32.eq  	$push4=, $pop28, $pop27
	br_if   	1, $pop4        # 1: down to label11
# BB#6:                                 # %while.cond7.i
                                        #   in Loop: Header=BB1_5 Depth=2
	i32.const	$push45=, 0
	i32.eq  	$push46=, $1, $pop45
	br_if   	3, $pop46       # 3: down to label8
# BB#7:                                 # %while.body14.i
                                        #   in Loop: Header=BB1_5 Depth=2
	i32.const	$push30=, 1
	i32.add 	$0=, $0, $pop30
	br      	0               # 0: up to label10
.LBB1_8:                                # %if.end21.i
                                        #   in Loop: Header=BB1_1 Depth=1
	end_loop                        # label11:
	i32.const	$push32=, 0
	i32.store8	$discard=, 0($0), $pop32
	i32.const	$push31=, 1
	i32.add 	$0=, $0, $pop31
	copy_local	$1=, $2
	br      	0               # 0: up to label7
.LBB1_9:
	end_loop                        # label8:
	copy_local	$1=, $2
.LBB1_10:                               # %buildargv.exit
	end_block                       # label6:
	block
	block
	i32.const	$push5=, 2
	i32.shl 	$push6=, $1, $pop5
	i32.const	$push7=, 0
	i32.store	$push8=, buildargv.arglist($pop6), $pop7
	i32.load	$push34=, buildargv.arglist($pop8):p2align=4
	tee_local	$push33=, $0=, $pop34
	i32.load8_u	$push9=, 0($pop33)
	i32.const	$push10=, 97
	i32.ne  	$push11=, $pop9, $pop10
	br_if   	0, $pop11       # 0: down to label13
# BB#11:                                # %if.end37
	i32.load8_u	$push12=, 1($0)
	br_if   	0, $pop12       # 0: down to label13
# BB#12:                                # %cond.true52
	i32.const	$push13=, 0
	i32.load	$push36=, buildargv.arglist+4($pop13)
	tee_local	$push35=, $0=, $pop36
	i32.load8_u	$push14=, 0($pop35)
	i32.const	$push15=, 98
	i32.ne  	$push16=, $pop14, $pop15
	br_if   	1, $pop16       # 1: down to label12
# BB#13:                                # %if.end94
	i32.load8_u	$push17=, 1($0)
	br_if   	1, $pop17       # 1: down to label12
# BB#14:                                # %if.end104
	i32.const	$push37=, 0
	i32.load	$push18=, buildargv.arglist+8($pop37):p2align=3
	br_if   	1, $pop18       # 1: down to label12
# BB#15:                                # %if.end109
	i32.const	$push38=, 0
	call    	exit@FUNCTION, $pop38
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
