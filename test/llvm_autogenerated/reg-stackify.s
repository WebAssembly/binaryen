	.text
	.file	"/s/llvm-upstream/llvm/test/CodeGen/WebAssembly/reg-stackify.ll"
	.globl	no0
	.type	no0,@function
no0:
.Lfunc_begin0:
	.param  	i32, i32
	.result 	i32
	i32.load	$1=, 0($1)
	i32.const	$push0=, 0
	i32.store	0($0), $pop0
	return  	$1
	.endfunc
.Lfunc_end0:
	.size	no0, .Lfunc_end0-no0

	.globl	no1
	.type	no1,@function
no1:
.Lfunc_begin1:
	.param  	i32, i32
	.result 	i32
	i32.load	$1=, 0($1)
	i32.const	$push0=, 0
	i32.store	0($0), $pop0
	return  	$1
	.endfunc
.Lfunc_end1:
	.size	no1, .Lfunc_end1-no1

	.globl	yes0
	.type	yes0,@function
yes0:
.Lfunc_begin2:
	.param  	i32, i32
	.result 	i32
	i32.const	$push0=, 0
	i32.store	0($0), $pop0
	i32.load	$push1=, 0($1)
	return  	$pop1
	.endfunc
.Lfunc_end2:
	.size	yes0, .Lfunc_end2-yes0

	.globl	yes1
	.type	yes1,@function
yes1:
.Lfunc_begin3:
	.param  	i32
	.result 	i32
	i32.load	$push0=, 0($0)
	return  	$pop0
	.endfunc
.Lfunc_end3:
	.size	yes1, .Lfunc_end3-yes1

	.globl	sink_trap
	.type	sink_trap,@function
sink_trap:
.Lfunc_begin4:
	.param  	i32, i32, i32
	.result 	i32
	i32.const	$push0=, 0
	i32.store	0($2), $pop0
	i32.div_s	$push1=, $0, $1
	return  	$pop1
	.endfunc
.Lfunc_end4:
	.size	sink_trap, .Lfunc_end4-sink_trap

	.globl	sink_readnone_call
	.type	sink_readnone_call,@function
sink_readnone_call:
.Lfunc_begin5:
	.param  	i32, i32, i32
	.result 	i32
	i32.const	$push1=, 0
	i32.store	0($2), $pop1
	i32.call	$push0=, readnone_callee@FUNCTION
	return  	$pop0
	.endfunc
.Lfunc_end5:
	.size	sink_readnone_call, .Lfunc_end5-sink_readnone_call

	.globl	no_sink_readonly_call
	.type	no_sink_readonly_call,@function
no_sink_readonly_call:
.Lfunc_begin6:
	.param  	i32, i32, i32
	.result 	i32
	.local  	i32
	i32.call	$3=, readonly_callee@FUNCTION
	i32.const	$push0=, 0
	i32.store	0($2), $pop0
	return  	$3
	.endfunc
.Lfunc_end6:
	.size	no_sink_readonly_call, .Lfunc_end6-no_sink_readonly_call

	.globl	stack_uses
	.type	stack_uses,@function
stack_uses:
.Lfunc_begin7:
	.param  	i32, i32, i32, i32
	.result 	i32
	block   	
	i32.const	$push13=, 1
	i32.lt_s	$push5=, $0, $pop13
	i32.const	$push0=, 2
	i32.lt_s	$push4=, $1, $pop0
	i32.xor 	$push6=, $pop5, $pop4
	i32.const	$push12=, 1
	i32.lt_s	$push2=, $2, $pop12
	i32.const	$push11=, 2
	i32.lt_s	$push1=, $3, $pop11
	i32.xor 	$push3=, $pop2, $pop1
	i32.xor 	$push7=, $pop6, $pop3
	i32.const	$push10=, 1
	i32.ne  	$push8=, $pop7, $pop10
	br_if   	0, $pop8
	i32.const	$push9=, 0
	return  	$pop9
.LBB7_2:
	end_block
	i32.const	$push14=, 1
	return  	$pop14
	.endfunc
.Lfunc_end7:
	.size	stack_uses, .Lfunc_end7-stack_uses

	.globl	multiple_uses
	.type	multiple_uses,@function
multiple_uses:
.Lfunc_begin8:
	.param  	i32, i32, i32
	.local  	i32
	block   	
	i32.load	$push3=, 0($2)
	tee_local	$push2=, $3=, $pop3
	i32.ge_u	$push0=, $pop2, $1
	br_if   	0, $pop0
	i32.lt_u	$push1=, $3, $0
	br_if   	0, $pop1
	i32.store	0($2), $3
