	.text
	.file	"/s/llvm/llvm/test/CodeGen/WebAssembly/mem-intrinsics.ll"
	.globl	copy_yes
	.type	copy_yes,@function
copy_yes:
	.param  	i32, i32, i32
	.result 	i32
	i32.call	$push0=, memcpy@FUNCTION, $0, $1, $2
	return  	$pop0
	.endfunc
.Lfunc_end0:
	.size	copy_yes, .Lfunc_end0-copy_yes

	.globl	copy_no
	.type	copy_no,@function
copy_no:
	.param  	i32, i32, i32
	i32.call	$drop=, memcpy@FUNCTION, $0, $1, $2
	return
	.endfunc
.Lfunc_end1:
	.size	copy_no, .Lfunc_end1-copy_no

	.globl	move_yes
	.type	move_yes,@function
move_yes:
	.param  	i32, i32, i32
	.result 	i32
	i32.call	$push0=, memmove@FUNCTION, $0, $1, $2
	return  	$pop0
	.endfunc
.Lfunc_end2:
	.size	move_yes, .Lfunc_end2-move_yes

	.globl	move_no
	.type	move_no,@function
move_no:
	.param  	i32, i32, i32
	i32.call	$drop=, memmove@FUNCTION, $0, $1, $2
	return
	.endfunc
.Lfunc_end3:
	.size	move_no, .Lfunc_end3-move_no

	.globl	set_yes
	.type	set_yes,@function
set_yes:
	.param  	i32, i32, i32
	.result 	i32
	i32.call	$push0=, memset@FUNCTION, $0, $1, $2
	return  	$pop0
	.endfunc
.Lfunc_end4:
	.size	set_yes, .Lfunc_end4-set_yes

	.globl	set_no
	.type	set_no,@function
set_no:
	.param  	i32, i32, i32
	i32.call	$drop=, memset@FUNCTION, $0, $1, $2
	return
	.endfunc
.Lfunc_end5:
	.size	set_no, .Lfunc_end5-set_no

	.globl	frame_index
	.type	frame_index,@function
frame_index:
	.local  	i32
	i32.const	$push6=, __stack_pointer
	i32.const	$push3=, __stack_pointer
	i32.load	$push4=, 0($pop3)
	i32.const	$push5=, 4096
	i32.sub 	$push12=, $pop4, $pop5
	i32.store	$push16=, 0($pop6), $pop12
	tee_local	$push15=, $0=, $pop16
	i32.const	$push10=, 2048
	i32.add 	$push11=, $pop15, $pop10
	i32.const	$push2=, 0
	i32.const	$push1=, 1024
	i32.call	$drop=, memset@FUNCTION, $pop11, $pop2, $pop1
	i32.const	$push9=, __stack_pointer
	i32.const	$push14=, 0
	i32.const	$push13=, 1024
	i32.call	$push0=, memset@FUNCTION, $0, $pop14, $pop13
	i32.const	$push7=, 4096
	i32.add 	$push8=, $pop0, $pop7
	i32.store	$drop=, 0($pop9), $pop8
	return
	.endfunc
.Lfunc_end6:
	.size	frame_index, .Lfunc_end6-frame_index

	.globl	drop_result
	.type	drop_result,@function
drop_result:
	.param  	i32, i32, i32, i32, i32
	.result 	i32
	block
	block
	block
	i32.eqz 	$push0=, $3
	br_if   	0, $pop0
	i32.call	$0=, def@FUNCTION
	br      	1
.LBB7_2:
	end_block
	i32.eqz 	$push1=, $4
	br_if   	1, $pop1
.LBB7_3:
	end_block
	call    	block_tail_dup@FUNCTION
	return  	$0
.LBB7_4:
	end_block
	i32.call	$drop=, memset@FUNCTION, $0, $1, $2
	call    	block_tail_dup@FUNCTION
	return  	$0
	.endfunc
.Lfunc_end7:
	.size	drop_result, .Lfunc_end7-drop_result

	.globl	tail_dup_to_reuse_result
	.type	tail_dup_to_reuse_result,@function
tail_dup_to_reuse_result:
	.param  	i32, i32, i32, i32, i32
	.result 	i32
	block
	block
	block
	i32.eqz 	$push1=, $3
	br_if   	0, $pop1
	i32.call	$0=, def@FUNCTION
	br      	1
.LBB8_2:
	end_block
	i32.eqz 	$push2=, $4
	br_if   	1, $pop2
.LBB8_3:
	end_block
	return  	$0
.LBB8_4:
	end_block
	i32.call	$push0=, memset@FUNCTION, $0, $1, $2
	return  	$pop0
	.endfunc
.Lfunc_end8:
	.size	tail_dup_to_reuse_result, .Lfunc_end8-tail_dup_to_reuse_result


