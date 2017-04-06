	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20060910-1.c"
	.section	.text.input_getc_complicated,"ax",@progbits
	.hidden	input_getc_complicated
	.globl	input_getc_complicated
	.type	input_getc_complicated,@function
input_getc_complicated:                 # @input_getc_complicated
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end0:
	.size	input_getc_complicated, .Lfunc_end0-input_getc_complicated

	.section	.text.check_header,"ax",@progbits
	.hidden	check_header
	.globl	check_header
	.type	check_header,@function
check_header:                           # @check_header
	.param  	i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
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
	i32.load	$push23=, 0($0)
	tee_local	$push22=, $2=, $pop23
	i32.load	$push21=, 4($0)
	tee_local	$push20=, $1=, $pop21
	i32.lt_u	$push0=, $pop22, $pop20
	br_if   	0, $pop0        # 0: down to label10
# BB#1:                                 # %for.inc
	i32.lt_u	$push3=, $2, $1
	br_if   	1, $pop3        # 1: down to label9
	br      	2               # 2: down to label8
.LBB1_2:                                # %cond.true
	end_block                       # label10:
	i32.const	$push1=, 1
	i32.add 	$push25=, $2, $pop1
	tee_local	$push24=, $2=, $pop25
	i32.store	0($0), $pop24
	i32.ge_u	$push2=, $2, $1
	br_if   	1, $pop2        # 1: down to label8
.LBB1_3:                                # %cond.true.1
	end_block                       # label9:
	i32.const	$push4=, 1
	i32.add 	$push27=, $2, $pop4
	tee_local	$push26=, $2=, $pop27
	i32.store	0($0), $pop26
	i32.ge_u	$push5=, $2, $1
	br_if   	1, $pop5        # 1: down to label7
	br      	2               # 2: down to label6
.LBB1_4:                                # %for.inc.1
	end_block                       # label8:
	i32.lt_u	$push6=, $2, $1
	br_if   	1, $pop6        # 1: down to label6
.LBB1_5:                                # %for.inc.2
	end_block                       # label7:
	i32.lt_u	$push9=, $2, $1
	br_if   	1, $pop9        # 1: down to label5
	br      	2               # 2: down to label4
.LBB1_6:                                # %cond.true.2
	end_block                       # label6:
	i32.const	$push7=, 1
	i32.add 	$push29=, $2, $pop7
	tee_local	$push28=, $2=, $pop29
	i32.store	0($0), $pop28
	i32.ge_u	$push8=, $2, $1
	br_if   	1, $pop8        # 1: down to label4
.LBB1_7:                                # %cond.true.3
	end_block                       # label5:
	i32.const	$push10=, 1
	i32.add 	$push31=, $2, $pop10
	tee_local	$push30=, $2=, $pop31
	i32.store	0($0), $pop30
	i32.ge_u	$push11=, $2, $1
	br_if   	1, $pop11       # 1: down to label3
	br      	2               # 2: down to label2
.LBB1_8:                                # %for.inc.3
	end_block                       # label4:
	i32.lt_u	$push12=, $2, $1
	br_if   	1, $pop12       # 1: down to label2
.LBB1_9:                                # %for.inc.4
	end_block                       # label3:
	i32.lt_u	$push15=, $2, $1
	br_if   	1, $pop15       # 1: down to label1
	br      	2               # 2: down to label0
.LBB1_10:                               # %cond.true.4
	end_block                       # label2:
	i32.const	$push13=, 1
	i32.add 	$push33=, $2, $pop13
	tee_local	$push32=, $2=, $pop33
	i32.store	0($0), $pop32
	i32.ge_u	$push14=, $2, $1
	br_if   	1, $pop14       # 1: down to label0
.LBB1_11:                               # %cond.true.5
	end_block                       # label1:
	i32.const	$push16=, 1
	i32.add 	$push17=, $2, $pop16
	i32.store	0($0), $pop17
	i32.const	$push18=, 1
	return  	$pop18
.LBB1_12:                               # %for.inc.5
	end_block                       # label0:
	i32.const	$push19=, 1
                                        # fallthrough-return: $pop19
	.endfunc
.Lfunc_end1:
	.size	check_header, .Lfunc_end1-check_header

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end2
	i32.const	$push1=, 0
	i32.const	$push0=, b+6
	i32.store	s($pop1), $pop0
	i32.const	$push4=, 0
	i32.const	$push3=, b+6
	i32.store	s+4($pop4), $pop3
	i32.const	$push2=, 0
                                        # fallthrough-return: $pop2
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.hidden	b                       # @b
	.type	b,@object
	.section	.bss.b,"aw",@nobits
	.globl	b
b:
	.skip	6
	.size	b, 6

	.hidden	s                       # @s
	.type	s,@object
	.section	.bss.s,"aw",@nobits
	.globl	s
	.p2align	2
s:
	.skip	8
	.size	s, 8


	.ident	"clang version 5.0.0 (https://chromium.googlesource.com/external/github.com/llvm-mirror/clang e7bf9bd23e5ab5ae3f79d88d3e8956f0067fc683) (https://chromium.googlesource.com/external/github.com/llvm-mirror/llvm 7bfedca6fc415b0e5edea211f299142b03de1e97)"
