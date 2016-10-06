	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/981001-1.c"
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
	i32.call	$push17=, sub@FUNCTION, $1
	tee_local	$push16=, $0=, $pop17
	i32.const	$push7=, -1
	i32.add 	$push8=, $1, $pop7
	i32.call	$push9=, sub@FUNCTION, $pop8
	i32.const	$push15=, 1
	i32.shl 	$push10=, $pop9, $pop15
	i32.add 	$push11=, $0, $pop10
	i32.mul 	$push12=, $pop16, $pop11
	return  	$pop12
.LBB0_3:                                # %cleanup
	end_block                       # label1:
	return  	$0
.LBB0_4:                                # %if.else
	end_block                       # label0:
	i32.const	$push20=, 1
	i32.add 	$push3=, $1, $pop20
	i32.call	$0=, sub@FUNCTION, $pop3
	i32.call	$push19=, sub@FUNCTION, $1
	tee_local	$push18=, $1=, $pop19
	i32.mul 	$push5=, $pop18, $1
	i32.mul 	$push4=, $0, $0
	i32.add 	$push6=, $pop5, $pop4
                                        # fallthrough-return: $pop6
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
	i32.store	flg($pop8), $pop5
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
