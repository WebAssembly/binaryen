	.text
	.file	"pr33669.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i64, i32
	.result 	i64
	.local  	i32, i64, i64
# %bb.0:                                # %entry
	i32.load	$3=, 0($0)
	i64.extend_u/i32	$push1=, $3
	i64.rem_s	$4=, $1, $pop1
	i32.add 	$push0=, $2, $3
	i32.wrap/i64	$push2=, $4
	i32.add 	$push3=, $pop0, $pop2
	i32.const	$push4=, -1
	i32.add 	$2=, $pop3, $pop4
	i64.const	$5=, -1
	block   	
	i32.rem_u	$push5=, $2, $3
	i32.sub 	$push6=, $2, $pop5
	i32.lt_u	$push7=, $3, $pop6
	br_if   	0, $pop7        # 0: down to label0
# %bb.1:                                # %if.end
	i64.sub 	$5=, $1, $4
	i32.load	$push8=, 4($0)
	i32.le_u	$push9=, $pop8, $3
	br_if   	0, $pop9        # 0: down to label0
# %bb.2:                                # %if.then13
	i32.const	$push10=, 4
	i32.add 	$push11=, $0, $pop10
	i32.store	0($pop11), $3
.LBB0_3:                                # %cleanup
	end_block                       # label0:
	copy_local	$push12=, $5
                                        # fallthrough-return: $pop12
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %if.end
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
