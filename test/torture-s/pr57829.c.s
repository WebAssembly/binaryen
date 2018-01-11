	.text
	.file	"pr57829.c"
	.section	.text.f1,"ax",@progbits
	.hidden	f1                      # -- Begin function f1
	.globl	f1
	.type	f1,@function
f1:                                     # @f1
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, -1
	i32.add 	$push1=, $0, $pop0
	i32.const	$push2=, 31
	i32.shr_s	$push3=, $pop1, $pop2
	i32.const	$push4=, 2
	i32.or  	$push5=, $pop3, $pop4
                                        # fallthrough-return: $pop5
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
# %bb.0:                                # %entry
	i32.const	$push0=, -1
	i32.add 	$push1=, $0, $pop0
	i32.const	$push2=, 31
	i32.shr_s	$push3=, $pop1, $pop2
	i32.const	$push4=, 2
	i32.or  	$push5=, $pop3, $pop4
                                        # fallthrough-return: $pop5
	.endfunc
.Lfunc_end1:
	.size	f2, .Lfunc_end1-f2
                                        # -- End function
	.section	.text.f3,"ax",@progbits
	.hidden	f3                      # -- Begin function f3
	.globl	f3
	.type	f3,@function
f3:                                     # @f3
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 63
	i32.and 	$push1=, $0, $pop0
	i32.const	$push2=, 2
	i32.add 	$push3=, $pop1, $pop2
	i32.const	$push4=, 5
	i32.shr_u	$push5=, $pop3, $pop4
	i32.const	$push6=, 4
	i32.or  	$push7=, $pop5, $pop6
                                        # fallthrough-return: $pop7
	.endfunc
.Lfunc_end2:
	.size	f3, .Lfunc_end2-f3
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push14=, 1
	i32.call	$push0=, f1@FUNCTION, $pop14
	i32.const	$push13=, 2
	i32.ne  	$push1=, $pop0, $pop13
	br_if   	0, $pop1        # 0: down to label0
# %bb.1:                                # %lor.lhs.false
	i32.const	$push16=, 1
	i32.call	$push2=, f2@FUNCTION, $pop16
	i32.const	$push15=, 2
	i32.ne  	$push3=, $pop2, $pop15
	br_if   	0, $pop3        # 0: down to label0
# %bb.2:                                # %lor.lhs.false3
	i32.const	$push4=, 63
	i32.call	$push5=, f3@FUNCTION, $pop4
	i32.const	$push6=, 6
	i32.ne  	$push7=, $pop5, $pop6
	br_if   	0, $pop7        # 0: down to label0
# %bb.3:                                # %lor.lhs.false6
	i32.const	$push8=, 1
	i32.call	$push9=, f3@FUNCTION, $pop8
	i32.const	$push10=, 4
	i32.ne  	$push11=, $pop9, $pop10
	br_if   	0, $pop11       # 0: down to label0
# %bb.4:                                # %if.end
	i32.const	$push12=, 0
	return  	$pop12
.LBB3_5:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
