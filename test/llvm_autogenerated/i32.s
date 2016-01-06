	.text
	.file	"/s/llvm/llvm/test/CodeGen/WebAssembly/i32.ll"
	.globl	add32
	.type	add32,@function
add32:
	.param  	i32, i32
	.result 	i32
	i32.add 	$push0=, $0, $1
	return  	$pop0
func_end0:
	.size	add32, func_end0-add32

	.globl	sub32
	.type	sub32,@function
sub32:
	.param  	i32, i32
	.result 	i32
	i32.sub 	$push0=, $0, $1
	return  	$pop0
func_end1:
	.size	sub32, func_end1-sub32

	.globl	mul32
	.type	mul32,@function
mul32:
	.param  	i32, i32
	.result 	i32
	i32.mul 	$push0=, $0, $1
	return  	$pop0
func_end2:
	.size	mul32, func_end2-mul32

	.globl	sdiv32
	.type	sdiv32,@function
sdiv32:
	.param  	i32, i32
	.result 	i32
	i32.div_s	$push0=, $0, $1
	return  	$pop0
func_end3:
	.size	sdiv32, func_end3-sdiv32

	.globl	udiv32
	.type	udiv32,@function
udiv32:
	.param  	i32, i32
	.result 	i32
	i32.div_u	$push0=, $0, $1
	return  	$pop0
func_end4:
	.size	udiv32, func_end4-udiv32

	.globl	srem32
	.type	srem32,@function
srem32:
	.param  	i32, i32
	.result 	i32
	i32.rem_s	$push0=, $0, $1
	return  	$pop0
func_end5:
	.size	srem32, func_end5-srem32

	.globl	urem32
	.type	urem32,@function
urem32:
	.param  	i32, i32
	.result 	i32
	i32.rem_u	$push0=, $0, $1
	return  	$pop0
func_end6:
	.size	urem32, func_end6-urem32

	.globl	and32
	.type	and32,@function
and32:
	.param  	i32, i32
	.result 	i32
	i32.and 	$push0=, $0, $1
	return  	$pop0
func_end7:
	.size	and32, func_end7-and32

	.globl	or32
	.type	or32,@function
or32:
	.param  	i32, i32
	.result 	i32
	i32.or  	$push0=, $0, $1
	return  	$pop0
func_end8:
	.size	or32, func_end8-or32

	.globl	xor32
	.type	xor32,@function
xor32:
	.param  	i32, i32
	.result 	i32
	i32.xor 	$push0=, $0, $1
	return  	$pop0
func_end9:
	.size	xor32, func_end9-xor32

	.globl	shl32
	.type	shl32,@function
shl32:
	.param  	i32, i32
	.result 	i32
	i32.shl 	$push0=, $0, $1
	return  	$pop0
func_end10:
	.size	shl32, func_end10-shl32

	.globl	shr32
	.type	shr32,@function
shr32:
	.param  	i32, i32
	.result 	i32
	i32.shr_u	$push0=, $0, $1
	return  	$pop0
func_end11:
	.size	shr32, func_end11-shr32

	.globl	sar32
	.type	sar32,@function
sar32:
	.param  	i32, i32
	.result 	i32
	i32.shr_s	$push0=, $0, $1
	return  	$pop0
func_end12:
	.size	sar32, func_end12-sar32

	.globl	clz32
	.type	clz32,@function
clz32:
	.param  	i32
	.result 	i32
	i32.clz 	$push0=, $0
	return  	$pop0
func_end13:
	.size	clz32, func_end13-clz32

	.globl	clz32_zero_undef
	.type	clz32_zero_undef,@function
clz32_zero_undef:
	.param  	i32
	.result 	i32
	i32.clz 	$push0=, $0
	return  	$pop0
func_end14:
	.size	clz32_zero_undef, func_end14-clz32_zero_undef

	.globl	ctz32
	.type	ctz32,@function
ctz32:
	.param  	i32
	.result 	i32
	i32.ctz 	$push0=, $0
	return  	$pop0
func_end15:
	.size	ctz32, func_end15-ctz32

	.globl	ctz32_zero_undef
	.type	ctz32_zero_undef,@function
ctz32_zero_undef:
	.param  	i32
	.result 	i32
	i32.ctz 	$push0=, $0
	return  	$pop0
func_end16:
	.size	ctz32_zero_undef, func_end16-ctz32_zero_undef

	.globl	popcnt32
	.type	popcnt32,@function
popcnt32:
	.param  	i32
	.result 	i32
	i32.popcnt	$push0=, $0
	return  	$pop0
func_end17:
	.size	popcnt32, func_end17-popcnt32


	.section	".note.GNU-stack","",@progbits
