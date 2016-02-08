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
	f32.store	$discard=, 0($0), $pop2
	f32.add 	$push3=, $3, $4
	f32.store	$discard=, 4($0), $pop3
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
	.local  	f32, f32, f32, f32, f32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$5=, __stack_pointer
	i32.load	$5=, 0($5)
	i32.const	$6=, 16
	i32.sub 	$9=, $5, $6
	i32.const	$6=, __stack_pointer
	i32.store	$9=, 0($6), $9
	i32.const	$push28=, 0
	f32.load	$0=, x+4($pop28)
	i32.const	$push27=, 0
	f32.load	$1=, y+4($pop27)
	f32.const	$push9=, 0x1p0
	f32.const	$push8=, 0x0p0
	i32.const	$push26=, 0
	i32.const	$push25=, 0
	f32.load	$push2=, x($pop25)
	tee_local	$push24=, $4=, $pop2
	i32.const	$push23=, 0
	f32.load	$push3=, y($pop23)
	f32.add 	$push4=, $pop24, $pop3
	f32.store	$push6=, z($pop26), $pop4
	i32.const	$push22=, 0
	f32.add 	$push5=, $0, $1
	f32.store	$push7=, z+4($pop22), $pop5
	i32.const	$7=, 8
	i32.add 	$7=, $9, $7
	call    	__divsc3@FUNCTION, $7, $pop9, $pop8, $pop6, $pop7
	i32.const	$push21=, 0
	f32.load	$1=, z($pop21)
	i32.const	$push20=, 0
	f32.load	$3=, w($pop20)
	i32.const	$push11=, 4
	i32.const	$8=, 8
	i32.add 	$8=, $9, $8
	i32.or  	$push12=, $8, $pop11
	f32.load	$2=, 0($pop12)
	i32.const	$push19=, 0
	f32.load	$push10=, 8($9):p2align=3
	f32.add 	$push13=, $4, $pop10
	f32.store	$discard=, y($pop19), $pop13
	i32.const	$push18=, 0
	f32.add 	$push14=, $0, $2
	f32.store	$discard=, y+4($pop18), $pop14
	block
	f32.ne  	$push15=, $1, $3
	br_if   	0, $pop15       # 0: down to label0
# BB#1:                                 # %entry
	i32.const	$push30=, 0
	f32.load	$push0=, z+4($pop30)
	i32.const	$push29=, 0
	f32.load	$push1=, w+4($pop29)
	f32.ne  	$push16=, $pop0, $pop1
	br_if   	0, $pop16       # 0: down to label0
# BB#2:                                 # %if.end
	i32.const	$push17=, 0
	call    	exit@FUNCTION, $pop17
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
