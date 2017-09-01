	.text
	.file	"980716-1.c"
	.section	.text.stub,"ax",@progbits
	.hidden	stub                    # -- Begin function stub
	.globl	stub
	.type	stub,@function
stub:                                   # @stub
	.param  	i32, i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push1=, 0
	i32.load	$push0=, __stack_pointer($pop1)
	i32.const	$push2=, 16
	i32.sub 	$push4=, $pop0, $pop2
	tee_local	$push3=, $5=, $pop4
	i32.store	12($pop3), $1
	copy_local	$4=, $1
.LBB0_1:                                # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label0:
	i32.const	$push7=, 4
	i32.add 	$push6=, $4, $pop7
	tee_local	$push5=, $2=, $pop6
	i32.store	12($5), $pop5
	i32.load	$3=, 0($4)
	copy_local	$4=, $2
	br_if   	0, $3           # 0: up to label0
# BB#2:                                 # %while.end
	end_loop
	i32.store	12($5), $1
.LBB0_3:                                # %while.cond.1
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.const	$push10=, 4
	i32.add 	$push9=, $1, $pop10
	tee_local	$push8=, $4=, $pop9
	i32.store	12($5), $pop8
	i32.load	$2=, 0($1)
	copy_local	$1=, $4
	br_if   	0, $2           # 0: up to label1
# BB#4:                                 # %while.end.1
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
# BB#0:                                 # %entry
	i32.const	$push7=, 0
	i32.const	$push5=, 0
	i32.load	$push4=, __stack_pointer($pop5)
	i32.const	$push6=, 16
	i32.sub 	$push10=, $pop4, $pop6
	tee_local	$push9=, $0=, $pop10
	i32.store	__stack_pointer($pop7), $pop9
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


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	exit, void, i32
