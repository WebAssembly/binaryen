	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/compare-1.c"
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
	block
	i32.ne  	$push1=, $0, $1
	tee_local	$push0=, $1=, $pop1
	i32.const	$push2=, 0
	i32.eq  	$push3=, $pop0, $pop2
	br_if   	0, $pop3        # 0: down to label5
# BB#1:                                 # %if.else
	i32.const	$push4=, 0
	i32.eq  	$push5=, $2, $pop4
	br_if   	1, $pop5        # 1: down to label4
# BB#2:                                 # %if.then4
	call    	abort@FUNCTION
	unreachable
.LBB0_3:                                # %if.then
	end_block                       # label5:
	i32.const	$push6=, 0
	i32.eq  	$push7=, $2, $pop6
	br_if   	1, $pop7        # 1: down to label3
.LBB0_4:                                # %if.end6
	end_block                       # label4:
	block
	block
	br_if   	0, $1           # 0: down to label7
# BB#5:                                 # %if.then10
	br_if   	1, $2           # 1: down to label6
# BB#6:                                 # %if.then12
	call    	abort@FUNCTION
	unreachable
.LBB0_7:                                # %if.else14
	end_block                       # label7:
	br_if   	2, $2           # 2: down to label2
.LBB0_8:                                # %if.end18
	end_block                       # label6:
	block
	block
	i32.const	$push8=, 0
	i32.eq  	$push9=, $1, $pop8
	br_if   	0, $pop9        # 0: down to label9
# BB#9:                                 # %if.else26
	i32.const	$push10=, 0
	i32.eq  	$push11=, $2, $pop10
	br_if   	1, $pop11       # 1: down to label8
# BB#10:                                # %if.then28
	call    	abort@FUNCTION
	unreachable
.LBB0_11:                               # %if.then22
	end_block                       # label9:
	i32.const	$push12=, 0
	i32.eq  	$push13=, $2, $pop12
	br_if   	3, $pop13       # 3: down to label1
.LBB0_12:                               # %if.end30
	end_block                       # label8:
	block
	block
	br_if   	0, $1           # 0: down to label11
# BB#13:                                # %if.then34
	br_if   	1, $2           # 1: down to label10
# BB#14:                                # %if.then36
	call    	abort@FUNCTION
	unreachable
.LBB0_15:                               # %if.else38
	end_block                       # label11:
	br_if   	4, $2           # 4: down to label0
.LBB0_16:                               # %if.end42
	end_block                       # label10:
	return  	$2
.LBB0_17:                               # %if.then2
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB0_18:                               # %if.then16
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB0_19:                               # %if.then24
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_20:                               # %if.then40
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
	br_if   	0, $pop0        # 0: down to label14
# BB#1:                                 # %if.else
	i32.const	$push1=, 0
	i32.eq  	$push2=, $2, $pop1
	br_if   	1, $pop2        # 1: down to label13
# BB#2:                                 # %if.then4
	call    	abort@FUNCTION
	unreachable
.LBB1_3:                                # %if.then
	end_block                       # label14:
	i32.const	$push3=, 0
	i32.eq  	$push4=, $2, $pop3
	br_if   	1, $pop4        # 1: down to label12
.LBB1_4:                                # %if.end6
	end_block                       # label13:
	return  	$2
.LBB1_5:                                # %if.then2
	end_block                       # label12:
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
	br_if   	0, $pop0        # 0: down to label17
# BB#1:                                 # %if.then
	br_if   	1, $2           # 1: down to label16
# BB#2:                                 # %if.then2
	call    	abort@FUNCTION
	unreachable
.LBB2_3:                                # %if.else
	end_block                       # label17:
	br_if   	1, $2           # 1: down to label15
.LBB2_4:                                # %if.end6
	end_block                       # label16:
	return  	$2
.LBB2_5:                                # %if.then4
	end_block                       # label15:
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
	br_if   	0, $pop0        # 0: down to label20
# BB#1:                                 # %if.else
	i32.const	$push1=, 0
	i32.eq  	$push2=, $2, $pop1
	br_if   	1, $pop2        # 1: down to label19
# BB#2:                                 # %if.then4
	call    	abort@FUNCTION
	unreachable
.LBB3_3:                                # %if.then
	end_block                       # label20:
	i32.const	$push3=, 0
	i32.eq  	$push4=, $2, $pop3
	br_if   	1, $pop4        # 1: down to label18
.LBB3_4:                                # %if.end6
	end_block                       # label19:
	return  	$2
.LBB3_5:                                # %if.then2
	end_block                       # label18:
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
	br_if   	0, $pop0        # 0: down to label23
# BB#1:                                 # %if.then
	br_if   	1, $2           # 1: down to label22
# BB#2:                                 # %if.then2
	call    	abort@FUNCTION
	unreachable
.LBB4_3:                                # %if.else
	end_block                       # label23:
	br_if   	1, $2           # 1: down to label21
.LBB4_4:                                # %if.end6
	end_block                       # label22:
	return  	$2
.LBB4_5:                                # %if.then4
	end_block                       # label21:
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
	br_if   	0, $pop0        # 0: down to label26
# BB#1:                                 # %if.else
	i32.const	$push1=, 0
	i32.eq  	$push2=, $2, $pop1
	br_if   	1, $pop2        # 1: down to label25
# BB#2:                                 # %if.then4
	call    	abort@FUNCTION
	unreachable
.LBB5_3:                                # %if.then
	end_block                       # label26:
	i32.const	$push3=, 0
	i32.eq  	$push4=, $2, $pop3
	br_if   	1, $pop4        # 1: down to label24
.LBB5_4:                                # %if.end6
	end_block                       # label25:
	return  	$2
.LBB5_5:                                # %if.then2
	end_block                       # label24:
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
	return  	$pop0
	.endfunc
.Lfunc_end6:
	.size	main, .Lfunc_end6-main


	.ident	"clang version 3.9.0 "
