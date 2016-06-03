	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/complex-5.c"
	.section	.text.p,"ax",@progbits
	.hidden	p
	.globl	p
	.type	p,@function
p:                                      # @p
	.param  	i32, i32, i32
# BB#0:                                 # %entry
	f32.load	$push1=, 0($1)
	f32.load	$push0=, 0($2)
	f32.add 	$push2=, $pop1, $pop0
	f32.store	$drop=, 0($0), $pop2
	f32.load	$push4=, 4($1)
	f32.load	$push3=, 4($2)
	f32.add 	$push5=, $pop4, $pop3
	f32.store	$drop=, 4($0), $pop5
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	p, .Lfunc_end0-p

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, f32, f32
# BB#0:                                 # %entry
	i32.const	$push22=, 0
	i32.const	$push19=, 0
	i32.load	$push20=, __stack_pointer($pop19)
	i32.const	$push21=, 16
	i32.sub 	$push25=, $pop20, $pop21
	i32.store	$push41=, __stack_pointer($pop22), $pop25
	tee_local	$push40=, $0=, $pop41
	i32.const	$push23=, 8
	i32.add 	$push24=, $pop40, $pop23
	f32.const	$push9=, 0x1p0
	f32.const	$push8=, 0x0p0
	i32.const	$push39=, 0
	i32.const	$push38=, 0
	f32.load	$push37=, x($pop38)
	tee_local	$push36=, $1=, $pop37
	i32.const	$push35=, 0
	f32.load	$push4=, y($pop35)
	f32.add 	$push5=, $pop36, $pop4
	f32.store	$push0=, z($pop39), $pop5
	i32.const	$push34=, 0
	i32.const	$push33=, 0
	f32.load	$push32=, x+4($pop33)
	tee_local	$push31=, $2=, $pop32
	i32.const	$push30=, 0
	f32.load	$push6=, y+4($pop30)
	f32.add 	$push7=, $pop31, $pop6
	f32.store	$push1=, z+4($pop34), $pop7
	call    	__divsc3@FUNCTION, $pop24, $pop9, $pop8, $pop0, $pop1
	i32.const	$push29=, 0
	f32.load	$push10=, 8($0)
	f32.add 	$push11=, $1, $pop10
	f32.store	$drop=, y($pop29), $pop11
	i32.const	$push28=, 0
	f32.load	$push12=, 12($0)
	f32.add 	$push13=, $2, $pop12
	f32.store	$drop=, y+4($pop28), $pop13
	block
	i32.const	$push27=, 0
	f32.load	$push15=, z($pop27)
	i32.const	$push26=, 0
	f32.load	$push14=, w($pop26)
	f32.ne  	$push16=, $pop15, $pop14
	br_if   	0, $pop16       # 0: down to label0
# BB#1:                                 # %entry
	i32.const	$push43=, 0
	f32.load	$push2=, z+4($pop43)
	i32.const	$push42=, 0
	f32.load	$push3=, w+4($pop42)
	f32.ne  	$push17=, $pop2, $pop3
	br_if   	0, $pop17       # 0: down to label0
# BB#2:                                 # %if.end
	i32.const	$push18=, 0
	call    	exit@FUNCTION, $pop18
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
	.functype	__divsc3, void, i32, f32, f32, f32, f32
	.functype	abort, void
	.functype	exit, void, i32
