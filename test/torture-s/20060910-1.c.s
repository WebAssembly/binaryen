	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20060910-1.c"
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
	i32.load	$push17=, 0($0)
	tee_local	$push16=, $2=, $pop17
	i32.load	$push15=, 4($0)
	tee_local	$push14=, $1=, $pop15
	i32.ge_u	$push0=, $pop16, $pop14
	br_if   	0, $pop0        # 0: down to label0
# BB#1:                                 # %cond.true
	i32.const	$push1=, 1
	i32.add 	$push19=, $2, $pop1
	tee_local	$push18=, $2=, $pop19
	i32.store	0($0), $pop18
.LBB1_2:                                # %for.inc
	end_block                       # label0:
	block   	
	i32.ge_u	$push2=, $2, $1
	br_if   	0, $pop2        # 0: down to label1
# BB#3:                                 # %cond.true.1
	i32.const	$push3=, 1
	i32.add 	$push21=, $2, $pop3
	tee_local	$push20=, $2=, $pop21
	i32.store	0($0), $pop20
.LBB1_4:                                # %for.inc.1
	end_block                       # label1:
	block   	
	i32.ge_u	$push4=, $2, $1
	br_if   	0, $pop4        # 0: down to label2
# BB#5:                                 # %cond.true.2
	i32.const	$push5=, 1
	i32.add 	$push23=, $2, $pop5
	tee_local	$push22=, $2=, $pop23
	i32.store	0($0), $pop22
.LBB1_6:                                # %for.inc.2
	end_block                       # label2:
	block   	
	i32.ge_u	$push6=, $2, $1
	br_if   	0, $pop6        # 0: down to label3
# BB#7:                                 # %cond.true.3
	i32.const	$push7=, 1
	i32.add 	$push25=, $2, $pop7
	tee_local	$push24=, $2=, $pop25
	i32.store	0($0), $pop24
.LBB1_8:                                # %for.inc.3
	end_block                       # label3:
	block   	
	i32.ge_u	$push8=, $2, $1
	br_if   	0, $pop8        # 0: down to label4
# BB#9:                                 # %cond.true.4
	i32.const	$push9=, 1
	i32.add 	$push27=, $2, $pop9
	tee_local	$push26=, $2=, $pop27
	i32.store	0($0), $pop26
.LBB1_10:                               # %for.inc.4
	end_block                       # label4:
	block   	
	i32.ge_u	$push10=, $2, $1
	br_if   	0, $pop10       # 0: down to label5
# BB#11:                                # %cond.true.5
	i32.const	$push11=, 1
	i32.add 	$push12=, $2, $pop11
	i32.store	0($0), $pop12
.LBB1_12:                               # %for.inc.5
	end_block                       # label5:
	i32.const	$push13=, 1
                                        # fallthrough-return: $pop13
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
