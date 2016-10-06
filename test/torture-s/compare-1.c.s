	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/compare-1.c"
	.section	.text.ieq,"ax",@progbits
	.hidden	ieq
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
	block   	
	i32.ne  	$push1=, $0, $1
	tee_local	$push0=, $0=, $pop1
	i32.eqz 	$push2=, $pop0
	br_if   	0, $pop2        # 0: down to label4
# BB#1:                                 # %if.else
	i32.eqz 	$push3=, $2
	br_if   	1, $pop3        # 1: down to label3
	br      	2               # 2: down to label2
.LBB0_2:                                # %if.then
	end_block                       # label4:
	i32.eqz 	$push4=, $2
	br_if   	2, $pop4        # 2: down to label1
.LBB0_3:                                # %if.end6
	end_block                       # label3:
	block   	
	block   	
	br_if   	0, $0           # 0: down to label6
# BB#4:                                 # %if.then10
	br_if   	1, $2           # 1: down to label5
# BB#5:                                 # %if.then12
	call    	abort@FUNCTION
	unreachable
.LBB0_6:                                # %if.else14
	end_block                       # label6:
	br_if   	1, $2           # 1: down to label2
.LBB0_7:                                # %if.end18
	end_block                       # label5:
	block   	
	block   	
	i32.eqz 	$push5=, $0
	br_if   	0, $pop5        # 0: down to label8
# BB#8:                                 # %if.else26
	i32.eqz 	$push6=, $2
	br_if   	1, $pop6        # 1: down to label7
	br      	2               # 2: down to label2
.LBB0_9:                                # %if.then22
	end_block                       # label8:
	i32.eqz 	$push7=, $2
	br_if   	3, $pop7        # 3: down to label0
.LBB0_10:                               # %if.end30
	end_block                       # label7:
	block   	
	block   	
	br_if   	0, $0           # 0: down to label10
# BB#11:                                # %if.then34
	br_if   	1, $2           # 1: down to label9
# BB#12:                                # %if.then36
	call    	abort@FUNCTION
	unreachable
.LBB0_13:                               # %if.else38
	end_block                       # label10:
	br_if   	1, $2           # 1: down to label2
.LBB0_14:                               # %if.end42
	end_block                       # label9:
	return  	$2
.LBB0_15:                               # %if.then40
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB0_16:                               # %if.then2
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_17:                               # %if.then24
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	ieq, .Lfunc_end0-ieq

	.section	.text.ine,"ax",@progbits
	.hidden	ine
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
	br_if   	0, $pop0        # 0: down to label13
# BB#1:                                 # %if.else
	i32.eqz 	$push1=, $2
	br_if   	1, $pop1        # 1: down to label12
# BB#2:                                 # %if.then4
	call    	abort@FUNCTION
	unreachable
.LBB1_3:                                # %if.then
	end_block                       # label13:
	i32.eqz 	$push2=, $2
	br_if   	1, $pop2        # 1: down to label11
.LBB1_4:                                # %if.end6
	end_block                       # label12:
	return  	$2
.LBB1_5:                                # %if.then2
	end_block                       # label11:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	ine, .Lfunc_end1-ine

	.section	.text.ilt,"ax",@progbits
	.hidden	ilt
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
	br_if   	0, $pop0        # 0: down to label16
# BB#1:                                 # %if.then
	br_if   	1, $2           # 1: down to label15
# BB#2:                                 # %if.then2
	call    	abort@FUNCTION
	unreachable
.LBB2_3:                                # %if.else
	end_block                       # label16:
	br_if   	1, $2           # 1: down to label14
.LBB2_4:                                # %if.end6
	end_block                       # label15:
	return  	$2
.LBB2_5:                                # %if.then4
	end_block                       # label14:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	ilt, .Lfunc_end2-ilt

	.section	.text.ile,"ax",@progbits
	.hidden	ile
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
	br_if   	0, $pop0        # 0: down to label19
# BB#1:                                 # %if.else
	i32.eqz 	$push1=, $2
	br_if   	1, $pop1        # 1: down to label18
# BB#2:                                 # %if.then4
	call    	abort@FUNCTION
	unreachable
.LBB3_3:                                # %if.then
	end_block                       # label19:
	i32.eqz 	$push2=, $2
	br_if   	1, $pop2        # 1: down to label17
.LBB3_4:                                # %if.end6
	end_block                       # label18:
	return  	$2
.LBB3_5:                                # %if.then2
	end_block                       # label17:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end3:
	.size	ile, .Lfunc_end3-ile

	.section	.text.igt,"ax",@progbits
	.hidden	igt
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
	br_if   	0, $pop0        # 0: down to label22
# BB#1:                                 # %if.then
	br_if   	1, $2           # 1: down to label21
# BB#2:                                 # %if.then2
	call    	abort@FUNCTION
	unreachable
.LBB4_3:                                # %if.else
	end_block                       # label22:
	br_if   	1, $2           # 1: down to label20
.LBB4_4:                                # %if.end6
	end_block                       # label21:
	return  	$2
.LBB4_5:                                # %if.then4
	end_block                       # label20:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end4:
	.size	igt, .Lfunc_end4-igt

	.section	.text.ige,"ax",@progbits
	.hidden	ige
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
	br_if   	0, $pop0        # 0: down to label25
# BB#1:                                 # %if.else
	i32.eqz 	$push1=, $2
	br_if   	1, $pop1        # 1: down to label24
# BB#2:                                 # %if.then4
	call    	abort@FUNCTION
	unreachable
.LBB5_3:                                # %if.then
	end_block                       # label25:
	i32.eqz 	$push2=, $2
	br_if   	1, $pop2        # 1: down to label23
.LBB5_4:                                # %if.end6
	end_block                       # label24:
	return  	$2
.LBB5_5:                                # %if.then2
	end_block                       # label23:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end5:
	.size	ige, .Lfunc_end5-ige

	.section	.text.main,"ax",@progbits
	.hidden	main
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
