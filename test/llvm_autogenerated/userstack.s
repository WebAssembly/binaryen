	.text
	.file	"/s/llvm-upstream/llvm/test/CodeGen/WebAssembly/userstack.ll"
	.globl	alloca32
	.type	alloca32,@function
alloca32:
	.local  	i32
	i32.const	$push4=, 0
	i32.const	$push1=, 0
	i32.load	$push2=, __stack_pointer($pop1)
	i32.const	$push3=, 16
	i32.sub 	$push9=, $pop2, $pop3
	tee_local	$push8=, $0=, $pop9
	i32.store	__stack_pointer($pop4), $pop8
	i32.const	$push0=, 0
	i32.store	12($0), $pop0
	i32.const	$push7=, 0
	i32.const	$push5=, 16
	i32.add 	$push6=, $0, $pop5
	i32.store	__stack_pointer($pop7), $pop6
	return
	.endfunc
.Lfunc_end0:
	.size	alloca32, .Lfunc_end0-alloca32

	.globl	alloca3264
	.type	alloca3264,@function
alloca3264:
	.local  	i32
	i32.const	$push2=, 0
	i32.load	$push3=, __stack_pointer($pop2)
	i32.const	$push4=, 16
	i32.sub 	$push6=, $pop3, $pop4
	tee_local	$push5=, $0=, $pop6
	i32.const	$push0=, 0
	i32.store	12($pop5), $pop0
	i64.const	$push1=, 0
	i64.store	0($0), $pop1
	return
	.endfunc
.Lfunc_end1:
	.size	alloca3264, .Lfunc_end1-alloca3264

	.globl	allocarray
	.type	allocarray,@function
allocarray:
	.local  	i32
	i32.const	$push6=, 0
	i32.const	$push3=, 0
	i32.load	$push4=, __stack_pointer($pop3)
	i32.const	$push5=, 144
	i32.sub 	$push12=, $pop4, $pop5
	tee_local	$push11=, $0=, $pop12
	i32.store	__stack_pointer($pop6), $pop11
	i32.const	$push0=, 24
	i32.add 	$push1=, $0, $pop0
	i32.const	$push2=, 1
	i32.store	0($pop1), $pop2
	i32.const	$push10=, 1
	i32.store	12($0), $pop10
	i32.const	$push9=, 0
	i32.const	$push7=, 144
	i32.add 	$push8=, $0, $pop7
	i32.store	__stack_pointer($pop9), $pop8
	return
	.endfunc
.Lfunc_end2:
	.size	allocarray, .Lfunc_end2-allocarray

	.globl	non_mem_use
	.type	non_mem_use,@function
non_mem_use:
	.param  	i32
	.local  	i32
	i32.const	$push3=, 0
	i32.const	$push0=, 0
	i32.load	$push1=, __stack_pointer($pop0)
	i32.const	$push2=, 48
	i32.sub 	$push12=, $pop1, $pop2
	tee_local	$push11=, $1=, $pop12
	i32.store	__stack_pointer($pop3), $pop11
	i32.const	$push7=, 8
	i32.add 	$push8=, $1, $pop7
	call    	ext_func@FUNCTION, $pop8
	call    	ext_func@FUNCTION, $1
	i32.const	$push9=, 16
	i32.add 	$push10=, $1, $pop9
	i32.store	0($0), $pop10
	i32.const	$push6=, 0
	i32.const	$push4=, 48
	i32.add 	$push5=, $1, $pop4
	i32.store	__stack_pointer($pop6), $pop5
	return
	.endfunc
.Lfunc_end3:
	.size	non_mem_use, .Lfunc_end3-non_mem_use

	.globl	allocarray_inbounds
	.type	allocarray_inbounds,@function
allocarray_inbounds:
	.local  	i32
	i32.const	$push5=, 0
	i32.const	$push2=, 0
	i32.load	$push3=, __stack_pointer($pop2)
	i32.const	$push4=, 32
	i32.sub 	$push11=, $pop3, $pop4
	tee_local	$push10=, $0=, $pop11
	i32.store	__stack_pointer($pop5), $pop10
	i32.const	$push0=, 1
	i32.store	24($0), $pop0
	i32.const	$push9=, 1
	i32.store	12($0), $pop9
	i32.const	$push1=, 0
	call    	ext_func@FUNCTION, $pop1
	i32.const	$push8=, 0
	i32.const	$push6=, 32
	i32.add 	$push7=, $0, $pop6
	i32.store	__stack_pointer($pop8), $pop7
	return
	.endfunc
