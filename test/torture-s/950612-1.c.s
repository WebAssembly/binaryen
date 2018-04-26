	.text
	.file	"950612-1.c"
	.section	.text.f1,"ax",@progbits
	.hidden	f1                      # -- Begin function f1
	.globl	f1
	.type	f1,@function
f1:                                     # @f1
	.param  	i32
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 31
	i32.shr_s	$1=, $0, $pop0
	i32.add 	$push1=, $0, $1
	i32.xor 	$push2=, $pop1, $1
                                        # fallthrough-return: $pop2
	.endfunc
.Lfunc_end0:
	.size	f1, .Lfunc_end0-f1
                                        # -- End function
	.section	.text.f2,"ax",@progbits
	.hidden	f2                      # -- Begin function f2
	.globl	f2
	.type	f2,@function
f2:                                     # @f2
	.param  	i32
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 31
	i32.shr_s	$1=, $0, $pop0
	i32.add 	$push1=, $0, $1
	i32.xor 	$push2=, $pop1, $1
                                        # fallthrough-return: $pop2
	.endfunc
.Lfunc_end1:
	.size	f2, .Lfunc_end1-f2
                                        # -- End function
	.section	.text.f3,"ax",@progbits
	.hidden	f3                      # -- Begin function f3
	.globl	f3
	.type	f3,@function
f3:                                     # @f3
	.param  	i64
	.result 	i64
	.local  	i64
# %bb.0:                                # %entry
	i64.const	$push0=, 63
	i64.shr_s	$1=, $0, $pop0
	i64.add 	$push1=, $0, $1
	i64.xor 	$push2=, $pop1, $1
                                        # fallthrough-return: $pop2
	.endfunc
.Lfunc_end2:
	.size	f3, .Lfunc_end2-f3
                                        # -- End function
	.section	.text.f4,"ax",@progbits
	.hidden	f4                      # -- Begin function f4
	.globl	f4
	.type	f4,@function
f4:                                     # @f4
	.param  	i64
	.result 	i64
	.local  	i64
# %bb.0:                                # %entry
	i64.const	$push0=, 63
	i64.shr_s	$1=, $0, $pop0
	i64.add 	$push1=, $0, $1
	i64.xor 	$push2=, $pop1, $1
                                        # fallthrough-return: $pop2
	.endfunc
.Lfunc_end3:
	.size	f4, .Lfunc_end3-f4
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i64, i64, i32, i32
# %bb.0:                                # %entry
	i64.const	$1=, 0
	i32.const	$0=, 0
	i64.const	$2=, 0
	i32.const	$3=, 0
.LBB4_1:                                # %if.end
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label1:
	i64.eqz 	$4=, $2
	i32.select	$push0=, $0, $3, $4
	i64.extend_u/i32	$push1=, $pop0
	i64.ne  	$push2=, $2, $pop1
	br_if   	1, $pop2        # 1: down to label0
# %bb.2:                                # %if.end20
                                        #   in Loop: Header=BB4_1 Depth=1
	i64.select	$push3=, $1, $2, $4
	i64.ne  	$push4=, $2, $pop3
	br_if   	1, $pop4        # 1: down to label0
# %bb.3:                                # %for.cond
                                        #   in Loop: Header=BB4_1 Depth=1
	i64.const	$push11=, 1
	i64.add 	$2=, $2, $pop11
	i32.const	$push10=, -1
	i32.add 	$0=, $0, $pop10
	i64.const	$push9=, -1
	i64.add 	$1=, $1, $pop9
	i32.const	$push8=, 1
	i32.add 	$3=, $3, $pop8
	i64.const	$push7=, 10
	i64.le_u	$push5=, $2, $pop7
	br_if   	0, $pop5        # 0: up to label1
# %bb.4:                                # %for.end
	end_loop
	i32.const	$push6=, 0
	call    	exit@FUNCTION, $pop6
	unreachable
.LBB4_5:                                # %if.then4
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end4:
	.size	main, .Lfunc_end4-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
