	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/switch-1.c"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	block   	BB0_2
	i32.const	$push0=, -4
	i32.add 	$0=, $0, $pop0
	i32.const	$push1=, 7
	i32.gt_u	$push2=, $0, $pop1
	br_if   	$pop2, BB0_2
# BB#1:                                 # %switch.lookup
	i32.const	$push6=, switch.table
	i32.const	$push4=, 2
	i32.shl 	$push5=, $0, $pop4
	i32.add 	$push7=, $pop6, $pop5
	i32.load	$push8=, 0($pop7)
	return  	$pop8
BB0_2:                                  # %return
	i32.const	$push3=, 31
	return  	$pop3
func_end0:
	.size	foo, func_end0-foo

	.globl	main
	.type	main,@function
main:                                   # @main
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, -1
BB1_1:                                  # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block   	BB1_17
	loop    	BB1_16
	i32.const	$push0=, -4
	i32.add 	$2=, $1, $pop0
	i32.const	$push1=, 7
	i32.gt_u	$4=, $2, $pop1
	i32.const	$3=, 31
	block   	BB1_3
	br_if   	$4, BB1_3
# BB#2:                                 # %switch.lookup.i
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push4=, switch.table
	i32.const	$push2=, 2
	i32.shl 	$push3=, $2, $pop2
	i32.add 	$push5=, $pop4, $pop3
	i32.load	$3=, 0($pop5)
BB1_3:                                  # %foo.exit
                                        #   in Loop: Header=BB1_1 Depth=1
	block   	BB1_14
	br_if   	$4, BB1_14
# BB#4:                                 # %foo.exit
                                        #   in Loop: Header=BB1_1 Depth=1
	block   	BB1_13
	block   	BB1_12
	block   	BB1_11
	block   	BB1_9
	block   	BB1_7
	block   	BB1_5
	tableswitch	$2, BB1_5, BB1_5, BB1_14, BB1_7, BB1_14, BB1_14, BB1_9, BB1_14, BB1_11
BB1_5:                                  # %if.then
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push12=, 30
	i32.eq  	$push13=, $3, $pop12
	br_if   	$pop13, BB1_12
# BB#6:                                 # %if.then3
	call    	abort
	unreachable
BB1_7:                                  # %if.then5
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push10=, 30
	i32.eq  	$push11=, $3, $pop10
	br_if   	$pop11, BB1_12
# BB#8:                                 # %if.then7
	call    	abort
	unreachable
BB1_9:                                  # %if.then11
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push8=, 30
	i32.eq  	$push9=, $3, $pop8
	br_if   	$pop9, BB1_12
# BB#10:                                # %if.then13
	call    	abort
	unreachable
BB1_11:                                 # %if.then17
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push6=, 30
	i32.ne  	$push7=, $3, $pop6
	br_if   	$pop7, BB1_13
BB1_12:                                 # %for.inc.thread
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push14=, 1
	i32.add 	$1=, $1, $pop14
	br      	BB1_1
BB1_13:                                 # %if.then19
	call    	abort
	unreachable
BB1_14:                                 # %if.else21
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push15=, 31
	i32.ne  	$push16=, $3, $pop15
	br_if   	$pop16, BB1_17
# BB#15:                                # %for.inc
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push17=, 1
	i32.add 	$1=, $1, $pop17
	i32.const	$push18=, 66
	i32.lt_s	$push19=, $1, $pop18
	br_if   	$pop19, BB1_1
BB1_16:                                 # %for.end
	i32.const	$push20=, 0
	return  	$pop20
BB1_17:                                 # %if.then23
	call    	abort
	unreachable
func_end1:
	.size	main, func_end1-main

	.type	switch.table,@object    # @switch.table
	.section	.rodata,"a",@progbits
	.align	4
switch.table:
	.int32	30                      # 0x1e
	.int32	31                      # 0x1f
	.int32	30                      # 0x1e
	.int32	31                      # 0x1f
	.int32	31                      # 0x1f
	.int32	30                      # 0x1e
	.int32	31                      # 0x1f
	.int32	30                      # 0x1e
	.size	switch.table, 32


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