.Lfunc_end4:
	.size	allocarray_inbounds, .Lfunc_end4-allocarray_inbounds

	.globl	dynamic_alloca
	.type	dynamic_alloca,@function
dynamic_alloca:
	.param  	i32
	.local  	i32
	i32.const	$push6=, 0
	i32.const	$push7=, 0
	i32.load	$push14=, __stack_pointer($pop7)
	tee_local	$push13=, $1=, $pop14
	i32.const	$push0=, 2
	i32.shl 	$push1=, $0, $pop0
	i32.const	$push2=, 15
	i32.add 	$push3=, $pop1, $pop2
	i32.const	$push4=, -16
	i32.and 	$push5=, $pop3, $pop4
	i32.sub 	$push12=, $pop13, $pop5
	tee_local	$push11=, $0=, $pop12
	copy_local	$push10=, $pop11
	i32.store	__stack_pointer($pop6), $pop10
	call    	ext_func_i32@FUNCTION, $0
	i32.const	$push8=, 0
	copy_local	$push9=, $1
	i32.store	__stack_pointer($pop8), $pop9
	return
	.endfunc
.Lfunc_end5:
	.size	dynamic_alloca, .Lfunc_end5-dynamic_alloca

	.globl	dynamic_alloca_redzone
	.type	dynamic_alloca_redzone,@function
dynamic_alloca_redzone:
	.param  	i32
	.local  	i32
	i32.const	$push7=, 0
	i32.load	$push11=, __stack_pointer($pop7)
	tee_local	$push10=, $1=, $pop11
	copy_local	$drop=, $pop10
	i32.const	$push0=, 2
	i32.shl 	$push1=, $0, $pop0
	i32.const	$push2=, 15
	i32.add 	$push3=, $pop1, $pop2
	i32.const	$push4=, -16
	i32.and 	$push5=, $pop3, $pop4
	i32.sub 	$push9=, $1, $pop5
	tee_local	$push8=, $0=, $pop9
	copy_local	$drop=, $pop8
	i32.const	$push6=, 0
	i32.store	0($0), $pop6
	return
	.endfunc
.Lfunc_end6:
	.size	dynamic_alloca_redzone, .Lfunc_end6-dynamic_alloca_redzone

	.globl	dynamic_static_alloca
	.type	dynamic_static_alloca,@function
dynamic_static_alloca:
	.param  	i32
	.local  	i32, i32, i32
	i32.const	$push16=, 0
	i32.const	$push13=, 0
	i32.load	$push14=, __stack_pointer($pop13)
	i32.const	$push15=, 16
	i32.sub 	$push32=, $pop14, $pop15
	tee_local	$push31=, $2=, $pop32
	i32.store	__stack_pointer($pop16), $pop31
	copy_local	$push30=, $2
	tee_local	$push29=, $1=, $pop30
	i32.const	$push0=, 101
	i32.store	12($pop29), $pop0
	i32.const	$push11=, 0
	i32.const	$push1=, 2
	i32.shl 	$push2=, $0, $pop1
	i32.const	$push3=, 15
	i32.add 	$push4=, $pop2, $pop3
	i32.const	$push5=, -16
	i32.and 	$push28=, $pop4, $pop5
	tee_local	$push27=, $0=, $pop28
	i32.sub 	$push26=, $2, $pop27
	tee_local	$push25=, $2=, $pop26
	copy_local	$push24=, $pop25
	tee_local	$push23=, $3=, $pop24
	i32.store	__stack_pointer($pop11), $pop23
	i32.const	$push6=, 102
	i32.store	12($1), $pop6
	i32.const	$push7=, 103
	i32.store	0($2), $pop7
	i32.const	$push12=, 0
	i32.sub 	$push22=, $3, $0
	tee_local	$push21=, $0=, $pop22
	copy_local	$push20=, $pop21
	i32.store	__stack_pointer($pop12), $pop20
	i32.const	$push8=, 104
	i32.store	12($1), $pop8
	i32.const	$push9=, 105
	i32.store	0($2), $pop9
	i32.const	$push10=, 106
	i32.store	0($0), $pop10
	i32.const	$push19=, 0
	i32.const	$push17=, 16
	i32.add 	$push18=, $1, $pop17
	i32.store	__stack_pointer($pop19), $pop18
	return
	.endfunc
.Lfunc_end7:
	.size	dynamic_static_alloca, .Lfunc_end7-dynamic_static_alloca

	.globl	llvm_stack_builtins
	.type	llvm_stack_builtins,@function
