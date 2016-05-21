	.text
	.file	"/s/llvm/llvm/test/CodeGen/WebAssembly/i128.ll"
	.globl	add128
	.type	add128,@function
add128:
	.param  	i32, i64, i64, i64, i64
	i32.const	$push8=, 8
	i32.add 	$push9=, $0, $pop8
	i64.add 	$push6=, $2, $4
	i64.const	$push4=, 1
	i64.add 	$push0=, $1, $3
	i64.store	$push11=, 0($0), $pop0
	tee_local	$push10=, $2=, $pop11
	i64.lt_u	$push2=, $pop10, $1
	i64.extend_u/i32	$push3=, $pop2
	i64.lt_u	$push1=, $2, $3
	i64.select	$push5=, $pop4, $pop3, $pop1
	i64.add 	$push7=, $pop6, $pop5
	i64.store	$drop=, 0($pop9), $pop7
	return
	.endfunc
.Lfunc_end0:
	.size	add128, .Lfunc_end0-add128

	.globl	sub128
	.type	sub128,@function
sub128:
	.param  	i32, i64, i64, i64, i64
	i64.sub 	$push0=, $1, $3
	i64.store	$drop=, 0($0), $pop0
	i32.const	$push5=, 8
	i32.add 	$push6=, $0, $pop5
	i64.sub 	$push1=, $2, $4
	i64.lt_u	$push2=, $1, $3
	i64.extend_u/i32	$push3=, $pop2
	i64.sub 	$push4=, $pop1, $pop3
	i64.store	$drop=, 0($pop6), $pop4
	return
	.endfunc
.Lfunc_end1:
	.size	sub128, .Lfunc_end1-sub128

	.globl	mul128
	.type	mul128,@function
mul128:
	.param  	i32, i64, i64, i64, i64
	.local  	i32
	i32.const	$push8=, __stack_pointer
	i32.const	$push5=, __stack_pointer
	i32.load	$push6=, 0($pop5)
	i32.const	$push7=, 16
	i32.sub 	$push12=, $pop6, $pop7
	i32.store	$push15=, 0($pop8), $pop12
	tee_local	$push14=, $5=, $pop15
	call    	__multi3@FUNCTION, $pop14, $1, $2, $3, $4
	i32.const	$push0=, 8
	i32.add 	$push1=, $0, $pop0
	i32.const	$push13=, 8
	i32.add 	$push2=, $5, $pop13
	i64.load	$push3=, 0($pop2)
	i64.store	$drop=, 0($pop1), $pop3
	i64.load	$push4=, 0($5)
	i64.store	$drop=, 0($0), $pop4
	i32.const	$push11=, __stack_pointer
	i32.const	$push9=, 16
	i32.add 	$push10=, $5, $pop9
	i32.store	$drop=, 0($pop11), $pop10
	return
	.endfunc
.Lfunc_end2:
	.size	mul128, .Lfunc_end2-mul128

	.globl	sdiv128
	.type	sdiv128,@function
sdiv128:
	.param  	i32, i64, i64, i64, i64
	.local  	i32
	i32.const	$push8=, __stack_pointer
	i32.const	$push5=, __stack_pointer
	i32.load	$push6=, 0($pop5)
	i32.const	$push7=, 16
	i32.sub 	$push12=, $pop6, $pop7
	i32.store	$push15=, 0($pop8), $pop12
	tee_local	$push14=, $5=, $pop15
	call    	__divti3@FUNCTION, $pop14, $1, $2, $3, $4
	i32.const	$push0=, 8
	i32.add 	$push1=, $0, $pop0
	i32.const	$push13=, 8
	i32.add 	$push2=, $5, $pop13
	i64.load	$push3=, 0($pop2)
	i64.store	$drop=, 0($pop1), $pop3
	i64.load	$push4=, 0($5)
	i64.store	$drop=, 0($0), $pop4
	i32.const	$push11=, __stack_pointer
	i32.const	$push9=, 16
	i32.add 	$push10=, $5, $pop9
	i32.store	$drop=, 0($pop11), $pop10
	return
	.endfunc
.Lfunc_end3:
	.size	sdiv128, .Lfunc_end3-sdiv128

	.globl	udiv128
	.type	udiv128,@function
