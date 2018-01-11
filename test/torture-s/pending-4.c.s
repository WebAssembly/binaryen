	.text
	.file	"pending-4.c"
	.section	.text.dummy,"ax",@progbits
	.hidden	dummy                   # -- Begin function dummy
	.globl	dummy
	.type	dummy,@function
dummy:                                  # @dummy
	.param  	i32, i32
# %bb.0:                                # %entry
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	dummy, .Lfunc_end0-dummy
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$4=, 8
	i32.const	$2=, 0
	i32.const	$3=, 0
	block   	
	block   	
	i32.const	$push9=, 8
	i32.const	$push8=, 1
	i32.ne  	$push1=, $pop9, $pop8
	br_if   	0, $pop1        # 0: down to label1
# %bb.1:
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
	br_table 	$5, 2, 0, 1, 3, 4, 5, 6, 6 # 2: down to label12
                                        # 0: down to label14
                                        # 1: down to label13
                                        # 3: down to label11
                                        # 4: down to label10
                                        # 5: down to label9
                                        # 6: down to label8
.LBB1_4:                                # %if.else
                                        #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label14:
	i32.const	$push12=, 1
	i32.add 	$3=, $3, $pop12
	i32.const	$push11=, -1
	i32.add 	$4=, $4, $pop11
	i32.const	$push10=, 1
	i32.ne  	$push2=, $4, $pop10
	br_if   	8, $pop2        # 8: down to label5
# %bb.5:                                #   in Loop: Header=BB1_3 Depth=1
	i32.const	$5=, 2
	br      	11              # 11: up to label2
.LBB1_6:                                # %if.then
                                        #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label13:
	i32.const	$push15=, 1
	i32.add 	$2=, $2, $pop15
	i32.const	$push14=, -1
	i32.add 	$4=, $4, $pop14
	i32.const	$push13=, 1
	i32.eq  	$push0=, $4, $pop13
	br_if   	6, $pop0        # 6: down to label6
# %bb.7:                                #   in Loop: Header=BB1_3 Depth=1
	i32.const	$5=, 0
	br      	10              # 10: up to label2
.LBB1_8:                                # %for.cond
                                        #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label12:
	br_if   	4, $4           # 4: down to label7
# %bb.9:                                #   in Loop: Header=BB1_3 Depth=1
	i32.const	$5=, 3
	br      	9               # 9: up to label2
.LBB1_10:                               # %for.end
                                        #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label11:
	i32.const	$push3=, 1
	i32.ne  	$push4=, $2, $pop3
	br_if   	6, $pop4        # 6: down to label4
# %bb.11:                               #   in Loop: Header=BB1_3 Depth=1
	i32.const	$5=, 4
	br      	8               # 8: up to label2
.LBB1_12:                               # %for.end
                                        #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label10:
	i32.const	$push5=, 7
	i32.ne  	$push6=, $3, $pop5
	br_if   	6, $pop6        # 6: down to label3
# %bb.13:                               #   in Loop: Header=BB1_3 Depth=1
	i32.const	$5=, 5
	br      	7               # 7: up to label2
.LBB1_14:                               # %if.end7
	end_block                       # label9:
	i32.const	$push7=, 0
	call    	exit@FUNCTION, $pop7
	unreachable
.LBB1_15:                               # %if.then6
	end_block                       # label8:
	call    	abort@FUNCTION
	unreachable
.LBB1_16:                               #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label7:
	i32.const	$5=, 1
	br      	4               # 4: up to label2
.LBB1_17:                               #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label6:
	i32.const	$5=, 2
	br      	3               # 3: up to label2
.LBB1_18:                               #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label5:
	i32.const	$5=, 0
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
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
