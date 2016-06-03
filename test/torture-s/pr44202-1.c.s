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
	i32.eqz 	$push3=, $pop1
	br_if   	0, $pop3        # 0: down to label0
# BB#1:                                 # %if.then
	i32.store	$drop=, 0($1), $0
.LBB0_2:                                # %if.end
	end_block                       # label0:
	copy_local	$push4=, $2
                                        # fallthrough-return: $pop4
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
	i32.store	$drop=, 0($1), $0
.LBB1_2:                                # %if.end
	end_block                       # label1:
	copy_local	$push3=, $2
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end1:
	.size	add513, .Lfunc_end1-add513

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push13=, 0
	i32.const	$push10=, 0
	i32.load	$push11=, __stack_pointer($pop10)
	i32.const	$push12=, 16
	i32.sub 	$push18=, $pop11, $pop12
	i32.store	$push20=, __stack_pointer($pop13), $pop18
	tee_local	$push19=, $1=, $pop20
	i32.const	$push2=, -1
	i32.store	$push0=, 12($1), $pop2
	i32.store	$0=, 8($pop19), $pop0
	block
	i32.const	$push3=, -512
	i32.const	$push14=, 12
	i32.add 	$push15=, $1, $pop14
	i32.call	$push4=, add512@FUNCTION, $pop3, $pop15
	br_if   	0, $pop4        # 0: down to label2
# BB#1:                                 # %entry
	i32.load	$push1=, 12($1)
	i32.ne  	$push5=, $pop1, $0
	br_if   	0, $pop5        # 0: down to label2
# BB#2:                                 # %lor.lhs.false2
	i32.const	$push21=, -513
	i32.const	$push16=, 8
	i32.add 	$push17=, $1, $pop16
	i32.call	$push7=, add513@FUNCTION, $pop21, $pop17
	br_if   	0, $pop7        # 0: down to label2
# BB#3:                                 # %lor.lhs.false2
	i32.load	$push6=, 8($1)
	i32.const	$push22=, -513
	i32.ne  	$push8=, $pop6, $pop22
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
	.functype	abort, void
	.functype	exit, void, i32
