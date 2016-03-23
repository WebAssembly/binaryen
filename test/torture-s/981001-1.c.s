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
	block
	i32.const	$push0=, 2
	i32.lt_s	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label1
# BB#1:                                 # %if.then
	i32.const	$push14=, 1
	i32.shr_u	$1=, $0, $pop14
	i32.const	$push13=, 1
	i32.and 	$push2=, $0, $pop13
	br_if   	1, $pop2        # 1: down to label0
# BB#2:                                 # %if.then2
	i32.call	$0=, sub@FUNCTION, $1
	i32.const	$push7=, -1
	i32.add 	$push8=, $1, $pop7
	i32.call	$push9=, sub@FUNCTION, $pop8
	i32.const	$push15=, 1
	i32.shl 	$push10=, $pop9, $pop15
	i32.add 	$push11=, $0, $pop10
	i32.mul 	$push12=, $0, $pop11
	return  	$pop12
.LBB0_3:                                # %cleanup
	end_block                       # label1:
	return  	$0
.LBB0_4:                                # %if.else
	end_block                       # label0:
	i32.const	$push18=, 1
	i32.add 	$push3=, $1, $pop18
	i32.call	$0=, sub@FUNCTION, $pop3
	i32.call	$push17=, sub@FUNCTION, $1
	tee_local	$push16=, $1=, $pop17
	i32.mul 	$push5=, $pop16, $1
	i32.mul 	$push4=, $0, $0
	i32.add 	$push6=, $pop5, $pop4
	return  	$pop6
	.endfunc
.Lfunc_end0:
	.size	sub, .Lfunc_end0-sub

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 30
	i32.call	$1=, sub@FUNCTION, $pop0
	i32.const	$push6=, 0
	i32.load	$0=, flg($pop6)
	block
	block
	i32.const	$push1=, 832040
	i32.ne  	$push2=, $1, $pop1
	br_if   	0, $pop2        # 0: down to label3
# BB#1:                                 # %if.end
	br_if   	1, $0           # 1: down to label2
# BB#2:                                 # %if.end2
	i32.const	$push5=, 0
	call    	exit@FUNCTION, $pop5
	unreachable
.LBB1_3:                                # %if.end.thread
	end_block                       # label3:
	i32.const	$push7=, 0
	i32.const	$push3=, 256
	i32.or  	$push4=, $0, $pop3
	i32.store	$discard=, flg($pop7), $pop4
	call    	abort@FUNCTION
	unreachable
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
