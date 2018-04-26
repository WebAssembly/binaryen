	.text
	.file	"950809-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push0=, 16
	i32.add 	$1=, $0, $pop0
	i32.load	$2=, 0($1)
	i32.load	$3=, 12($0)
	i32.load	$4=, 8($0)
	i32.load	$5=, 8($4)
	i32.load	$push1=, 0($4)
	i32.store	8($4), $pop1
	i32.store	0($4), $2
	i32.store	0($0), $4
	i32.load	$4=, 4($4)
	i32.store	12($0), $5
	i32.store	0($1), $3
	i32.store	4($0), $4
	copy_local	$push2=, $0
                                        # fallthrough-return: $pop2
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push2=, 0
	i32.load8_u	$0=, main.sc.0($pop2)
	i32.const	$push1=, 0
	i32.const	$push0=, 1
	i32.store8	main.sc.0($pop1), $pop0
	block   	
	i32.eqz 	$push4=, $0
	br_if   	0, $pop4        # 0: down to label0
# %bb.1:                                # %if.then
	call    	abort@FUNCTION
	unreachable
.LBB1_2:                                # %if.end
	end_block                       # label0:
	i32.const	$push3=, 0
	call    	exit@FUNCTION, $pop3
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.type	main.sc.0,@object       # @main.sc.0
	.section	.bss.main.sc.0,"aw",@nobits
	.p2align	2
main.sc.0:
	.int8	0                       # 0x0
	.size	main.sc.0, 1


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
