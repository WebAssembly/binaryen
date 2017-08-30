	.text
	.file	"compare-1.c"
	.section	.text.ieq,"ax",@progbits
	.hidden	ieq                     # -- Begin function ieq
	.globl	ieq
	.type	ieq,@function
ieq:                                    # @ieq
	.param  	i32, i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block   	
	block   	
	block   	
	block   	
	i32.ne  	$push1=, $0, $1
	tee_local	$push0=, $0=, $pop1
	i32.eqz 	$push2=, $pop0
	br_if   	0, $pop2        # 0: down to label3
# BB#1:                                 # %if.else
	br_if   	2, $2           # 2: down to label1
	br      	1               # 1: down to label2
.LBB0_2:                                # %if.then
	end_block                       # label3:
	i32.eqz 	$push3=, $2
	br_if   	1, $pop3        # 1: down to label1
.LBB0_3:                                # %if.end6
	end_block                       # label2:
	block   	
	block   	
	br_if   	0, $0           # 0: down to label5
# BB#4:                                 # %if.then10
	i32.eqz 	$push4=, $2
	br_if   	2, $pop4        # 2: down to label1
	br      	1               # 1: down to label4
.LBB0_5:                                # %if.else14
	end_block                       # label5:
	br_if   	1, $2           # 1: down to label1
.LBB0_6:                                # %if.end18
	end_block                       # label4:
	block   	
	block   	
	i32.eqz 	$push5=, $0
	br_if   	0, $pop5        # 0: down to label7
# BB#7:                                 # %if.else26
	br_if   	2, $2           # 2: down to label1
	br      	1               # 1: down to label6
.LBB0_8:                                # %if.then22
	end_block                       # label7:
	i32.eqz 	$push6=, $2
	br_if   	1, $pop6        # 1: down to label1
.LBB0_9:                                # %if.end30
	end_block                       # label6:
	block   	
	br_if   	0, $0           # 0: down to label8
# BB#10:                                # %if.then34
	i32.eqz 	$push7=, $2
	br_if   	1, $pop7        # 1: down to label1
	br      	2               # 2: down to label0
.LBB0_11:                               # %if.else38
	end_block                       # label8:
	i32.eqz 	$push8=, $2
	br_if   	1, $pop8        # 1: down to label0
.LBB0_12:                               # %if.then2
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_13:                               # %if.end42
	end_block                       # label0:
	copy_local	$push9=, $2
                                        # fallthrough-return: $pop9
	.endfunc
.Lfunc_end0:
	.size	ieq, .Lfunc_end0-ieq
                                        # -- End function
	.section	.text.ine,"ax",@progbits
	.hidden	ine                     # -- Begin function ine
	.globl	ine
	.type	ine,@function
ine:                                    # @ine
	.param  	i32, i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block   	
	block   	
	block   	
	i32.ne  	$push0=, $0, $1
	br_if   	0, $pop0        # 0: down to label11
# BB#1:                                 # %if.else
	i32.eqz 	$push1=, $2
	br_if   	1, $pop1        # 1: down to label10
	br      	2               # 2: down to label9
.LBB1_2:                                # %if.then
	end_block                       # label11:
	i32.eqz 	$push2=, $2
	br_if   	1, $pop2        # 1: down to label9
.LBB1_3:                                # %if.end6
	end_block                       # label10:
	return  	$2
.LBB1_4:                                # %if.then2
	end_block                       # label9:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	ine, .Lfunc_end1-ine
                                        # -- End function
	.section	.text.ilt,"ax",@progbits
	.hidden	ilt                     # -- Begin function ilt
	.globl	ilt
	.type	ilt,@function
ilt:                                    # @ilt
	.param  	i32, i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block   	
	block   	
	block   	
	i32.ge_s	$push0=, $0, $1
	br_if   	0, $pop0        # 0: down to label14
# BB#1:                                 # %if.then
	br_if   	1, $2           # 1: down to label13
	br      	2               # 2: down to label12
.LBB2_2:                                # %if.else
	end_block                       # label14:
	br_if   	1, $2           # 1: down to label12
.LBB2_3:                                # %if.end6
	end_block                       # label13:
	return  	$2
.LBB2_4:                                # %if.then2
	end_block                       # label12:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	ilt, .Lfunc_end2-ilt
                                        # -- End function
	.section	.text.ile,"ax",@progbits
	.hidden	ile                     # -- Begin function ile
	.globl	ile
	.type	ile,@function
ile:                                    # @ile
	.param  	i32, i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block   	
	block   	
	block   	
	i32.le_s	$push0=, $0, $1
	br_if   	0, $pop0        # 0: down to label17
# BB#1:                                 # %if.else
	i32.eqz 	$push1=, $2
	br_if   	1, $pop1        # 1: down to label16
	br      	2               # 2: down to label15
.LBB3_2:                                # %if.then
	end_block                       # label17:
	i32.eqz 	$push2=, $2
	br_if   	1, $pop2        # 1: down to label15
.LBB3_3:                                # %if.end6
	end_block                       # label16:
	return  	$2
.LBB3_4:                                # %if.then2
	end_block                       # label15:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end3:
	.size	ile, .Lfunc_end3-ile
                                        # -- End function
	.section	.text.igt,"ax",@progbits
	.hidden	igt                     # -- Begin function igt
	.globl	igt
	.type	igt,@function
igt:                                    # @igt
	.param  	i32, i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block   	
	block   	
	block   	
	i32.le_s	$push0=, $0, $1
	br_if   	0, $pop0        # 0: down to label20
# BB#1:                                 # %if.then
	br_if   	1, $2           # 1: down to label19
	br      	2               # 2: down to label18
.LBB4_2:                                # %if.else
	end_block                       # label20:
	br_if   	1, $2           # 1: down to label18
.LBB4_3:                                # %if.end6
	end_block                       # label19:
	return  	$2
.LBB4_4:                                # %if.then2
	end_block                       # label18:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end4:
	.size	igt, .Lfunc_end4-igt
                                        # -- End function
	.section	.text.ige,"ax",@progbits
	.hidden	ige                     # -- Begin function ige
	.globl	ige
	.type	ige,@function
ige:                                    # @ige
	.param  	i32, i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block   	
	block   	
	block   	
	i32.ge_s	$push0=, $0, $1
	br_if   	0, $pop0        # 0: down to label23
# BB#1:                                 # %if.else
	i32.eqz 	$push1=, $2
	br_if   	1, $pop1        # 1: down to label22
	br      	2               # 2: down to label21
.LBB5_2:                                # %if.then
	end_block                       # label23:
	i32.eqz 	$push2=, $2
	br_if   	1, $pop2        # 1: down to label21
.LBB5_3:                                # %if.end6
	end_block                       # label22:
	return  	$2
.LBB5_4:                                # %if.then2
	end_block                       # label21:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end5:
	.size	ige, .Lfunc_end5-ige
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end6:
	.size	main, .Lfunc_end6-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
