	.text
	.file	"/s/llvm-upstream/llvm/test/CodeGen/WebAssembly/i64-load-store-alignment.ll"
	.globl	ldi64_a1
	.type	ldi64_a1,@function
ldi64_a1:
	.param  	i32
	.result 	i64
	i64.load	$push0=, 0($0):p2align=0
	return  	$pop0
	.endfunc
.Lfunc_end0:
	.size	ldi64_a1, .Lfunc_end0-ldi64_a1

	.globl	ldi64_a2
	.type	ldi64_a2,@function
ldi64_a2:
	.param  	i32
	.result 	i64
	i64.load	$push0=, 0($0):p2align=1
	return  	$pop0
	.endfunc
.Lfunc_end1:
	.size	ldi64_a2, .Lfunc_end1-ldi64_a2

	.globl	ldi64_a4
	.type	ldi64_a4,@function
ldi64_a4:
	.param  	i32
	.result 	i64
	i64.load	$push0=, 0($0):p2align=2
	return  	$pop0
	.endfunc
.Lfunc_end2:
	.size	ldi64_a4, .Lfunc_end2-ldi64_a4

	.globl	ldi64_a8
	.type	ldi64_a8,@function
ldi64_a8:
	.param  	i32
	.result 	i64
	i64.load	$push0=, 0($0)
	return  	$pop0
	.endfunc
.Lfunc_end3:
	.size	ldi64_a8, .Lfunc_end3-ldi64_a8

	.globl	ldi64
	.type	ldi64,@function
ldi64:
	.param  	i32
	.result 	i64
	i64.load	$push0=, 0($0)
	return  	$pop0
	.endfunc
.Lfunc_end4:
	.size	ldi64, .Lfunc_end4-ldi64

	.globl	ldi64_a16
	.type	ldi64_a16,@function
ldi64_a16:
	.param  	i32
	.result 	i64
	i64.load	$push0=, 0($0)
	return  	$pop0
	.endfunc
.Lfunc_end5:
	.size	ldi64_a16, .Lfunc_end5-ldi64_a16

	.globl	ldi8_a1
	.type	ldi8_a1,@function
ldi8_a1:
	.param  	i32
	.result 	i64
	i64.load8_u	$push0=, 0($0)
	return  	$pop0
	.endfunc
.Lfunc_end6:
	.size	ldi8_a1, .Lfunc_end6-ldi8_a1

	.globl	ldi8_a2
	.type	ldi8_a2,@function
ldi8_a2:
	.param  	i32
	.result 	i64
	i64.load8_u	$push0=, 0($0)
	return  	$pop0
	.endfunc
.Lfunc_end7:
	.size	ldi8_a2, .Lfunc_end7-ldi8_a2

	.globl	ldi16_a1
	.type	ldi16_a1,@function
ldi16_a1:
	.param  	i32
	.result 	i64
	i64.load16_u	$push0=, 0($0):p2align=0
	return  	$pop0
	.endfunc
.Lfunc_end8:
	.size	ldi16_a1, .Lfunc_end8-ldi16_a1

	.globl	ldi16_a2
	.type	ldi16_a2,@function
ldi16_a2:
	.param  	i32
	.result 	i64
	i64.load16_u	$push0=, 0($0)
	return  	$pop0
	.endfunc
.Lfunc_end9:
	.size	ldi16_a2, .Lfunc_end9-ldi16_a2

	.globl	ldi16_a4
	.type	ldi16_a4,@function
ldi16_a4:
	.param  	i32
	.result 	i64
	i64.load16_u	$push0=, 0($0)
	return  	$pop0
	.endfunc
.Lfunc_end10:
	.size	ldi16_a4, .Lfunc_end10-ldi16_a4

	.globl	ldi32_a1
	.type	ldi32_a1,@function
ldi32_a1:
	.param  	i32
	.result 	i64
	i64.load32_u	$push0=, 0($0):p2align=0
	return  	$pop0
	.endfunc
.Lfunc_end11:
	.size	ldi32_a1, .Lfunc_end11-ldi32_a1

	.globl	ldi32_a2
	.type	ldi32_a2,@function
ldi32_a2:
	.param  	i32
	.result 	i64
	i64.load32_u	$push0=, 0($0):p2align=1
	return  	$pop0
	.endfunc
.Lfunc_end12:
	.size	ldi32_a2, .Lfunc_end12-ldi32_a2

	.globl	ldi32_a4
	.type	ldi32_a4,@function
ldi32_a4:
	.param  	i32
	.result 	i64
	i64.load32_u	$push0=, 0($0)
	return  	$pop0
	.endfunc
