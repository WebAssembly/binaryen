	.text
	.file	"20051110-1.c"
	.section	.text.add_unwind_adjustsp,"ax",@progbits
	.hidden	add_unwind_adjustsp     # -- Begin function add_unwind_adjustsp
	.globl	add_unwind_adjustsp
	.type	add_unwind_adjustsp,@function
add_unwind_adjustsp:                    # @add_unwind_adjustsp
	.param  	i32
	.local  	i32, i32
# %bb.0:                                # %entry
	i32.const	$push0=, -516
	i32.add 	$push1=, $0, $pop0
	i32.const	$push2=, 2
	i32.shr_s	$0=, $pop1, $pop2
	block   	
	i32.eqz 	$push10=, $0
	br_if   	0, $pop10       # 0: down to label0
# %bb.1:                                # %while.body.preheader
	i32.const	$2=, bytes
.LBB0_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.const	$push9=, 7
	i32.shr_u	$1=, $0, $pop9
	i32.const	$push8=, 128
	i32.or  	$push4=, $0, $pop8
	i32.const	$push7=, 127
	i32.and 	$push3=, $0, $pop7
	i32.select	$push5=, $pop4, $pop3, $1
	i32.store8	0($2), $pop5
	i32.const	$push6=, 1
	i32.add 	$2=, $2, $pop6
	copy_local	$0=, $1
	br_if   	0, $1           # 0: up to label1
.LBB0_3:                                # %while.end
	end_loop
	end_block                       # label0:
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	add_unwind_adjustsp, .Lfunc_end0-add_unwind_adjustsp
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %if.end
	i32.const	$push1=, 0
	i32.const	$push0=, 1928
	i32.store16	bytes($pop1):p2align=0, $pop0
	i32.const	$push2=, 0
                                        # fallthrough-return: $pop2
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	bytes                   # @bytes
	.type	bytes,@object
	.section	.bss.bytes,"aw",@nobits
	.globl	bytes
bytes:
	.skip	5
	.size	bytes, 5


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