udiv128:
	.param  	i32, i64, i64, i64, i64
	.local  	i32
	i32.const	$push8=, __stack_pointer
	i32.const	$push5=, __stack_pointer
	i32.load	$push6=, 0($pop5)
	i32.const	$push7=, 16
	i32.sub 	$push12=, $pop6, $pop7
	i32.store	$push15=, 0($pop8), $pop12
	tee_local	$push14=, $5=, $pop15
	call    	__udivti3@FUNCTION, $pop14, $1, $2, $3, $4
	i32.const	$push0=, 8
	i32.add 	$push1=, $0, $pop0
	i32.const	$push13=, 8
	i32.add 	$push2=, $5, $pop13
	i64.load	$push3=, 0($pop2)
	i64.store	$drop=, 0($pop1), $pop3
	i64.load	$push4=, 0($5)
	i64.store	$drop=, 0($0), $pop4
	i32.const	$push11=, __stack_pointer
	i32.const	$push9=, 16
	i32.add 	$push10=, $5, $pop9
	i32.store	$drop=, 0($pop11), $pop10
	return
	.endfunc
.Lfunc_end4:
	.size	udiv128, .Lfunc_end4-udiv128

	.globl	srem128
	.type	srem128,@function
srem128:
	.param  	i32, i64, i64, i64, i64
	.local  	i32
	i32.const	$push8=, __stack_pointer
	i32.const	$push5=, __stack_pointer
	i32.load	$push6=, 0($pop5)
	i32.const	$push7=, 16
	i32.sub 	$push12=, $pop6, $pop7
	i32.store	$push15=, 0($pop8), $pop12
	tee_local	$push14=, $5=, $pop15
	call    	__modti3@FUNCTION, $pop14, $1, $2, $3, $4
	i32.const	$push0=, 8
	i32.add 	$push1=, $0, $pop0
	i32.const	$push13=, 8
	i32.add 	$push2=, $5, $pop13
	i64.load	$push3=, 0($pop2)
	i64.store	$drop=, 0($pop1), $pop3
	i64.load	$push4=, 0($5)
	i64.store	$drop=, 0($0), $pop4
	i32.const	$push11=, __stack_pointer
	i32.const	$push9=, 16
	i32.add 	$push10=, $5, $pop9
	i32.store	$drop=, 0($pop11), $pop10
	return
	.endfunc
.Lfunc_end5:
	.size	srem128, .Lfunc_end5-srem128

	.globl	urem128
	.type	urem128,@function
urem128:
	.param  	i32, i64, i64, i64, i64
	.local  	i32
	i32.const	$push8=, __stack_pointer
	i32.const	$push5=, __stack_pointer
	i32.load	$push6=, 0($pop5)
	i32.const	$push7=, 16
	i32.sub 	$push12=, $pop6, $pop7
	i32.store	$push15=, 0($pop8), $pop12
	tee_local	$push14=, $5=, $pop15
	call    	__umodti3@FUNCTION, $pop14, $1, $2, $3, $4
	i32.const	$push0=, 8
	i32.add 	$push1=, $0, $pop0
	i32.const	$push13=, 8
	i32.add 	$push2=, $5, $pop13
	i64.load	$push3=, 0($pop2)
	i64.store	$drop=, 0($pop1), $pop3
	i64.load	$push4=, 0($5)
	i64.store	$drop=, 0($0), $pop4
	i32.const	$push11=, __stack_pointer
	i32.const	$push9=, 16
	i32.add 	$push10=, $5, $pop9
	i32.store	$drop=, 0($pop11), $pop10
	return
	.endfunc
.Lfunc_end6:
	.size	urem128, .Lfunc_end6-urem128

	.globl	and128
	.type	and128,@function
and128:
	.param  	i32, i64, i64, i64, i64
	i32.const	$push1=, 8
	i32.add 	$push2=, $0, $pop1
	i64.and 	$push0=, $2, $4
	i64.store	$drop=, 0($pop2), $pop0
	i64.and 	$push3=, $1, $3
	i64.store	$drop=, 0($0), $pop3
	return
	.endfunc
.Lfunc_end7:
	.size	and128, .Lfunc_end7-and128

	.globl	or128
	.type	or128,@function
