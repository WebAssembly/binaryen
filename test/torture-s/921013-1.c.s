	.text
	.file	"921013-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32, i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block   	
	i32.eqz 	$push9=, $3
	br_if   	0, $pop9        # 0: down to label0
# BB#1:                                 # %while.body.preheader
.LBB0_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	f32.load	$push1=, 0($1)
	f32.load	$push0=, 0($2)
	f32.eq  	$push2=, $pop1, $pop0
	i32.store	0($0), $pop2
	i32.const	$push8=, 4
	i32.add 	$0=, $0, $pop8
	i32.const	$push7=, 4
	i32.add 	$2=, $2, $pop7
	i32.const	$push6=, 4
	i32.add 	$1=, $1, $pop6
	i32.const	$push5=, -1
	i32.add 	$push4=, $3, $pop5
	tee_local	$push3=, $3=, $pop4
	br_if   	0, $pop3        # 0: up to label1
.LBB0_3:                                # %while.end
	end_loop
	end_block                       # label0:
	copy_local	$push10=, $0
                                        # fallthrough-return: $pop10
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
# BB#0:                                 # %for.cond.3
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	exit, void, i32
