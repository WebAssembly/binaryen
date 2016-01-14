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
	i32.add 	$0=, $0, $pop0
	i32.const	$push1=, 7
	i32.gt_u	$push2=, $0, $pop1
	br_if   	$pop2, 0        # 0: down to label0
# BB#1:                                 # %switch.lookup
	i32.const	$push6=, .Lswitch.table
	i32.const	$push4=, 2
	i32.shl 	$push5=, $0, $pop4
	i32.add 	$push7=, $pop6, $pop5
	i32.load	$push8=, 0($pop7)
	return  	$pop8
.LBB0_2:                                # %return
	end_block                       # label0:
	i32.const	$push3=, 31
	return  	$pop3
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
	i32.const	$push0=, -4
	i32.add 	$2=, $1, $pop0
	i32.const	$push1=, 7
	i32.gt_u	$4=, $2, $pop1
	i32.const	$3=, 31
	block
	br_if   	$4, 0           # 0: down to label4
# BB#2:                                 # %switch.lookup.i
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push4=, .Lswitch.table
	i32.const	$push2=, 2
	i32.shl 	$push3=, $2, $pop2
	i32.add 	$push5=, $pop4, $pop3
	i32.load	$3=, 0($pop5)
.LBB1_3:                                # %foo.exit
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label4:
	block
	br_if   	$4, 0           # 0: down to label5
# BB#4:                                 # %foo.exit
                                        #   in Loop: Header=BB1_1 Depth=1
	block
	block
	block
	block
	block
	block
	tableswitch	$2, 0, 0, 6, 1, 6, 6, 2, 6, 3 # 0: down to label11
                                        # 6: down to label5
                                        # 1: down to label10
                                        # 2: down to label9
                                        # 3: down to label8
.LBB1_5:                                # %if.then
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label11:
	i32.const	$push12=, 30
	i32.eq  	$push13=, $3, $pop12
	br_if   	$pop13, 3       # 3: down to label7
# BB#6:                                 # %if.then3
	call    	abort@FUNCTION
	unreachable
.LBB1_7:                                # %if.then5
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label10:
	i32.const	$push10=, 30
	i32.eq  	$push11=, $3, $pop10
	br_if   	$pop11, 2       # 2: down to label7
# BB#8:                                 # %if.then7
	call    	abort@FUNCTION
	unreachable
.LBB1_9:                                # %if.then11
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label9:
	i32.const	$push8=, 30
	i32.eq  	$push9=, $3, $pop8
	br_if   	$pop9, 1        # 1: down to label7
# BB#10:                                # %if.then13
	call    	abort@FUNCTION
	unreachable
.LBB1_11:                               # %if.then17
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label8:
	i32.const	$push6=, 30
	i32.ne  	$push7=, $3, $pop6
	br_if   	$pop7, 1        # 1: down to label6
.LBB1_12:                               # %for.inc.thread
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label7:
	i32.const	$push14=, 1
	i32.add 	$1=, $1, $pop14
	br      	2               # 2: up to label2
.LBB1_13:                               # %if.then19
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
.LBB1_14:                               # %if.else21
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label5:
	i32.const	$push15=, 31
	i32.ne  	$push16=, $3, $pop15
	br_if   	$pop16, 2       # 2: down to label1
# BB#15:                                # %for.inc
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push17=, 1
	i32.add 	$1=, $1, $pop17
	i32.const	$push18=, 66
	i32.lt_s	$push19=, $1, $pop18
	br_if   	$pop19, 0       # 0: up to label2
# BB#16:                                # %for.end
	end_loop                        # label3:
	i32.const	$push20=, 0
	return  	$pop20
.LBB1_17:                               # %if.then23
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	.Lswitch.table,@object  # @switch.table
	.section	.rodata..Lswitch.table,"a",@progbits
	.align	4
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
	.section	".note.GNU-stack","",@progbits
