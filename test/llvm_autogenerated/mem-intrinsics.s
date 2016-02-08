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
	i32.call	$discard=, memcpy@FUNCTION, $0, $1, $2
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
	i32.call	$discard=, memmove@FUNCTION, $0, $1, $2
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
	i32.call	$discard=, memset@FUNCTION, $0, $1, $2
	return
	.endfunc
.Lfunc_end5:
	.size	set_no, .Lfunc_end5-set_no

	.globl	frame_index
	.type	frame_index,@function
frame_index:
	.local  	i32, i32, i32, i32, i32
	i32.const	$0=, __stack_pointer
	i32.load	$0=, 0($0)
	i32.const	$1=, 4096
	i32.sub 	$4=, $0, $1
	i32.const	$1=, __stack_pointer
	i32.store	$4=, 0($1), $4
	i32.const	$push1=, 0
	i32.const	$push0=, 1024
	i32.const	$3=, 2048
	i32.add 	$3=, $4, $3
	i32.call	$discard=, memset@FUNCTION, $3, $pop1, $pop0
	i32.const	$push3=, 0
	i32.const	$push2=, 1024
	i32.call	$discard=, memset@FUNCTION, $4, $pop3, $pop2
	i32.const	$2=, 4096
	i32.add 	$4=, $4, $2
	i32.const	$2=, __stack_pointer
	i32.store	$4=, 0($2), $4
	return
	.endfunc
.Lfunc_end6:
	.size	frame_index, .Lfunc_end6-frame_index

	.globl	discard_result
	.type	discard_result,@function
discard_result:
	.param  	i32, i32, i32, i32, i32
	.result 	i32
	block
	block
	i32.const	$push0=, 0
	i32.eq  	$push1=, $3, $pop0
	br_if   	0, $pop1
	i32.call	$0=, def@FUNCTION
	br      	1
.LBB7_2:
	end_block
	br_if   	0, $4
	i32.call	$discard=, memset@FUNCTION, $0, $1, $2
.LBB7_4:
	end_block
	return  	$0
	.endfunc
.Lfunc_end7:
	.size	discard_result, .Lfunc_end7-discard_result


