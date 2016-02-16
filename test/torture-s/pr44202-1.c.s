	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr44202-1.c"
	.section	.text.add512,"ax",@progbits
	.hidden	add512
	.globl	add512
	.type	add512,@function
add512:                                 # @add512
	.param  	i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	block
	i32.const	$push0=, 512
	i32.add 	$push2=, $0, $pop0
	tee_local	$push1=, $2=, $pop2
	i32.const	$push3=, 0
	i32.eq  	$push4=, $pop1, $pop3
	br_if   	0, $pop4        # 0: down to label0
# BB#1:                                 # %if.then
	i32.store	$discard=, 0($1), $0
.LBB0_2:                                # %if.end
	end_block                       # label0:
	return  	$2
	.endfunc
.Lfunc_end0:
	.size	add512, .Lfunc_end0-add512

	.section	.text.add513,"ax",@progbits
	.hidden	add513
	.globl	add513
	.type	add513,@function
add513:                                 # @add513
	.param  	i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	block
	i32.const	$push0=, 513
	i32.add 	$push2=, $0, $pop0
	tee_local	$push1=, $2=, $pop2
	br_if   	0, $pop1        # 0: down to label1
# BB#1:                                 # %if.then
	i32.store	$discard=, 0($1), $0
.LBB1_2:                                # %if.end
	end_block                       # label1:
	return  	$2
	.endfunc
.Lfunc_end1:
	.size	add513, .Lfunc_end1-add513

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 16
	i32.sub 	$5=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$5=, 0($2), $5
	i32.const	$push1=, -1
	i32.store	$push2=, 12($5), $pop1
	i32.store	$0=, 8($5), $pop2
	i32.const	$push3=, -512
	i32.const	$3=, 12
	i32.add 	$3=, $5, $3
	block
	i32.call	$push4=, add512@FUNCTION, $pop3, $3
	br_if   	0, $pop4        # 0: down to label2
# BB#1:                                 # %entry
	i32.load	$push0=, 12($5)
	i32.ne  	$push5=, $pop0, $0
	br_if   	0, $pop5        # 0: down to label2
# BB#2:                                 # %lor.lhs.false2
	i32.const	$push10=, -513
	i32.const	$4=, 8
	i32.add 	$4=, $5, $4
	i32.call	$push7=, add513@FUNCTION, $pop10, $4
	br_if   	0, $pop7        # 0: down to label2
# BB#3:                                 # %lor.lhs.false2
	i32.load	$push6=, 8($5)
	i32.const	$push11=, -513
	i32.ne  	$push8=, $pop6, $pop11
	br_if   	0, $pop8        # 0: down to label2
# BB#4:                                 # %if.end
	i32.const	$push9=, 0
	call    	exit@FUNCTION, $pop9
	unreachable
.LBB2_5:                                # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 3.9.0 "
