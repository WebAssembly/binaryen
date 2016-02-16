	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/980707-1.c"
	.section	.text.buildargv,"ax",@progbits
	.hidden	buildargv
	.globl	buildargv
	.type	buildargv,@function
buildargv:                              # @buildargv
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
.LBB0_1:                                # %while.cond1
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_5 Depth 2
	loop                            # label0:
	block
	i32.load8_u	$push9=, 0($0)
	tee_local	$push8=, $3=, $pop9
	i32.const	$push7=, 32
	i32.ne  	$push0=, $pop8, $pop7
	br_if   	0, $pop0        # 0: down to label2
# BB#2:                                 # %while.body3
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push10=, 1
	i32.add 	$0=, $0, $pop10
	br      	1               # 1: up to label0
.LBB0_3:                                # %while.cond1
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label2:
	copy_local	$2=, $1
	i32.const	$push19=, 0
	i32.eq  	$push20=, $3, $pop19
	br_if   	1, $pop20       # 1: down to label1
# BB#4:                                 # %if.end
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push12=, 2
	i32.shl 	$push1=, $1, $pop12
	i32.store	$discard=, buildargv.arglist($pop1), $0
	i32.const	$push11=, 1
	i32.add 	$2=, $1, $pop11
.LBB0_5:                                # %while.cond7
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label3:
	i32.load8_u	$push14=, 0($0)
	tee_local	$push13=, $3=, $pop14
	i32.const	$push21=, 0
	i32.eq  	$push22=, $pop13, $pop21
	br_if   	3, $pop22       # 3: down to label1
# BB#6:                                 # %while.cond7
                                        #   in Loop: Header=BB0_5 Depth=2
	i32.const	$push15=, 32
	i32.eq  	$push2=, $3, $pop15
	br_if   	1, $pop2        # 1: down to label4
# BB#7:                                 # %while.body14
                                        #   in Loop: Header=BB0_5 Depth=2
	i32.const	$push16=, 1
	i32.add 	$0=, $0, $pop16
	br      	0               # 0: up to label3
.LBB0_8:                                # %if.end21
                                        #   in Loop: Header=BB0_1 Depth=1
	end_loop                        # label4:
	i32.const	$push18=, 0
	i32.store8	$discard=, 0($0), $pop18
	i32.const	$push17=, 1
	i32.add 	$0=, $0, $pop17
	copy_local	$1=, $2
	br      	0               # 0: up to label0
.LBB0_9:                                # %while.end23
	end_loop                        # label1:
	i32.const	$push3=, 2
	i32.shl 	$push4=, $2, $pop3
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
	.local  	i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$4=, __stack_pointer
	i32.load	$4=, 0($4)
	i32.const	$5=, 256
	i32.sub 	$6=, $4, $5
	i32.const	$5=, __stack_pointer
	i32.store	$6=, 0($5), $6
	copy_local	$1=, $6
	i32.const	$push1=, 4
	i32.or  	$push2=, $6, $pop1
	i32.const	$push22=, 0
	i32.load8_u	$push0=, .L.str+4($pop22)
	i32.store8	$discard=, 0($pop2):p2align=2, $pop0
	i32.const	$push21=, 0
	i32.load	$push3=, .L.str($pop21):p2align=0
	i32.store	$discard=, 0($6):p2align=4, $pop3
	i32.const	$0=, 0
.LBB1_1:                                # %while.cond1.i
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB1_5 Depth 2
	loop                            # label5:
	block
	i32.load8_u	$push25=, 0($1)
	tee_local	$push24=, $3=, $pop25
	i32.const	$push23=, 32
	i32.ne  	$push4=, $pop24, $pop23
	br_if   	0, $pop4        # 0: down to label7
# BB#2:                                 # %while.body3.i
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push26=, 1
	i32.add 	$1=, $1, $pop26
	br      	1               # 1: up to label5
.LBB1_3:                                # %while.cond1.i
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label7:
	copy_local	$2=, $0
	i32.const	$push41=, 0
	i32.eq  	$push42=, $3, $pop41
	br_if   	1, $pop42       # 1: down to label6
# BB#4:                                 # %if.end.i
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push28=, 2
	i32.shl 	$push5=, $0, $pop28
	i32.store	$discard=, buildargv.arglist($pop5), $1
	i32.const	$push27=, 1
	i32.add 	$2=, $0, $pop27
.LBB1_5:                                # %while.cond7.i
                                        #   Parent Loop BB1_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label8:
	i32.load8_u	$push31=, 0($1)
	tee_local	$push30=, $0=, $pop31
	i32.const	$push29=, 32
	i32.eq  	$push6=, $pop30, $pop29
	br_if   	1, $pop6        # 1: down to label9
# BB#6:                                 # %while.cond7.i
                                        #   in Loop: Header=BB1_5 Depth=2
	i32.const	$push43=, 0
	i32.eq  	$push44=, $0, $pop43
	br_if   	3, $pop44       # 3: down to label6
# BB#7:                                 # %while.body14.i
                                        #   in Loop: Header=BB1_5 Depth=2
	i32.const	$push32=, 1
	i32.add 	$1=, $1, $pop32
	br      	0               # 0: up to label8
.LBB1_8:                                # %if.end21.i
                                        #   in Loop: Header=BB1_1 Depth=1
	end_loop                        # label9:
	i32.const	$push34=, 0
	i32.store8	$discard=, 0($1), $pop34
	i32.const	$push33=, 1
	i32.add 	$1=, $1, $pop33
	copy_local	$0=, $2
	br      	0               # 0: up to label5
.LBB1_9:                                # %buildargv.exit
	end_loop                        # label6:
	block
	block
	block
	i32.const	$push7=, 2
	i32.shl 	$push8=, $2, $pop7
	i32.const	$push9=, 0
	i32.store	$push10=, buildargv.arglist($pop8), $pop9
	i32.load	$push36=, buildargv.arglist($pop10):p2align=4
	tee_local	$push35=, $1=, $pop36
	i32.load8_u	$push11=, 0($pop35)
	i32.const	$push12=, 97
	i32.ne  	$push13=, $pop11, $pop12
	br_if   	0, $pop13       # 0: down to label12
# BB#10:                                # %if.end37
	i32.load8_u	$push14=, 1($1)
	br_if   	0, $pop14       # 0: down to label12
# BB#11:                                # %cond.true52
	i32.const	$push15=, 0
	i32.load	$push38=, buildargv.arglist+4($pop15)
	tee_local	$push37=, $1=, $pop38
	i32.load8_u	$push16=, 0($pop37)
	i32.const	$push17=, 98
	i32.ne  	$push18=, $pop16, $pop17
	br_if   	1, $pop18       # 1: down to label11
# BB#12:                                # %if.end94
	i32.load8_u	$push19=, 1($1)
	br_if   	1, $pop19       # 1: down to label11
# BB#13:                                # %if.end104
	i32.const	$push39=, 0
	i32.load	$push20=, buildargv.arglist+8($pop39):p2align=3
	br_if   	2, $pop20       # 2: down to label10
# BB#14:                                # %if.end109
	i32.const	$push40=, 0
	call    	exit@FUNCTION, $pop40
	unreachable
.LBB1_15:                               # %if.then42
	end_block                       # label12:
	call    	abort@FUNCTION
	unreachable
.LBB1_16:                               # %if.then103
	end_block                       # label11:
	call    	abort@FUNCTION
	unreachable
.LBB1_17:                               # %if.then108
	end_block                       # label10:
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
