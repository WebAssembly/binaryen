	.text
	.file	"980709-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	f64, f64, i32
# %bb.0:                                # %entry
	i32.const	$push13=, 0
	i32.load	$push12=, __stack_pointer($pop13)
	i32.const	$push14=, 16
	i32.sub 	$2=, $pop12, $pop14
	i32.const	$push15=, 0
	i32.store	__stack_pointer($pop15), $2
	i64.const	$push0=, 4629700416936869888
	i64.store	8($2), $pop0
	f64.load	$push2=, 8($2)
	f64.const	$push1=, 0x1.5555555555555p-2
	f64.call	$0=, pow@FUNCTION, $pop2, $pop1
	f64.const	$push3=, 0x1.999999999999ap-4
	f64.add 	$1=, $0, $pop3
	block   	
	f64.const	$push16=, 0x1.965fe974a3401p1
	f64.le  	$push4=, $1, $pop16
	f64.ne  	$push5=, $1, $1
	i32.or  	$push6=, $pop4, $pop5
	br_if   	0, $pop6        # 0: down to label0
# %bb.1:                                # %entry
	f64.const	$push7=, -0x1.999999999999ap-4
	f64.add 	$1=, $0, $pop7
	f64.const	$push17=, 0x1.965fe974a3401p1
	f64.ge  	$push8=, $1, $pop17
	f64.ne  	$push9=, $1, $1
	i32.or  	$push10=, $pop8, $pop9
	br_if   	0, $pop10       # 0: down to label0
# %bb.2:                                # %if.then
	i32.const	$push11=, 0
	call    	exit@FUNCTION, $pop11
	unreachable
.LBB0_3:                                # %if.else
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	exit, void, i32
	.functype	abort, void
