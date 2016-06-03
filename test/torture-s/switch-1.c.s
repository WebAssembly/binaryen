	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/switch-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	block
	i32.const	$push0=, -4
	i32.add 	$push8=, $0, $pop0
	tee_local	$push7=, $0=, $pop8
	i32.const	$push1=, 7
	i32.gt_u	$push2=, $pop7, $pop1
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %switch.lookup
	i32.const	$push4=, 2
	i32.shl 	$push5=, $0, $pop4
	i32.load	$push6=, .Lswitch.table($pop5)
	return  	$pop6
.LBB0_2:                                # %return
	end_block                       # label0:
	i32.const	$push3=, 31
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, -1
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block
	block
	block
	block
	block
	loop                            # label6:
	i32.const	$3=, 31
	block
	i32.const	$push14=, -4
	i32.add 	$push13=, $1, $pop14
	tee_local	$push12=, $2=, $pop13
	i32.const	$push11=, 7
	i32.gt_u	$push10=, $pop12, $pop11
	tee_local	$push9=, $4=, $pop10
	br_if   	0, $pop9        # 0: down to label8
# BB#2:                                 # %switch.lookup.i
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push15=, 2
	i32.shl 	$push0=, $2, $pop15
	i32.load	$3=, .Lswitch.table($pop0)
.LBB1_3:                                # %foo.exit
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label8:
	block
	block
	block
	block
	block
	br_if   	0, $4           # 0: down to label13
# BB#4:                                 # %foo.exit
                                        #   in Loop: Header=BB1_1 Depth=1
	block
	br_table 	$2, 0, 1, 2, 1, 1, 3, 1, 4, 0 # 0: down to label14
                                        # 1: down to label13
                                        # 2: down to label12
                                        # 3: down to label11
                                        # 4: down to label10
.LBB1_5:                                # %if.then
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label14:
	i32.const	$push16=, 30
	i32.eq  	$push4=, $3, $pop16
	br_if   	4, $pop4        # 4: down to label9
	br      	8               # 8: down to label4
.LBB1_6:                                # %if.else21
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label13:
	i32.const	$push17=, 31
	i32.ne  	$push5=, $3, $pop17
	br_if   	8, $pop5        # 8: down to label3
# BB#7:                                 # %for.inc
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push21=, 1
	i32.add 	$push20=, $1, $pop21
	tee_local	$push19=, $1=, $pop20
	i32.const	$push18=, 66
	i32.lt_s	$push6=, $pop19, $pop18
	br_if   	4, $pop6        # 4: up to label6
	br      	6               # 6: down to label5
.LBB1_8:                                # %if.then5
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label12:
	i32.const	$push22=, 30
	i32.eq  	$push3=, $3, $pop22
	br_if   	2, $pop3        # 2: down to label9
	br      	8               # 8: down to label2
.LBB1_9:                                # %if.then11
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label11:
	i32.const	$push23=, 30
	i32.eq  	$push2=, $3, $pop23
	br_if   	1, $pop2        # 1: down to label9
	br      	8               # 8: down to label1
.LBB1_10:                               # %if.then17
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label10:
	i32.const	$push24=, 30
	i32.ne  	$push1=, $3, $pop24
	br_if   	2, $pop1        # 2: down to label7
.LBB1_11:                               # %for.inc.thread
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label9:
	i32.const	$push8=, 1
	i32.add 	$1=, $1, $pop8
	br      	0               # 0: up to label6
.LBB1_12:                               # %if.then19
	end_loop                        # label7:
	call    	abort@FUNCTION
	unreachable
.LBB1_13:                               # %for.end
	end_block                       # label5:
	i32.const	$push7=, 0
	return  	$pop7
.LBB1_14:                               # %if.then3
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB1_15:                               # %if.then23
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB1_16:                               # %if.then7
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB1_17:                               # %if.then13
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	.Lswitch.table,@object  # @switch.table
	.section	.rodata.cst32,"aM",@progbits,32
	.p2align	4
.Lswitch.table:
	.int32	30                      # 0x1e
	.int32	31                      # 0x1f
	.int32	30                      # 0x1e
	.int32	31                      # 0x1f
	.int32	31                      # 0x1f
	.int32	30                      # 0x1e
	.int32	31                      # 0x1f
	.int32	30                      # 0x1e
	.size	.Lswitch.table, 32


	.ident	"clang version 3.9.0 "
	.functype	abort, void
