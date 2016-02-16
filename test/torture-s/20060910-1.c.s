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
	return  	$pop0
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
	i32.load	$push22=, 0($0)
	tee_local	$push21=, $2=, $pop22
	i32.load	$push20=, 4($0)
	tee_local	$push19=, $1=, $pop20
	i32.ge_u	$push5=, $pop21, $pop19
	br_if   	0, $pop5        # 0: down to label0
# BB#1:                                 # %cond.true
	i32.const	$push6=, 1
	i32.add 	$push0=, $2, $pop6
	i32.store	$2=, 0($0), $pop0
.LBB1_2:                                # %for.inc
	end_block                       # label0:
	block
	i32.ge_u	$push7=, $2, $1
	br_if   	0, $pop7        # 0: down to label1
# BB#3:                                 # %cond.true.1
	i32.const	$push8=, 1
	i32.add 	$push1=, $2, $pop8
	i32.store	$2=, 0($0), $pop1
.LBB1_4:                                # %for.inc.1
	end_block                       # label1:
	block
	i32.ge_u	$push9=, $2, $1
	br_if   	0, $pop9        # 0: down to label2
# BB#5:                                 # %cond.true.2
	i32.const	$push10=, 1
	i32.add 	$push2=, $2, $pop10
	i32.store	$2=, 0($0), $pop2
.LBB1_6:                                # %for.inc.2
	end_block                       # label2:
	block
	i32.ge_u	$push11=, $2, $1
	br_if   	0, $pop11       # 0: down to label3
# BB#7:                                 # %cond.true.3
	i32.const	$push12=, 1
	i32.add 	$push3=, $2, $pop12
	i32.store	$2=, 0($0), $pop3
.LBB1_8:                                # %for.inc.3
	end_block                       # label3:
	block
	i32.ge_u	$push13=, $2, $1
	br_if   	0, $pop13       # 0: down to label4
# BB#9:                                 # %cond.true.4
	i32.const	$push14=, 1
	i32.add 	$push4=, $2, $pop14
	i32.store	$2=, 0($0), $pop4
.LBB1_10:                               # %for.inc.4
	end_block                       # label4:
	block
	i32.ge_u	$push15=, $2, $1
	br_if   	0, $pop15       # 0: down to label5
# BB#11:                                # %cond.true.5
	i32.const	$push16=, 1
	i32.add 	$push17=, $2, $pop16
	i32.store	$discard=, 0($0), $pop17
.LBB1_12:                               # %for.inc.5
	end_block                       # label5:
	i32.const	$push18=, 1
	return  	$pop18
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
	i32.const	$push4=, 0
	i32.const	$push0=, b+6
	i32.store	$push2=, s+4($pop4), $pop0
	i32.store	$discard=, s($pop1), $pop2
	i32.const	$push3=, 0
	return  	$pop3
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


	.ident	"clang version 3.9.0 "
