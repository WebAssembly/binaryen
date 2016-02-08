	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/981001-1.c"
	.section	.text.sub,"ax",@progbits
	.hidden	sub
	.globl	sub
	.type	sub,@function
sub:                                    # @sub
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	block
	i32.const	$push0=, 2
	i32.lt_s	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %if.then
	i32.const	$push3=, 31
	i32.shr_u	$push4=, $0, $pop3
	i32.add 	$push5=, $0, $pop4
	i32.const	$push18=, 1
	i32.shr_s	$1=, $pop5, $pop18
	block
	i32.const	$push17=, 1
	i32.and 	$push2=, $0, $pop17
	br_if   	0, $pop2        # 0: down to label1
# BB#2:                                 # %if.then2
	i32.call	$0=, sub@FUNCTION, $1
	i32.const	$push11=, -1
	i32.add 	$push12=, $1, $pop11
	i32.call	$push13=, sub@FUNCTION, $pop12
	i32.const	$push19=, 1
	i32.shl 	$push14=, $pop13, $pop19
	i32.add 	$push15=, $0, $pop14
	i32.mul 	$push16=, $0, $pop15
	return  	$pop16
.LBB0_3:                                # %if.else
	end_block                       # label1:
	i32.const	$push21=, 1
	i32.add 	$push6=, $1, $pop21
	i32.call	$0=, sub@FUNCTION, $pop6
	i32.call	$push7=, sub@FUNCTION, $1
	tee_local	$push20=, $1=, $pop7
	i32.mul 	$push9=, $pop20, $1
	i32.mul 	$push8=, $0, $0
	i32.add 	$push10=, $pop9, $pop8
	return  	$pop10
.LBB0_4:                                # %cleanup
	end_block                       # label0:
	return  	$0
	.endfunc
.Lfunc_end0:
	.size	sub, .Lfunc_end0-sub

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push7=, 0
	i32.load	$0=, flg($pop7)
	block
	block
	i32.const	$push0=, 30
	i32.call	$push1=, sub@FUNCTION, $pop0
	i32.const	$push2=, 832040
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label3
# BB#1:                                 # %if.end
	br_if   	1, $0           # 1: down to label2
# BB#2:                                 # %if.end2
	i32.const	$push6=, 0
	call    	exit@FUNCTION, $pop6
	unreachable
.LBB1_3:                                # %if.end.thread
	end_block                       # label3:
	i32.const	$push8=, 0
	i32.const	$push4=, 256
	i32.or  	$push5=, $0, $pop4
	i32.store	$discard=, flg($pop8), $pop5
.LBB1_4:                                # %if.then1
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	flg                     # @flg
	.type	flg,@object
	.section	.bss.flg,"aw",@nobits
	.globl	flg
	.p2align	2
flg:
	.int32	0                       # 0x0
	.size	flg, 4


	.ident	"clang version 3.9.0 "
