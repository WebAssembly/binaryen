	.text
	.file	"981001-1.c"
	.section	.text.sub,"ax",@progbits
	.hidden	sub                     # -- Begin function sub
	.globl	sub
	.type	sub,@function
sub:                                    # @sub
	.param  	i32
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	block   	
	block   	
	i32.const	$push0=, 2
	i32.lt_s	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label1
# %bb.1:                                # %if.then
	i32.const	$push14=, 1
	i32.shr_u	$1=, $0, $pop14
	i32.const	$push13=, 1
	i32.and 	$push2=, $0, $pop13
	br_if   	1, $pop2        # 1: down to label0
# %bb.2:                                # %if.then2
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
	i32.const	$push16=, 1
	i32.add 	$push3=, $1, $pop16
	i32.call	$0=, sub@FUNCTION, $pop3
	i32.call	$1=, sub@FUNCTION, $1
	i32.mul 	$push5=, $1, $1
	i32.mul 	$push4=, $0, $0
	i32.add 	$push6=, $pop5, $pop4
                                        # fallthrough-return: $pop6
	.endfunc
.Lfunc_end0:
	.size	sub, .Lfunc_end0-sub
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push7=, 0
	i32.load	$0=, flg($pop7)
	block   	
	block   	
	i32.const	$push0=, 30
	i32.call	$push1=, sub@FUNCTION, $pop0
	i32.const	$push2=, 832040
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label3
# %bb.1:                                # %if.end
	br_if   	1, $0           # 1: down to label2
# %bb.2:                                # %if.end2
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
                                        # -- End function
	.hidden	flg                     # @flg
	.type	flg,@object
	.section	.bss.flg,"aw",@nobits
	.globl	flg
	.p2align	2
flg:
	.int32	0                       # 0x0
	.size	flg, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
