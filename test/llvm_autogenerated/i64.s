	.text
	.file	"/s/llvm-upstream/llvm/test/CodeGen/WebAssembly/i64.ll"
	.globl	add64
	.type	add64,@function
add64:
	.param  	i64, i64
	.result 	i64
	i64.add 	$push0=, $0, $1
	return  	$pop0
	.endfunc
.Lfunc_end0:
	.size	add64, .Lfunc_end0-add64

	.globl	sub64
	.type	sub64,@function
sub64:
	.param  	i64, i64
	.result 	i64
	i64.sub 	$push0=, $0, $1
	return  	$pop0
	.endfunc
.Lfunc_end1:
	.size	sub64, .Lfunc_end1-sub64

	.globl	mul64
	.type	mul64,@function
mul64:
	.param  	i64, i64
	.result 	i64
	i64.mul 	$push0=, $0, $1
	return  	$pop0
	.endfunc
.Lfunc_end2:
	.size	mul64, .Lfunc_end2-mul64

	.globl	sdiv64
	.type	sdiv64,@function
sdiv64:
	.param  	i64, i64
	.result 	i64
	i64.div_s	$push0=, $0, $1
	return  	$pop0
	.endfunc
.Lfunc_end3:
	.size	sdiv64, .Lfunc_end3-sdiv64

	.globl	udiv64
	.type	udiv64,@function
udiv64:
	.param  	i64, i64
	.result 	i64
	i64.div_u	$push0=, $0, $1
	return  	$pop0
	.endfunc
.Lfunc_end4:
	.size	udiv64, .Lfunc_end4-udiv64

	.globl	srem64
	.type	srem64,@function
srem64:
	.param  	i64, i64
	.result 	i64
	i64.rem_s	$push0=, $0, $1
	return  	$pop0
	.endfunc
.Lfunc_end5:
	.size	srem64, .Lfunc_end5-srem64

	.globl	urem64
	.type	urem64,@function
urem64:
	.param  	i64, i64
	.result 	i64
	i64.rem_u	$push0=, $0, $1
	return  	$pop0
	.endfunc
.Lfunc_end6:
	.size	urem64, .Lfunc_end6-urem64

	.globl	and64
	.type	and64,@function
and64:
	.param  	i64, i64
	.result 	i64
	i64.and 	$push0=, $0, $1
	return  	$pop0
	.endfunc
.Lfunc_end7:
	.size	and64, .Lfunc_end7-and64

	.globl	or64
	.type	or64,@function
or64:
	.param  	i64, i64
	.result 	i64
	i64.or  	$push0=, $0, $1
	return  	$pop0
	.endfunc
.Lfunc_end8:
	.size	or64, .Lfunc_end8-or64

	.globl	xor64
	.type	xor64,@function
xor64:
	.param  	i64, i64
	.result 	i64
	i64.xor 	$push0=, $0, $1
	return  	$pop0
	.endfunc
.Lfunc_end9:
	.size	xor64, .Lfunc_end9-xor64

	.globl	shl64
	.type	shl64,@function
shl64:
	.param  	i64, i64
	.result 	i64
	i64.shl 	$push0=, $0, $1
	return  	$pop0
	.endfunc
.Lfunc_end10:
	.size	shl64, .Lfunc_end10-shl64

	.globl	shr64
	.type	shr64,@function
shr64:
	.param  	i64, i64
	.result 	i64
	i64.shr_u	$push0=, $0, $1
	return  	$pop0
	.endfunc
.Lfunc_end11:
	.size	shr64, .Lfunc_end11-shr64

	.globl	sar64
	.type	sar64,@function
sar64:
	.param  	i64, i64
	.result 	i64
	i64.shr_s	$push0=, $0, $1
	return  	$pop0
	.endfunc
.Lfunc_end12:
	.size	sar64, .Lfunc_end12-sar64

	.globl	clz64
	.type	clz64,@function
clz64:
	.param  	i64
	.result 	i64
	i64.clz 	$push0=, $0
	return  	$pop0
	.endfunc
.Lfunc_end13:
	.size	clz64, .Lfunc_end13-clz64

	.globl	clz64_zero_undef
	.type	clz64_zero_undef,@function
clz64_zero_undef:
	.param  	i64
	.result 	i64
	i64.clz 	$push0=, $0
	return  	$pop0
	.endfunc
.Lfunc_end14:
	.size	clz64_zero_undef, .Lfunc_end14-clz64_zero_undef

	.globl	ctz64
	.type	ctz64,@function
ctz64:
	.param  	i64
	.result 	i64
	i64.ctz 	$push0=, $0
	return  	$pop0
	.endfunc
.Lfunc_end15:
	.size	ctz64, .Lfunc_end15-ctz64

	.globl	ctz64_zero_undef
	.type	ctz64_zero_undef,@function
ctz64_zero_undef:
	.param  	i64
	.result 	i64
	i64.ctz 	$push0=, $0
	return  	$pop0
	.endfunc
.Lfunc_end16:
	.size	ctz64_zero_undef, .Lfunc_end16-ctz64_zero_undef

	.globl	popcnt64
	.type	popcnt64,@function
popcnt64:
	.param  	i64
	.result 	i64
	i64.popcnt	$push0=, $0
	return  	$pop0
	.endfunc
.Lfunc_end17:
	.size	popcnt64, .Lfunc_end17-popcnt64

	.globl	eqz64
	.type	eqz64,@function
eqz64:
	.param  	i64
	.result 	i32
	i64.eqz 	$push0=, $0
	return  	$pop0
	.endfunc
.Lfunc_end18:
	.size	eqz64, .Lfunc_end18-eqz64

	.globl	rotl
	.type	rotl,@function
rotl:
	.param  	i64, i64
	.result 	i64
	i64.rotl	$push0=, $0, $1
	return  	$pop0
	.endfunc
.Lfunc_end19:
	.size	rotl, .Lfunc_end19-rotl

	.globl	masked_rotl
	.type	masked_rotl,@function
masked_rotl:
	.param  	i64, i64
	.result 	i64
	i64.rotl	$push0=, $0, $1
	return  	$pop0
	.endfunc
.Lfunc_end20:
	.size	masked_rotl, .Lfunc_end20-masked_rotl

	.globl	rotr
	.type	rotr,@function
rotr:
	.param  	i64, i64
	.result 	i64
	i64.rotr	$push0=, $0, $1
	return  	$pop0
	.endfunc
.Lfunc_end21:
	.size	rotr, .Lfunc_end21-rotr

	.globl	masked_rotr
	.type	masked_rotr,@function
masked_rotr:
	.param  	i64, i64
	.result 	i64
	i64.rotr	$push0=, $0, $1
	return  	$pop0
	.endfunc
.Lfunc_end22:
	.size	masked_rotr, .Lfunc_end22-masked_rotr


