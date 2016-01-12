	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/tstdi-1.c"
	.section	.text.feq,"ax",@progbits
	.hidden	feq
	.globl	feq
	.type	feq,@function
feq:                                    # @feq
	.param  	i64
	.result 	i32
# BB#0:                                 # %entry
	i64.const	$push0=, 0
	i64.eq  	$push1=, $0, $pop0
	i32.const	$push3=, 13
	i32.const	$push2=, 140
	i32.select	$push4=, $pop1, $pop3, $pop2
	return  	$pop4
.Lfunc_end0:
	.size	feq, .Lfunc_end0-feq

	.section	.text.fne,"ax",@progbits
	.hidden	fne
	.globl	fne
	.type	fne,@function
fne:                                    # @fne
	.param  	i64
	.result 	i32
# BB#0:                                 # %entry
	i64.const	$push0=, 0
	i64.eq  	$push1=, $0, $pop0
	i32.const	$push3=, 140
	i32.const	$push2=, 13
	i32.select	$push4=, $pop1, $pop3, $pop2
	return  	$pop4
.Lfunc_end1:
	.size	fne, .Lfunc_end1-fne

	.section	.text.flt,"ax",@progbits
	.hidden	flt
	.globl	flt
	.type	flt,@function
flt:                                    # @flt
	.param  	i64
	.result 	i32
# BB#0:                                 # %entry
	i64.const	$push0=, 0
	i64.lt_s	$push1=, $0, $pop0
	i32.const	$push3=, 13
	i32.const	$push2=, 140
	i32.select	$push4=, $pop1, $pop3, $pop2
	return  	$pop4
.Lfunc_end2:
	.size	flt, .Lfunc_end2-flt

	.section	.text.fge,"ax",@progbits
	.hidden	fge
	.globl	fge
	.type	fge,@function
fge:                                    # @fge
	.param  	i64
	.result 	i32
# BB#0:                                 # %entry
	i64.const	$push0=, -1
	i64.gt_s	$push1=, $0, $pop0
	i32.const	$push3=, 13
	i32.const	$push2=, 140
	i32.select	$push4=, $pop1, $pop3, $pop2
	return  	$pop4
.Lfunc_end3:
	.size	fge, .Lfunc_end3-fge

	.section	.text.fgt,"ax",@progbits
	.hidden	fgt
	.globl	fgt
	.type	fgt,@function
fgt:                                    # @fgt
	.param  	i64
	.result 	i32
# BB#0:                                 # %entry
	i64.const	$push0=, 0
	i64.gt_s	$push1=, $0, $pop0
	i32.const	$push3=, 13
	i32.const	$push2=, 140
	i32.select	$push4=, $pop1, $pop3, $pop2
	return  	$pop4
.Lfunc_end4:
	.size	fgt, .Lfunc_end4-fgt

	.section	.text.fle,"ax",@progbits
	.hidden	fle
	.globl	fle
	.type	fle,@function
fle:                                    # @fle
	.param  	i64
	.result 	i32
# BB#0:                                 # %entry
	i64.const	$push0=, 1
	i64.lt_s	$push1=, $0, $pop0
	i32.const	$push3=, 13
	i32.const	$push2=, 140
	i32.select	$push4=, $pop1, $pop3, $pop2
	return  	$pop4
.Lfunc_end5:
	.size	fle, .Lfunc_end5-fle

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end140
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
.Lfunc_end6:
	.size	main, .Lfunc_end6-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
