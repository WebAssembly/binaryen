	.text
	.file	"/s/llvm/llvm/test/CodeGen/WebAssembly/offset.ll"
	.globl	load_i32_with_folded_offset
	.type	load_i32_with_folded_offset,@function
load_i32_with_folded_offset:
	.param  	i32
	.result 	i32
	i32.load	$push0=, 24($0)
	return  	$pop0
func_end0:
	.size	load_i32_with_folded_offset, func_end0-load_i32_with_folded_offset

	.globl	load_i32_with_folded_gep_offset
	.type	load_i32_with_folded_gep_offset,@function
load_i32_with_folded_gep_offset:
	.param  	i32
	.result 	i32
	i32.load	$push0=, 24($0)
	return  	$pop0
func_end1:
	.size	load_i32_with_folded_gep_offset, func_end1-load_i32_with_folded_gep_offset

	.globl	load_i32_with_unfolded_gep_negative_offset
	.type	load_i32_with_unfolded_gep_negative_offset,@function
load_i32_with_unfolded_gep_negative_offset:
	.param  	i32
	.result 	i32
	i32.const	$push0=, -24
	i32.add 	$push1=, $0, $pop0
	i32.load	$push2=, 0($pop1)
	return  	$pop2
func_end2:
	.size	load_i32_with_unfolded_gep_negative_offset, func_end2-load_i32_with_unfolded_gep_negative_offset

	.globl	load_i32_with_unfolded_offset
	.type	load_i32_with_unfolded_offset,@function
load_i32_with_unfolded_offset:
	.param  	i32
	.result 	i32
	i32.const	$push0=, 24
	i32.add 	$push1=, $0, $pop0
	i32.load	$push2=, 0($pop1)
	return  	$pop2
func_end3:
	.size	load_i32_with_unfolded_offset, func_end3-load_i32_with_unfolded_offset

	.globl	load_i32_with_unfolded_gep_offset
	.type	load_i32_with_unfolded_gep_offset,@function
load_i32_with_unfolded_gep_offset:
	.param  	i32
	.result 	i32
	i32.const	$push0=, 24
	i32.add 	$push1=, $0, $pop0
	i32.load	$push2=, 0($pop1)
	return  	$pop2
func_end4:
	.size	load_i32_with_unfolded_gep_offset, func_end4-load_i32_with_unfolded_gep_offset

	.globl	load_i64_with_folded_offset
	.type	load_i64_with_folded_offset,@function
load_i64_with_folded_offset:
	.param  	i32
	.result 	i64
	i64.load	$push0=, 24($0)
	return  	$pop0
func_end5:
	.size	load_i64_with_folded_offset, func_end5-load_i64_with_folded_offset

	.globl	load_i64_with_folded_gep_offset
	.type	load_i64_with_folded_gep_offset,@function
load_i64_with_folded_gep_offset:
	.param  	i32
	.result 	i64
	i64.load	$push0=, 24($0)
	return  	$pop0
func_end6:
	.size	load_i64_with_folded_gep_offset, func_end6-load_i64_with_folded_gep_offset

	.globl	load_i64_with_unfolded_gep_negative_offset
	.type	load_i64_with_unfolded_gep_negative_offset,@function
load_i64_with_unfolded_gep_negative_offset:
	.param  	i32
	.result 	i64
	i32.const	$push0=, -24
	i32.add 	$push1=, $0, $pop0
	i64.load	$push2=, 0($pop1)
	return  	$pop2
func_end7:
	.size	load_i64_with_unfolded_gep_negative_offset, func_end7-load_i64_with_unfolded_gep_negative_offset

	.globl	load_i64_with_unfolded_offset
	.type	load_i64_with_unfolded_offset,@function
load_i64_with_unfolded_offset:
	.param  	i32
	.result 	i64
	i32.const	$push0=, 24
	i32.add 	$push1=, $0, $pop0
	i64.load	$push2=, 0($pop1)
	return  	$pop2
func_end8:
	.size	load_i64_with_unfolded_offset, func_end8-load_i64_with_unfolded_offset

	.globl	load_i64_with_unfolded_gep_offset
	.type	load_i64_with_unfolded_gep_offset,@function
load_i64_with_unfolded_gep_offset:
	.param  	i32
	.result 	i64
	i32.const	$push0=, 24
	i32.add 	$push1=, $0, $pop0
	i64.load	$push2=, 0($pop1)
	return  	$pop2
func_end9:
	.size	load_i64_with_unfolded_gep_offset, func_end9-load_i64_with_unfolded_gep_offset

	.globl	store_i32_with_folded_offset
	.type	store_i32_with_folded_offset,@function
