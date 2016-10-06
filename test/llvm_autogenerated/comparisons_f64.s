	.text
	.file	"/s/llvm-upstream/llvm/test/CodeGen/WebAssembly/comparisons_f64.ll"
	.globl	ord_f64
	.type	ord_f64,@function
ord_f64:
	.param  	f64, f64
	.result 	i32
	f64.eq  	$push1=, $0, $0
	f64.eq  	$push0=, $1, $1
	i32.and 	$push2=, $pop1, $pop0
	return  	$pop2
	.endfunc
.Lfunc_end0:
	.size	ord_f64, .Lfunc_end0-ord_f64

	.globl	uno_f64
	.type	uno_f64,@function
uno_f64:
	.param  	f64, f64
	.result 	i32
	f64.ne  	$push1=, $0, $0
	f64.ne  	$push0=, $1, $1
	i32.or  	$push2=, $pop1, $pop0
	return  	$pop2
	.endfunc
.Lfunc_end1:
	.size	uno_f64, .Lfunc_end1-uno_f64

	.globl	oeq_f64
	.type	oeq_f64,@function
oeq_f64:
	.param  	f64, f64
	.result 	i32
	f64.eq  	$push0=, $0, $1
	return  	$pop0
	.endfunc
.Lfunc_end2:
	.size	oeq_f64, .Lfunc_end2-oeq_f64

	.globl	une_f64
	.type	une_f64,@function
une_f64:
	.param  	f64, f64
	.result 	i32
	f64.ne  	$push0=, $0, $1
	return  	$pop0
	.endfunc
.Lfunc_end3:
	.size	une_f64, .Lfunc_end3-une_f64

	.globl	olt_f64
	.type	olt_f64,@function
olt_f64:
	.param  	f64, f64
	.result 	i32
	f64.lt  	$push0=, $0, $1
	return  	$pop0
	.endfunc
.Lfunc_end4:
	.size	olt_f64, .Lfunc_end4-olt_f64

	.globl	ole_f64
	.type	ole_f64,@function
ole_f64:
	.param  	f64, f64
	.result 	i32
	f64.le  	$push0=, $0, $1
	return  	$pop0
	.endfunc
.Lfunc_end5:
	.size	ole_f64, .Lfunc_end5-ole_f64

	.globl	ogt_f64
	.type	ogt_f64,@function
ogt_f64:
	.param  	f64, f64
	.result 	i32
	f64.gt  	$push0=, $0, $1
	return  	$pop0
	.endfunc
.Lfunc_end6:
	.size	ogt_f64, .Lfunc_end6-ogt_f64

	.globl	oge_f64
	.type	oge_f64,@function
oge_f64:
	.param  	f64, f64
	.result 	i32
	f64.ge  	$push0=, $0, $1
	return  	$pop0
	.endfunc
.Lfunc_end7:
	.size	oge_f64, .Lfunc_end7-oge_f64

	.globl	ueq_f64
	.type	ueq_f64,@function
ueq_f64:
	.param  	f64, f64
	.result 	i32
	f64.eq  	$push0=, $0, $1
	f64.ne  	$push2=, $0, $0
	f64.ne  	$push1=, $1, $1
	i32.or  	$push3=, $pop2, $pop1
	i32.or  	$push4=, $pop0, $pop3
	return  	$pop4
	.endfunc
.Lfunc_end8:
	.size	ueq_f64, .Lfunc_end8-ueq_f64

	.globl	one_f64
	.type	one_f64,@function
one_f64:
	.param  	f64, f64
	.result 	i32
	f64.ne  	$push0=, $0, $1
	f64.eq  	$push2=, $0, $0
	f64.eq  	$push1=, $1, $1
	i32.and 	$push3=, $pop2, $pop1
	i32.and 	$push4=, $pop0, $pop3
	return  	$pop4
	.endfunc
.Lfunc_end9:
	.size	one_f64, .Lfunc_end9-one_f64

	.globl	ult_f64
	.type	ult_f64,@function
ult_f64:
	.param  	f64, f64
	.result 	i32
	f64.lt  	$push0=, $0, $1
	f64.ne  	$push2=, $0, $0
	f64.ne  	$push1=, $1, $1
	i32.or  	$push3=, $pop2, $pop1
	i32.or  	$push4=, $pop0, $pop3
	return  	$pop4
	.endfunc
.Lfunc_end10:
	.size	ult_f64, .Lfunc_end10-ult_f64

	.globl	ule_f64
	.type	ule_f64,@function
ule_f64:
	.param  	f64, f64
	.result 	i32
	f64.le  	$push0=, $0, $1
	f64.ne  	$push2=, $0, $0
	f64.ne  	$push1=, $1, $1
	i32.or  	$push3=, $pop2, $pop1
	i32.or  	$push4=, $pop0, $pop3
	return  	$pop4
	.endfunc
.Lfunc_end11:
	.size	ule_f64, .Lfunc_end11-ule_f64

	.globl	ugt_f64
	.type	ugt_f64,@function
ugt_f64:
	.param  	f64, f64
	.result 	i32
	f64.gt  	$push0=, $0, $1
	f64.ne  	$push2=, $0, $0
	f64.ne  	$push1=, $1, $1
	i32.or  	$push3=, $pop2, $pop1
	i32.or  	$push4=, $pop0, $pop3
	return  	$pop4
	.endfunc
.Lfunc_end12:
	.size	ugt_f64, .Lfunc_end12-ugt_f64

	.globl	uge_f64
	.type	uge_f64,@function
uge_f64:
	.param  	f64, f64
	.result 	i32
	f64.ge  	$push0=, $0, $1
	f64.ne  	$push2=, $0, $0
	f64.ne  	$push1=, $1, $1
	i32.or  	$push3=, $pop2, $pop1
	i32.or  	$push4=, $pop0, $pop3
	return  	$pop4
	.endfunc
.Lfunc_end13:
	.size	uge_f64, .Lfunc_end13-uge_f64


