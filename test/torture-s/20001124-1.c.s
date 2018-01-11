	.text
	.file	"20001124-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.param  	i32, i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push1=, 0
	i32.const	$push0=, 9
	i32.store8	s+4($pop1), $pop0
	i32.const	$push9=, 0
	i32.const	$push2=, 512
	i32.store	s($pop9), $pop2
	i32.const	$push8=, 0
	i64.const	$push3=, 2048
	i64.store	i($pop8), $pop3
	i32.const	$push7=, 0
	i32.const	$push4=, s
	i32.store	i+8($pop7), $pop4
	i32.const	$push6=, 0
	i64.const	$push5=, 0
	i64.store	f($pop6), $pop5
	call    	do_isofs_readdir@FUNCTION
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.section	.text.do_isofs_readdir,"ax",@progbits
	.type	do_isofs_readdir,@function # -- Begin function do_isofs_readdir
do_isofs_readdir:                       # @do_isofs_readdir
	.local  	i64
# %bb.0:                                # %entry
	i32.const	$push7=, 0
	i64.load	$0=, f($pop7)
	block   	
	i32.const	$push6=, 0
	i64.load	$push0=, i($pop6)
	i64.lt_s	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label0
# %bb.1:                                # %cleanup
	return
.LBB1_2:                                # %if.then12
	end_block                       # label0:
	i32.const	$push8=, 0
	i32.load	$push2=, i+8($pop8)
	i64.load8_u	$push3=, 4($pop2)
	i64.shr_s	$push4=, $0, $pop3
	i32.wrap/i64	$push5=, $pop4
	call    	isofs_bread@FUNCTION, $pop5
	unreachable
	.endfunc
.Lfunc_end1:
	.size	do_isofs_readdir, .Lfunc_end1-do_isofs_readdir
                                        # -- End function
	.section	.text.isofs_bread,"ax",@progbits
	.type	isofs_bread,@function   # -- Begin function isofs_bread
isofs_bread:                            # @isofs_bread
	.param  	i32
# %bb.0:                                # %entry
	block   	
	br_if   	0, $0           # 0: down to label1
# %bb.1:                                # %if.end
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
.LBB2_2:                                # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	isofs_bread, .Lfunc_end2-isofs_bread
                                        # -- End function
	.hidden	s                       # @s
	.type	s,@object
	.section	.bss.s,"aw",@nobits
	.globl	s
	.p2align	2
s:
	.skip	12
	.size	s, 12

	.hidden	i                       # @i
	.type	i,@object
	.section	.bss.i,"aw",@nobits
	.globl	i
	.p2align	3
i:
	.skip	16
	.size	i, 16

	.hidden	f                       # @f
	.type	f,@object
	.section	.bss.f,"aw",@nobits
	.globl	f
	.p2align	3
f:
	.skip	8
	.size	f, 8


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
