	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pending-4.c"
	.section	.text.dummy,"ax",@progbits
	.hidden	dummy
	.globl	dummy
	.type	dummy,@function
dummy:                                  # @dummy
	.param  	i32, i32
# BB#0:                                 # %entry
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	dummy, .Lfunc_end0-dummy

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$4=, 8
	i32.const	$2=, 0
	i32.const	$3=, 0
	block   	
	block   	
	i32.const	$push9=, 8
	i32.const	$push8=, 1
	i32.ne  	$push1=, $pop9, $pop8
	br_if   	0, $pop1        # 0: down to label1
# BB#1:
	i32.const	$5=, 2
	br      	1               # 1: down to label0
.LBB1_2:
	end_block                       # label1:
	i32.const	$5=, 0
.LBB1_3:                                # =>This Inner Loop Header: Depth=1
	end_block                       # label0:
	loop    	i32             # label2:
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	br_table 	$5, 1, 2, 0, 3, 4, 5, 6, 6 # 1: down to label14
                                        # 2: down to label13
                                        # 0: down to label15
                                        # 3: down to label12
                                        # 4: down to label11
                                        # 5: down to label10
                                        # 6: down to label9
.LBB1_4:                                # %if.then
                                        #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label15:
	i32.const	$push14=, 1
	i32.add 	$2=, $2, $pop14
	i32.const	$push13=, -1
	i32.add 	$push12=, $4, $pop13
	tee_local	$push11=, $4=, $pop12
	i32.const	$push10=, 1
	i32.eq  	$push2=, $pop11, $pop10
	br_if   	9, $pop2        # 9: down to label5
# BB#5:                                 #   in Loop: Header=BB1_3 Depth=1
	i32.const	$5=, 0
	br      	12              # 12: up to label2
.LBB1_6:                                # %for.cond
                                        #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label14:
	i32.eqz 	$push20=, $4
	br_if   	5, $pop20       # 5: down to label8
# BB#7:                                 #   in Loop: Header=BB1_3 Depth=1
	i32.const	$5=, 1
	br      	11              # 11: up to label2
.LBB1_8:                                # %if.else
                                        #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label13:
	i32.const	$push19=, 1
	i32.add 	$3=, $3, $pop19
	i32.const	$push18=, -1
	i32.add 	$push17=, $4, $pop18
	tee_local	$push16=, $4=, $pop17
	i32.const	$push15=, 1
	i32.ne  	$push0=, $pop16, $pop15
	br_if   	6, $pop0        # 6: down to label6
	br      	5               # 5: down to label7
.LBB1_9:                                # %for.end
                                        #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label12:
	i32.const	$push3=, 1
	i32.ne  	$push4=, $2, $pop3
	br_if   	7, $pop4        # 7: down to label4
# BB#10:                                #   in Loop: Header=BB1_3 Depth=1
	i32.const	$5=, 4
	br      	9               # 9: up to label2
.LBB1_11:                               # %for.end
                                        #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label11:
	i32.const	$push5=, 7
	i32.ne  	$push6=, $3, $pop5
	br_if   	7, $pop6        # 7: down to label3
# BB#12:                                #   in Loop: Header=BB1_3 Depth=1
	i32.const	$5=, 5
	br      	8               # 8: up to label2
.LBB1_13:                               # %if.end7
	end_block                       # label10:
	i32.const	$push7=, 0
	call    	exit@FUNCTION, $pop7
	unreachable
.LBB1_14:                               # %if.then6
	end_block                       # label9:
	call    	abort@FUNCTION
	unreachable
.LBB1_15:                               #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label8:
	i32.const	$5=, 3
	br      	5               # 5: up to label2
.LBB1_16:                               #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label7:
	i32.const	$5=, 2
	br      	4               # 4: up to label2
.LBB1_17:                               #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label6:
	i32.const	$5=, 0
	br      	3               # 3: up to label2
.LBB1_18:                               #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label5:
	i32.const	$5=, 2
	br      	2               # 2: up to label2
.LBB1_19:                               #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label4:
	i32.const	$5=, 6
	br      	1               # 1: up to label2
.LBB1_20:                               #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label3:
	i32.const	$5=, 6
	br      	0               # 0: up to label2
.LBB1_21:
	end_loop
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 5.0.0 (https://chromium.googlesource.com/external/github.com/llvm-mirror/clang e7bf9bd23e5ab5ae3f79d88d3e8956f0067fc683) (https://chromium.googlesource.com/external/github.com/llvm-mirror/llvm 7bfedca6fc415b0e5edea211f299142b03de1e97)"
	.functype	abort, void
	.functype	exit, void, i32
