	.text
	.file	"complex-5.c"
	.section	.text.p,"ax",@progbits
	.hidden	p                       # -- Begin function p
	.globl	p
	.type	p,@function
p:                                      # @p
	.param  	i32, i32, i32
# %bb.0:                                # %entry
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
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	f32, f32, f32, f32, i32
# %bb.0:                                # %entry
	i32.const	$push16=, 0
	i32.load	$push15=, __stack_pointer($pop16)
	i32.const	$push17=, 16
	i32.sub 	$4=, $pop15, $pop17
	i32.const	$push18=, 0
	i32.store	__stack_pointer($pop18), $4
	i32.const	$push30=, 0
	f32.load	$0=, x($pop30)
	i32.const	$push29=, 0
	f32.load	$push2=, y($pop29)
	f32.add 	$1=, $0, $pop2
	i32.const	$push28=, 0
	f32.store	z($pop28), $1
	i32.const	$push27=, 0
	f32.load	$2=, x+4($pop27)
	i32.const	$push26=, 0
	f32.load	$push3=, y+4($pop26)
	f32.add 	$3=, $2, $pop3
	i32.const	$push25=, 0
	f32.store	z+4($pop25), $3
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
# %bb.1:                                # %entry
	i32.const	$push32=, 0
	f32.load	$push0=, z+4($pop32)
	i32.const	$push31=, 0
	f32.load	$push1=, w+4($pop31)
	f32.ne  	$push13=, $pop0, $pop1
	br_if   	0, $pop13       # 0: down to label0
# %bb.2:                                # %if.end
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
                                        # -- End function
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


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	__divsc3, void, i32, f32, f32, f32, f32
	.functype	abort, void
	.functype	exit, void, i32