or128:
	.param  	i32, i64, i64, i64, i64
	i32.const	$push1=, 8
	i32.add 	$push2=, $0, $pop1
	i64.or  	$push0=, $2, $4
	i64.store	$drop=, 0($pop2), $pop0
	i64.or  	$push3=, $1, $3
	i64.store	$drop=, 0($0), $pop3
	return
	.endfunc
.Lfunc_end8:
	.size	or128, .Lfunc_end8-or128

	.globl	xor128
	.type	xor128,@function
xor128:
	.param  	i32, i64, i64, i64, i64
	i32.const	$push1=, 8
	i32.add 	$push2=, $0, $pop1
	i64.xor 	$push0=, $2, $4
	i64.store	$drop=, 0($pop2), $pop0
	i64.xor 	$push3=, $1, $3
	i64.store	$drop=, 0($0), $pop3
	return
	.endfunc
.Lfunc_end9:
	.size	xor128, .Lfunc_end9-xor128

	.globl	shl128
	.type	shl128,@function
shl128:
	.param  	i32, i64, i64, i64, i64
	.local  	i32
	i32.const	$push9=, __stack_pointer
	i32.const	$push6=, __stack_pointer
	i32.load	$push7=, 0($pop6)
	i32.const	$push8=, 16
	i32.sub 	$push13=, $pop7, $pop8
	i32.store	$push16=, 0($pop9), $pop13
	tee_local	$push15=, $5=, $pop16
	i32.wrap/i64	$push0=, $3
	call    	__ashlti3@FUNCTION, $pop15, $1, $2, $pop0
	i32.const	$push1=, 8
	i32.add 	$push2=, $0, $pop1
	i32.const	$push14=, 8
	i32.add 	$push3=, $5, $pop14
	i64.load	$push4=, 0($pop3)
	i64.store	$drop=, 0($pop2), $pop4
	i64.load	$push5=, 0($5)
	i64.store	$drop=, 0($0), $pop5
	i32.const	$push12=, __stack_pointer
	i32.const	$push10=, 16
	i32.add 	$push11=, $5, $pop10
	i32.store	$drop=, 0($pop12), $pop11
	return
	.endfunc
.Lfunc_end10:
	.size	shl128, .Lfunc_end10-shl128

	.globl	shr128
	.type	shr128,@function
shr128:
	.param  	i32, i64, i64, i64, i64
	.local  	i32
	i32.const	$push9=, __stack_pointer
	i32.const	$push6=, __stack_pointer
	i32.load	$push7=, 0($pop6)
	i32.const	$push8=, 16
	i32.sub 	$push13=, $pop7, $pop8
	i32.store	$push16=, 0($pop9), $pop13
	tee_local	$push15=, $5=, $pop16
	i32.wrap/i64	$push0=, $3
	call    	__lshrti3@FUNCTION, $pop15, $1, $2, $pop0
	i32.const	$push1=, 8
	i32.add 	$push2=, $0, $pop1
	i32.const	$push14=, 8
	i32.add 	$push3=, $5, $pop14
	i64.load	$push4=, 0($pop3)
	i64.store	$drop=, 0($pop2), $pop4
	i64.load	$push5=, 0($5)
	i64.store	$drop=, 0($0), $pop5
	i32.const	$push12=, __stack_pointer
	i32.const	$push10=, 16
	i32.add 	$push11=, $5, $pop10
	i32.store	$drop=, 0($pop12), $pop11
	return
	.endfunc
.Lfunc_end11:
	.size	shr128, .Lfunc_end11-shr128

	.globl	sar128
	.type	sar128,@function
sar128:
	.param  	i32, i64, i64, i64, i64
	.local  	i32
	i32.const	$push9=, __stack_pointer
	i32.const	$push6=, __stack_pointer
	i32.load	$push7=, 0($pop6)
	i32.const	$push8=, 16
	i32.sub 	$push13=, $pop7, $pop8
	i32.store	$push16=, 0($pop9), $pop13
	tee_local	$push15=, $5=, $pop16
	i32.wrap/i64	$push0=, $3
	call    	__ashrti3@FUNCTION, $pop15, $1, $2, $pop0
	i32.const	$push1=, 8
	i32.add 	$push2=, $0, $pop1
	i32.const	$push14=, 8
	i32.add 	$push3=, $5, $pop14
	i64.load	$push4=, 0($pop3)
	i64.store	$drop=, 0($pop2), $pop4
	i64.load	$push5=, 0($5)
	i64.store	$drop=, 0($0), $pop5
	i32.const	$push12=, __stack_pointer
	i32.const	$push10=, 16
	i32.add 	$push11=, $5, $pop10
	i32.store	$drop=, 0($pop12), $pop11
	return
	.endfunc
