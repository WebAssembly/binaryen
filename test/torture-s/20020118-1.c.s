	.text
	.file	"20020118-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push13=, 0
	i32.load	$push0=, q($pop13)
	i32.const	$push1=, 2
	i32.add 	$0=, $pop0, $pop1
.LBB0_1:                                # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label0:
	i32.const	$push24=, 0
	i32.load8_s	$push2=, 0($0)
	i32.store	n($pop24), $pop2
	i32.const	$push23=, 0
	i32.load8_s	$push3=, 0($0)
	i32.store	n($pop23), $pop3
	i32.const	$push22=, 0
	i32.load8_s	$push4=, 0($0)
	i32.store	n($pop22), $pop4
	i32.const	$push21=, 0
	i32.load8_s	$push5=, 0($0)
	i32.store	n($pop21), $pop5
	i32.const	$push20=, 0
	i32.load8_s	$push6=, 0($0)
	i32.store	n($pop20), $pop6
	i32.const	$push19=, 0
	i32.load8_s	$push7=, 0($0)
	i32.store	n($pop19), $pop7
	i32.const	$push18=, 0
	i32.load8_s	$push8=, 0($0)
	i32.store	n($pop18), $pop8
	i32.const	$push17=, 0
	i32.load8_s	$push9=, 0($0)
	i32.store	n($pop17), $pop9
	i32.const	$push16=, 0
	i32.load8_s	$push10=, 0($0)
	i32.store	n($pop16), $pop10
	i32.const	$push15=, 0
	i32.load8_s	$push11=, 0($0)
	i32.store	n($pop15), $pop11
	i32.const	$push14=, 0
	i32.load8_s	$push12=, 0($0)
	i32.store	n($pop14), $pop12
	br      	0               # 0: up to label0
.LBB0_2:
	end_loop
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
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	q                       # @q
	.type	q,@object
	.section	.bss.q,"aw",@nobits
	.globl	q
	.p2align	2
q:
	.int32	0
	.size	q, 4

	.hidden	n                       # @n
	.type	n,@object
	.section	.bss.n,"aw",@nobits
	.globl	n
	.p2align	2
n:
	.int32	0                       # 0x0
	.size	n, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	exit, void, i32
