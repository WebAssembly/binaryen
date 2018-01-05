	.text
	.file	"va-arg-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
	.result 	i32
	.local  	i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push12=, 0
	i32.load	$push11=, __stack_pointer($pop12)
	i32.const	$push13=, 16
	i32.sub 	$12=, $pop11, $pop13
	i32.const	$push14=, 0
	i32.store	__stack_pointer($pop14), $12
	i32.const	$push0=, 4
	i32.add 	$10=, $9, $pop0
	i32.store	12($12), $10
	block   	
	i32.load	$push1=, 0($9)
	i32.const	$push2=, 10
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$push4=, 8
	i32.add 	$11=, $9, $pop4
	i32.store	12($12), $11
	i32.load	$push5=, 0($10)
	i32.const	$push6=, 11
	i32.ne  	$push7=, $pop5, $pop6
	br_if   	0, $pop7        # 0: down to label0
# %bb.2:                                # %if.end6
	i32.const	$push8=, 12
	i32.add 	$push9=, $9, $pop8
	i32.store	12($12), $pop9
	i32.load	$push10=, 0($11)
	br_if   	0, $pop10       # 0: down to label0
# %bb.3:                                # %if.end11
	i32.const	$push17=, 0
	i32.const	$push15=, 16
	i32.add 	$push16=, $12, $pop15
	i32.store	__stack_pointer($pop17), $pop16
	return  	$12
.LBB0_4:                                # %if.then
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
	i32.const	$push0=, 0
	i32.store	8($0), $pop0
	i64.const	$push1=, 47244640266
	i64.store	0($0), $pop1
	i32.call	$drop=, f@FUNCTION, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0
	i32.const	$push6=, 0
	call    	exit@FUNCTION, $pop6
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