.LBB8_3:
	end_block
	return
	.endfunc
.Lfunc_end8:
	.size	multiple_uses, .Lfunc_end8-multiple_uses

	.hidden	stackify_store_across_side_effects
	.globl	stackify_store_across_side_effects
	.type	stackify_store_across_side_effects,@function
stackify_store_across_side_effects:
.Lfunc_begin9:
	.param  	i32
	i64.const	$push0=, 4611686018427387904
	i64.store	0($0), $pop0
	call    	evoke_side_effects@FUNCTION
	i64.const	$push1=, 4611686018427387904
	i64.store	0($0), $pop1
	call    	evoke_side_effects@FUNCTION
	return
	.endfunc
.Lfunc_end9:
	.size	stackify_store_across_side_effects, .Lfunc_end9-stackify_store_across_side_effects

	.globl	div_tree
	.type	div_tree,@function
div_tree:
.Lfunc_begin10:
	.param  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
	.result 	i32
	i32.div_s	$push11=, $0, $1
	i32.div_s	$push10=, $2, $3
	i32.div_s	$push12=, $pop11, $pop10
	i32.div_s	$push8=, $4, $5
	i32.div_s	$push7=, $6, $7
	i32.div_s	$push9=, $pop8, $pop7
	i32.div_s	$push13=, $pop12, $pop9
	i32.div_s	$push4=, $8, $9
	i32.div_s	$push3=, $10, $11
	i32.div_s	$push5=, $pop4, $pop3
	i32.div_s	$push1=, $12, $13
	i32.div_s	$push0=, $14, $15
	i32.div_s	$push2=, $pop1, $pop0
	i32.div_s	$push6=, $pop5, $pop2
	i32.div_s	$push14=, $pop13, $pop6
	return  	$pop14
	.endfunc
.Lfunc_end10:
	.size	div_tree, .Lfunc_end10-div_tree

	.globl	simple_multiple_use
	.type	simple_multiple_use,@function
simple_multiple_use:
.Lfunc_begin11:
	.param  	i32, i32
	i32.mul 	$push1=, $1, $0
	tee_local	$push0=, $1=, $pop1
	call    	use_a@FUNCTION, $pop0
	call    	use_b@FUNCTION, $1
	return
	.endfunc
.Lfunc_end11:
	.size	simple_multiple_use, .Lfunc_end11-simple_multiple_use

	.globl	multiple_uses_in_same_insn
	.type	multiple_uses_in_same_insn,@function
multiple_uses_in_same_insn:
.Lfunc_begin12:
	.param  	i32, i32
	i32.mul 	$push1=, $1, $0
	tee_local	$push0=, $1=, $pop1
	call    	use_2@FUNCTION, $pop0, $1
	return
	.endfunc
.Lfunc_end12:
	.size	multiple_uses_in_same_insn, .Lfunc_end12-multiple_uses_in_same_insn

	.globl	commute
	.type	commute,@function
commute:
.Lfunc_begin13:
	.result 	i32
	i32.call	$push0=, red@FUNCTION
	i32.call	$push1=, green@FUNCTION
	i32.add 	$push2=, $pop0, $pop1
	i32.call	$push3=, blue@FUNCTION
	i32.add 	$push4=, $pop2, $pop3
	return  	$pop4
	.endfunc
.Lfunc_end13:
	.size	commute, .Lfunc_end13-commute

	.globl	no_stackify_past_use
	.type	no_stackify_past_use,@function
no_stackify_past_use:
.Lfunc_begin14:
	.param  	i32
	.result 	i32
	.local  	i32
	i32.call	$1=, callee@FUNCTION, $0
	i32.const	$push0=, 1
	i32.add 	$push1=, $0, $pop0
	i32.call	$push2=, callee@FUNCTION, $pop1
	i32.sub 	$push3=, $pop2, $1
	i32.div_s	$push4=, $pop3, $1
	return  	$pop4
	.endfunc
.Lfunc_end14:
	.size	no_stackify_past_use, .Lfunc_end14-no_stackify_past_use

	.globl	commute_to_fix_ordering
	.type	commute_to_fix_ordering,@function
commute_to_fix_ordering:
.Lfunc_begin15:
	.param  	i32
	.result 	i32
	.local  	i32
	i32.call	$push6=, callee@FUNCTION, $0
	tee_local	$push5=, $1=, $pop6
	i32.const	$push0=, 1
	i32.add 	$push1=, $0, $pop0
	i32.call	$push2=, callee@FUNCTION, $pop1
	i32.add 	$push3=, $1, $pop2
	i32.mul 	$push4=, $pop5, $pop3
	return  	$pop4
	.endfunc
