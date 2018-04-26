	.text
	.file	"20051113-1.c"
	.section	.text.Sum,"ax",@progbits
	.hidden	Sum                     # -- Begin function Sum
	.globl	Sum
	.type	Sum,@function
Sum:                                    # @Sum
	.param  	i32
	.result 	i64
	.local  	i32, i32, i64
# %bb.0:                                # %entry
	i32.load	$1=, 0($0):p2align=0
	block   	
	i32.const	$push6=, 1
	i32.lt_s	$push1=, $1, $pop6
	br_if   	0, $pop1        # 0: down to label0
# %bb.1:                                # %for.body.preheader
	i32.const	$push2=, 10
	i32.add 	$0=, $0, $pop2
	i64.const	$3=, 0
	i32.const	$2=, 0
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i64.load	$push3=, 0($0):p2align=0
	i64.add 	$3=, $pop3, $3
	i32.const	$push8=, 1
	i32.add 	$2=, $2, $pop8
	i32.const	$push7=, 30
	i32.add 	$push0=, $0, $pop7
	copy_local	$0=, $pop0
	i32.lt_s	$push4=, $2, $1
	br_if   	0, $pop4        # 0: up to label1
# %bb.3:                                # %for.end
	end_loop
	return  	$3
.LBB0_4:
	end_block                       # label0:
	i64.const	$push5=, 0
                                        # fallthrough-return: $pop5
	.endfunc
.Lfunc_end0:
	.size	Sum, .Lfunc_end0-Sum
                                        # -- End function
	.section	.text.Sum2,"ax",@progbits
	.hidden	Sum2                    # -- Begin function Sum2
	.globl	Sum2
	.type	Sum2,@function
Sum2:                                   # @Sum2
	.param  	i32
	.result 	i64
	.local  	i32, i32, i64
# %bb.0:                                # %entry
	i32.load	$1=, 0($0):p2align=0
	block   	
	i32.const	$push6=, 1
	i32.lt_s	$push1=, $1, $pop6
	br_if   	0, $pop1        # 0: down to label2
# %bb.1:                                # %for.body.preheader
	i32.const	$push2=, 18
	i32.add 	$0=, $0, $pop2
	i64.const	$3=, 0
	i32.const	$2=, 0
.LBB1_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label3:
	i64.load	$push3=, 0($0):p2align=0
	i64.add 	$3=, $pop3, $3
	i32.const	$push8=, 1
	i32.add 	$2=, $2, $pop8
	i32.const	$push7=, 30
	i32.add 	$push0=, $0, $pop7
	copy_local	$0=, $pop0
	i32.lt_s	$push4=, $2, $1
	br_if   	0, $pop4        # 0: up to label3
# %bb.3:                                # %for.end
	end_loop
	return  	$3
.LBB1_4:
	end_block                       # label2:
	i64.const	$push5=, 0
                                        # fallthrough-return: $pop5
	.endfunc
.Lfunc_end1:
	.size	Sum2, .Lfunc_end1-Sum2
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 94
	i32.call	$0=, malloc@FUNCTION, $pop0
	i32.const	$push1=, 4
	i32.add 	$push2=, $0, $pop1
	i32.const	$push4=, 0
	i32.const	$push3=, 90
	i32.call	$drop=, memset@FUNCTION, $pop2, $pop4, $pop3
	i64.const	$push5=, 555
	i64.store	10($0):p2align=0, $pop5
	i32.const	$push6=, 3
	i32.store	0($0):p2align=0, $pop6
	i64.const	$push7=, 999
	i64.store	40($0):p2align=0, $pop7
	i64.const	$push8=, 4311810305
	i64.store	70($0):p2align=0, $pop8
	i64.const	$push17=, 555
	i64.store	18($0):p2align=0, $pop17
	i64.const	$push16=, 999
	i64.store	48($0):p2align=0, $pop16
	i64.const	$push15=, 4311810305
	i64.store	78($0):p2align=0, $pop15
	block   	
	i64.call	$push9=, Sum@FUNCTION, $0
	i64.const	$push14=, 4311811859
	i64.ne  	$push10=, $pop9, $pop14
	br_if   	0, $pop10       # 0: down to label4
# %bb.1:                                # %if.end
	i64.call	$push11=, Sum2@FUNCTION, $0
	i64.const	$push18=, 4311811859
	i64.ne  	$push12=, $pop11, $pop18
	br_if   	0, $pop12       # 0: down to label4
# %bb.2:                                # %if.end25
	i32.const	$push13=, 0
	return  	$pop13
.LBB2_3:                                # %if.then
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	malloc, i32, i32
	.functype	abort, void