.Lfunc_end12:
	.size	sar128, .Lfunc_end12-sar128

	.globl	clz128
	.type	clz128,@function
clz128:
	.param  	i32, i64, i64
	i64.clz 	$push8=, $2
	i64.clz 	$push5=, $1
	i64.const	$push6=, 64
	i64.add 	$push7=, $pop5, $pop6
	i32.const	$push1=, 8
	i32.add 	$push2=, $0, $pop1
	i64.const	$push3=, 0
	i64.store	$push0=, 0($pop2), $pop3
	i64.ne  	$push4=, $2, $pop0
	i64.select	$push9=, $pop8, $pop7, $pop4
	i64.store	$drop=, 0($0), $pop9
	return
	.endfunc
.Lfunc_end13:
	.size	clz128, .Lfunc_end13-clz128

	.globl	clz128_zero_undef
	.type	clz128_zero_undef,@function
clz128_zero_undef:
	.param  	i32, i64, i64
	i64.clz 	$push8=, $2
	i64.clz 	$push5=, $1
	i64.const	$push6=, 64
	i64.add 	$push7=, $pop5, $pop6
	i32.const	$push1=, 8
	i32.add 	$push2=, $0, $pop1
	i64.const	$push3=, 0
	i64.store	$push0=, 0($pop2), $pop3
	i64.ne  	$push4=, $2, $pop0
	i64.select	$push9=, $pop8, $pop7, $pop4
	i64.store	$drop=, 0($0), $pop9
	return
	.endfunc
.Lfunc_end14:
	.size	clz128_zero_undef, .Lfunc_end14-clz128_zero_undef

	.globl	ctz128
	.type	ctz128,@function
ctz128:
	.param  	i32, i64, i64
	i64.ctz 	$push8=, $1
	i64.ctz 	$push5=, $2
	i64.const	$push6=, 64
	i64.add 	$push7=, $pop5, $pop6
	i32.const	$push1=, 8
	i32.add 	$push2=, $0, $pop1
	i64.const	$push3=, 0
	i64.store	$push0=, 0($pop2), $pop3
	i64.ne  	$push4=, $1, $pop0
	i64.select	$push9=, $pop8, $pop7, $pop4
	i64.store	$drop=, 0($0), $pop9
	return
	.endfunc
.Lfunc_end15:
	.size	ctz128, .Lfunc_end15-ctz128

	.globl	ctz128_zero_undef
	.type	ctz128_zero_undef,@function
ctz128_zero_undef:
	.param  	i32, i64, i64
	i64.ctz 	$push8=, $1
	i64.ctz 	$push5=, $2
	i64.const	$push6=, 64
	i64.add 	$push7=, $pop5, $pop6
	i32.const	$push1=, 8
	i32.add 	$push2=, $0, $pop1
	i64.const	$push3=, 0
	i64.store	$push0=, 0($pop2), $pop3
	i64.ne  	$push4=, $1, $pop0
	i64.select	$push9=, $pop8, $pop7, $pop4
	i64.store	$drop=, 0($0), $pop9
	return
	.endfunc
.Lfunc_end16:
	.size	ctz128_zero_undef, .Lfunc_end16-ctz128_zero_undef

	.globl	popcnt128
	.type	popcnt128,@function
popcnt128:
	.param  	i32, i64, i64
	i32.const	$push0=, 8
	i32.add 	$push1=, $0, $pop0
	i64.const	$push2=, 0
	i64.store	$drop=, 0($pop1), $pop2
	i64.popcnt	$push4=, $1
	i64.popcnt	$push3=, $2
	i64.add 	$push5=, $pop4, $pop3
	i64.store	$drop=, 0($0), $pop5
	return
	.endfunc
.Lfunc_end17:
	.size	popcnt128, .Lfunc_end17-popcnt128

	.globl	eqz128
	.type	eqz128,@function
