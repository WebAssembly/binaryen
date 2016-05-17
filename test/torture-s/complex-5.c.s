	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/complex-5.c"
	.section	.text.p,"ax",@progbits
	.hidden	p
	.globl	p
	.type	p,@function
p:                                      # @p
	.param  	i32, i32, i32
	.local  	f32, f32
# BB#0:                                 # %entry
	f32.load	$3=, 4($1)
	f32.load	$4=, 4($2)
	f32.load	$push0=, 0($1)
	f32.load	$push1=, 0($2)
	f32.add 	$push2=, $pop0, $pop1
	f32.store	$drop=, 0($0), $pop2
	f32.add 	$push3=, $3, $4
	f32.store	$drop=, 4($0), $pop3
	return
	.endfunc
.Lfunc_end0:
	.size	p, .Lfunc_end0-p

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, f32, f32, f32, f32, f32
# BB#0:                                 # %entry
	i32.const	$push18=, __stack_pointer
	i32.const	$push15=, __stack_pointer
	i32.load	$push16=, 0($pop15)
	i32.const	$push17=, 16
	i32.sub 	$push21=, $pop16, $pop17
	i32.store	$0=, 0($pop18), $pop21
	i32.const	$push33=, 0
	f32.load	$1=, x+4($pop33)
	i32.const	$push32=, 0
	f32.load	$2=, y+4($pop32)
	i32.const	$push19=, 8
	i32.add 	$push20=, $0, $pop19
	f32.const	$push8=, 0x1p0
	f32.const	$push7=, 0x0p0
	i32.const	$push31=, 0
	i32.const	$push30=, 0
	f32.load	$push29=, x($pop30)
	tee_local	$push28=, $5=, $pop29
	i32.const	$push27=, 0
	f32.load	$push4=, y($pop27)
	f32.add 	$push5=, $pop28, $pop4
	f32.store	$push0=, z($pop31), $pop5
	i32.const	$push26=, 0
	f32.add 	$push6=, $1, $2
	f32.store	$push1=, z+4($pop26), $pop6
	call    	__divsc3@FUNCTION, $pop20, $pop8, $pop7, $pop0, $pop1
	i32.const	$push25=, 0
	f32.load	$2=, z($pop25)
	i32.const	$push24=, 0
	f32.load	$4=, w($pop24)
	f32.load	$3=, 12($0)
	i32.const	$push23=, 0
	f32.load	$push9=, 8($0)
	f32.add 	$push10=, $5, $pop9
	f32.store	$drop=, y($pop23), $pop10
	i32.const	$push22=, 0
	f32.add 	$push11=, $1, $3
	f32.store	$drop=, y+4($pop22), $pop11
	block
	f32.ne  	$push12=, $2, $4
	br_if   	0, $pop12       # 0: down to label0
# BB#1:                                 # %entry
	i32.const	$push35=, 0
	f32.load	$push2=, z+4($pop35)
	i32.const	$push34=, 0
	f32.load	$push3=, w+4($pop34)
	f32.ne  	$push13=, $pop2, $pop3
	br_if   	0, $pop13       # 0: down to label0
# BB#2:                                 # %if.end
	i32.const	$push14=, 0
	call    	exit@FUNCTION, $pop14
	unreachable
.LBB1_3:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	x                       # @x
	.type	x,@object
	.section	.data.x,"aw",@progbits
	.globl	x
	.p2align	2
x:
	.int32	1065353216              # float 1
	.int32	1096810496              # float 14
	.size	x, 8

	.hidden	y                       # @y
	.type	y,@object
	.section	.data.y,"aw",@progbits
	.globl	y
	.p2align	2
y:
	.int32	1088421888              # float 7
	.int32	1084227584              # float 5
	.size	y, 8

	.hidden	w                       # @w
	.type	w,@object
	.section	.data.w,"aw",@progbits
	.globl	w
	.p2align	2
w:
	.int32	1090519040              # float 8
	.int32	1100480512              # float 19
	.size	w, 8

	.hidden	z                       # @z
	.type	z,@object
	.section	.bss.z,"aw",@nobits
	.globl	z
	.p2align	2
z:
	.skip	8
	.size	z, 8


	.ident	"clang version 3.9.0 "