store_i32_with_folded_offset:
	.param  	i32
	i32.const	$push0=, 0
	i32.store	$discard=, 24($0), $pop0
	return
func_end10:
	.size	store_i32_with_folded_offset, func_end10-store_i32_with_folded_offset

	.globl	store_i32_with_folded_gep_offset
	.type	store_i32_with_folded_gep_offset,@function
store_i32_with_folded_gep_offset:
	.param  	i32
	i32.const	$push0=, 0
	i32.store	$discard=, 24($0), $pop0
	return
func_end11:
	.size	store_i32_with_folded_gep_offset, func_end11-store_i32_with_folded_gep_offset

	.globl	store_i32_with_unfolded_gep_negative_offset
	.type	store_i32_with_unfolded_gep_negative_offset,@function
store_i32_with_unfolded_gep_negative_offset:
	.param  	i32
	i32.const	$push0=, -24
	i32.add 	$push1=, $0, $pop0
	i32.const	$push2=, 0
	i32.store	$discard=, 0($pop1), $pop2
	return
func_end12:
	.size	store_i32_with_unfolded_gep_negative_offset, func_end12-store_i32_with_unfolded_gep_negative_offset

	.globl	store_i32_with_unfolded_offset
	.type	store_i32_with_unfolded_offset,@function
store_i32_with_unfolded_offset:
	.param  	i32
	i32.const	$push0=, 24
	i32.add 	$push1=, $0, $pop0
	i32.const	$push2=, 0
	i32.store	$discard=, 0($pop1), $pop2
	return
func_end13:
	.size	store_i32_with_unfolded_offset, func_end13-store_i32_with_unfolded_offset

	.globl	store_i32_with_unfolded_gep_offset
	.type	store_i32_with_unfolded_gep_offset,@function
store_i32_with_unfolded_gep_offset:
	.param  	i32
	i32.const	$push0=, 24
	i32.add 	$push1=, $0, $pop0
	i32.const	$push2=, 0
	i32.store	$discard=, 0($pop1), $pop2
	return
func_end14:
	.size	store_i32_with_unfolded_gep_offset, func_end14-store_i32_with_unfolded_gep_offset

	.globl	store_i64_with_folded_offset
	.type	store_i64_with_folded_offset,@function
store_i64_with_folded_offset:
	.param  	i32
	i64.const	$push0=, 0
	i64.store	$discard=, 24($0), $pop0
	return
func_end15:
	.size	store_i64_with_folded_offset, func_end15-store_i64_with_folded_offset

	.globl	store_i64_with_folded_gep_offset
	.type	store_i64_with_folded_gep_offset,@function
store_i64_with_folded_gep_offset:
	.param  	i32
	i64.const	$push0=, 0
	i64.store	$discard=, 24($0), $pop0
	return
func_end16:
	.size	store_i64_with_folded_gep_offset, func_end16-store_i64_with_folded_gep_offset

	.globl	store_i64_with_unfolded_gep_negative_offset
	.type	store_i64_with_unfolded_gep_negative_offset,@function
store_i64_with_unfolded_gep_negative_offset:
	.param  	i32
	i32.const	$push0=, -24
	i32.add 	$push1=, $0, $pop0
	i64.const	$push2=, 0
	i64.store	$discard=, 0($pop1), $pop2
	return
func_end17:
	.size	store_i64_with_unfolded_gep_negative_offset, func_end17-store_i64_with_unfolded_gep_negative_offset

	.globl	store_i64_with_unfolded_offset
	.type	store_i64_with_unfolded_offset,@function
store_i64_with_unfolded_offset:
	.param  	i32
	i32.const	$push0=, 24
	i32.add 	$push1=, $0, $pop0
	i64.const	$push2=, 0
	i64.store	$discard=, 0($pop1), $pop2
	return
func_end18:
	.size	store_i64_with_unfolded_offset, func_end18-store_i64_with_unfolded_offset

	.globl	store_i64_with_unfolded_gep_offset
	.type	store_i64_with_unfolded_gep_offset,@function
store_i64_with_unfolded_gep_offset:
	.param  	i32
	i32.const	$push0=, 24
	i32.add 	$push1=, $0, $pop0
	i64.const	$push2=, 0
	i64.store	$discard=, 0($pop1), $pop2
	return
func_end19:
	.size	store_i64_with_unfolded_gep_offset, func_end19-store_i64_with_unfolded_gep_offset

	.globl	load_i32_from_numeric_address
	.type	load_i32_from_numeric_address,@function
load_i32_from_numeric_address:
	.result 	i32
	i32.const	$push0=, 0
	i32.load	$push1=, 42($pop0)
	return  	$pop1