eqz128:
	.param  	i64, i64
	.result 	i32
	i64.or  	$push0=, $0, $1
	i64.eqz 	$push1=, $pop0
	return  	$pop1
	.endfunc
.Lfunc_end18:
	.size	eqz128, .Lfunc_end18-eqz128

	.globl	rotl
	.type	rotl,@function
rotl:
	.param  	i32, i64, i64, i64, i64
	.local  	i32
	i32.const	$push17=, __stack_pointer
	i32.const	$push14=, __stack_pointer
	i32.load	$push15=, 0($pop14)
	i32.const	$push16=, 32
	i32.sub 	$push25=, $pop15, $pop16
	i32.store	$push29=, 0($pop17), $pop25
	tee_local	$push28=, $5=, $pop29
	i32.const	$push21=, 16
	i32.add 	$push22=, $pop28, $pop21
	i32.wrap/i64	$push0=, $3
	call    	__ashlti3@FUNCTION, $pop22, $1, $2, $pop0
	i64.const	$push1=, 128
	i64.sub 	$push2=, $pop1, $3
	i32.wrap/i64	$push3=, $pop2
	call    	__lshrti3@FUNCTION, $5, $1, $2, $pop3
	i32.const	$push4=, 8
	i32.add 	$push5=, $0, $pop4
	i32.const	$push23=, 16
	i32.add 	$push24=, $5, $pop23
	i32.const	$push27=, 8
	i32.add 	$push6=, $pop24, $pop27
	i64.load	$push7=, 0($pop6)
	i32.const	$push26=, 8
	i32.add 	$push8=, $5, $pop26
	i64.load	$push9=, 0($pop8)
	i64.or  	$push10=, $pop7, $pop9
	i64.store	$drop=, 0($pop5), $pop10
	i64.load	$push11=, 16($5)
	i64.load	$push12=, 0($5)
	i64.or  	$push13=, $pop11, $pop12
	i64.store	$drop=, 0($0), $pop13
	i32.const	$push20=, __stack_pointer
	i32.const	$push18=, 32
	i32.add 	$push19=, $5, $pop18
	i32.store	$drop=, 0($pop20), $pop19
	return
	.endfunc
.Lfunc_end19:
	.size	rotl, .Lfunc_end19-rotl

	.globl	masked_rotl
	.type	masked_rotl,@function
masked_rotl:
	.param  	i32, i64, i64, i64, i64
	.local  	i32
	i32.const	$push18=, __stack_pointer
	i32.const	$push15=, __stack_pointer
	i32.load	$push16=, 0($pop15)
	i32.const	$push17=, 32
	i32.sub 	$push26=, $pop16, $pop17
	i32.store	$push32=, 0($pop18), $pop26
	tee_local	$push31=, $5=, $pop32
	i32.const	$push22=, 16
	i32.add 	$push23=, $pop31, $pop22
	i64.const	$push0=, 127
	i64.and 	$push30=, $3, $pop0
	tee_local	$push29=, $3=, $pop30
	i32.wrap/i64	$push1=, $pop29
	call    	__ashlti3@FUNCTION, $pop23, $1, $2, $pop1
	i64.const	$push2=, 128
	i64.sub 	$push3=, $pop2, $3
	i32.wrap/i64	$push4=, $pop3
	call    	__lshrti3@FUNCTION, $5, $1, $2, $pop4
	i32.const	$push5=, 8
	i32.add 	$push6=, $0, $pop5
	i32.const	$push24=, 16
	i32.add 	$push25=, $5, $pop24
	i32.const	$push28=, 8
	i32.add 	$push7=, $pop25, $pop28
	i64.load	$push8=, 0($pop7)
	i32.const	$push27=, 8
	i32.add 	$push9=, $5, $pop27
	i64.load	$push10=, 0($pop9)
	i64.or  	$push11=, $pop8, $pop10
	i64.store	$drop=, 0($pop6), $pop11
	i64.load	$push12=, 16($5)
	i64.load	$push13=, 0($5)
	i64.or  	$push14=, $pop12, $pop13
	i64.store	$drop=, 0($0), $pop14
	i32.const	$push21=, __stack_pointer
	i32.const	$push19=, 32
	i32.add 	$push20=, $5, $pop19
	i32.store	$drop=, 0($pop21), $pop20
	return
	.endfunc
