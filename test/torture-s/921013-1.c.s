	.text
	.file	"921013-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32, i32, i32
	.result 	i32
# %bb.0:                                # %entry
	block   	
	i32.eqz 	$push7=, $3
	br_if   	0, $pop7        # 0: down to label0
# %bb.1:                                # %while.body.preheader
.LBB0_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	f32.load	$push1=, 0($1)
	f32.load	$push0=, 0($2)
	f32.eq  	$push2=, $pop1, $pop0
	i32.store	0($0), $pop2
	i32.const	$push6=, 4
	i32.add 	$0=, $0, $pop6
	i32.const	$push5=, 4
	i32.add 	$2=, $2, $pop5
	i32.const	$push4=, 4
	i32.add 	$1=, $1, $pop4
	i32.const	$push3=, -1
	i32.add 	$3=, $3, $pop3
	br_if   	0, $3           # 0: up to label1
.LBB0_3:                                # %while.end
	end_loop
	end_block                       # label0:
	copy_local	$push8=, $3
                                        # fallthrough-return: $pop8
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
# %bb.0:                                # %for.cond.3
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	exit, void, i32