.Lfunc_end13:
	.size	ldi32_a4, .Lfunc_end13-ldi32_a4

	.globl	ldi32_a8
	.type	ldi32_a8,@function
ldi32_a8:
	.param  	i32
	.result 	i64
	i64.load32_u	$push0=, 0($0)
	return  	$pop0
	.endfunc
.Lfunc_end14:
	.size	ldi32_a8, .Lfunc_end14-ldi32_a8

	.globl	sti64_a1
	.type	sti64_a1,@function
sti64_a1:
	.param  	i32, i64
	i64.store	0($0):p2align=0, $1
	return
	.endfunc
.Lfunc_end15:
	.size	sti64_a1, .Lfunc_end15-sti64_a1

	.globl	sti64_a2
	.type	sti64_a2,@function
sti64_a2:
	.param  	i32, i64
	i64.store	0($0):p2align=1, $1
	return
	.endfunc
.Lfunc_end16:
	.size	sti64_a2, .Lfunc_end16-sti64_a2

	.globl	sti64_a4
	.type	sti64_a4,@function
sti64_a4:
	.param  	i32, i64
	i64.store	0($0):p2align=2, $1
	return
	.endfunc
.Lfunc_end17:
	.size	sti64_a4, .Lfunc_end17-sti64_a4

	.globl	sti64_a8
	.type	sti64_a8,@function
sti64_a8:
	.param  	i32, i64
	i64.store	0($0), $1
	return
	.endfunc
.Lfunc_end18:
	.size	sti64_a8, .Lfunc_end18-sti64_a8

	.globl	sti64
	.type	sti64,@function
sti64:
	.param  	i32, i64
	i64.store	0($0), $1
	return
	.endfunc
.Lfunc_end19:
	.size	sti64, .Lfunc_end19-sti64

	.globl	sti64_a16
	.type	sti64_a16,@function
sti64_a16:
	.param  	i32, i64
	i64.store	0($0), $1
	return
	.endfunc
.Lfunc_end20:
	.size	sti64_a16, .Lfunc_end20-sti64_a16

	.globl	sti8_a1
	.type	sti8_a1,@function
sti8_a1:
	.param  	i32, i64
	i64.store8	0($0), $1
	return
	.endfunc
.Lfunc_end21:
	.size	sti8_a1, .Lfunc_end21-sti8_a1

	.globl	sti8_a2
	.type	sti8_a2,@function
sti8_a2:
	.param  	i32, i64
	i64.store8	0($0), $1
	return
	.endfunc
.Lfunc_end22:
	.size	sti8_a2, .Lfunc_end22-sti8_a2

	.globl	sti16_a1
	.type	sti16_a1,@function
sti16_a1:
	.param  	i32, i64
	i64.store16	0($0):p2align=0, $1
	return
	.endfunc
.Lfunc_end23:
	.size	sti16_a1, .Lfunc_end23-sti16_a1

	.globl	sti16_a2
	.type	sti16_a2,@function
sti16_a2:
	.param  	i32, i64
	i64.store16	0($0), $1
	return
	.endfunc
.Lfunc_end24:
	.size	sti16_a2, .Lfunc_end24-sti16_a2

	.globl	sti16_a4
	.type	sti16_a4,@function
sti16_a4:
	.param  	i32, i64
	i64.store16	0($0), $1
	return
	.endfunc
.Lfunc_end25:
	.size	sti16_a4, .Lfunc_end25-sti16_a4

	.globl	sti32_a1
	.type	sti32_a1,@function
sti32_a1:
	.param  	i32, i64
	i64.store32	0($0):p2align=0, $1
	return
	.endfunc
.Lfunc_end26:
	.size	sti32_a1, .Lfunc_end26-sti32_a1

	.globl	sti32_a2
	.type	sti32_a2,@function
sti32_a2:
	.param  	i32, i64
	i64.store32	0($0):p2align=1, $1
	return
	.endfunc
.Lfunc_end27:
	.size	sti32_a2, .Lfunc_end27-sti32_a2

	.globl	sti32_a4
	.type	sti32_a4,@function
sti32_a4:
	.param  	i32, i64
	i64.store32	0($0), $1
	return
	.endfunc
.Lfunc_end28:
	.size	sti32_a4, .Lfunc_end28-sti32_a4

	.globl	sti32_a8
	.type	sti32_a8,@function
sti32_a8:
	.param  	i32, i64
	i64.store32	0($0), $1
	return
	.endfunc
.Lfunc_end29:
	.size	sti32_a8, .Lfunc_end29-sti32_a8


