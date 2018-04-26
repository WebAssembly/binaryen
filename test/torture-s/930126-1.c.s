	.text
	.file	"930126-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32
# %bb.0:                                # %entry
	i64.load	$push0=, 0($1)
	i64.const	$push1=, -1099511627521
	i64.and 	$push2=, $pop0, $pop1
	i64.const	$push3=, 884479243264
	i64.or  	$push4=, $pop2, $pop3
	i64.store	0($0), $pop4
                                        # fallthrough-return
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
	i32.const	$push7=, 0
	i64.load	$push1=, main.i($pop7)
	i64.const	$push2=, -1099511627776
	i64.and 	$push3=, $pop1, $pop2
	i64.const	$push4=, 884479243276
	i64.or  	$push5=, $pop3, $pop4
	i64.store	main.i($pop0), $pop5
	i32.const	$push6=, 0
	call    	exit@FUNCTION, $pop6
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.type	main.i,@object          # @main.i
	.section	.bss.main.i,"aw",@nobits
	.p2align	3
main.i:
	.skip	8
	.size	main.i, 8


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	exit, void, i32
