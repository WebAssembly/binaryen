	.text
	.file	"980716-1.c"
	.section	.text.stub,"ax",@progbits
	.hidden	stub                    # -- Begin function stub
	.globl	stub
	.type	stub,@function
stub:                                   # @stub
	.param  	i32, i32
	.local  	i32, i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push1=, 0
	i32.load	$push0=, __stack_pointer($pop1)
	i32.const	$push2=, 16
	i32.sub 	$5=, $pop0, $pop2
	i32.store	12($5), $1
	copy_local	$4=, $1
.LBB0_1:                                # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label0:
	i32.const	$push3=, 4
	i32.add 	$2=, $4, $pop3
	i32.store	12($5), $2
	i32.load	$3=, 0($4)
	copy_local	$4=, $2
	br_if   	0, $3           # 0: up to label0
# %bb.2:                                # %while.end
	end_loop
	i32.store	12($5), $1
.LBB0_3:                                # %while.cond.1
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.const	$push4=, 4
	i32.add 	$4=, $1, $pop4
	i32.store	12($5), $4
	i32.load	$2=, 0($1)
	copy_local	$1=, $4
	br_if   	0, $2           # 0: up to label1
# %bb.4:                                # %while.end.1
	end_loop
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	stub, .Lfunc_end0-stub
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push5=, 0
	i32.load	$push4=, __stack_pointer($pop5)
	i32.const	$push6=, 16
	i32.sub 	$0=, $pop4, $pop6
	i32.const	$push7=, 0
	i32.store	__stack_pointer($pop7), $0
	i32.const	$push0=, 0
	i32.store	12($0), $pop0
	i32.const	$push1=, .L.str.2
	i32.store	8($0), $pop1
	i32.const	$push2=, .L.str.1
	i32.store	4($0), $pop2
	i32.const	$push3=, .L.str
	i32.store	0($0), $pop3
	call    	stub@FUNCTION, $0, $0
	i32.const	$push8=, 0
	call    	exit@FUNCTION, $pop8
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"ab"
	.size	.L.str, 3

	.type	.L.str.1,@object        # @.str.1
.L.str.1:
	.asciz	"bc"
	.size	.L.str.1, 3

	.type	.L.str.2,@object        # @.str.2
.L.str.2:
	.asciz	"cx"
	.size	.L.str.2, 3


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	exit, void, i32
