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
	block
	i32.load	$push0=, 0($2)
	tee_local	$push3=, $3=, $pop0
	i32.ge_u	$push1=, $pop3, $1
	br_if   	$pop1, 0
	i32.lt_u	$push2=, $3, $0
	br_if   	$pop2, 0
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

	.globl	div_tree
	.type	div_tree,@function
div_tree:
	.param  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
	.result 	i32
	i32.div_s	$push0=, $0, $1
	i32.div_s	$push1=, $2, $3
	i32.div_s	$push2=, $pop0, $pop1
	i32.div_s	$push3=, $4, $5
	i32.div_s	$push4=, $6, $7
	i32.div_s	$push5=, $pop3, $pop4
	i32.div_s	$push6=, $pop2, $pop5
	i32.div_s	$push7=, $8, $9
	i32.div_s	$push8=, $10, $11
	i32.div_s	$push9=, $pop7, $pop8
	i32.div_s	$push10=, $12, $13
	i32.div_s	$push11=, $14, $15
	i32.div_s	$push12=, $pop10, $pop11
	i32.div_s	$push13=, $pop9, $pop12
	i32.div_s	$push14=, $pop6, $pop13
	return  	$pop14
	.endfunc
.Lfunc_end7:
	.size	div_tree, .Lfunc_end7-div_tree

	.globl	simple_multiple_use
	.type	simple_multiple_use,@function
simple_multiple_use:
	.param  	i32, i32
	i32.mul 	$push0=, $1, $0
	tee_local	$push1=, $0=, $pop0
	call    	use_a@FUNCTION, $pop1
	call    	use_b@FUNCTION, $0
	return
	.endfunc
.Lfunc_end8:
	.size	simple_multiple_use, .Lfunc_end8-simple_multiple_use

	.globl	multiple_uses_in_same_insn
	.type	multiple_uses_in_same_insn,@function
multiple_uses_in_same_insn:
	.param  	i32, i32
	i32.mul 	$push0=, $1, $0
	tee_local	$push1=, $0=, $pop0
	call    	use_2@FUNCTION, $pop1, $0
	return
	.endfunc
.Lfunc_end9:
	.size	multiple_uses_in_same_insn, .Lfunc_end9-multiple_uses_in_same_insn

	.globl	commute
	.type	commute,@function
commute:
	.result 	i32
	i32.call	$push0=, red@FUNCTION
	i32.call	$push1=, green@FUNCTION
	i32.add 	$push2=, $pop0, $pop1
	i32.call	$push3=, blue@FUNCTION
	i32.add 	$push4=, $pop2, $pop3
	return  	$pop4
	.endfunc
.Lfunc_end10:
	.size	commute, .Lfunc_end10-commute


