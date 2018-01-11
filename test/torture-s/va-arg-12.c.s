	.text
	.file	"va-arg-12.c"
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	f64, f64, f64, f64, f64, f64, f64, f64, f64, i32
	.local  	i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push17=, 0
	i32.load	$push16=, __stack_pointer($pop17)
	i32.const	$push18=, 16
	i32.sub 	$12=, $pop16, $pop18
	i32.const	$push19=, 0
	i32.store	__stack_pointer($pop19), $12
	i32.const	$push0=, 7
	i32.add 	$push1=, $9, $pop0
	i32.const	$push2=, -8
	i32.and 	$9=, $pop1, $pop2
	i32.const	$push3=, 8
	i32.add 	$10=, $9, $pop3
	i32.store	12($12), $10
	block   	
	f64.load	$push4=, 0($9)
	f64.const	$push5=, 0x1.4p3
	f64.ne  	$push6=, $pop4, $pop5
	br_if   	0, $pop6        # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$push7=, 16
	i32.add 	$11=, $9, $pop7
	i32.store	12($12), $11
	f64.load	$push8=, 0($10)
	f64.const	$push9=, 0x1.6p3
	f64.ne  	$push10=, $pop8, $pop9
	br_if   	0, $pop10       # 0: down to label0
# %bb.2:                                # %if.end6
	i32.const	$push11=, 24
	i32.add 	$push12=, $9, $pop11
	i32.store	12($12), $pop12
	f64.load	$push13=, 0($11)
	f64.const	$push14=, 0x0p0
	f64.ne  	$push15=, $pop13, $pop14
	br_if   	0, $pop15       # 0: down to label0
# %bb.3:                                # %if.end11
	i32.const	$push22=, 0
	i32.const	$push20=, 16
	i32.add 	$push21=, $12, $pop20
	i32.store	__stack_pointer($pop22), $pop21
	return
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
	.local  	f64, i32
# %bb.0:                                # %entry
	i32.const	$push7=, 0
	i32.load	$push6=, __stack_pointer($pop7)
	i32.const	$push8=, 32
	i32.sub 	$1=, $pop6, $pop8
	i32.const	$push9=, 0
	i32.store	__stack_pointer($pop9), $1
	i32.const	$push0=, 16
	i32.add 	$push1=, $1, $pop0
	i64.const	$push2=, 0
	i64.store	0($pop1), $pop2
	i64.const	$push3=, 4622382067542392832
	i64.store	8($1), $pop3
	i64.const	$push4=, 4621819117588971520
	i64.store	0($1), $pop4
	call    	f@FUNCTION, $0, $0, $0, $0, $0, $0, $0, $0, $0, $1
	i32.const	$push5=, 0
	call    	exit@FUNCTION, $pop5
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
