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


