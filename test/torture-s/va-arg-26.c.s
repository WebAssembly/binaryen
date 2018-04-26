	.text
	.file	"va-arg-26.c"
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	f32, f32, f32, f32, f32, f32, i32
	.result 	f64
# %bb.0:                                # %entry
	i32.const	$push0=, 7
	i32.add 	$push1=, $6, $pop0
	i32.const	$push2=, -8
	i32.and 	$6=, $pop1, $pop2
	i32.const	$push7=, 0
	i32.load	$push6=, __stack_pointer($pop7)
	i32.const	$push8=, 16
	i32.sub 	$push9=, $pop6, $pop8
	i32.const	$push3=, 8
	i32.add 	$push4=, $6, $pop3
	i32.store	12($pop9), $pop4
	f64.load	$push5=, 0($6)
                                        # fallthrough-return: $pop5
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
	.local  	f32, i32
# %bb.0:                                # %entry
	i32.const	$push6=, 0
	i32.load	$push5=, __stack_pointer($pop6)
	i32.const	$push7=, 16
	i32.sub 	$1=, $pop5, $pop7
	i32.const	$push8=, 0
	i32.store	__stack_pointer($pop8), $1
	i64.const	$push0=, 4619567317775286272
	i64.store	0($1), $pop0
	block   	
	f64.call	$push1=, f@FUNCTION, $0, $0, $0, $0, $0, $0, $1
	f64.const	$push2=, 0x1.cp2
	f64.eq  	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label0
# %bb.1:                                # %if.then
	call    	abort@FUNCTION
	unreachable
.LBB1_2:                                # %if.end
	end_block                       # label0:
	i32.const	$push4=, 0
	call    	exit@FUNCTION, $pop4
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
