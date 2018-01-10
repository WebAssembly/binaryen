	.text
	.file	"20030717-1.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar                     # -- Begin function bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32
# %bb.0:                                # %entry
	i32.load	$2=, 24($0)
	i32.load	$4=, 4($1)
	i32.const	$push20=, 20
	i32.mul 	$push0=, $2, $pop20
	i32.add 	$push1=, $0, $pop0
	i32.load	$push2=, 12($pop1)
	i32.sub 	$6=, $4, $pop2
	i32.const	$push19=, 31
	i32.shr_s	$7=, $6, $pop19
	i32.add 	$push3=, $6, $7
	i32.xor 	$5=, $pop3, $7
	i32.load16_u	$3=, 0($1)
	copy_local	$1=, $2
	copy_local	$8=, $2
.LBB0_1:                                # %do.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label0:
	block   	
	i32.const	$push21=, 0
	i32.gt_s	$push4=, $1, $pop21
	br_if   	0, $pop4        # 0: down to label1
# %bb.2:                                # %if.then
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push22=, 20
	i32.add 	$push5=, $0, $pop22
	i32.load	$1=, 0($pop5)
.LBB0_3:                                # %if.end
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label1:
	i32.const	$push25=, -1
	i32.add 	$1=, $1, $pop25
	i32.const	$push24=, 20
	i32.mul 	$push6=, $1, $pop24
	i32.add 	$push7=, $0, $pop6
	i32.load	$push8=, 12($pop7)
	i32.sub 	$6=, $4, $pop8
	i32.const	$push23=, 31
	i32.shr_s	$7=, $6, $pop23
	i32.add 	$push9=, $6, $7
	i32.xor 	$push10=, $pop9, $7
	i32.lt_u	$push11=, $pop10, $5
	i32.select	$8=, $1, $8, $pop11
	i32.ne  	$push12=, $1, $2
	br_if   	0, $pop12       # 0: up to label0
# %bb.4:                                # %do.end
	end_loop
	i32.const	$push16=, 20
	i32.mul 	$push17=, $8, $pop16
	i32.add 	$push18=, $0, $pop17
	i32.const	$push13=, 9
	i32.shr_u	$push14=, $3, $pop13
	i32.add 	$push15=, $pop14, $4
	i32.store	12($pop18), $pop15
	copy_local	$push26=, $8
                                        # fallthrough-return: $pop26
	.endfunc
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %bar.exit
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
