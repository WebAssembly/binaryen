	.text
	.file	"zero-struct-1.c"
	.section	.text.h,"ax",@progbits
	.hidden	h                       # -- Begin function h
	.globl	h
	.type	h,@function
h:                                      # @h
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.const	$push9=, 0
	i32.load	$push1=, f($pop9)
	i32.const	$push2=, 2
	i32.add 	$push3=, $pop1, $pop2
	i32.store	f($pop0), $pop3
	i32.const	$push8=, 0
	i32.const	$push7=, 0
	i32.load	$push4=, ff($pop7)
	i32.const	$push6=, 2
	i32.add 	$push5=, $pop4, $pop6
	i32.store	ff($pop8), $pop5
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	h, .Lfunc_end0-h
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, f($pop0)
	i32.const	$push2=, 2
	i32.add 	$1=, $pop1, $pop2
	i32.const	$push11=, 0
	i32.store	f($pop11), $1
	i32.const	$push10=, 0
	i32.load	$push3=, ff($pop10)
	i32.const	$push9=, 2
	i32.add 	$0=, $pop3, $pop9
	i32.const	$push8=, 0
	i32.store	ff($pop8), $0
	block   	
	i32.const	$push7=, y+2
	i32.ne  	$push4=, $1, $pop7
	br_if   	0, $pop4        # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$push12=, y+2
	i32.ne  	$push5=, $0, $pop12
	br_if   	0, $pop5        # 0: down to label0
# %bb.2:                                # %if.end3
	i32.const	$push6=, 0
	return  	$pop6
.LBB1_3:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	y                       # @y
	.type	y,@object
	.section	.bss.y,"aw",@nobits
	.globl	y
y:
	.skip	3
	.size	y, 3

	.hidden	f                       # @f
	.type	f,@object
	.section	.data.f,"aw",@progbits
	.globl	f
	.p2align	2
f:
	.int32	y
	.size	f, 4

	.hidden	ff                      # @ff
	.type	ff,@object
	.section	.data.ff,"aw",@progbits
	.globl	ff
	.p2align	2
ff:
	.int32	y
	.size	ff, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