func_end20:
	.size	load_i32_from_numeric_address, func_end20-load_i32_from_numeric_address

	.globl	load_i32_from_global_address
	.type	load_i32_from_global_address,@function
load_i32_from_global_address:
	.result 	i32
	i32.const	$push0=, 0
	i32.load	$push1=, gv($pop0)
	return  	$pop1
func_end21:
	.size	load_i32_from_global_address, func_end21-load_i32_from_global_address

	.globl	store_i32_to_numeric_address
	.type	store_i32_to_numeric_address,@function
store_i32_to_numeric_address:
	.local  	i32
	i32.const	$0=, 0
	i32.store	$discard=, 42($0), $0
	return
func_end22:
	.size	store_i32_to_numeric_address, func_end22-store_i32_to_numeric_address

	.globl	store_i32_to_global_address
	.type	store_i32_to_global_address,@function
store_i32_to_global_address:
	.local  	i32
	i32.const	$0=, 0
	i32.store	$discard=, gv($0), $0
	return
func_end23:
	.size	store_i32_to_global_address, func_end23-store_i32_to_global_address

	.globl	load_i8_s_with_folded_offset
	.type	load_i8_s_with_folded_offset,@function
load_i8_s_with_folded_offset:
	.param  	i32
	.result 	i32
	i32.load8_s	$push0=, 24($0)
	return  	$pop0
func_end24:
	.size	load_i8_s_with_folded_offset, func_end24-load_i8_s_with_folded_offset

	.globl	load_i8_s_with_folded_gep_offset
	.type	load_i8_s_with_folded_gep_offset,@function
load_i8_s_with_folded_gep_offset:
	.param  	i32
	.result 	i32
	i32.load8_s	$push0=, 24($0)
	return  	$pop0
func_end25:
	.size	load_i8_s_with_folded_gep_offset, func_end25-load_i8_s_with_folded_gep_offset

	.globl	load_i8_u_with_folded_offset
	.type	load_i8_u_with_folded_offset,@function
load_i8_u_with_folded_offset:
	.param  	i32
	.result 	i32
	i32.load8_u	$push0=, 24($0)
	return  	$pop0
func_end26:
	.size	load_i8_u_with_folded_offset, func_end26-load_i8_u_with_folded_offset

	.globl	load_i8_u_with_folded_gep_offset
	.type	load_i8_u_with_folded_gep_offset,@function
load_i8_u_with_folded_gep_offset:
	.param  	i32
	.result 	i32
	i32.load8_u	$push0=, 24($0)
	return  	$pop0
func_end27:
	.size	load_i8_u_with_folded_gep_offset, func_end27-load_i8_u_with_folded_gep_offset

	.globl	store_i8_with_folded_offset
	.type	store_i8_with_folded_offset,@function
store_i8_with_folded_offset:
	.param  	i32
	i32.const	$push0=, 0
	i32.store8	$discard=, 24($0), $pop0
	return
func_end28:
	.size	store_i8_with_folded_offset, func_end28-store_i8_with_folded_offset

	.globl	store_i8_with_folded_gep_offset
	.type	store_i8_with_folded_gep_offset,@function
store_i8_with_folded_gep_offset:
	.param  	i32
	i32.const	$push0=, 0
	i32.store8	$discard=, 24($0), $pop0
	return
func_end29:
	.size	store_i8_with_folded_gep_offset, func_end29-store_i8_with_folded_gep_offset

	.globl	aggregate_load_store
	.type	aggregate_load_store,@function
aggregate_load_store:
	.param  	i32, i32
	.local  	i32, i32, i32
	i32.load	$2=, 0($0)
	i32.load	$3=, 4($0)
	i32.load	$4=, 8($0)
	i32.load	$push0=, 12($0)
	i32.store	$discard=, 12($1), $pop0
	i32.store	$discard=, 8($1), $4
	i32.store	$discard=, 4($1), $3
	i32.store	$discard=, 0($1), $2
	return
func_end30:
	.size	aggregate_load_store, func_end30-aggregate_load_store

	.globl	aggregate_return
	.type	aggregate_return,@function
aggregate_return:
	.param  	i32
	i32.const	$push0=, 0
	i32.store	$push1=, 12($0), $pop0
	i32.store	$push2=, 8($0), $pop1
	i32.store	$push3=, 4($0), $pop2
	i32.store	$discard=, 0($0), $pop3
	return
func_end31:
	.size	aggregate_return, func_end31-aggregate_return

	.type	gv,@object
	.bss
	.globl	gv
	.align	2
gv:
	.int32	0
	.size	gv, 4


	.section	".note.GNU-stack","",@progbits