.Lfunc_end20:
	.size	masked_rotl, .Lfunc_end20-masked_rotl

	.globl	rotr
	.type	rotr,@function
rotr:
	.param  	i32, i64, i64, i64, i64
	.local  	i32
	i32.const	$push17=, __stack_pointer
	i32.const	$push14=, __stack_pointer
	i32.load	$push15=, 0($pop14)
	i32.const	$push16=, 32
	i32.sub 	$push25=, $pop15, $pop16
	i32.store	$push29=, 0($pop17), $pop25
	tee_local	$push28=, $5=, $pop29
	i32.const	$push21=, 16
	i32.add 	$push22=, $pop28, $pop21
	i32.wrap/i64	$push0=, $3
	call    	__lshrti3@FUNCTION, $pop22, $1, $2, $pop0
	i64.const	$push1=, 128
	i64.sub 	$push2=, $pop1, $3
	i32.wrap/i64	$push3=, $pop2
	call    	__ashlti3@FUNCTION, $5, $1, $2, $pop3
	i32.const	$push4=, 8
	i32.add 	$push5=, $0, $pop4
	i32.const	$push23=, 16
	i32.add 	$push24=, $5, $pop23
	i32.const	$push27=, 8
	i32.add 	$push6=, $pop24, $pop27
	i64.load	$push7=, 0($pop6)
	i32.const	$push26=, 8
	i32.add 	$push8=, $5, $pop26
	i64.load	$push9=, 0($pop8)
	i64.or  	$push10=, $pop7, $pop9
	i64.store	$drop=, 0($pop5), $pop10
	i64.load	$push11=, 16($5)
	i64.load	$push12=, 0($5)
	i64.or  	$push13=, $pop11, $pop12
	i64.store	$drop=, 0($0), $pop13
	i32.const	$push20=, __stack_pointer
	i32.const	$push18=, 32
	i32.add 	$push19=, $5, $pop18
	i32.store	$drop=, 0($pop20), $pop19
	return
	.endfunc
.Lfunc_end21:
	.size	rotr, .Lfunc_end21-rotr

	.globl	masked_rotr
	.type	masked_rotr,@function
masked_rotr:
	.param  	i32, i64, i64, i64, i64
	.local  	i32
	i32.const	$push18=, __stack_pointer
	i32.const	$push15=, __stack_pointer
	i32.load	$push16=, 0($pop15)
	i32.const	$push17=, 32
	i32.sub 	$push26=, $pop16, $pop17
	i32.store	$push32=, 0($pop18), $pop26
	tee_local	$push31=, $5=, $pop32
	i32.const	$push22=, 16
	i32.add 	$push23=, $pop31, $pop22
	i64.const	$push0=, 127
	i64.and 	$push30=, $3, $pop0
	tee_local	$push29=, $3=, $pop30
	i32.wrap/i64	$push1=, $pop29
	call    	__lshrti3@FUNCTION, $pop23, $1, $2, $pop1
	i64.const	$push2=, 128
	i64.sub 	$push3=, $pop2, $3
	i32.wrap/i64	$push4=, $pop3
	call    	__ashlti3@FUNCTION, $5, $1, $2, $pop4
	i32.const	$push5=, 8
	i32.add 	$push6=, $0, $pop5
	i32.const	$push24=, 16
	i32.add 	$push25=, $5, $pop24
	i32.const	$push28=, 8
	i32.add 	$push7=, $pop25, $pop28
	i64.load	$push8=, 0($pop7)
	i32.const	$push27=, 8
	i32.add 	$push9=, $5, $pop27
	i64.load	$push10=, 0($pop9)
	i64.or  	$push11=, $pop8, $pop10
	i64.store	$drop=, 0($pop6), $pop11
	i64.load	$push12=, 16($5)
	i64.load	$push13=, 0($5)
	i64.or  	$push14=, $pop12, $pop13
	i64.store	$drop=, 0($0), $pop14
	i32.const	$push21=, __stack_pointer
	i32.const	$push19=, 32
	i32.add 	$push20=, $5, $pop19
	i32.store	$drop=, 0($pop21), $pop20
	return
	.endfunc
.Lfunc_end22:
	.size	masked_rotr, .Lfunc_end22-masked_rotr


