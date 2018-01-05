	.text
	.file	"switch-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, -4
	i32.add 	$0=, $0, $pop0
	block   	
	i32.const	$push1=, 7
	i32.gt_u	$push2=, $0, $pop1
	br_if   	0, $pop2        # 0: down to label0
# %bb.1:                                # %switch.lookup
	i32.const	$push4=, 2
	i32.shl 	$push5=, $0, $pop4
	i32.const	$push6=, .Lswitch.table.main
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
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$2=, -5
	i32.const	$1=, .Lswitch.table.main-20
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label2:
	i32.const	$push10=, 4
	i32.add 	$3=, $2, $pop10
	i32.const	$4=, 31
	block   	
	i32.const	$push9=, 7
	i32.gt_u	$push0=, $2, $pop9
	br_if   	0, $pop0        # 0: down to label3
# %bb.2:                                # %switch.lookup
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.load	$4=, 0($1)
.LBB1_3:                                # %foo.exit
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label3:
	i32.const	$push12=, -4
	i32.add 	$5=, $3, $pop12
	block   	
	block   	
	i32.const	$push11=, 7
	i32.gt_u	$push1=, $5, $pop11
	br_if   	0, $pop1        # 0: down to label5
# %bb.4:                                # %foo.exit
                                        #   in Loop: Header=BB1_1 Depth=1
	block   	
	block   	
	block   	
	block   	
	br_table 	$5, 0, 4, 2, 4, 4, 1, 4, 3, 0 # 0: down to label9
                                        # 4: down to label5
                                        # 2: down to label7
                                        # 1: down to label8
                                        # 3: down to label6
.LBB1_5:                                # %if.then
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label9:
	i32.const	$push13=, 30
	i32.eq  	$push5=, $4, $pop13
	br_if   	4, $pop5        # 4: down to label4
	br      	6               # 6: down to label1
.LBB1_6:                                # %if.then11
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label8:
	i32.const	$push14=, 30
	i32.eq  	$push3=, $4, $pop14
	br_if   	3, $pop3        # 3: down to label4
	br      	5               # 5: down to label1
.LBB1_7:                                # %if.then5
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label7:
	i32.const	$push15=, 30
	i32.eq  	$push4=, $4, $pop15
	br_if   	2, $pop4        # 2: down to label4
	br      	4               # 4: down to label1
.LBB1_8:                                # %if.then17
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label6:
	i32.const	$push16=, 30
	i32.eq  	$push2=, $4, $pop16
	br_if   	1, $pop2        # 1: down to label4
	br      	3               # 3: down to label1
.LBB1_9:                                # %if.else21
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label5:
	i32.const	$push17=, 31
	i32.ne  	$push6=, $4, $pop17
	br_if   	2, $pop6        # 2: down to label1
.LBB1_10:                               # %for.inc
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label4:
	i32.const	$push20=, 4
	i32.add 	$1=, $1, $pop20
	i32.const	$push19=, 1
	i32.add 	$2=, $2, $pop19
	i32.const	$push18=, 65
	i32.lt_s	$push7=, $3, $pop18
	br_if   	0, $pop7        # 0: up to label2
# %bb.11:                               # %for.end
	end_loop
	i32.const	$push8=, 0
	return  	$pop8
.LBB1_12:                               # %if.then3
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.type	.Lswitch.table.main,@object # @switch.table.main
	.section	.rodata.cst32,"aM",@progbits,32
	.p2align	4
.Lswitch.table.main:
	.int32	30                      # 0x1e
	.int32	31                      # 0x1f
	.int32	30                      # 0x1e
	.int32	31                      # 0x1f
	.int32	31                      # 0x1f
	.int32	30                      # 0x1e
	.int32	31                      # 0x1f
	.int32	30                      # 0x1e
	.size	.Lswitch.table.main, 32


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
