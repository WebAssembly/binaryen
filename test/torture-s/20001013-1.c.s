	.text
	.file	"20001013-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.result 	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push0=, 255
	i32.and 	$push1=, $1, $pop0
	i32.ne  	$push2=, $pop1, $1
	br_if   	0, $pop2        # 0: down to label0
# %bb.1:                                # %lor.lhs.false
	i32.load	$push7=, 0($0)
	i32.const	$push5=, 0
	i32.load	$push4=, 4($0)
	i32.sub 	$push6=, $pop5, $pop4
	i32.le_s	$push8=, $pop7, $pop6
	return  	$pop8
.LBB0_2:                                # %return
	end_block                       # label0:
	i32.const	$push3=, 1
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push6=, 0
	i32.load	$push2=, z($pop6)
	i32.const	$push5=, 0
	i32.const	$push4=, 0
	i32.load	$push0=, z+4($pop4)
	i32.sub 	$push1=, $pop5, $pop0
	i32.le_s	$push3=, $pop2, $pop1
	br_if   	0, $pop3        # 0: down to label1
# %bb.1:                                # %if.end
	i32.const	$push7=, 0
	call    	exit@FUNCTION, $pop7
	unreachable
.LBB1_2:                                # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	z                       # @z
	.type	z,@object
	.section	.data.z,"aw",@progbits
	.globl	z
	.p2align	2
z:
	.int32	4294963268              # 0xfffff044
	.int32	4096                    # 0x1000
	.size	z, 8


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
