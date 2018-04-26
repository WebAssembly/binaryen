	.text
	.file	"920908-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32
# %bb.0:                                # %entry
	i32.const	$push9=, 0
	i32.load	$push8=, __stack_pointer($pop9)
	i32.const	$push10=, 16
	i32.sub 	$3=, $pop8, $pop10
	i32.const	$push11=, 0
	i32.store	__stack_pointer($pop11), $3
	i32.const	$push0=, 4
	i32.add 	$2=, $1, $pop0
	i32.store	12($3), $2
	block   	
	i32.load	$push1=, 0($1)
	i32.const	$push2=, 10
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$push4=, 8
	i32.add 	$push5=, $1, $pop4
	i32.store	12($3), $pop5
	i32.load	$push6=, 0($2)
	i32.const	$push15=, 20
	i32.ne  	$push7=, $pop6, $pop15
	br_if   	0, $pop7        # 0: down to label0
# %bb.2:                                # %if.end7
	i32.const	$push14=, 0
	i32.const	$push12=, 16
	i32.add 	$push13=, $3, $pop12
	i32.store	__stack_pointer($pop14), $pop13
	i32.const	$push16=, 20
	return  	$pop16
.LBB0_3:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
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
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push3=, 0
	i32.load	$push2=, __stack_pointer($pop3)
	i32.const	$push4=, 16
	i32.sub 	$0=, $pop2, $pop4
	i32.const	$push5=, 0
	i32.store	__stack_pointer($pop5), $0
	i64.const	$push0=, 85899345930
	i64.store	0($0), $pop0
	i32.call	$drop=, f@FUNCTION, $0, $0
	i32.const	$push1=, 0
	call    	exit@FUNCTION, $pop1
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