.Lfunc_end15:
	.size	commute_to_fix_ordering, .Lfunc_end15-commute_to_fix_ordering

	.globl	multiple_defs
	.type	multiple_defs,@function
multiple_defs:
.Lfunc_begin16:
	.param  	i32, i32, i32, i32, i32
	.local  	f64, f64, f64, f64, f64
	f64.const	$6=, 0x0p0
	i32.const	$push3=, 1
	i32.and 	$2=, $2, $pop3
	i32.const	$push12=, 1
	i32.and 	$3=, $3, $pop12
	f64.const	$push11=, -0x1.62cc8f5c28f5cp13
	f64.const	$push9=, -0x1.e147ae147bp-3
	i32.const	$push5=, 2
	i32.or  	$push6=, $1, $pop5
	i32.const	$push7=, 14
	i32.eq  	$push8=, $pop6, $pop7
	f64.select	$5=, $pop11, $pop9, $pop8
	f64.const	$7=, 0x0p0
.LBB16_1:
	loop    	
	block   	
	f64.const	$push14=, 0x1.73c083126e979p4
	f64.ge  	$push0=, $7, $pop14
	f64.ne  	$push1=, $7, $7
	i32.or  	$push2=, $pop0, $pop1
	br_if   	0, $pop2
	copy_local	$8=, $6
.LBB16_3:
	loop    	
	f64.const	$push20=, -0x1.62cc8f5c28f5cp13
	f64.const	$push19=, -0x1p0
	f64.add 	$push18=, $7, $pop19
	tee_local	$push17=, $9=, $pop18
	f64.select	$push4=, $pop20, $pop17, $2
	copy_local	$push16=, $8
	tee_local	$push15=, $6=, $pop16
	f64.add 	$8=, $pop4, $pop15
	block   	
	br_if   	0, $3
	copy_local	$9=, $5
.LBB16_5:
	end_block
	f64.add 	$8=, $9, $8
	f64.const	$push21=, 0x1.73c083126e979p4
	f64.lt  	$push10=, $7, $pop21
	br_if   	0, $pop10
.LBB16_6:
	end_loop
	end_block
	f64.const	$push13=, 0x1p0
	f64.add 	$7=, $7, $pop13
	br      	0
.LBB16_7:
	end_loop
	.endfunc
.Lfunc_end16:
	.size	multiple_defs, .Lfunc_end16-multiple_defs

	.globl	no_stackify_call_past_load
	.type	no_stackify_call_past_load,@function
no_stackify_call_past_load:
.Lfunc_begin17:
	.result 	i32
	.local  	i32, i32
	i32.call	$0=, red@FUNCTION
	i32.const	$push0=, 0
	i32.load	$1=, count($pop0)
	i32.call	$drop=, callee@FUNCTION, $0
	return  	$1
	.endfunc
.Lfunc_end17:
	.size	no_stackify_call_past_load, .Lfunc_end17-no_stackify_call_past_load

	.globl	no_stackify_store_past_load
	.type	no_stackify_store_past_load,@function
no_stackify_store_past_load:
.Lfunc_begin18:
	.param  	i32, i32, i32
	.result 	i32
	i32.store	0($1), $0
	i32.load	$2=, 0($2)
	i32.call	$drop=, callee@FUNCTION, $0
	return  	$2
	.endfunc
.Lfunc_end18:
	.size	no_stackify_store_past_load, .Lfunc_end18-no_stackify_store_past_load

	.globl	store_past_invar_load
	.type	store_past_invar_load,@function
store_past_invar_load:
.Lfunc_begin19:
	.param  	i32, i32, i32
	.result 	i32
	i32.store	0($1), $0
	i32.call	$drop=, callee@FUNCTION, $0
	i32.load	$push0=, 0($2)
	return  	$pop0
	.endfunc
.Lfunc_end19:
	.size	store_past_invar_load, .Lfunc_end19-store_past_invar_load

	.globl	ignore_dbg_value
	.type	ignore_dbg_value,@function
ignore_dbg_value:
.Lfunc_begin20:
	unreachable
	.endfunc
.Lfunc_end20:
	.size	ignore_dbg_value, .Lfunc_end20-ignore_dbg_value

	.globl	no_stackify_past_epilogue
	.type	no_stackify_past_epilogue,@function
