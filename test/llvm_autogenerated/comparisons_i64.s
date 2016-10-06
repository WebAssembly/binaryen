	.text
	.file	"/s/llvm-upstream/llvm/test/CodeGen/WebAssembly/comparisons_i64.ll"
	.globl	eq_i64
	.type	eq_i64,@function
eq_i64:
	.param  	i64, i64
	.result 	i32
	i64.eq  	$push0=, $0, $1
	return  	$pop0
	.endfunc
.Lfunc_end0:
	.size	eq_i64, .Lfunc_end0-eq_i64

	.globl	ne_i64
	.type	ne_i64,@function
ne_i64:
	.param  	i64, i64
	.result 	i32
	i64.ne  	$push0=, $0, $1
	return  	$pop0
	.endfunc
.Lfunc_end1:
	.size	ne_i64, .Lfunc_end1-ne_i64

	.globl	slt_i64
	.type	slt_i64,@function
slt_i64:
	.param  	i64, i64
	.result 	i32
	i64.lt_s	$push0=, $0, $1
	return  	$pop0
	.endfunc
.Lfunc_end2:
	.size	slt_i64, .Lfunc_end2-slt_i64

	.globl	sle_i64
	.type	sle_i64,@function
sle_i64:
	.param  	i64, i64
	.result 	i32
	i64.le_s	$push0=, $0, $1
	return  	$pop0
	.endfunc
.Lfunc_end3:
	.size	sle_i64, .Lfunc_end3-sle_i64

	.globl	ult_i64
	.type	ult_i64,@function
ult_i64:
	.param  	i64, i64
	.result 	i32
	i64.lt_u	$push0=, $0, $1
	return  	$pop0
	.endfunc
.Lfunc_end4:
	.size	ult_i64, .Lfunc_end4-ult_i64

	.globl	ule_i64
	.type	ule_i64,@function
ule_i64:
	.param  	i64, i64
	.result 	i32
	i64.le_u	$push0=, $0, $1
	return  	$pop0
	.endfunc
.Lfunc_end5:
	.size	ule_i64, .Lfunc_end5-ule_i64

	.globl	sgt_i64
	.type	sgt_i64,@function
sgt_i64:
	.param  	i64, i64
	.result 	i32
	i64.gt_s	$push0=, $0, $1
	return  	$pop0
	.endfunc
.Lfunc_end6:
	.size	sgt_i64, .Lfunc_end6-sgt_i64

	.globl	sge_i64
	.type	sge_i64,@function
sge_i64:
	.param  	i64, i64
	.result 	i32
	i64.ge_s	$push0=, $0, $1
	return  	$pop0
	.endfunc
.Lfunc_end7:
	.size	sge_i64, .Lfunc_end7-sge_i64

	.globl	ugt_i64
	.type	ugt_i64,@function
ugt_i64:
	.param  	i64, i64
	.result 	i32
	i64.gt_u	$push0=, $0, $1
	return  	$pop0
	.endfunc
.Lfunc_end8:
	.size	ugt_i64, .Lfunc_end8-ugt_i64

	.globl	uge_i64
	.type	uge_i64,@function
uge_i64:
	.param  	i64, i64
	.result 	i32
	i64.ge_u	$push0=, $0, $1
	return  	$pop0
	.endfunc
.Lfunc_end9:
	.size	uge_i64, .Lfunc_end9-uge_i64


