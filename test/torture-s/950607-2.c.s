	.text
	.file	"950607-2.c"
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32, i32
	.result 	i32
	.local  	i32, i64
# BB#0:                                 # %entry
	i32.const	$push21=, 0
	i32.const	$push19=, 2
	i32.load	$push10=, 4($2)
	i32.load	$push28=, 4($0)
	tee_local	$push27=, $3=, $pop28
	i32.sub 	$push11=, $pop10, $pop27
	i64.extend_s/i32	$push12=, $pop11
	i32.load	$push7=, 0($1)
	i32.load	$push26=, 0($0)
	tee_local	$push25=, $0=, $pop26
	i32.sub 	$push8=, $pop7, $pop25
	i64.extend_s/i32	$push9=, $pop8
	i64.mul 	$push13=, $pop12, $pop9
	i32.load	$push3=, 0($2)
	i32.sub 	$push4=, $pop3, $0
	i64.extend_s/i32	$push5=, $pop4
	i32.load	$push0=, 4($1)
	i32.sub 	$push1=, $pop0, $3
	i64.extend_s/i32	$push2=, $pop1
	i64.mul 	$push6=, $pop5, $pop2
	i64.sub 	$push24=, $pop13, $pop6
	tee_local	$push23=, $4=, $pop24
	i64.const	$push16=, 63
	i64.shr_u	$push17=, $pop23, $pop16
	i32.wrap/i64	$push18=, $pop17
	i32.sub 	$push20=, $pop19, $pop18
	i64.const	$push14=, 0
	i64.gt_s	$push15=, $4, $pop14
	i32.select	$push22=, $pop21, $pop20, $pop15
                                        # fallthrough-return: $pop22
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
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	exit, void, i32