no_stackify_past_epilogue:
.Lfunc_begin21:
	.result 	i32
	.local  	i32, i32
	i32.const	$push3=, 0
	i32.const	$push0=, 0
	i32.load	$push1=, __stack_pointer($pop0)
	i32.const	$push2=, 16
	i32.sub 	$push10=, $pop1, $pop2
	tee_local	$push9=, $1=, $pop10
	i32.store	__stack_pointer($pop3), $pop9
	i32.const	$push7=, 12
	i32.add 	$push8=, $1, $pop7
	i32.call	$0=, use_memory@FUNCTION, $pop8
	i32.const	$push6=, 0
	i32.const	$push4=, 16
	i32.add 	$push5=, $1, $pop4
	i32.store	__stack_pointer($pop6), $pop5
	return  	$0
	.endfunc
.Lfunc_end21:
	.size	no_stackify_past_epilogue, .Lfunc_end21-no_stackify_past_epilogue

	.globl	stackify_indvar
	.type	stackify_indvar,@function
stackify_indvar:
.Lfunc_begin22:
	.param  	i32, i32
	.local  	i32
	i32.const	$2=, 0
.LBB22_1:
	loop    	
	i32.load	$push0=, 0($1)
	i32.add 	$push1=, $2, $pop0
	i32.store	0($1), $pop1
	i32.const	$push5=, 1
	i32.add 	$push4=, $2, $pop5
	tee_local	$push3=, $2=, $pop4
	i32.ne  	$push2=, $0, $pop3
	br_if   	0, $pop2
	end_loop
	return
	.endfunc
.Lfunc_end22:
	.size	stackify_indvar, .Lfunc_end22-stackify_indvar

	.globl	stackpointer_dependency
	.type	stackpointer_dependency,@function
stackpointer_dependency:
.Lfunc_begin23:
	.param  	i32
	.result 	i32
	.local  	i32
	i32.const	$push0=, 0
	i32.load	$push2=, __stack_pointer($pop0)
	copy_local	$push4=, $pop2
	tee_local	$push3=, $1=, $pop4
	i32.call	$0=, stackpointer_callee@FUNCTION, $0, $pop3
	i32.const	$push1=, 0
	i32.store	__stack_pointer($pop1), $1
	return  	$0
	.endfunc
.Lfunc_end23:
	.size	stackpointer_dependency, .Lfunc_end23-stackpointer_dependency

	.globl	call_indirect_stackify
	.type	call_indirect_stackify,@function
call_indirect_stackify:
.Lfunc_begin24:
	.param  	i32, i32
	.result 	i32
	i32.load	$push4=, 0($0)
	tee_local	$push3=, $0=, $pop4
	i32.load	$push0=, 0($0)
	i32.load	$push1=, 0($pop0)
	i32.call_indirect	$push2=, $pop3, $1, $pop1
	return  	$pop2
	.endfunc
.Lfunc_end24:
	.size	call_indirect_stackify, .Lfunc_end24-call_indirect_stackify

	.hidden	count
	.type	count,@object
	.bss
	.globl	count
	.p2align	2
count:
	.int32	0
	.size	count, 4

	.section	.debug_str,"MS",@progbits,1
.Linfo_string0:
	.asciz	"clang version 3.9.0 (trunk 266005) (llvm/trunk 266105)"
.Linfo_string1:
	.asciz	"test.c"
.Linfo_string2:
	.asciz	"/"
	.section	.debug_loc,"",@progbits
	.section	.debug_abbrev,"",@progbits
.Lsection_abbrev:
	.int8	1
	.int8	17
	.int8	0
	.int8	37
	.int8	14
	.int8	19
	.int8	5
	.int8	3
	.int8	14
	.int8	16
	.int8	23
	.int8	27
	.int8	14
	.int8	0
	.int8	0
	.int8	0
	.section	.debug_info,"",@progbits
.Lsection_info:
.Lcu_begin0:
	.int32	26
	.int16	4
	.int32	.Lsection_abbrev
	.int8	4
	.int8	1
	.int32	.Linfo_string0
	.int16	12
	.int32	.Linfo_string1
	.int32	.Lline_table_start0
	.int32	.Linfo_string2
	.section	.debug_ranges,"",@progbits
.Ldebug_range:
	.section	.debug_macinfo,"",@progbits
.Ldebug_macinfo:
.Lcu_macro_begin0:
	.int8	0

	.functype	readnone_callee, i32
	.functype	readonly_callee, i32
	.functype	evoke_side_effects, void
	.functype	use_a, void, i32
	.functype	use_b, void, i32
	.functype	use_2, void, i32, i32
	.functype	red, i32
	.functype	green, i32
	.functype	blue, i32
	.functype	callee, i32, i32
	.functype	use_memory, i32, i32
	.functype	stackpointer_callee, i32, i32, i32
	.section	.debug_line,"",@progbits
.Lline_table_start0:
