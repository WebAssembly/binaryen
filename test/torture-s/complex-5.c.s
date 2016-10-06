	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/complex-5.c"
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
	f32.store	0($0), $pop2
	f32.load	$push4=, 4($1)
	f32.load	$push3=, 4($2)
	f32.add 	$push5=, $pop4, $pop3
	f32.store	4($0), $pop5
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
	.local  	f32, f32, f32, f32, i32
# BB#0:                                 # %entry
	i32.const	$push18=, 0
	i32.const	$push15=, 0
	i32.load	$push16=, __stack_pointer($pop15)
	i32.const	$push17=, 16
	i32.sub 	$push40=, $pop16, $pop17
	tee_local	$push39=, $4=, $pop40
	i32.store	__stack_pointer($pop18), $pop39
	i32.const	$push38=, 0
	i32.const	$push37=, 0
	f32.load	$push36=, x($pop37)
	tee_local	$push35=, $0=, $pop36
	i32.const	$push34=, 0
	f32.load	$push2=, y($pop34)
	f32.add 	$push33=, $pop35, $pop2
	tee_local	$push32=, $1=, $pop33
	f32.store	z($pop38), $pop32
	i32.const	$push31=, 0
	i32.const	$push30=, 0
	f32.load	$push29=, x+4($pop30)
	tee_local	$push28=, $2=, $pop29
	i32.const	$push27=, 0
	f32.load	$push3=, y+4($pop27)
	f32.add 	$push26=, $pop28, $pop3
	tee_local	$push25=, $3=, $pop26
	f32.store	z+4($pop31), $pop25
	i32.const	$push19=, 8
	i32.add 	$push20=, $4, $pop19
	f32.const	$push5=, 0x1p0
	f32.const	$push4=, 0x0p0
	call    	__divsc3@FUNCTION, $pop20, $pop5, $pop4, $1, $3
	i32.const	$push24=, 0
	f32.load	$push6=, 8($4)
	f32.add 	$push7=, $0, $pop6
	f32.store	y($pop24), $pop7
	i32.const	$push23=, 0
	f32.load	$push8=, 12($4)
	f32.add 	$push9=, $2, $pop8
	f32.store	y+4($pop23), $pop9
	block   	
	i32.const	$push22=, 0
	f32.load	$push11=, z($pop22)
	i32.const	$push21=, 0
	f32.load	$push10=, w($pop21)
	f32.ne  	$push12=, $pop11, $pop10
	br_if   	0, $pop12       # 0: down to label0
# BB#1:                                 # %entry
	i32.const	$push42=, 0
	f32.load	$push0=, z+4($pop42)
	i32.const	$push41=, 0
	f32.load	$push1=, w+4($pop41)
	f32.ne  	$push13=, $pop0, $pop1
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	__divsc3, void, i32, f32, f32, f32, f32
	.functype	abort, void
	.functype	exit, void, i32