llvm_stack_builtins:
	.param  	i32
	.local  	i32, i32, i32
	i32.const	$push7=, 0
	i32.load	$push11=, __stack_pointer($pop7)
	tee_local	$push10=, $3=, $pop11
	copy_local	$2=, $pop10
	copy_local	$1=, $3
	i32.const	$push6=, 0
	i32.const	$push0=, 2
	i32.shl 	$push1=, $0, $pop0
	i32.const	$push2=, 15
	i32.add 	$push3=, $pop1, $pop2
	i32.const	$push4=, -16
	i32.and 	$push5=, $pop3, $pop4
	i32.sub 	$push9=, $3, $pop5
	i32.store	__stack_pointer($pop6), $pop9
	copy_local	$drop=, $1
	i32.const	$push8=, 0
	i32.store	__stack_pointer($pop8), $2
	return
	.endfunc
.Lfunc_end8:
	.size	llvm_stack_builtins, .Lfunc_end8-llvm_stack_builtins

	.globl	dynamic_alloca_nouse
	.type	dynamic_alloca_nouse,@function
dynamic_alloca_nouse:
	.param  	i32
	.local  	i32, i32
	i32.const	$push7=, 0
	i32.load	$push11=, __stack_pointer($pop7)
	tee_local	$push10=, $2=, $pop11
	copy_local	$1=, $pop10
	i32.const	$push6=, 0
	i32.const	$push0=, 2
	i32.shl 	$push1=, $0, $pop0
	i32.const	$push2=, 15
	i32.add 	$push3=, $pop1, $pop2
	i32.const	$push4=, -16
	i32.and 	$push5=, $pop3, $pop4
	i32.sub 	$push9=, $2, $pop5
	i32.store	__stack_pointer($pop6), $pop9
	i32.const	$push8=, 0
	i32.store	__stack_pointer($pop8), $1
	return
	.endfunc
.Lfunc_end9:
	.size	dynamic_alloca_nouse, .Lfunc_end9-dynamic_alloca_nouse

	.globl	copytoreg_fi
	.type	copytoreg_fi,@function
copytoreg_fi:
	.param  	i32, i32
	.local  	i32
	i32.const	$push0=, 0
	i32.load	$push1=, __stack_pointer($pop0)
	i32.const	$push2=, 16
	i32.sub 	$push5=, $pop1, $pop2
	i32.const	$push3=, 12
	i32.add 	$push4=, $pop5, $pop3
	copy_local	$2=, $pop4
	i32.const	$push6=, 1
	i32.and 	$0=, $0, $pop6
.LBB10_1:
	loop    	
	i32.const	$push7=, 1
	i32.store	0($2), $pop7
	copy_local	$2=, $1
	br_if   	0, $0
	end_loop
	return
	.endfunc
.Lfunc_end10:
	.size	copytoreg_fi, .Lfunc_end10-copytoreg_fi

	.globl	frameaddress_0
	.type	frameaddress_0,@function
frameaddress_0:
	.local  	i32
	i32.const	$push0=, 0
	i32.load	$push2=, __stack_pointer($pop0)
	copy_local	$push4=, $pop2
	tee_local	$push3=, $0=, $pop4
	call    	use_i8_star@FUNCTION, $pop3
	i32.const	$push1=, 0
	i32.store	__stack_pointer($pop1), $0
	return
	.endfunc
.Lfunc_end11:
	.size	frameaddress_0, .Lfunc_end11-frameaddress_0

	.globl	frameaddress_1
	.type	frameaddress_1,@function
frameaddress_1:
	i32.const	$push0=, 0
	call    	use_i8_star@FUNCTION, $pop0
	return
	.endfunc
.Lfunc_end12:
	.size	frameaddress_1, .Lfunc_end12-frameaddress_1

	.globl	inline_asm
	.type	inline_asm,@function
inline_asm:
	.local  	i32
	i32.const	$push0=, 0
	i32.load	$push1=, __stack_pointer($pop0)
	i32.const	$push2=, 16
	i32.sub 	$push5=, $pop1, $pop2
	i32.const	$push3=, 15
	i32.add 	$push4=, $pop5, $pop3
	copy_local	$0=, $pop4
	#APP
	# %0
	#NO_APP
	return
	.endfunc
.Lfunc_end13:
	.size	inline_asm, .Lfunc_end13-inline_asm


	.functype	ext_func, void, i32
	.functype	ext_func_i32, void, i32
	.functype	use_i8_star, void, i32
