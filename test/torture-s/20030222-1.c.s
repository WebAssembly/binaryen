	.text
	.file	"20030222-1.c"
	.section	.text.ll_to_int,"ax",@progbits
	.hidden	ll_to_int               # -- Begin function ll_to_int
	.globl	ll_to_int
	.type	ll_to_int,@function
ll_to_int:                              # @ll_to_int
	.param  	i64, i32
# BB#0:                                 # %entry
	#APP
	#NO_APP
	i64.store32	0($1), $0
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	ll_to_int, .Lfunc_end0-ll_to_int
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i64, i32, i32
# BB#0:                                 # %entry
	i32.const	$push5=, 0
	i32.const	$push3=, 0
	i32.load	$push2=, __stack_pointer($pop3)
	i32.const	$push4=, 16
	i32.sub 	$push10=, $pop2, $pop4
	tee_local	$push9=, $2=, $pop10
	i32.store	__stack_pointer($pop5), $pop9
	i32.const	$push8=, 0
	i32.load	$push7=, val($pop8)
	tee_local	$push6=, $1=, $pop7
	i64.extend_s/i32	$0=, $pop6
	#APP
	#NO_APP
	i64.store32	12($2), $0
	block   	
	i32.load	$push0=, 12($2)
	i32.ne  	$push1=, $1, $pop0
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push11=, 0
	call    	exit@FUNCTION, $pop11
	unreachable
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	val                     # @val
	.type	val,@object
	.section	.data.val,"aw",@progbits
	.globl	val
	.p2align	2
val:
	.int32	2147483649              # 0x80000001
	.size	val, 4


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
	.functype	exit, void, i32
