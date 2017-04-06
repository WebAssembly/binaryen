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
	i32.add 	$push10=, $0, $pop0
	tee_local	$push9=, $0=, $pop10
	i32.const	$push1=, 7
	i32.gt_u	$push2=, $pop9, $pop1
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %switch.lookup
	i32.const	$push4=, 2
	i32.shl 	$push5=, $0, $pop4
	i32.const	$push6=, .Lswitch.table.1
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
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, -5
	i32.const	$1=, .Lswitch.table.1-20
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label2:
	i32.const	$push12=, 4
	i32.add 	$3=, $2, $pop12
	i32.const	$4=, 31
	block   	
	i32.const	$push11=, 7
	i32.gt_u	$push0=, $2, $pop11
	br_if   	0, $pop0        # 0: down to label3
# BB#2:                                 # %switch.lookup
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.load	$4=, 0($1)
.LBB1_3:                                # %foo.exit
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label3:
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	i32.const	$push16=, -4
	i32.add 	$push15=, $3, $pop16
	tee_local	$push14=, $5=, $pop15
	i32.const	$push13=, 7
	i32.gt_u	$push1=, $pop14, $pop13
	br_if   	0, $pop1        # 0: down to label9
# BB#4:                                 # %foo.exit
                                        #   in Loop: Header=BB1_1 Depth=1
	block   	
	br_table 	$5, 0, 1, 2, 1, 1, 3, 1, 4, 0 # 0: down to label10
                                        # 1: down to label9
                                        # 2: down to label8
                                        # 3: down to label7
                                        # 4: down to label6
.LBB1_5:                                # %if.then
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label10:
	i32.const	$push17=, 30
	i32.eq  	$push5=, $4, $pop17
	br_if   	4, $pop5        # 4: down to label5
	br      	5               # 5: down to label4
.LBB1_6:                                # %if.else21
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label9:
	i32.const	$push18=, 31
	i32.ne  	$push6=, $4, $pop18
	br_if   	4, $pop6        # 4: down to label4
# BB#7:                                 # %for.inc
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push19=, 64
	i32.le_s	$push7=, $3, $pop19
	br_if   	3, $pop7        # 3: down to label5
	br      	6               # 6: down to label1
.LBB1_8:                                # %if.then5
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label8:
	i32.const	$push20=, 30
	i32.eq  	$push4=, $4, $pop20
	br_if   	2, $pop4        # 2: down to label5
	br      	3               # 3: down to label4
.LBB1_9:                                # %if.then11
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label7:
	i32.const	$push21=, 30
	i32.eq  	$push3=, $4, $pop21
	br_if   	1, $pop3        # 1: down to label5
	br      	2               # 2: down to label4
.LBB1_10:                               # %if.then17
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label6:
	i32.const	$push22=, 30
	i32.ne  	$push2=, $4, $pop22
	br_if   	1, $pop2        # 1: down to label4
.LBB1_11:                               # %for.body.backedge
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label5:
	i32.const	$push10=, 4
	i32.add 	$1=, $1, $pop10
	i32.const	$push9=, 1
	i32.add 	$2=, $2, $pop9
	br      	1               # 1: up to label2
.LBB1_12:                               # %if.then3
	end_block                       # label4:
	end_loop
	call    	abort@FUNCTION
	unreachable
.LBB1_13:                               # %for.end
	end_block                       # label1:
	i32.const	$push8=, 0
                                        # fallthrough-return: $pop8
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	.Lswitch.table.1,@object # @switch.table.1
	.section	.rodata.cst32,"aM",@progbits,32
	.p2align	4
.Lswitch.table.1:
	.int32	30                      # 0x1e
	.int32	31                      # 0x1f
	.int32	30                      # 0x1e
	.int32	31                      # 0x1f
	.int32	31                      # 0x1f
	.int32	30                      # 0x1e
	.int32	31                      # 0x1f
	.int32	30                      # 0x1e
	.size	.Lswitch.table.1, 32


	.ident	"clang version 5.0.0 (https://chromium.googlesource.com/external/github.com/llvm-mirror/clang e7bf9bd23e5ab5ae3f79d88d3e8956f0067fc683) (https://chromium.googlesource.com/external/github.com/llvm-mirror/llvm 7bfedca6fc415b0e5edea211f299142b03de1e97)"
	.functype	abort, void
