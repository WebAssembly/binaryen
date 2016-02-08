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
	i32.const	$push1=, -4
	i32.add 	$push0=, $0, $pop1
	tee_local	$push8=, $0=, $pop0
	i32.const	$push2=, 7
	i32.gt_u	$push3=, $pop8, $pop2
	br_if   	0, $pop3        # 0: down to label0
# BB#1:                                 # %switch.lookup
	i32.const	$push5=, 2
	i32.shl 	$push6=, $0, $pop5
	i32.load	$push7=, .Lswitch.table($pop6)
	return  	$pop7
.LBB0_2:                                # %return
	end_block                       # label0:
	i32.const	$push4=, 31
	return  	$pop4
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
	loop                            # label2:
	i32.const	$2=, 31
	block
	i32.const	$push13=, -4
	i32.add 	$push0=, $1, $pop13
	tee_local	$push12=, $4=, $pop0
	i32.const	$push11=, 7
	i32.gt_u	$push1=, $pop12, $pop11
	tee_local	$push10=, $3=, $pop1
	br_if   	0, $pop10       # 0: down to label4
# BB#2:                                 # %switch.lookup.i
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push14=, 2
	i32.shl 	$push2=, $4, $pop14
	i32.load	$2=, .Lswitch.table($pop2)
.LBB1_3:                                # %foo.exit
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label4:
	block
	br_if   	0, $3           # 0: down to label5
# BB#4:                                 # %foo.exit
                                        #   in Loop: Header=BB1_1 Depth=1
	block
	block
	block
	block
	block
	block
	tableswitch	$4, 0, 0, 6, 1, 6, 6, 2, 6, 3 # 0: down to label11
                                        # 6: down to label5
                                        # 1: down to label10
                                        # 2: down to label9
                                        # 3: down to label8
.LBB1_5:                                # %if.then
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label11:
	i32.const	$push15=, 30
	i32.eq  	$push6=, $2, $pop15
	br_if   	3, $pop6        # 3: down to label7
# BB#6:                                 # %if.then3
	call    	abort@FUNCTION
	unreachable
.LBB1_7:                                # %if.then5
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label10:
	i32.const	$push16=, 30
	i32.eq  	$push5=, $2, $pop16
	br_if   	2, $pop5        # 2: down to label7
# BB#8:                                 # %if.then7
	call    	abort@FUNCTION
	unreachable
.LBB1_9:                                # %if.then11
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label9:
	i32.const	$push17=, 30
	i32.eq  	$push4=, $2, $pop17
	br_if   	1, $pop4        # 1: down to label7
# BB#10:                                # %if.then13
	call    	abort@FUNCTION
	unreachable
.LBB1_11:                               # %if.then17
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label8:
	i32.const	$push18=, 30
	i32.ne  	$push3=, $2, $pop18
	br_if   	1, $pop3        # 1: down to label6
.LBB1_12:                               # %for.inc.thread
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label7:
	i32.const	$push20=, 1
	i32.add 	$1=, $1, $pop20
	br      	2               # 2: up to label2
.LBB1_13:                               # %if.then19
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
.LBB1_14:                               # %if.else21
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label5:
	i32.const	$push19=, 31
	i32.ne  	$push7=, $2, $pop19
	br_if   	2, $pop7        # 2: down to label1
# BB#15:                                # %for.inc
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push22=, 1
	i32.add 	$1=, $1, $pop22
	i32.const	$push21=, 66
	i32.lt_s	$push8=, $1, $pop21
	br_if   	0, $pop8        # 0: up to label2
# BB#16:                                # %for.end
	end_loop                        # label3:
	i32.const	$push9=, 0
	return  	$pop9
.LBB1_17:                               # %if.then23
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	.Lswitch.table,@object  # @switch.table
	.section	.rodata..Lswitch.table,"a",@progbits
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
