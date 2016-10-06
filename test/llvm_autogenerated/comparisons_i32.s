	.text
	.file	"/s/llvm-upstream/llvm/test/CodeGen/WebAssembly/comparisons_i32.ll"
	.globl	eq_i32
	.type	eq_i32,@function
eq_i32:
	.param  	i32, i32
	.result 	i32
	i32.eq  	$push0=, $0, $1
	return  	$pop0
	.endfunc
.Lfunc_end0:
	.size	eq_i32, .Lfunc_end0-eq_i32

	.globl	ne_i32
	.type	ne_i32,@function
ne_i32:
	.param  	i32, i32
	.result 	i32
	i32.ne  	$push0=, $0, $1
	return  	$pop0
	.endfunc
.Lfunc_end1:
	.size	ne_i32, .Lfunc_end1-ne_i32

	.globl	slt_i32
	.type	slt_i32,@function
slt_i32:
	.param  	i32, i32
	.result 	i32
	i32.lt_s	$push0=, $0, $1
	return  	$pop0
	.endfunc
.Lfunc_end2:
	.size	slt_i32, .Lfunc_end2-slt_i32

	.globl	sle_i32
	.type	sle_i32,@function
sle_i32:
	.param  	i32, i32
	.result 	i32
	i32.le_s	$push0=, $0, $1
	return  	$pop0
	.endfunc
.Lfunc_end3:
	.size	sle_i32, .Lfunc_end3-sle_i32

	.globl	ult_i32
	.type	ult_i32,@function
ult_i32:
	.param  	i32, i32
	.result 	i32
	i32.lt_u	$push0=, $0, $1
	return  	$pop0
	.endfunc
.Lfunc_end4:
	.size	ult_i32, .Lfunc_end4-ult_i32

	.globl	ule_i32
	.type	ule_i32,@function
ule_i32:
	.param  	i32, i32
	.result 	i32
	i32.le_u	$push0=, $0, $1
	return  	$pop0
	.endfunc
.Lfunc_end5:
	.size	ule_i32, .Lfunc_end5-ule_i32

	.globl	sgt_i32
	.type	sgt_i32,@function
sgt_i32:
	.param  	i32, i32
	.result 	i32
	i32.gt_s	$push0=, $0, $1
	return  	$pop0
	.endfunc
.Lfunc_end6:
	.size	sgt_i32, .Lfunc_end6-sgt_i32

	.globl	sge_i32
	.type	sge_i32,@function
sge_i32:
	.param  	i32, i32
	.result 	i32
	i32.ge_s	$push0=, $0, $1
	return  	$pop0
	.endfunc
.Lfunc_end7:
	.size	sge_i32, .Lfunc_end7-sge_i32

	.globl	ugt_i32
	.type	ugt_i32,@function
ugt_i32:
	.param  	i32, i32
	.result 	i32
	i32.gt_u	$push0=, $0, $1
	return  	$pop0
	.endfunc
.Lfunc_end8:
	.size	ugt_i32, .Lfunc_end8-ugt_i32

	.globl	uge_i32
	.type	uge_i32,@function
uge_i32:
	.param  	i32, i32
	.result 	i32
	i32.ge_u	$push0=, $0, $1
	return  	$pop0
	.endfunc
.Lfunc_end9:
	.size	uge_i32, .Lfunc_end9-uge_i32


