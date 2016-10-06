	.text
	.file	"/s/llvm-upstream/llvm/test/CodeGen/WebAssembly/i32-load-store-alignment.ll"
	.globl	ldi32_a1
	.type	ldi32_a1,@function
ldi32_a1:
	.param  	i32
	.result 	i32
	i32.load	$push0=, 0($0):p2align=0
	return  	$pop0
	.endfunc
.Lfunc_end0:
	.size	ldi32_a1, .Lfunc_end0-ldi32_a1

	.globl	ldi32_a2
	.type	ldi32_a2,@function
ldi32_a2:
	.param  	i32
	.result 	i32
	i32.load	$push0=, 0($0):p2align=1
	return  	$pop0
	.endfunc
.Lfunc_end1:
	.size	ldi32_a2, .Lfunc_end1-ldi32_a2

	.globl	ldi32_a4
	.type	ldi32_a4,@function
ldi32_a4:
	.param  	i32
	.result 	i32
	i32.load	$push0=, 0($0)
	return  	$pop0
	.endfunc
.Lfunc_end2:
	.size	ldi32_a4, .Lfunc_end2-ldi32_a4

	.globl	ldi32
	.type	ldi32,@function
ldi32:
	.param  	i32
	.result 	i32
	i32.load	$push0=, 0($0)
	return  	$pop0
	.endfunc
.Lfunc_end3:
	.size	ldi32, .Lfunc_end3-ldi32

	.globl	ldi32_a8
	.type	ldi32_a8,@function
ldi32_a8:
	.param  	i32
	.result 	i32
	i32.load	$push0=, 0($0)
	return  	$pop0
	.endfunc
.Lfunc_end4:
	.size	ldi32_a8, .Lfunc_end4-ldi32_a8

	.globl	ldi8_a1
	.type	ldi8_a1,@function
ldi8_a1:
	.param  	i32
	.result 	i32
	i32.load8_u	$push0=, 0($0)
	return  	$pop0
	.endfunc
.Lfunc_end5:
	.size	ldi8_a1, .Lfunc_end5-ldi8_a1

	.globl	ldi8_a2
	.type	ldi8_a2,@function
ldi8_a2:
	.param  	i32
	.result 	i32
	i32.load8_u	$push0=, 0($0)
	return  	$pop0
	.endfunc
.Lfunc_end6:
	.size	ldi8_a2, .Lfunc_end6-ldi8_a2

	.globl	ldi16_a1
	.type	ldi16_a1,@function
ldi16_a1:
	.param  	i32
	.result 	i32
	i32.load16_u	$push0=, 0($0):p2align=0
	return  	$pop0
	.endfunc
.Lfunc_end7:
	.size	ldi16_a1, .Lfunc_end7-ldi16_a1

	.globl	ldi16_a2
	.type	ldi16_a2,@function
ldi16_a2:
	.param  	i32
	.result 	i32
	i32.load16_u	$push0=, 0($0)
	return  	$pop0
	.endfunc
.Lfunc_end8:
	.size	ldi16_a2, .Lfunc_end8-ldi16_a2

	.globl	ldi16_a4
	.type	ldi16_a4,@function
ldi16_a4:
	.param  	i32
	.result 	i32
	i32.load16_u	$push0=, 0($0)
	return  	$pop0
	.endfunc
.Lfunc_end9:
	.size	ldi16_a4, .Lfunc_end9-ldi16_a4

	.globl	sti32_a1
	.type	sti32_a1,@function
sti32_a1:
	.param  	i32, i32
	i32.store	0($0):p2align=0, $1
	return
	.endfunc
.Lfunc_end10:
	.size	sti32_a1, .Lfunc_end10-sti32_a1

	.globl	sti32_a2
	.type	sti32_a2,@function
sti32_a2:
	.param  	i32, i32
	i32.store	0($0):p2align=1, $1
	return
	.endfunc
.Lfunc_end11:
	.size	sti32_a2, .Lfunc_end11-sti32_a2

	.globl	sti32_a4
	.type	sti32_a4,@function
sti32_a4:
	.param  	i32, i32
	i32.store	0($0), $1
	return
	.endfunc
.Lfunc_end12:
	.size	sti32_a4, .Lfunc_end12-sti32_a4

	.globl	sti32
	.type	sti32,@function
sti32:
	.param  	i32, i32
	i32.store	0($0), $1
	return
	.endfunc
.Lfunc_end13:
	.size	sti32, .Lfunc_end13-sti32

	.globl	sti32_a8
	.type	sti32_a8,@function
sti32_a8:
	.param  	i32, i32
	i32.store	0($0), $1
	return
	.endfunc
.Lfunc_end14:
	.size	sti32_a8, .Lfunc_end14-sti32_a8

	.globl	sti8_a1
	.type	sti8_a1,@function
sti8_a1:
	.param  	i32, i32
	i32.store8	0($0), $1
	return
	.endfunc
.Lfunc_end15:
	.size	sti8_a1, .Lfunc_end15-sti8_a1

	.globl	sti8_a2
	.type	sti8_a2,@function
sti8_a2:
	.param  	i32, i32
	i32.store8	0($0), $1
	return
	.endfunc
.Lfunc_end16:
	.size	sti8_a2, .Lfunc_end16-sti8_a2

	.globl	sti16_a1
	.type	sti16_a1,@function
sti16_a1:
	.param  	i32, i32
	i32.store16	0($0):p2align=0, $1
	return
	.endfunc
.Lfunc_end17:
	.size	sti16_a1, .Lfunc_end17-sti16_a1

	.globl	sti16_a2
	.type	sti16_a2,@function
sti16_a2:
	.param  	i32, i32
	i32.store16	0($0), $1
	return
	.endfunc
.Lfunc_end18:
	.size	sti16_a2, .Lfunc_end18-sti16_a2

	.globl	sti16_a4
	.type	sti16_a4,@function
sti16_a4:
	.param  	i32, i32
	i32.store16	0($0), $1
	return
	.endfunc
.Lfunc_end19:
	.size	sti16_a4, .Lfunc_end19-sti16_a4


