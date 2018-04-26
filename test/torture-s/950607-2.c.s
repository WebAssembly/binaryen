	.text
	.file	"950607-2.c"
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32, i32
	.result 	i32
	.local  	i32, i64
# %bb.0:                                # %entry
	i32.load	$3=, 4($0)
	i32.load	$0=, 0($0)
	i32.load	$push10=, 4($2)
	i32.sub 	$push11=, $pop10, $3
	i64.extend_s/i32	$push12=, $pop11
	i32.load	$push7=, 0($1)
	i32.sub 	$push8=, $pop7, $0
	i64.extend_s/i32	$push9=, $pop8
	i64.mul 	$push13=, $pop12, $pop9
	i32.load	$push3=, 0($2)
	i32.sub 	$push4=, $pop3, $0
	i64.extend_s/i32	$push5=, $pop4
	i32.load	$push0=, 4($1)
	i32.sub 	$push1=, $pop0, $3
	i64.extend_s/i32	$push2=, $pop1
	i64.mul 	$push6=, $pop5, $pop2
	i64.sub 	$4=, $pop13, $pop6
	i32.const	$push21=, 0
	i32.const	$push19=, 2
	i64.const	$push16=, 63
	i64.shr_u	$push17=, $4, $pop16
	i32.wrap/i64	$push18=, $pop17
	i32.sub 	$push20=, $pop19, $pop18
	i64.const	$push14=, 0
	i64.gt_s	$push15=, $4, $pop14
	i32.select	$push22=, $pop21, $pop20, $pop15
                                        # fallthrough-return: $pop22
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %if.end
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	exit, void, i32
