	.text
	.file	"/s/llvm/llvm/test/CodeGen/WebAssembly/reg-stackify.ll"
	.globl	no0
	.type	no0,@function
no0:
	.param  	i32, i32
	.result 	i32
	i32.load	$1=, 0($1)
	i32.const	$push0=, 0
	i32.store	$discard=, 0($0), $pop0
	return  	$1
	.endfunc
.Lfunc_end0:
	.size	no0, .Lfunc_end0-no0

	.globl	no1
	.type	no1,@function
no1:
	.param  	i32, i32
	.result 	i32
	i32.load	$1=, 0($1)
	i32.const	$push0=, 0
	i32.store	$discard=, 0($0), $pop0
	return  	$1
	.endfunc
.Lfunc_end1:
	.size	no1, .Lfunc_end1-no1

	.globl	yes0
	.type	yes0,@function
yes0:
	.param  	i32, i32
	.result 	i32
	i32.const	$push1=, 0
	i32.store	$discard=, 0($0), $pop1
	i32.load	$push0=, 0($1)
	return  	$pop0
	.endfunc
.Lfunc_end2:
	.size	yes0, .Lfunc_end2-yes0

	.globl	yes1
	.type	yes1,@function
yes1:
	.param  	i32
	.result 	i32
	i32.load	$push0=, 0($0)
	return  	$pop0
	.endfunc
.Lfunc_end3:
	.size	yes1, .Lfunc_end3-yes1

	.globl	stack_uses
	.type	stack_uses,@function
stack_uses:
	.param  	i32, i32, i32, i32
	.result 	i32
	block
	i32.const	$push13=, 1
	i32.lt_s	$push0=, $0, $pop13
	i32.const	$push1=, 2
	i32.lt_s	$push2=, $1, $pop1
	i32.xor 	$push5=, $pop0, $pop2
	i32.const	$push12=, 1
	i32.lt_s	$push3=, $2, $pop12
	i32.const	$push11=, 2
	i32.lt_s	$push4=, $3, $pop11
	i32.xor 	$push6=, $pop3, $pop4
	i32.xor 	$push7=, $pop5, $pop6
	i32.const	$push10=, 1
	i32.ne  	$push8=, $pop7, $pop10
	br_if   	$pop8, 0
	i32.const	$push9=, 0
	return  	$pop9
.LBB4_2:
	end_block
	i32.const	$push14=, 1
	return  	$pop14
	.endfunc
.Lfunc_end4:
	.size	stack_uses, .Lfunc_end4-stack_uses

	.globl	multiple_uses
	.type	multiple_uses,@function
multiple_uses:
	.param  	i32, i32, i32
	.local  	i32
	i32.load	$3=, 0($2)
	block
	i32.ge_u	$push0=, $3, $1
	br_if   	$pop0, 0
	i32.lt_u	$push1=, $3, $0
	br_if   	$pop1, 0
	i32.store	$discard=, 0($2), $3
.LBB5_3:
	end_block
	return
	.endfunc
.Lfunc_end5:
	.size	multiple_uses, .Lfunc_end5-multiple_uses

	.hidden	stackify_store_across_side_effects
	.globl	stackify_store_across_side_effects
	.type	stackify_store_across_side_effects,@function
stackify_store_across_side_effects:
	.param  	i32
	.local  	i64
	i64.const	$push0=, 4611686018427387904
	i64.store	$1=, 0($0), $pop0
	call    	evoke_side_effects@FUNCTION
	i64.store	$discard=, 0($0), $1
	call    	evoke_side_effects@FUNCTION
	return
	.endfunc
.Lfunc_end6:
	.size	stackify_store_across_side_effects, .Lfunc_end6-stackify_store_across_side_effects


