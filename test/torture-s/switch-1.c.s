	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/switch-1.c"
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
	i32.add 	$push10=, $0, $pop0
	tee_local	$push9=, $0=, $pop10
	i32.const	$push1=, 7
	i32.gt_u	$push2=, $pop9, $pop1
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %switch.lookup
	i32.const	$push4=, 2
	i32.shl 	$push5=, $0, $pop4
	i32.const	$push6=, .Lswitch.table
	i32.add 	$push7=, $pop5, $pop6
	i32.load	$push8=, 0($pop7)
	return  	$pop8
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
	loop    	                # label6:
	i32.const	$3=, 31
	block   	
	i32.const	$push15=, -4
	i32.add 	$push14=, $1, $pop15
	tee_local	$push13=, $2=, $pop14
	i32.const	$push12=, 7
	i32.gt_u	$push11=, $pop13, $pop12
	tee_local	$push10=, $4=, $pop11
	br_if   	0, $pop10       # 0: down to label7
# BB#2:                                 # %switch.lookup.i
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push17=, 2
	i32.shl 	$push0=, $2, $pop17
	i32.const	$push16=, .Lswitch.table
	i32.add 	$push1=, $pop0, $pop16
	i32.load	$3=, 0($pop1)
.LBB1_3:                                # %foo.exit
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label7:
	block   	
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
	i32.const	$push18=, 30
	i32.eq  	$push5=, $3, $pop18
	br_if   	4, $pop5        # 4: down to label9
	br      	8               # 8: down to label4
.LBB1_6:                                # %if.else21
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label13:
	i32.const	$push19=, 31
	i32.ne  	$push6=, $3, $pop19
	br_if   	8, $pop6        # 8: down to label3
# BB#7:                                 # %for.inc
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push23=, 1
	i32.add 	$push22=, $1, $pop23
	tee_local	$push21=, $1=, $pop22
	i32.const	$push20=, 66
	i32.lt_s	$push7=, $pop21, $pop20
	br_if   	5, $pop7        # 5: up to label6
	br      	6               # 6: down to label5
.LBB1_8:                                # %if.then5
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label12:
	i32.const	$push24=, 30
	i32.eq  	$push4=, $3, $pop24
	br_if   	2, $pop4        # 2: down to label9
	br      	8               # 8: down to label2
.LBB1_9:                                # %if.then11
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label11:
	i32.const	$push25=, 30
	i32.eq  	$push3=, $3, $pop25
	br_if   	1, $pop3        # 1: down to label9
	br      	8               # 8: down to label1
.LBB1_10:                               # %if.then17
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label10:
	i32.const	$push26=, 30
	i32.ne  	$push2=, $3, $pop26
	br_if   	1, $pop2        # 1: down to label8
.LBB1_11:                               # %for.inc.thread
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label9:
	i32.const	$push9=, 1
	i32.add 	$1=, $1, $pop9
	br      	1               # 1: up to label6
.LBB1_12:                               # %if.then19
	end_block                       # label8:
	end_loop
	call    	abort@FUNCTION
	unreachable
.LBB1_13:                               # %for.end
	end_block                       # label5:
	i32.const	$push8=, 0
	return  	$pop8
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
