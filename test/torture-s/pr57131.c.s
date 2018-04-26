	.text
	.file	"pr57131.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i64, i64, i64, i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push12=, 0
	i32.load	$push11=, __stack_pointer($pop12)
	i32.const	$push13=, 48
	i32.sub 	$5=, $pop11, $pop13
	i32.const	$push14=, 0
	i32.store	__stack_pointer($pop14), $5
	i32.const	$push21=, 0
	i32.store	44($5), $pop21
	i64.const	$push0=, 0
	i64.store	32($5), $pop0
	i32.const	$push20=, 0
	i32.store	28($5), $pop20
	i32.const	$push1=, 1
	i32.store	24($5), $pop1
	i32.const	$push19=, 1
	i32.store	20($5), $pop19
	i64.const	$push2=, 1
	i64.store	8($5), $pop2
	i64.load32_s	$0=, 44($5)
	i64.load	$1=, 32($5)
	i64.load32_u	$2=, 28($5)
	i32.load	$3=, 24($5)
	i32.load	$4=, 20($5)
	block   	
	i64.load	$push8=, 8($5)
	i64.shl 	$push3=, $1, $2
	i64.mul 	$push4=, $0, $pop3
	i32.mul 	$push5=, $4, $3
	i64.extend_s/i32	$push6=, $pop5
	i64.div_s	$push7=, $pop4, $pop6
	i64.add 	$push9=, $pop8, $pop7
	i64.const	$push18=, 1
	i64.ne  	$push10=, $pop9, $pop18
	br_if   	0, $pop10       # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$push17=, 0
	i32.const	$push15=, 48
	i32.add 	$push16=, $5, $pop15
	i32.store	__stack_pointer($pop17), $pop16
	i32.const	$push22=, 0
	return  	$pop22
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
