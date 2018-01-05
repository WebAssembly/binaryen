	.text
	.file	"20030221-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# %bb.0:                                # %entry
	i32.const	$push7=, 0
	i32.load	$push6=, __stack_pointer($pop7)
	i32.const	$push8=, 16
	i32.sub 	$1=, $pop6, $pop8
	i32.const	$push9=, 0
	i32.store	__stack_pointer($pop9), $1
	i32.const	$push14=, 0
	i64.load	$push0=, .Lmain.buf+8($pop14)
	i64.store	8($1), $pop0
	i32.const	$push13=, 0
	i64.load	$push1=, .Lmain.buf($pop13)
	i64.store	0($1), $pop1
	i32.call	$0=, strlen@FUNCTION, $1
	i32.store8	0($1), $0
	block   	
	i32.const	$push2=, 255
	i32.and 	$push3=, $0, $pop2
	i32.const	$push4=, 10
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	0, $pop5        # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$push12=, 0
	i32.const	$push10=, 16
	i32.add 	$push11=, $1, $pop10
	i32.store	__stack_pointer($pop12), $pop11
	i32.const	$push15=, 0
	return  	$pop15
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.type	.Lmain.buf,@object      # @main.buf
	.section	.rodata.cst16,"aM",@progbits,16
	.p2align	4
.Lmain.buf:
	.asciz	"1234567890\000\000\000\000\000"
	.size	.Lmain.buf, 16


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	strlen, i32, i32
	.functype	abort, void
