	.text
	.file	"/s/llvm-upstream/llvm/test/CodeGen/WebAssembly/comparisons_f32.ll"
	.globl	ord_f32
	.type	ord_f32,@function
ord_f32:
	.param  	f32, f32
	.result 	i32
	f32.eq  	$push1=, $0, $0
	f32.eq  	$push0=, $1, $1
	i32.and 	$push2=, $pop1, $pop0
	return  	$pop2
	.endfunc
.Lfunc_end0:
	.size	ord_f32, .Lfunc_end0-ord_f32

	.globl	uno_f32
	.type	uno_f32,@function
uno_f32:
	.param  	f32, f32
	.result 	i32
	f32.ne  	$push1=, $0, $0
	f32.ne  	$push0=, $1, $1
	i32.or  	$push2=, $pop1, $pop0
	return  	$pop2
	.endfunc
.Lfunc_end1:
	.size	uno_f32, .Lfunc_end1-uno_f32

	.globl	oeq_f32
	.type	oeq_f32,@function
oeq_f32:
	.param  	f32, f32
	.result 	i32
	f32.eq  	$push0=, $0, $1
	return  	$pop0
	.endfunc
.Lfunc_end2:
	.size	oeq_f32, .Lfunc_end2-oeq_f32

	.globl	une_f32
	.type	une_f32,@function
une_f32:
	.param  	f32, f32
	.result 	i32
	f32.ne  	$push0=, $0, $1
	return  	$pop0
	.endfunc
.Lfunc_end3:
	.size	une_f32, .Lfunc_end3-une_f32

	.globl	olt_f32
	.type	olt_f32,@function
olt_f32:
	.param  	f32, f32
	.result 	i32
	f32.lt  	$push0=, $0, $1
	return  	$pop0
	.endfunc
.Lfunc_end4:
	.size	olt_f32, .Lfunc_end4-olt_f32

	.globl	ole_f32
	.type	ole_f32,@function
ole_f32:
	.param  	f32, f32
	.result 	i32
	f32.le  	$push0=, $0, $1
	return  	$pop0
	.endfunc
.Lfunc_end5:
	.size	ole_f32, .Lfunc_end5-ole_f32

	.globl	ogt_f32
	.type	ogt_f32,@function
ogt_f32:
	.param  	f32, f32
	.result 	i32
	f32.gt  	$push0=, $0, $1
	return  	$pop0
	.endfunc
.Lfunc_end6:
	.size	ogt_f32, .Lfunc_end6-ogt_f32

	.globl	oge_f32
	.type	oge_f32,@function
oge_f32:
	.param  	f32, f32
	.result 	i32
	f32.ge  	$push0=, $0, $1
	return  	$pop0
	.endfunc
.Lfunc_end7:
	.size	oge_f32, .Lfunc_end7-oge_f32

	.globl	ueq_f32
	.type	ueq_f32,@function
ueq_f32:
	.param  	f32, f32
	.result 	i32
	f32.eq  	$push0=, $0, $1
	f32.ne  	$push2=, $0, $0
	f32.ne  	$push1=, $1, $1
	i32.or  	$push3=, $pop2, $pop1
	i32.or  	$push4=, $pop0, $pop3
	return  	$pop4
	.endfunc
.Lfunc_end8:
	.size	ueq_f32, .Lfunc_end8-ueq_f32

	.globl	one_f32
	.type	one_f32,@function
one_f32:
	.param  	f32, f32
	.result 	i32
	f32.ne  	$push0=, $0, $1
	f32.eq  	$push2=, $0, $0
	f32.eq  	$push1=, $1, $1
	i32.and 	$push3=, $pop2, $pop1
	i32.and 	$push4=, $pop0, $pop3
	return  	$pop4
	.endfunc
.Lfunc_end9:
	.size	one_f32, .Lfunc_end9-one_f32

	.globl	ult_f32
	.type	ult_f32,@function
ult_f32:
	.param  	f32, f32
	.result 	i32
	f32.lt  	$push0=, $0, $1
	f32.ne  	$push2=, $0, $0
	f32.ne  	$push1=, $1, $1
	i32.or  	$push3=, $pop2, $pop1
	i32.or  	$push4=, $pop0, $pop3
	return  	$pop4
	.endfunc
.Lfunc_end10:
	.size	ult_f32, .Lfunc_end10-ult_f32

	.globl	ule_f32
	.type	ule_f32,@function
ule_f32:
	.param  	f32, f32
	.result 	i32
	f32.le  	$push0=, $0, $1
	f32.ne  	$push2=, $0, $0
	f32.ne  	$push1=, $1, $1
	i32.or  	$push3=, $pop2, $pop1
	i32.or  	$push4=, $pop0, $pop3
	return  	$pop4
	.endfunc
.Lfunc_end11:
	.size	ule_f32, .Lfunc_end11-ule_f32

	.globl	ugt_f32
	.type	ugt_f32,@function
ugt_f32:
	.param  	f32, f32
	.result 	i32
	f32.gt  	$push0=, $0, $1
	f32.ne  	$push2=, $0, $0
	f32.ne  	$push1=, $1, $1
	i32.or  	$push3=, $pop2, $pop1
	i32.or  	$push4=, $pop0, $pop3
	return  	$pop4
	.endfunc
.Lfunc_end12:
	.size	ugt_f32, .Lfunc_end12-ugt_f32

	.globl	uge_f32
	.type	uge_f32,@function
uge_f32:
	.param  	f32, f32
	.result 	i32
	f32.ge  	$push0=, $0, $1
	f32.ne  	$push2=, $0, $0
	f32.ne  	$push1=, $1, $1
	i32.or  	$push3=, $pop2, $pop1
	i32.or  	$push4=, $pop0, $pop3
	return  	$pop4
	.endfunc
.Lfunc_end13:
	.size	uge_f32, .Lfunc_end13-uge_f32


